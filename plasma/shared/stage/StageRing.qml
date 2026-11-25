// Circular gauge (0..1) with accent gradient.
import QtQuick
import QtQuick.Shapes

Item {
    id: ring

    required property var stage
    property real value: 0
    property real thickness: Math.max(3, width * 0.08)
    property color color: stage.accent
    property color color2: stage.accent2
    property color track: stage.alpha(stage.text, 0.10)

    readonly property real clamped: Math.max(0, Math.min(1, value))
    property real shown: clamped

    Behavior on shown {
        enabled: ring.stage.animations
        NumberAnimation { duration: 600; easing.type: Easing.OutCubic }
    }

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeColor: ring.track
            strokeWidth: ring.thickness
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            PathAngleArc {
                centerX: ring.width / 2
                centerY: ring.height / 2
                radiusX: (Math.min(ring.width, ring.height) - ring.thickness) / 2
                radiusY: radiusX
                startAngle: 0
                sweepAngle: 360
            }
        }

        ShapePath {
            strokeWidth: ring.thickness
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            strokeColor: ring.color
            PathAngleArc {
                centerX: ring.width / 2
                centerY: ring.height / 2
                radiusX: (Math.min(ring.width, ring.height) - ring.thickness) / 2
                radiusY: radiusX
                startAngle: -90
                sweepAngle: 360 * ring.shown
            }
        }
    }
}
