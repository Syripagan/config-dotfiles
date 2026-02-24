import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import Niri 0.1

Item {
    property real currentVolume: Pipewire.defaultAudioSink?.audio?.volume ?? 0
    Connections {
        target: Pipewire.defaultAudioSink?.audio
        function onVolumeChanged() {
            currentVolume = Pipewire.defaultAudioSink.audio.volume
        }
    }
    PanelWindow {
        exclusiveZone: 0
        id: startMenu1
        color: "transparent"
        width: 430
        anchors {
            left: true
            top: true
            bottom: true
        }
        Timer {
            id: closeDelay
            interval: 100 
            onTriggered: {
                startMenu1.expanded = !startMenu1.expanded
                menuRect.opacity = 1
            }
        }
        property bool expanded: false
        visible: expanded

        MouseArea {
            id: mainMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onExited: {
                closeDelay.start()
                menuRect.width = 0 * Screen.height
                menuRect.height = 0.310 * Screen.height
                menuRect.opacity = 0
            }
        }
        Item {
            id: menuContainer
            property var rebootProcess: Process {
                command: ["sh", "-c", "reboot"]
            }
            property var logoutProcess: Process {
                command: ["sh", "-c", "niri msg action quit"]
            }
            property var poweroffProcess: Process {
                command: ["sh", "-c", "poweroff"]
            }
            property var hyprlockProcess: Process {
                command: ["sh", "-c", "hyprlock"]
            }
            width: parent.width
            height: parent.height
            Rectangle {
                id: blg
                anchors.left: parent.left
		        y: 0
                color: "transparent"
                radius: 30
            }
            Rectangle {
                id: menuRect
                height: startMenu1.expanded ? 0.710 * Screen.height : 0.310 * Screen.height
                width: startMenu1.expanded ? 0.1671875 * Screen.width : 0
                property var formr: (-0.0025)*Screen.width
                // x: startMenu1.expanded ? (0.0045 * Screen.width) : formr
                x: formr
                z: 1
                anchors.verticalCenter: parent.verticalCenter
                y: 0.007 * Screen.height
                radius: 25
                color: "#2c2c2c"
                opacity: startMenu1.expanded ? 1 : 0
                Behavior on height {
                    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                }
                Behavior on width {
                    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                }
                Behavior on opacity {
                    NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
                }
                Column {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 2

                    Text {
                        text: "<thrix linux (NixOS Ed.)>"
                        font.family: "URW Gothic"
                        font.pixelSize: 0.01667 * Screen.height
                        color: "#ffffff"
                    }

                    Rectangle {
                        id: pob
                        height: 0.02777 * Screen.height
                        width: parent.width
                        radius: 20
                        color: "#3c3c3c"
                        Behavior on color {
                            ColorAnimation { duration: 100; easing.type: Easing.InOutQuad }
                        }
                        Behavior on radius {
                            NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
                        }
                        Behavior on height {
                            NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "󰤆 Вимикаємся"
                            font.family: "FiraMono Nerd Font"
                            color: "#ffffff"
                            font.pixelSize: 0.0125 * Screen.height
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                menuContainer.poweroffProcess.startDetached()
                                Qt.quit()
                            }
                            hoverEnabled: false
                            onEntered: {
                                pob.color = "#aa1b1b"
                                pob.radius = 5
                                startMenu1.closeDelay.stop()
                            }
                            onExited: {
                                pob.color = "#3c3c3c"
                                pob.radius = 20
                            }
                        }
                    }
                    Rectangle {
                        id: rebb
                        height: 0.027777 * Screen.height
                        width: parent.width
                        radius: 20
                        color: "#3c3c3c"
                        Behavior on color {
                            ColorAnimation { duration: 100; easing.type: Easing.InOutQuad }
                        }
                        Behavior on radius {
                            NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
                        }
                        Behavior on height {
                            NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: " Ребутаєм"
                            font.family: "FiraMono Nerd Font"
                            color: "#ffffff"
                            font.pixelSize: 0.0125 * Screen.height
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                menuContainer.rebootProcess.startDetached()
                                Qt.quit()
                            }
                            hoverEnabled: false
                            onEntered: {
                                rebb.color = "#aa1b1b"
                                rebb.radius = 5
                            }
                            onExited: {
                                rebb.color = "#3c3c3c" 
                                rebb.radius = 20
                            }
                        }
                    }
                    Rectangle {
                        id: lob
                        height: 0.027777 * Screen.height
                        width: parent.width
                        radius: 20
                        color: "#3c3c3c"
                        Behavior on color {
                            ColorAnimation { duration: 100; easing.type: Easing.InOutQuad }
                        }
                        Behavior on radius {
                            NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
                        }
                        Behavior on height {
                            NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "󰍃 Виходім із сесії"
                            font.family: "FiraMono Nerd Font"
                            color: "#ffffff"
                            font.pixelSize: 0.0125 * Screen.height
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                menuContainer.logoutProcess.startDetached()
                            }
                            hoverEnabled: false
                            onEntered: {
                                lob.color = "#aa1b1b"
                                lob.radius = 5
                            }
                            onExited: {
                                lob.color = "#3c3c3c" 
                                lob.radius = 20
                            }
                        }
                    }
                    Rectangle {
                        id: hlb
                        height: 0.027777 * Screen.height
                        width: parent.width
                        radius: 20
                        color: "#3c3c3c"
                        Behavior on color {
                            ColorAnimation { duration: 100; easing.type: Easing.InOutQuad }
                        }
                        Behavior on radius {
                            NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
                        }
                        Behavior on height {
                            NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: " Локаєм"
                            font.family: "FiraMono Nerd Font"
                            color: "#ffffff"
                            font.pixelSize: 0.0125 * Screen.height
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                menuContainer.hyprlockProcess.startDetached()
                                startMenu1.expanded = 0
                            }
                            hoverEnabled: false
                            onEntered: {
                                hlb.color = "#aa1b1b"
                                hlb.radius = 5
                            }
                            onExited: {
                                hlb.color = "#3c3c3c" 
                                hlb.radius = 20
                            }
                        }
                    }
                }
            }
        }
    }
    PanelWindow {
        WlrLayershell.layer: WlrLayer.Bottom
        exclusiveZone: 0.03123 * Screen.height
        color: "transparent"
        id: panel
        anchors {
            top: true
            left: true
            right: true
        }
        implicitHeight: 0.03125 * Screen.height

        Rectangle {
            id: background
            anchors.fill: parent
            color: "#2c2c2c"

            Rectangle {
                id: rightDock
                color: "#3c3c3c"
                anchors.topMargin: 0.00486 * Screen.height
                anchors.rightMargin: 0.00781 * Screen.width
                radius: 15
                height: 0.0229 * Screen.height
                width: 0.4390 * Screen.width
                anchors.right: parent.right
                anchors.top: parent.top
            }

            Rectangle {
                id: leftDock
                color: "#3c3c3c"
                anchors.topMargin: 0.00486 * Screen.height
                anchors.leftMargin: 0.00781 * Screen.width
                radius: 15
                height: 0.0229 * Screen.height
                width: 0.4390 * Screen.width
                anchors.left: parent.left
                anchors.top: parent.top
            }
            Rectangle {
                id: wsbg
                color: "#4c4c4c"
                height: 0.0236 * Screen.height
                radius: 15
                anchors.verticalCenter: workspaces.verticalCenter
                anchors.left: workspaces.left
                anchors.leftMargin: (-0.005125) * Screen.width
                width: workspaces.width + 0.01025 * Screen.width
                Behavior on width {
                    NumberAnimation { duration: 50; }
                }
                // Behavior on width {
                //     NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                // }
            }
            Rectangle {
                id: startMenu
                color: "#4c4c4c"
                height: 0.027777 * Screen.height
                radius: 20
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: background.left
                anchors.leftMargin: Screen.width * 0.00572
                width: height
                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
                Behavior on radius {
                    NumberAnimation { duration: 150 }
                }
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        // startMenu1.expanded = !startMenu1.expanded
                        closeDelay.start()
                        menuRect.width = 0 * Screen.height
                        menuRect.height = 0.310 * Screen.height
                        menuRect.opacity = 0
                    }
                    onEntered: {
                        startMenu.color = "#aa1b1b" 
                        startMenu.radius = 5
                        distroIcon.scale = 1.3
                    }
                    onExited: {
                        startMenu.color = "#4c4c4c" 
                        startMenu.radius = 20
                        distroIcon.scale = 1
                    }
                }
            }
            Rectangle {
                id: audioDock
                color: "#4c4c4c"
                anchors.topMargin: 0.004861 * Screen.height
                anchors.rightMargin: 0.0078125 * Screen.width
                radius: 15
                height: 0.022916 * Screen.height
                width: 0.078125 * Screen.width
                anchors.right: parent.right
                anchors.top: parent.top
                property real currentVolume: Pipewire.defaultAudioSink?.audio?.volume ?? 0
                Behavior on color {
                    ColorAnimation { duration: 200; easing.type: Easing.InOutQuad }
                }
                Behavior on radius {
                    NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                }
                Connections {
                    target: Pipewire.defaultAudioSink?.audio
                    function onVolumeChanged() {
                        if (Pipewire.defaultAudioSink?.audio?.volume !== undefined) {
                            audioDock.currentVolume = Pipewire.defaultAudioSink.audio.volume
                        } else {
                            audioDock.currentVolume = 0
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onEntered: {
                        audioDock.color = "#aa1b1b"
                        audioDock.radius = 5
                        volumeBar.color = "#682929"
                    }
                    onExited: {
                        audioDock.color = "#4c4c4c" 
                        audioDock.radius = 20
                        volumeBar.color = "#2c2c2c"
                    }
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onWheel: {
                        if (wheel.angleDelta.y > 0)
                            Pipewire.defaultAudioSink.audio.volume = Math.min(1.0, audioDock.currentVolume + 0.05)
                        else
                            Pipewire.defaultAudioSink.audio.volume = Math.max(0.0, audioDock.currentVolume - 0.05)
                    }
                    onClicked: {
                        if (Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio) {
                            let audio = Pipewire.defaultAudioSink.audio
                            audio.muted = !audio.muted
                        }
                    }
                }

                Text {
                    anchors.top: parent
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.left: parent
                    anchors.right: parent
                    color: "white"
                    font.pixelSize: 0.01111 * Screen.height
                    font.family: "FiraMono Nerd Font"
                    text: Pipewire.defaultAudioSink?.audio?.muted ? "󰖁 мутік" : "󰕾 " + Math.round(audioDock.currentVolume * 100) + "%"
                }

                Rectangle {
                    id: volumeBar
                    anchors {
                        left: parent.left
                        bottom: parent.bottom
                        leftMargin: 0.003906 * Screen.width
                        bottomMargin: 0.004166 * Screen.height
                    }
                    height: 0.004166 * Screen.height
                    Behavior on color {
                        ColorAnimation { duration: 200; easing.type: Easing.InOutQuad }
                    }
                    width: parent.width - (0.0078125 * Screen.width)
                    radius: 3
                    color: "#2c2c2c"

                    Rectangle {
                        anchors {
                            left: parent.left
                            top: parent.top
                            bottom: parent.bottom
                        }
                        width: parent.width * audioDock.currentVolume
                        radius: 3
                        color: "#ffffff"
                        Behavior on width {
                            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                        }
                    }
                }
            }

            Rectangle {
                id: tmbg
                color: "#4c4c4c"
                height: 0.023611 * Screen.height
                radius: 14
                anchors.verticalCenter: timeDisplay.verticalCenter
                anchors.left: timeDisplay.left
                anchors.leftMargin: (-0.0125) * Screen.width
                width: timeDisplay.width + (0.025 * Screen.width)

                Behavior on width {
                    NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                }
                Behavior on x {
                    NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                }
            }
            RowLayout {
                id: workspaces
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 0.03125 * Screen.width
                }
                spacing: 0.00078125 * Screen.width

                Repeater {
                    model: niri.workspaces

                    Rectangle {
                        id: wsrect
                        property bool hovered: false
                        width: 0.009084375 * Screen.width
                        height: 0.01484375 * Screen.height
                        radius: hovered ? 5 : 40
                        color: model.isActive ? "#aa1b1b" : '#3c3c3c'
                        visible: index < 10
                        Behavior on color {
                            ColorAnimation { duration: 200; easing.type: Easing.InOutQuad }
                        }
                        Behavior on width {
                            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                        }
                        Behavior on radius {
                            NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: niri.focusWorkspaceById(model.id)
                            onEntered: wsrect.hovered = true
                            onExited: wsrect.hovered = false
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }
            }
            Text {
                id: timeDisplay
                anchors {
                    verticalCenter: parent.verticalCenter
                    centerIn: parent
                }

                property string currentTime: ""

                text: currentTime
                color: "#ffffff"
                font.pixelSize: 0.0138888 * Screen.height
                font.family: "URW Gothic"
                
                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: {
                        var now = new Date()
                        timeDisplay.currentTime = Qt.formatDate(now, "MMMM dd") + " " + Qt.formatTime(now, "hh:mm:ss")  
                    }
                }
                
                Component.onCompleted: {
                    var now = new Date()
                    currentTime = Qt.formatDate(now, "MMMM dd") + " " + Qt.formatTime(now, "hh:mm:ss")
                }
            }
            
            Text {
                id: distroIcon
                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: startMenu.horizontalCenter
                }
                color: "#ffffff"
                font.family: "FiraMono Nerd Font"
                text: "" // or other "󰌽"
                font.pixelSize: Screen.height * 0.01789
                scale: 1
                Behavior on scale {
                    NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                }
            }
        }
    }
}
