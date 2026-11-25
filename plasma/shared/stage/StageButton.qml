// Round icon button with accent hover.
import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami

Rectangle {
    id: btn

    required property var stage
    property string icon: ""
    property string tooltip: ""
    property bool primary: false
    property real iconScale: 0.55
    property bool mask: true          // false = colored icon (e.g. an SVG file)
    readonly property bool hovered: mouse.containsMouse
    signal clicked

    QQC2.ToolTip.text: tooltip
    QQC2.ToolTip.visible: tooltip.length > 0 && hovered
    QQC2.ToolTip.delay: 400

    implicitWidth: Kirigami.Units.gridUnit * 2
    implicitHeight: implicitWidth
    radius: width / 2
    color: primary ? stage.accent : (mouse.containsMouse ? stage.alpha(stage.accent, 0.18) : stage.alpha(stage.text, 0.06))
    border.width: primary ? 0 : 1
    border.color: stage.alpha(stage.accent, mouse.containsMouse ? 0.6 : 0.15)
    scale: mouse.pressed ? 0.92 : 1

    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on scale { NumberAnimation { duration: 90 } }

    Kirigami.Icon {
        anchors.centerIn: parent
        width: parent.width * btn.iconScale
        height: width
        source: btn.icon
        color: btn.primary ? btn.stage.onAccent : btn.stage.text
        isMask: btn.mask
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: btn.clicked()
    }
}
