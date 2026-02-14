import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

ShellRoot {
    Variants {
        model: Quickshell.screens

        Scope {
            id: scope
            required property ShellScreen modelData
            property bool showClockDetails: false

            // Exclusion zones
            PanelWindow {
                screen: scope.modelData
                anchors.left: true
                exclusiveZone: 60
                mask: Region {}
                implicitWidth: 1
                implicitHeight: 1
            }

            PanelWindow {
                screen: scope.modelData
                anchors.top: true
                exclusiveZone: 12
                mask: Region {}
                implicitWidth: 1
                implicitHeight: 1
            }

            PanelWindow {
                screen: scope.modelData
                anchors.right: true
                exclusiveZone: 12
                mask: Region {}
                implicitWidth: 1
                implicitHeight: 1
            }

            PanelWindow {
                screen: scope.modelData
                anchors.bottom: true
                exclusiveZone: 12
                mask: Region {}
                implicitWidth: 1
                implicitHeight: 1
            }

            PanelWindow {
                id: win

                screen: scope.modelData
                anchors.top: true
                anchors.bottom: true
                anchors.left: true
                anchors.right: true

                color: "transparent"
                WlrLayershell.exclusionMode: ExclusionMode.Ignore

                // Border config
                property int borderThickness: 12
                property int borderRounding: 12
                property int barWidth: 60

                // Creates border effect
                mask: Region {
                    x: win.barWidth
                    y: win.borderThickness
                    width: win.width - win.barWidth - win.borderThickness
                    height: win.height - win.borderThickness * 2
                    intersection: Intersection.Xor

                    // Additional region for bar
                    Region {
                        x: 0
                        y: 0
                        width: win.barWidth
                        height: win.height
                        intersection: Intersection.Subtract
                    }
                }

                // Border rectangle
                Item {
                    anchors.fill: parent

                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        blurMax: 15
                        shadowColor: Qt.rgba(0, 0, 0, 0.5)
                    }

                    // Border rectangle
                    Rectangle {
                        anchors.fill: parent
                        color: "#1a1a1a"

                        layer.enabled: true
                        layer.effect: MultiEffect {
                            maskSource: borderMask
                            maskEnabled: true
                            maskInverted: true
                            maskThresholdMin: 0.5
                            maskSpreadAtMin: 1
                        }
                    }

                    // Mask for border
                    Item {
                        id: borderMask
                        anchors.fill: parent
                        layer.enabled: true
                        visible: false

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: win.borderThickness
                            anchors.leftMargin: win.barWidth
                            radius: win.borderRounding
                        }
                    }

                    // Sidebar
                    Rectangle {
                        id: bar
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        width: win.barWidth
                        color: "#1a1a1a"

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            anchors.bottomMargin: 14
                            anchors.topMargin: 14
                            spacing: 8

                            // Logo
                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter
                                implicitWidth: 44
                                implicitHeight: 44
                                radius: 22
                                color: logoHoverHandler.hovered ? "#2a2a2a" : "transparent" 

                                Text {
                                    anchors.centerIn: parent
                                    text: "♚"
                                    color: "#00aaff"
                                    font.pixelSize: 32
                                }

                                HoverHandler {
                                    id: logoHoverHandler
                                    cursorShape: Qt.PointerHandCursor
                                }

                                // TODO: Tap Handler
                            }

                            // Workspaces
                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter
                                implicitWidth: workspaceColumn.implicitWidth + 16
                                implicitHeight: workspaceColumn.implicitHeight + 12
                                radius: 12
                                color: "#2a2a2a"

                                Column {
                                    id: workspaceColumn
                                    anchors.centerIn: parent
                                    spacing: 6

                                    Repeater {
                                        model: 2

                                        Rectangle {
                                            width: 8
                                            height: index == 0 ? 16 : 10
                                            radius: 4
                                            color: index == 0 ? "#00aaff" : "#555555"

                                            Behavior on color {
                                                ColorAnimation { duration: 200 }
                                            }
                                        }
                                    }
                                }
                            }

                            // Top Spacer
                            Item {
                                Layout.fillHeight: true
                            }

                            // Active Window
                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter
                                implicitWidth: 44
                                implicitHeight: Math.min(activeWindowText.implicitWidth, 200)
                                color: "transparent"

                                Text {
                                    id: activeWindowText
                                    anchors.centerIn: parent
                                    text: "Active Window"
                                    color: "#aaaaaa"
                                    font.pixelSize: 14
                                    font.family: "monospace"

                                    transform: Rotation {
                                        angle: 90
                                        origin.x: activeWindowText.implicitWidth / 2
                                        origin.y: activeWindowText.implicitHeight / 2
                                    }
                                }
                            }

                            // Bottom Spacer
                            Item {
                                Layout.fillHeight: true
                            }

                            // System Tray
                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter
                                implicitWidth: 44
                                implicitHeight: trayColumn.implicitHeight + 12
                                radius: 22
                                color: "transparent"

                                Column {
                                    id: trayColumn
                                    anchors.centerIn: parent
                                    spacing: 6

                                    Repeater {
                                        model: 3

                                        Rectangle {
                                            width: 12
                                            height: 12
                                            radius: 4
                                            color: index == 0 ? "#ff6b6b" : index == 1 ? "#4ecdc4" : "#ffe66d"
                                        }
                                    }
                                }
                            }

                            // Separator
                            Rectangle {
                                implicitWidth: 44
                                implicitHeight: 1
                                opacity: 0.5
                                color: "#aaaaaa"
                            }

                            // Status Icons
                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter
                                implicitWidth: 44
                                implicitHeight: statusColumn.implicitHeight + 12
                                color: "transparent"

                                Column {
                                    id: statusColumn
                                    anchors.centerIn: parent
                                    spacing: 6

                                    // WiFi Icon
                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "📶" 
                                        font.pixelSize: 14
                                    }

                                    // Volume Icon
                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "🔊" 
                                        font.pixelSize: 14
                                    }
                                }
                            }

                            // Separator
                            Rectangle {
                                implicitWidth: 44
                                implicitHeight: 1
                                opacity: 0.5
                                color: "#aaaaaa"
                            }

                            // 24-Hour Clock
                            Rectangle {
                                id: clockContainer
                                Layout.alignment: Qt.AlignHCenter
                                implicitWidth: 44
                                implicitHeight: clockColumn.implicitHeight + 8
                                radius: 4

                                // Background Color
                                color: hoverHandler.hovered ? "#2a2a2a" : "transparent"

                                Behavior on color {
                                    ColorAnimation { duration: 150 }
                                }

                                Column {
                                    id: clockColumn
                                    anchors.centerIn: parent
                                    spacing: 4

                                    Text {
                                        id: dayText
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: Qt.formatDateTime(new Date(), "ddd")
                                        color: "#ffffff"
                                        font.pixelSize: 12
                                        font.family: "monospace"
                                        font.bold: true
                                    }

                                    Text {
                                        id: hourText
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: Qt.formatDateTime(new Date(), "HH:mm")
                                        color: "#ffffff"
                                        font.pixelSize: 12
                                        font.family: "monospace"
                                        font.bold: true
                                    }

                                    Timer {
                                        interval: 1000
                                        running: true
                                        repeat: true
                                        onTriggered: {
                                            const now = new Date()
                                            dayText.text = Qt.formatDateTime(now, "ddd")
                                            hourText.text = Qt.formatDateTime(now, "HH:mm")
                                        }
                                    }
                                }

                                HoverHandler {
                                    id: hoverHandler
                                    cursorShape: Qt.PointerHandCursor
                                }

                                TapHandler {
                                    onTapped: scope.showClockDetails = !scope.showClockDetails
                                }
                            }
                        }
                    }
                }
            }

            // Clock details panel
            PanelWindow {
                id: detailsPanel

                screen: scope.modelData
                visible: true

                anchors.left: true
                anchors.bottom: true

                // Position
                margins.left: win.barWidth - 1
                margins.bottom: 12

                width: scope.showClockDetails ? detailsText.width + 48 : 0
                height: detailsText.height + 48

                color: "transparent"
                WlrLayershell.exclusionMode: ExclusionMode.Ignore

                Behavior on width {
                    NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                }

                Behavior on height {
                    NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                }

                Rectangle {
                    id: detailsContent
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

                    Text {
                        id: detailsText
                        anchors.centerIn: parent
                        anchors.margins: 16

                        text: "Calendar goes here"
                        color: "#ffffff"
                        font.pixelSize: 16
                        font.family: "monospace"

                        // Fade in/out animation
                        opacity: scope.showClockDetails ? 1 : 0
                        Behavior on opacity {
                            NumberAnimation { duration: 100 }
                        }
                    }
                }
            }
        }
    }
}
