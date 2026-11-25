// AnimeStage splash screen. Colors, name and image are written by `animestage apply splash`
// into theme.js and images/hero.png.
import QtQuick
import "theme.js" as Theme

Rectangle {
    id: root

    property int stage
    readonly property var t: Theme.t
    readonly property real u: Math.min(width, height) / 40

    color: t.bg

    onStageChanged: {
        if (stage === 2) intro.start();
    }

    // staff lines across the screen
    Column {
        anchors.centerIn: parent
        spacing: root.u * 1.4
        rotation: -8
        Repeater {
            model: 5
            Rectangle {
                width: root.width * 1.5
                height: 2
                color: root.t.accent
                opacity: 0.08
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 1.0; color: Qt.rgba(0.2, 0.8, 0.75, 0.10) }
        }
    }

    Image {
        id: hero
        visible: root.t.hasHero
        source: "images/hero.png"
        anchors.right: parent.right
        anchors.rightMargin: root.width * 0.08
        anchors.bottom: parent.bottom
        height: parent.height * 0.92
        fillMode: Image.PreserveAspectFit
        opacity: 0
        sourceSize.height: height
        smooth: true
        mipmap: true
        transform: Translate { id: heroShift; x: root.u * 3 }
    }

    Column {
        id: title
        anchors.left: parent.left
        anchors.leftMargin: root.width * 0.1
        anchors.verticalCenter: parent.verticalCenter
        spacing: root.u * 0.6
        opacity: 0

        Text {
            text: "ANIMESTAGE  ▸  " + root.t.number
            color: root.t.muted
            font.pixelSize: root.u * 0.9
            font.letterSpacing: root.u * 0.3
            font.family: "M PLUS Rounded 1c"
        }
        Text {
            text: root.t.jp
            color: root.t.text
            font.pixelSize: root.u * 4.5
            font.weight: Font.ExtraBold
            font.family: "M PLUS Rounded 1c"
        }
        Text {
            text: root.t.name.toUpperCase()
            color: root.t.accent
            font.pixelSize: root.u * 1.6
            font.weight: Font.Bold
            font.letterSpacing: root.u * 0.25
            font.family: "M PLUS Rounded 1c"
        }

        Item { width: 1; height: root.u * 1.5 }

        Rectangle {
            width: root.u * 16
            height: root.u * 0.35
            radius: height / 2
            color: Qt.rgba(1, 1, 1, 0.08)

            Rectangle {
                height: parent.height
                radius: height / 2
                width: parent.width * Math.min(1, root.stage / 6)
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0; color: root.t.accent }
                    GradientStop { position: 1; color: root.t.accent2 }
                }
                Behavior on width { NumberAnimation { duration: 450; easing.type: Easing.OutCubic } }
            }
        }
    }

    ParallelAnimation {
        id: intro
        NumberAnimation { target: title; property: "opacity"; to: 1; duration: 600; easing.type: Easing.OutCubic }
        NumberAnimation { target: hero; property: "opacity"; to: 1; duration: 900; easing.type: Easing.OutCubic }
        NumberAnimation { target: heroShift; property: "x"; to: 0; duration: 900; easing.type: Easing.OutCubic }
    }
}
