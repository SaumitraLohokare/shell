import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland

// Bottom Details Panels
PanelWindow {
    id: bottomDetailsPanel

    required property ShellScreen screen
    required property int barWidth
    required property string currentPanel

    visible: true

    anchors.left: true
    anchors.bottom: true

    // Position
    margins.left: barWidth - 1
    margins.bottom: 12

    readonly property Item visibleContent: {
        if (currentPanel === "clock") return clockContent;
        if (currentPanel === "volume") return volumeContent;
        if (currentPanel === "wifi") return wifiContent;
        return null;
    }

    readonly property bool hasContent: visibleContent !== null

    implicitWidth: hasContent ? (visibleContent?.implicitWidth ?? 0) + 48 : 0
    implicitHeight: hasContent ? (visibleContent?.implicitHeight ?? 0) + 48 : 0

    color: "transparent"
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    Behavior on implicitWidth {
        NumberAnimation { duration: 250; easing.type: Easing.OutQuad }
    }

    Behavior on implicitHeight {
        NumberAnimation { duration: 250; easing.type: Easing.OutQuad }
    }

    Rectangle {
        anchors.fill: parent
        color: "#1a1a1a"
        topRightRadius: 12

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
            id: clockContent
            anchors.fill: parent
            visible: currentPanel === "clock"
            implicitWidth: clockInnerContent.implicitWidth
            implicitHeight: clockInnerContent.implicitHeight

            Calendar {
                id: clockInnerContent
                anchors.centerIn: parent
                anchors.margins: 12
            }
        }

        // Volume Content
        Item {
            id: volumeContent
            anchors.fill: parent
            visible: currentPanel === "volume"
            implicitWidth: volumeInnerContent.implicitWidth
            implicitHeight: volumeInnerContent.implicitHeight

            Volume {
                id: volumeInnerContent
                anchors.centerIn: parent
                anchors.margins: 12
            }
        }

        // WiFi Content
        Item {
            id: wifiContent
            anchors.fill: parent
            visible: currentPanel === "wifi"
            implicitWidth: wifiInnerContent.implicitWidth
            implicitHeight: wifiInnerContent.implicitHeight

            Text {
                id: wifiInnerContent
                anchors.centerIn: parent
                anchors.margins: 12

                text: "Network list goes here"
                color: "#aaaaaa"
                font.pixelSize: 16
                font.family: "monospace"
            }
        }
    }
}

