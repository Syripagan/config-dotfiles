import Quickshell
import Quickshell.Wayland
import QtQuick
Item {
    PanelWindow {
        id: root
        WlrLayershell.layer: WlrLayer.Background 
        exclusiveZone: 1
        color: "transparent"
        mask: Region {}
        anchors.top: true
        anchors.left: true
        anchors.right: true
        width: Screen.width
        height: Screen.height - 112.5
        Rectangle {
            id: corners
            anchors.fill: parent
            anchors.topMargin: -0.0675 * Screen.height
            anchors.bottomMargin: -0.070 * Screen.height
            anchors.leftMargin: -0.066 * Screen.height
            anchors.rightMargin: anchors.leftMargin
            color: "transparent"
            radius: 130 
            border.width: 102
            border.color: "#2c2c2c"
        }
        Rectangle {
            id: mainFrame
            anchors.fill: parent
            anchors.topMargin: corners.anchors.topMargin
            anchors.bottomMargin: corners.anchors.bottomMargin
            color: "transparent"
            radius: 30
            border.color: "#2c2c2c"
            border.width: Math.max(1, Math.round(0.00195 * Screen.width))
        }
    }
}