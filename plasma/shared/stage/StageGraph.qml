// History graph for up to two series. Append values with push(a, b);
// maxValue <= 0 scales automatically to the maximum.
import QtQuick

Canvas {
    id: graph

    required property var stage
    property int samples: 60
    property real maxValue: 100
    property color color: stage.accent
    property color color2: stage.accent2
    property bool second: true
    property var a: []
    property var b: []

    function push(va, vb) {
        const na = a.slice(-(samples - 1));
        na.push(Math.max(0, va || 0));
        a = na;
        if (second) {
            const nb = b.slice(-(samples - 1));
            nb.push(Math.max(0, vb || 0));
            b = nb;
        }
        requestPaint();
    }

    function scale() {
        if (maxValue > 0) return maxValue;
        let m = 1;
        for (let i = 0; i < a.length; ++i) m = Math.max(m, a[i]);
        for (let j = 0; j < b.length; ++j) m = Math.max(m, b[j]);
        return m * 1.15;
    }

    onPaint: {
        const ctx = getContext("2d");
        ctx.reset();
        const w = width, h = height, top = scale();

        // grid lines
        ctx.strokeStyle = Qt.rgba(stage.text.r, stage.text.g, stage.text.b, 0.07);
        ctx.lineWidth = 1;
        for (let g = 1; g < 4; ++g) {
            const y = Math.round(h * g / 4) + 0.5;
            ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(w, y); ctx.stroke();
        }

        function series(values, col, fill) {
            if (values.length < 2) return;
            const step = w / (samples - 1);
            const x0 = w - (values.length - 1) * step;
            ctx.beginPath();
            for (let i = 0; i < values.length; ++i) {
                const x = x0 + i * step;
                const y = h - Math.min(1, values[i] / top) * (h - 2) - 1;
                if (i === 0) ctx.moveTo(x, y); else ctx.lineTo(x, y);
            }
            ctx.strokeStyle = col;
            ctx.lineWidth = 2;
            ctx.lineJoin = "round";
            ctx.stroke();
            if (fill) {
                ctx.lineTo(w, h);
                ctx.lineTo(x0, h);
                ctx.closePath();
                const grad = ctx.createLinearGradient(0, 0, 0, h);
                grad.addColorStop(0, Qt.rgba(col.r, col.g, col.b, 0.35));
                grad.addColorStop(1, Qt.rgba(col.r, col.g, col.b, 0.0));
                ctx.fillStyle = grad;
                ctx.fill();
            }
        }
        if (second) series(b, color2, false);
        series(a, color, true);
    }

    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
}
