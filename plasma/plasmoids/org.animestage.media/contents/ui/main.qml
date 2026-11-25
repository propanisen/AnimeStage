// Now playing: simple pill in the panel (play/pause, title, artist,
// progress line), mouse wheel = next/previous. Click opens cover + controls.
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.private.mpris as Mpris
import org.kde.kirigami as Kirigami
import "stage" as Stage

PlasmoidItem {
    id: root

    readonly property var player: mpris.currentPlayer
    readonly property bool hasPlayer: player !== null && player !== undefined
    readonly property bool playing: hasPlayer && player.playbackStatus === Mpris.PlaybackStatus.Playing
    readonly property string track: hasPlayer && player.track ? player.track : ""
    readonly property string artist: hasPlayer && player.artist ? player.artist : ""
    readonly property string artUrl: hasPlayer && player.artUrl ? String(player.artUrl) : ""
    readonly property real progress: hasPlayer && player.length > 0 ? player.position / player.length : 0
    readonly property bool inPanel: Plasmoid.formFactor === PlasmaCore.Types.Horizontal
                                    || Plasmoid.formFactor === PlasmaCore.Types.Vertical

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    Plasmoid.status: hasPlayer ? PlasmaCore.Types.ActiveStatus : PlasmaCore.Types.PassiveStatus
    preferredRepresentation: inPanel ? compactRepresentation : fullRepresentation
    toolTipMainText: track.length ? track : vc.tr("Keine Musik")
    toolTipSubText: artist.length ? artist + "\n" + vc.tr("Mausrad: vor/zurück") : ""

    Stage.StageConfig { id: vc }
    Mpris.Mpris2Model { id: mpris }

    Timer {
        interval: 1000
        repeat: true
        running: root.playing
        onTriggered: root.player.updatePosition()
    }

    function fmt(us) {
        const s = Math.max(0, Math.floor(us / 1000000));
        return Math.floor(s / 60) + ":" + (s % 60 < 10 ? "0" : "") + (s % 60);
    }

    // ------------------------------------------------------------ Panel
    compactRepresentation: MouseArea {
        id: compact

        readonly property real h: height
        readonly property real pad: h * 0.22
        readonly property real btn: h * 0.5
        readonly property real textWidth: root.hasPlayer ? Math.min(Kirigami.Units.gridUnit * 10, Math.max(titleText.implicitWidth, artistText.implicitWidth)) : 0
        Layout.minimumWidth: root.hasPlayer ? pad + btn + pad * 0.7 + textWidth + pad * 1.3 : h * 0.8
        Layout.preferredWidth: Layout.minimumWidth
        hoverEnabled: true
        onClicked: root.expanded = !root.expanded

        Rectangle {
            visible: root.hasPlayer
            anchors.fill: parent
            anchors.topMargin: compact.h * 0.14
            anchors.bottomMargin: compact.h * 0.14
            radius: height / 2
            color: compact.containsMouse || root.expanded ? vc.alpha(vc.text, 0.10) : vc.alpha(vc.text, 0.05)
            clip: true
            Behavior on color { ColorAnimation { duration: 150 } }

            // progress as a thin line at the bottom edge
            Rectangle {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin: parent.radius * 0.6
                height: Math.max(1.5, compact.h * 0.04)
                radius: height / 2
                width: (parent.width - parent.radius * 1.2) * Math.min(1, Math.max(0, root.progress))
                color: vc.alpha(vc.accent, root.playing ? 0.85 : 0.4)
            }
        }

        Kirigami.Icon {
            visible: !root.hasPlayer
            anchors.centerIn: parent
            width: compact.h * 0.42
            height: width
            source: "media-default-album-symbolic"
            fallback: "audio-x-generic-symbolic"
            isMask: true
            color: vc.alpha(vc.muted, 0.7)
        }

        Row {
            visible: root.hasPlayer
            anchors.verticalCenter: parent.verticalCenter
            x: compact.pad
            spacing: compact.pad * 0.7

            Item {
                width: compact.btn
                height: width
                anchors.verticalCenter: parent.verticalCenter
                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: playMouse.containsMouse ? vc.alpha(vc.accent, 0.22) : "transparent"
                    border.width: 1
                    border.color: vc.alpha(vc.accent, playMouse.containsMouse ? 0.8 : 0.45)
                }
                Kirigami.Icon {
                    anchors.centerIn: parent
                    width: parent.width * 0.52
                    height: width
                    source: root.playing ? "media-playback-pause" : "media-playback-start"
                    isMask: true
                    color: vc.accent
                }
                MouseArea {
                    id: playMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.player.PlayPause()
                }
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                width: compact.textWidth
                Stage.StageText {
                    id: titleText
                    width: parent.width
                    stage: vc
                    text: root.track.length ? root.track : (root.player ? root.player.identity : "")
                    font.pixelSize: compact.h * 0.25
                    font.weight: Font.DemiBold
                }
                Stage.StageText {
                    id: artistText
                    width: parent.width
                    stage: vc
                    text: root.artist
                    color: vc.muted
                    font.pixelSize: compact.h * 0.21
                }
            }
        }

        WheelHandler {
            onWheel: function (event) {
                if (!root.hasPlayer) return;
                if (event.angleDelta.y < 0 && root.player.canGoNext) root.player.Next();
                else if (event.angleDelta.y > 0 && root.player.canGoPrevious) root.player.Previous();
            }
        }
    }

    // ------------------------------------------------------------ Popup
    fullRepresentation: Stage.StageCard {
        id: card
        stage: vc
        opacityOverride: root.inPanel ? 0 : -1
        border.width: root.inPanel ? 0 : 1
        Layout.minimumWidth: Kirigami.Units.gridUnit * 22
        Layout.preferredWidth: Kirigami.Units.gridUnit * 26
        Layout.preferredHeight: Kirigami.Units.gridUnit * 10

        readonly property real u: Kirigami.Units.gridUnit

        RowLayout {
            anchors.fill: parent
            anchors.margins: card.u
            spacing: card.u

            Rectangle {
                Layout.preferredHeight: card.height - card.u * 2
                Layout.preferredWidth: Layout.preferredHeight
                radius: vc.radius * 0.7
                color: vc.surfaceAlt
                clip: true
                Image {
                    anchors.fill: parent
                    source: root.artUrl.length ? root.artUrl : vc.image("media")
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: card.u * 0.2

                Stage.StageText {
                    Layout.fillWidth: true
                    stage: vc
                    display: true
                    text: root.track.length ? root.track : vc.tr("Keine Musik")
                    font.pixelSize: card.u * 1.05
                    wrapMode: Text.Wrap
                    maximumLineCount: 2
                }
                Stage.StageText { Layout.fillWidth: true; stage: vc; text: root.artist; color: vc.accent; font.pixelSize: card.u * 0.8 }
                Stage.StageText { Layout.fillWidth: true; stage: vc; text: root.player ? root.player.identity : ""; color: vc.muted; font.pixelSize: card.u * 0.65 }

                Item { Layout.fillHeight: true }

                Rectangle {
                    Layout.fillWidth: true
                    height: 4
                    radius: 2
                    color: vc.alpha(vc.text, 0.1)
                    Rectangle {
                        width: parent.width * Math.min(1, Math.max(0, root.progress))
                        height: parent.height
                        radius: 2
                        color: vc.accent
                    }
                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -6
                        enabled: root.hasPlayer && root.player.canSeek
                        cursorShape: Qt.PointingHandCursor
                        onClicked: function (m) { root.player.position = root.player.length * Math.max(0, Math.min(1, (m.x - 6) / parent.width)); }
                    }
                }
                RowLayout {
                    Layout.fillWidth: true
                    Stage.StageText { stage: vc; text: root.hasPlayer ? root.fmt(root.player.position) : ""; color: vc.muted; font.pixelSize: card.u * 0.6 }
                    Item { Layout.fillWidth: true }
                    Stage.StageText { stage: vc; text: root.hasPlayer ? root.fmt(root.player.length) : ""; color: vc.muted; font.pixelSize: card.u * 0.6 }
                }
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: card.u * 0.6
                    Stage.StageButton { stage: vc; icon: "media-skip-backward"; tooltip: vc.tr("Vorheriger Titel"); enabled: root.hasPlayer && root.player.canGoPrevious; onClicked: root.player.Previous() }
                    Stage.StageButton { stage: vc; icon: root.playing ? "media-playback-pause" : "media-playback-start"; tooltip: vc.tr("Play/Pause"); enabled: root.hasPlayer; onClicked: root.player.PlayPause() }
                    Stage.StageButton { stage: vc; icon: "media-skip-forward"; tooltip: vc.tr("Nächster Titel"); enabled: root.hasPlayer && root.player.canGoNext; onClicked: root.player.Next() }
                }
            }
        }
    }
}
