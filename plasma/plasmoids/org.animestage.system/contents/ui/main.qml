// System load in the panel: three rings (CPU, RAM, GPU). Click opens details with
// history and temperatures. Data comes from /proc, hwmon and nvidia-smi.
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as P5Support
import org.kde.kirigami as Kirigami
import "stage" as Stage

PlasmoidItem {
    id: root

    property real cpu: 0          // 0..100
    property real ram: 0
    property real gpu: -1         // -1 = no GPU data
    property real cpuTemp: -1
    property real gpuTemp: -1
    property real ramUsed: 0      // GiB
    property real ramTotal: 0
    property real vramUsed: 0
    property real vramTotal: 0
    property var lastCpu: null

    readonly property bool showGpu: vc.opt("system.gpu", true) && gpu >= 0
    readonly property bool inPanel: Plasmoid.formFactor === PlasmaCore.Types.Horizontal
                                    || Plasmoid.formFactor === PlasmaCore.Types.Vertical

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    preferredRepresentation: inPanel ? compactRepresentation : fullRepresentation
    toolTipMainText: vc.tr("Auslastung")
    toolTipSubText: "CPU " + Math.round(cpu) + " %  ·  RAM " + Math.round(ram) + " %" + (showGpu ? "  ·  GPU " + Math.round(gpu) + " %" : "")

    Stage.StageConfig { id: vc }

    P5Support.DataSource {
        id: probe
        readonly property string cmd: "head -1 /proc/stat; grep -E '^(MemTotal|MemAvailable):' /proc/meminfo; "
            + "for h in /sys/class/hwmon/hwmon*; do n=$(cat $h/name 2>/dev/null); "
            + "case $n in k10temp|coretemp|zenpower) echo CPUTEMP $(cat $h/temp1_input 2>/dev/null);; esac; done; "
            + "command -v nvidia-smi >/dev/null && echo GPU $(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null | head -1) "
            + "|| for c in /sys/class/drm/card*/device/gpu_busy_percent; do echo AMDGPU $(cat $c); break; done"
        engine: "executable"
        interval: 2000
        connectedSources: [cmd]
        onNewData: function (source, data) { root.parse(data["stdout"] || ""); }
    }

    function parse(out) {
        const lines = out.split("\n");
        let memTotal = 0, memAvail = 0;
        for (let i = 0; i < lines.length; ++i) {
            const l = lines[i].trim();
            if (l.indexOf("cpu ") === 0) {
                const v = l.split(/\s+/).slice(1).map(Number);
                const idle = v[3] + (v[4] || 0);
                const total = v.reduce((a, b) => a + b, 0);
                if (lastCpu) {
                    const dt = total - lastCpu.total, di = idle - lastCpu.idle;
                    if (dt > 0) cpu = Math.max(0, Math.min(100, 100 * (1 - di / dt)));
                }
                lastCpu = { total: total, idle: idle };
            } else if (l.indexOf("MemTotal:") === 0) {
                memTotal = Number(l.split(/\s+/)[1]);
            } else if (l.indexOf("MemAvailable:") === 0) {
                memAvail = Number(l.split(/\s+/)[1]);
            } else if (l.indexOf("CPUTEMP ") === 0) {
                const t = Number(l.substring(8)) / 1000;
                if (t > 0) cpuTemp = t;
            } else if (l.indexOf("GPU ") === 0) {
                const g = l.substring(4).split(",").map(s => Number(s.trim()));
                if (!isNaN(g[0])) {
                    gpu = g[0]; gpuTemp = g[1] || -1;
                    vramUsed = (g[2] || 0) / 1024; vramTotal = (g[3] || 0) / 1024;
                }
            } else if (l.indexOf("AMDGPU ") === 0) {
                const a = Number(l.substring(7));
                if (!isNaN(a)) gpu = a;
            }
        }
        if (memTotal > 0) {
            ram = 100 * (1 - memAvail / memTotal);
            ramTotal = memTotal / 1048576;
            ramUsed = (memTotal - memAvail) / 1048576;
        }
        history.push(cpu, ram);
        if (gpu >= 0) gpuHistory.push(gpu, 0);
    }

    // history keeps running while the popup is closed
    Stage.StageGraph { id: history; stage: vc; visible: false; samples: 90 }
    Stage.StageGraph { id: gpuHistory; stage: vc; visible: false; samples: 90; second: false }

    function ringColor(v) {
        return v >= 90 ? vc.negative : (v >= 70 ? vc.accent2 : vc.accent);
    }

    // ------------------------------------------------------------ Panel
    compactRepresentation: MouseArea {
        id: compact
        readonly property real h: height
        readonly property real ringSize: h * 0.56
        Layout.minimumWidth: row.implicitWidth + h * 0.2
        Layout.preferredWidth: Layout.minimumWidth
        hoverEnabled: true
        onClicked: root.expanded = !root.expanded

        Row {
            id: row
            anchors.centerIn: parent
            spacing: compact.h * 0.18
            Repeater {
                model: root.showGpu ? ["CPU", "RAM", "GPU"] : ["CPU", "RAM"]
                Column {
                    required property string modelData
                    readonly property real value: modelData === "CPU" ? root.cpu : (modelData === "RAM" ? root.ram : root.gpu)
                    spacing: -compact.h * 0.02
                    Item {
                        width: compact.ringSize
                        height: width
                        anchors.horizontalCenter: parent.horizontalCenter
                        Stage.StageRing {
                            anchors.fill: parent
                            stage: vc
                            value: parent.parent.value / 100
                            thickness: Math.max(2, width * 0.12)
                            color: root.ringColor(parent.parent.value)
                        }
                        Stage.StageText {
                            anchors.centerIn: parent
                            stage: vc
                            text: Math.round(parent.parent.value)
                            font.pixelSize: compact.ringSize * 0.36
                            font.weight: Font.Bold
                        }
                    }
                    Stage.StageText {
                        anchors.horizontalCenter: parent.horizontalCenter
                        stage: vc
                        text: modelData
                        color: vc.muted
                        font.pixelSize: compact.h * 0.17
                        font.weight: Font.Bold
                    }
                }
            }
        }
    }

    // ------------------------------------------------------------ Popup
    fullRepresentation: Stage.StagePopup {
        id: pop
        stage: vc
        u: Kirigami.Units.gridUnit
        title: vc.tr("Auslastung")
        jp: "システム · " + vc.info.jp
        subtitle: "CPU · RAM" + (root.showGpu ? " · GPU" : "")
        Layout.minimumWidth: Kirigami.Units.gridUnit * 21
        Layout.preferredWidth: Kirigami.Units.gridUnit * 24
        Layout.preferredHeight: Kirigami.Units.gridUnit * 24

        Stage.StagePanel {
            stage: vc
            Layout.fillWidth: true
            Layout.preferredHeight: ringRow.implicitHeight + pop.u * 1.2
            RowLayout {
                id: ringRow
                anchors.fill: parent
                anchors.margins: pop.u * 0.6
                spacing: pop.u * 0.6
                Repeater {
                    model: [
                        { k: "CPU", jp: "演算", v: root.cpu, sub: root.cpuTemp > 0 && vc.opt("system.temps", true) ? Math.round(root.cpuTemp) + " °C" : "" },
                        { k: "RAM", jp: "記憶", v: root.ram, sub: root.ramUsed.toFixed(1) + " / " + root.ramTotal.toFixed(0) + " GiB" },
                        { k: "GPU", jp: "画像", v: root.gpu, sub: (root.gpuTemp > 0 && vc.opt("system.temps", true) ? Math.round(root.gpuTemp) + " °C  " : "") + (root.vramTotal > 0 ? root.vramUsed.toFixed(1) + " GiB" : "") }
                    ].filter(m => m.k !== "GPU" || root.showGpu)
                    ColumnLayout {
                        required property var modelData
                        Layout.fillWidth: true
                        spacing: 1
                        Item {
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: pop.u * 4.4
                            Layout.preferredHeight: Layout.preferredWidth
                            // soft glow in the ring color
                            Rectangle {
                                anchors.centerIn: parent
                                width: parent.width * 0.78
                                height: width
                                radius: width / 2
                                color: vc.alpha(root.ringColor(modelData.v), 0.10)
                            }
                            Stage.StageRing { anchors.fill: parent; stage: vc; value: modelData.v / 100; color: root.ringColor(modelData.v) }
                            Column {
                                anchors.centerIn: parent
                                Stage.StageText {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    stage: vc
                                    display: true
                                    text: Math.round(modelData.v) + "%"
                                    font.pixelSize: pop.u * 1.1
                                }
                                Stage.StageText {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    stage: vc
                                    text: modelData.jp
                                    color: vc.muted
                                    font.pixelSize: pop.u * 0.55
                                }
                            }
                        }
                        Stage.StageText { Layout.alignment: Qt.AlignHCenter; stage: vc; text: modelData.k; font.weight: Font.Bold; font.pixelSize: pop.u * 0.75; color: root.ringColor(modelData.v) }
                        Stage.StageText { Layout.alignment: Qt.AlignHCenter; stage: vc; text: modelData.sub; color: vc.muted; font.pixelSize: pop.u * 0.62 }
                    }
                }
            }
        }

        Stage.StagePanel {
            stage: vc
            Layout.fillWidth: true
            Layout.fillHeight: true
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: pop.u * 0.6
                spacing: pop.u * 0.3
                RowLayout {
                    spacing: pop.u * 0.4
                    Rectangle { width: 12; height: 4; radius: 2; color: vc.accent }
                    Stage.StageText { stage: vc; text: "CPU"; color: vc.muted; font.pixelSize: pop.u * 0.62 }
                    Rectangle { width: 12; height: 4; radius: 2; color: vc.accent2 }
                    Stage.StageText { stage: vc; text: "RAM"; color: vc.muted; font.pixelSize: pop.u * 0.62 }
                    Item { Layout.fillWidth: true }
                    Stage.StageText { stage: vc; text: vc.tr("letzte 3 Minuten  ·  三分"); color: vc.muted; font.pixelSize: pop.u * 0.58 }
                }
                Stage.StageGraph {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    stage: vc
                    samples: history.samples
                    a: history.a
                    b: history.b
                    onAChanged: requestPaint()
                }
            }
        }
    }
}
