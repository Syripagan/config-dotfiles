import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Scope {
    
    id: dockScope

    ListModel { id: windowModel }

    readonly property string iconDir: "file:///home/syrik2000/.config/quickshell/icons/"
    Process { id: commandRunner }

    Process {
        id: niriLoader
        command: ["niri", "msg", "-j", "windows"]
        running: false
        
        stdout: SplitParser {
            onRead: (line) => {
                try {
                    const windows = JSON.parse(line);
                    if (JSON.stringify(windows) === dockScope.lastJson) return;
                    dockScope.lastJson = JSON.stringify(windows);

                    windowModel.clear();
                    for (let win of windows) {
                        windowModel.append({ 
                            "appId": (win.app_id || "unknown"), 
                            "winId": win.id,
                            "isFocused": win.is_focused || false
                        });
                    }
                } catch (e) { }
            }
        }
    }
    property string lastJson: ""

    Timer {
        interval: 100
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            niriLoader.running = false;
            niriLoader.running = true;
        }
    }
    function getIcon(name) {
        return iconDir + name.toLowerCase() + ".svg";
    }
    function launchApp(name) {
        const proc = Qt.createQmlObject(`
            import Quickshell.Io; 
            Process { 
                command: ["${name}"]; 
                onExited: destroy(); 
                onRunningChanged: if (!running) destroy();
            }
        `, dockScope);
        
        proc.running = true;
    }
    PanelWindow {
        WlrLayershell.layer: WlrLayer.Bottom
        anchors { bottom: true; left: true; right: true }
        color: "#2c2c2c"        
        implicitWidth: layout.width + 24
        implicitHeight: 64
        Rectangle {
            id: panelContent
            width: layout.width + 20
            height: parent.height
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#3c3c3c"
            radius: 25
            Row {
                id: layout
                anchors.centerIn: parent
                spacing: 8
                Repeater {
                    model: ["alacritty", "dolphin", "nix-software-center", "librewolf", "lutris", "steam", "AyuGram"]
                    
                    delegate: Rectangle {
                        width: 48; height: 48; color: "transparent"
                        Image {
                            id: pinnedIcon
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: getIcon(modelData)
                            fillMode: Image.PreserveAspectFit
                            visible: status === Image.Ready
                            scale: mouseDetector.containsMouse ? 0.8 : 0.7
                            y: mouseDetector.containsMouse ? -15 : -10

                            // Анімка!~
                            Behavior on scale {
                                NumberAnimation {
                                    duration: 150; easing.type: Easing.OutCubic
                                }
                            }
                            Behavior on y {
                                NumberAnimation {
                                    duration: 150; easing.type: Easing.OutCubic
                                }
                            }
                            onStatusChanged: {
                                if (status === Image.Error) {
                                    source = iconDir + "x-executable.svg"
                                }
                            }
                        }
                        Text {
                            anchors.centerIn: parent
                            text: modelData[0].toUpperCase()
                            color: "white"
                            visible: pinnedIcon.status !== Image.Ready
                        }
                        MouseArea {
                            id: mouseDetector
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            anchors.fill: parent
                            onClicked: launchApp(modelData)
                        }
                    }
                }

                // Сєпар
                Rectangle {
                    width: 4; height: 30; color: "#555"; radius: 10
                    anchors.verticalCenter: parent.verticalCenter
                    visible: windowModel.count > 0
                }
                Repeater {
                    model: windowModel
                    delegate: Rectangle {
                        width: 44
                        height: 44
                        color: "transparent"
                        y: mouseDetector.containsMouse ? -5 : 0
                        scale: mouseDetector.containsMouse ? 1.2 : 1
                        Behavior on y {
                            NumberAnimation {
                                duration: 150; easing.type: Easing.OutCubic
                            }
                        }
                        Behavior on scale {
                            NumberAnimation {
                                duration: 150; easing.type: Easing.OutCubic
                            }
                        }
                        Image {
                            anchors.fill: parent
                            anchors.margins: 0
                            source: iconDir + appId + ".svg"
                            fillMode: Image.PreserveAspectFit
                            MouseArea {
                                id: mouseDetector
                                anchors.fill: parent
                                hoverEnabled: true
                                acceptedButtons: Qt.LeftButton | Qt.RightButton
                                cursorShape: Qt.PointingHandCursor
                                onClicked: (mouse) => {
                                    if (mouse.button === Qt.LeftButton) {
                                        commandRunner.command = ["niri", "msg", "action", "focus-window", "--id", winId.toString()];
                                        commandRunner.running = true;
                                    }   else if (mouse.button === Qt.RightButton) {
                                        commandRunner.command = ["niri", "msg", "action", "close-window", "--id", winId.toString()];
                                        commandRunner.running = true;
                                    }
                                }
                            }
                            onStatusChanged: {
                                if (status === Image.Error) {
                                    source = iconDir + "x-executable.svg"
                                }
                            }
                        }
                        Rectangle {
                            width: 10
                            height: 5
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottomMargin: -5
                            radius: 15
                            color: "#bb2b2b"
                        }
                    }
                }
            }
        }
    }
}