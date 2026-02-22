import Quickshell
import Quickshell.Wayland
import QtQuick
import Niri 0.1

PanelWindow {
    id: root
    WlrLayershell.layer: WlrLayer.Bottom
    exclusiveZone: 0
    color: "transparent"
    mask: Region {}
    width: Screen.width
    height: Screen.height
    Rectangle {
        id: corners
        anchors.fill: parent
        anchors.topMargin: -0.0675 * Screen.height
        anchors.bottomMargin: -0.068 * Screen.height
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