import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

// Це крутий док чуваки
Scope {
    
    id: dockScope

    ListModel { id: windowModel }

    readonly property string iconDir: "file:///home/syrik2000/.config/quickshell/icons/"
    Process { id: commandRunner }

Process {
        id: niriEvents
        command: ["niri", "msg", "event-stream"]
        running: true
        stdout: SplitParser {
            onRead: (line) => {
                if (line.includes("Window") || line.includes("Workspace")) {
                    niriLoader.run();
                }
            }
        }
    }
    Process {
        id: niriLoader
        command: ["niri", "msg", "-j", "windows"]
        function run() { running = false; running = true; }
        
        stdout: SplitParser {
            onRead: (line) => {
                try {
                    const windows = JSON.parse(line);
                    updateWindowModel(windows);
                } catch (e) { }
            }
        }
    }
    function updateWindowModel(newWindows) {
        newWindows.sort((a, b) => a.id - b.id);
        for (let i = windowModel.count - 1; i >= 0; i--) {
            if (!newWindows.some(w => w.id === windowModel.get(i).winId)) {
                windowModel.remove(i);
            }
        }
        newWindows.forEach((win, index) => {
            let foundIdx = -1;
            for (let i = 0; i < windowModel.count; i++) {
                if (windowModel.get(i).winId === win.id) {
                    foundIdx = i;
                    break;
                }
            }

            let winData = {
                "appId": (win.app_id || "unknown"),
                "winId": win.id,
                "isFocused": win.is_focused || false
            };

            if (foundIdx !== -1) {
                windowModel.setProperty(foundIdx, "isFocused", win.is_focused);
                if (foundIdx !== index) windowModel.move(foundIdx, index, 1);
            } else {
                windowModel.insert(index, winData);
            }
        });
    }
    Component.onCompleted: niriLoader.run()
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
                    width: 4; height: 30; color: "#777"; radius: 10
                    anchors.verticalCenter: parent.verticalCenter
                    visible: windowModel.count > 0
                }
                Repeater {
                    model: windowModel
                    delegate: Rectangle {
                        width: 44; height: 44; color: "transparent"
                        y: mouseDetector.containsMouse ? -5 : 0
                        scale: mouseDetector.containsMouse ? 1.2 : 1
                        
                        Behavior on y { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

                        Image {
                            anchors.fill: parent
                            source: iconDir + appId.toLowerCase() + ".svg"
                            fillMode: Image.PreserveAspectFit
                            asynchronous: true
                            sourceSize: Qt.size(64, 64)

                            onStatusChanged: if (status === Image.Error) source = iconDir + "x-executable.svg"
		    	}
			Rectangle {
			    width: 12
                            height: 5
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: -6
                            anchors.horizontalCenter: parent.horizontalCenter
                            radius: 5
			    color: isFocused ? "#cc2c2c" : "#8c8c8c"
			    Behavior on color {
			        ColorAnimation { duration: 100; }
			    }
			}
			
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
                                } else if (mouse.button === Qt.RightButton) {
                                    commandRunner.command = ["niri", "msg", "action", "close-window", "--id", winId.toString()];
                                    commandRunner.running = true;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
