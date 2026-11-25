// Card in AnimeStage style: translucent surface, thin accent edge and
// a short gradient at the top left as signature.
import QtQuick

Rectangle {
    id: card

    required property var stage
    property bool stripe: true
    property real opacityOverride: -1

    radius: stage.radius
    color: stage.alpha(stage.surface, opacityOverride >= 0 ? opacityOverride : stage.widgetOpacity)
    border.width: 1
    border.color: stage.alpha(stage.accent, stage.borderOpacity)

    Behavior on color {
        enabled: card.stage.animations
        ColorAnimation { duration: 400 }
    }

    Rectangle {
        visible: card.stripe
        x: card.radius
        y: 0
        width: Math.min(card.width * 0.32, 120)
        height: 2
        radius: 1
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0; color: card.stage.accent }
            GradientStop { position: 1; color: card.stage.alpha(card.stage.accent2, 0) }
        }
    }
}
