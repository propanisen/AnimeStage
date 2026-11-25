// Popup in AnimeStage style (system load, calendar …): header with the anime's
// banner (darkened, accent-colored tint), title with Japanese
// subtitle, a character (cutout) reaching in on the right. Content below.
//
//   Stage.StagePopup { stage: vc; title: "Auslastung"; jp: "システム"; …content… }
import QtQuick
import QtQuick.Layouts

Item {
    id: pop

    required property var stage
    property string title: ""
    property string jp: ""
    property string subtitle: ""
    property real u: 16
    property real headerHeight: u * 5.4
    property real titleSize: u * 1.5
    property bool showFigure: true
    default property alias content: body.data

    readonly property var heroes: stage.anime.heroCuts || []
    // a different character every day
    readonly property string figure: heroes.length ? "file://" + heroes[(new Date().getDate() + title.length) % heroes.length] : ""
    readonly property string banner: stage.anime.banner ? "file://" + stage.anime.banner : stage.cover()

    // ---------------------------------------------------------------- header
    Item {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: pop.headerHeight
        clip: true

        Item {
            id: headerArt
            anchors.fill: parent

            Rectangle { anchors.fill: parent; color: pop.stage.surfaceAlt }
            Image {
                anchors.fill: parent
                source: pop.banner
                fillMode: Image.PreserveAspectCrop
                sourceSize.width: 900
                asynchronous: true
                opacity: 0.6
            }
            // tint: accent on the left, second color on the right
            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0; color: pop.stage.alpha(pop.stage.accent, 0.35) }
                    GradientStop { position: 0.6; color: pop.stage.alpha(pop.stage.bg, 0.25) }
                    GradientStop { position: 1; color: pop.stage.alpha(pop.stage.accent2, 0.25) }
                }
            }
            // fade out downwards into the background
            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0; color: pop.stage.alpha(pop.stage.bg, 0.1) }
                    GradientStop { position: 0.55; color: pop.stage.alpha(pop.stage.bg, 0.45) }
                    GradientStop { position: 1; color: pop.stage.alpha(pop.stage.bg, 0.97) }
                }
            }
            // character on the right, cropped at the top, faded out at the bottom
            Image {
                visible: pop.showFigure && pop.figure.length > 0
                source: pop.figure
                anchors.right: parent.right
                anchors.rightMargin: pop.u * 0.6
                y: pop.u * 0.3
                height: parent.height * 1.9
                width: parent.width * 0.42
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignRight
                verticalAlignment: Image.AlignTop
                sourceSize.height: 700
                asynchronous: true
            }
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: parent.height * 0.35
                gradient: Gradient {
                    GradientStop { position: 0; color: pop.stage.alpha(pop.stage.bg, 0) }
                    GradientStop { position: 1; color: pop.stage.alpha(pop.stage.bg, 0.95) }
                }
            }
        }
        // title
        Column {
            anchors.left: parent.left
            anchors.leftMargin: pop.u
            anchors.bottom: parent.bottom
            anchors.bottomMargin: pop.u * 0.35
            spacing: 0
            StageText {
                stage: pop.stage
                text: pop.jp
                visible: pop.jp.length > 0
                color: pop.stage.accent
                font.pixelSize: pop.u * 0.72
                font.weight: Font.Bold
                font.letterSpacing: pop.u * 0.08
            }
            StageText {
                stage: pop.stage
                display: true
                text: pop.title
                font.pixelSize: pop.titleSize
                style: Text.Raised
                styleColor: pop.stage.alpha(pop.stage.bg, 0.6)
            }
            StageText {
                stage: pop.stage
                text: pop.subtitle
                visible: pop.subtitle.length > 0
                color: pop.stage.muted
                font.pixelSize: pop.u * 0.7
            }
        }
        // signature: short gradient along the bottom edge
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: pop.u
            anchors.bottom: parent.bottom
            width: Math.min(parent.width * 0.3, 110)
            height: 2
            radius: 1
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0; color: pop.stage.accent }
                GradientStop { position: 1; color: pop.stage.alpha(pop.stage.accent2, 0) }
            }
        }
    }

    // ---------------------------------------------------------------- content
    ColumnLayout {
        id: body
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: pop.u * 0.8
        anchors.topMargin: pop.u * 0.6
        spacing: pop.u * 0.6
    }
}
