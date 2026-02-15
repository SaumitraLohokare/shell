import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects

// Top Details Panel
PanelWindow {
    id: topDetailsPanel

    required property ShellScreen screen
    required property int barWidth
    required property string currentPanel

    visible: true

    anchors.left: true
    anchors.top: true

    // Position
    margins.left: barWidth - 1
    margins.top: 12

    readonly property Item visibleContent: {
        if (currentPanel === "oslogo") return osContent;
        return null;
    }

    readonly property bool hasContent: visibleContent !== null

    implicitWidth: hasContent ? (visibleContent?.implicitWidth ?? 0) + 48 : 0
    implicitHeight: (visibleContent?.implicitHeight ?? 0) + 48

    color: "transparent"
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    Behavior on implicitWidth {
        NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
    }
    
    Rectangle {
        anchors.fill: parent
        color: "#1a1a1a"
        bottomRightRadius: 12

        // Drop Shadow
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowBlur: 0.8
            shadowOpacity: 0.5
            shadowColor: "#000000"
        }

        // Clock Content
        Item {
            id: osContent
            anchors.fill: parent
            visible: currentPanel === "oslogo"
            implicitWidth: osInnerContent.implicitWidth
            implicitHeight: osInnerContent.implicitHeight

            Text {
                id: osInnerContent
                anchors.centerIn: parent
                anchors.margins: 16

                text: "OS Details Content goes here"
                color: "#aaaaaa"
                font.pixelSize: 16
                font.family: "monospace"
            }
        }
    }
}
