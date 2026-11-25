// Round character image with accent ring.
// Drawn with Canvas instead of a shader effect, so it also works without
// GPU acceleration (software rendering, VMs, background screenshots).
import QtQuick

Item {
    id: avatar

    required property var stage
    property url source: ""
    property real ring: Math.max(2, width * 0.04)
    property real cornerRatio: 0.5
    property int alignTop: 1

    Rectangle {
        anchors.fill: parent
        radius: width * avatar.cornerRatio
        gradient: Gradient {
            GradientStop { position: 0; color: avatar.stage.accent }
            GradientStop { position: 1; color: avatar.stage.accent2 }
        }
    }

    Rectangle {
        id: hole
        anchors.fill: parent
        anchors.margins: avatar.ring
        radius: width * avatar.cornerRatio
        color: avatar.stage.surfaceAlt
    }

    // only for the image size (aspect ratio); drawing happens on the Canvas
    Image {
        id: img
        visible: false
        source: avatar.source
        sourceSize.width: 64
        asynchronous: true
        onStatusChanged: if (status === Image.Ready) canvas.requestPaint()
    }

    Canvas {
        id: canvas
        anchors.fill: hole
        renderStrategy: Canvas.Cooperative
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        readonly property string src: String(avatar.source)
        onSrcChanged: if (src.length) loadImage(src)
        onAvailableChanged: if (available) requestPaint()
        onImageLoaded: requestPaint()
        Component.onCompleted: if (src.length) loadImage(src)
        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            if (!src.length || !isImageLoaded(src) || img.status !== Image.Ready || width <= 0 || height <= 0) return;
            // rounded shape as clip
            const r = Math.min(width, height) * avatar.cornerRatio;
            ctx.beginPath();
            ctx.moveTo(r, 0);
            ctx.arcTo(width, 0, width, height, r);
            ctx.arcTo(width, height, 0, height, r);
            ctx.arcTo(0, height, 0, 0, r);
            ctx.arcTo(0, 0, width, 0, r);
            ctx.closePath();
            ctx.clip();
            // "PreserveAspectCrop", aligned to the top or center
            const iw = img.implicitWidth, ih = img.implicitHeight;
            const scale = Math.max(width / iw, height / ih);
            const dw = iw * scale, dh = ih * scale;
            const dx = (width - dw) / 2;
            const dy = avatar.alignTop ? 0 : (height - dh) / 2;
            ctx.drawImage(src, dx, dy, dw, dh);
        }
    }
}
