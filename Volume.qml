import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

Item {
    id: root

    implicitWidth: volumeLayout.implicitWidth
    implicitHeight: volumeLayout.implicitHeight

    // Bind the audio sink
    PwObjectTracker {
        objects: Pipewire.defaultAudioSink ? [Pipewire.defaultAudioSink] : []
    }

    ColumnLayout {
        id: volumeLayout
        anchors.fill: parent
        spacing: 12

        // Header
        Text {
            Layout.fillWidth: true
            text: "Volume"
            color: "#aaaaaa"
            font.pixelSize: 18
            font.family: "monospace"
            font.bold: true
        }

        // Device Name
        Text {
            Layout.fillWidth: true
            text: Pipewire.defaultAudioSink?.description || "No output device"
            color: "#aaaaaa"
            font.pixelSize: 12
            font.family: "monospace"
            elide: Text.ElideRight
        }

        // Volume Control Row
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 32

                Rectangle {
                    anchors.fill: parent
                    color: "#2a2a2a"
                    radius: 16

                    Rectangle {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width * (Pipewire.defaultAudioSink?.audio?.volume ?? 0)
                        height: parent.height
                        color: muteButton.muted ? "#555555" : "#00aaff"
                        radius: parent.radius

                        Behavior on width {
                            NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                        }

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        function updateVolume(mouse) {
                            if (Pipewire.defaultAudioSink?.ready && Pipewire.defaultAudioSink?.audio) {
                                const newVolume = Math.max(0, Math.min(1, mouse.x / width));
                                Pipewire.defaultAudioSink.audio.volume = newVolume;
                                if (muteButton.muted) {
                                    Pipewire.defaultAudioSink.audio.muted = false;
                                }
                            }
                        }

                        onClicked: function(mouse) { updateVolume(mouse); }
                        onPositionChanged: function(mouse) {
                            if (pressed) {
                                updateVolume(mouse);
                            }
                        }
                    }
                }
            }

            // Volume Percentage
            Text {
                text: {
                    if (muteButton.muted) return "Muted";
                    const vol = Math.round((Pipewire.defaultAudioSink?.audio?.volume ?? 0) * 100);
                    return vol + "%";
                }
                color: muteButton.muted ? "#777777" : "#aaaaaa"
                font.pixelSize: 14
                font.family: "monospace"
                font.bold: true
                horizontalAlignment: Text.AlignRight

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            // Mute Button
            Rectangle {
                id: muteButton
                Layout.preferredWidth: 44
                Layout.preferredHeight: 32
                radius: 6
                color: hovered ? (muted ? "#ff6b6b" : "#2a2a2a") : (muted ? "#cc5555" : "#2a2a2a")

                property bool hovered: false
                readonly property bool muted: Pipewire.defaultAudioSink?.audio?.muted ?? false

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }

                Text {
                    anchors.centerIn: parent
                    text: muteButton.muted ? "🔇" : "🔊"
                    font.pixelSize: 18
                }

                HoverHandler {
                    onHoveredChanged: muteButton.hovered = hovered
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    onTapped: {
                        if (Pipewire.defaultAudioSink?.ready && Pipewire.defaultAudioSink?.audio) {
                            Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted;
                        }
                    }
                }
            }
        }
    }
}
