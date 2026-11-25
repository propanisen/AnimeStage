// Inner card for popups: slightly raised surface with a thin accent edge.
import QtQuick

Rectangle {
    required property var stage
    radius: stage.radius * 0.8
    color: stage.alpha(stage.surfaceAlt, 0.55)
    border.width: 1
    border.color: stage.alpha(stage.accent, 0.18)
}
