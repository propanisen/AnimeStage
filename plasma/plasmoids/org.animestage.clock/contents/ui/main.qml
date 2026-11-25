// Time + date in the panel (colon in accent color, optional Japanese
// weekday). Click opens a large time block and a month calendar.
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import "stage" as Stage

PlasmoidItem {
    id: root

    property date now: new Date()
    property date shownMonth: new Date(now.getFullYear(), now.getMonth(), 1)
    readonly property bool use24h: vc.opt("clock.use24h", true)
    readonly property bool showSeconds: vc.opt("clock.seconds", false)
    readonly property bool japanese: vc.opt("clock.japanese", true)
    readonly property var jpDays: ["日", "月", "火", "水", "木", "金", "土"]
    readonly property bool inPanel: Plasmoid.formFactor === PlasmaCore.Types.Horizontal
                                    || Plasmoid.formFactor === PlasmaCore.Types.Vertical

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    preferredRepresentation: inPanel ? compactRepresentation : fullRepresentation
    toolTipMainText: now.toLocaleDateString(vc.locale, vc.tr("dddd, d. MMMM yyyy"))
    toolTipSubText: japanese ? jpDays[now.getDay()] + "曜日" : ""

    onExpandedChanged: if (root.expanded) root.shownMonth = new Date(now.getFullYear(), now.getMonth(), 1)

    Stage.StageConfig { id: vc }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.now = new Date()
    }

    function pad(n) { return n < 10 ? "0" + n : String(n); }
    function hours() { const h = root.now.getHours(); return root.pad(root.use24h ? h : (h % 12 || 12)); }

    // ------------------------------------------------------------ Panel
    compactRepresentation: MouseArea {
        id: compact
        Layout.minimumWidth: col.implicitWidth + height * 0.4
        Layout.preferredWidth: Layout.minimumWidth
        hoverEnabled: true
        onClicked: root.expanded = !root.expanded

        Column {
            id: col
            anchors.centerIn: parent
            spacing: -compact.height * 0.04
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                Stage.StageText { stage: vc; display: true; font.pixelSize: compact.height * 0.40; text: root.hours() }
                Stage.StageText { stage: vc; display: true; font.pixelSize: compact.height * 0.40; text: ":"; color: vc.accent }
                Stage.StageText { stage: vc; display: true; font.pixelSize: compact.height * 0.40; text: root.pad(root.now.getMinutes()) }
                Stage.StageText {
                    visible: root.showSeconds
                    stage: vc
                    font.pixelSize: compact.height * 0.22
                    text: " " + root.pad(root.now.getSeconds())
                    color: vc.accent
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: compact.height * 0.04
                }
            }
            Stage.StageText {
                anchors.horizontalCenter: parent.horizontalCenter
                stage: vc
                text: root.now.toLocaleDateString(vc.locale, vc.tr("ddd d. MMM")) + (root.japanese ? "  " + root.jpDays[root.now.getDay()] : "")
                color: vc.muted
                font.pixelSize: compact.height * 0.22
            }
        }
    }

    // ------------------------------------------------------------ Popup
    readonly property var jpMonths: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]

    fullRepresentation: Stage.StagePopup {
        id: pop
        stage: vc
        u: Kirigami.Units.gridUnit
        headerHeight: Kirigami.Units.gridUnit * 6.2
        titleSize: Kirigami.Units.gridUnit * 2.6
        title: root.hours() + ":" + root.pad(root.now.getMinutes())
        jp: root.jpMonths[root.now.getMonth()] + root.now.getDate() + "日 · " + root.jpDays[root.now.getDay()] + "曜日"
        subtitle: root.now.toLocaleDateString(vc.locale, vc.tr("dddd, d. MMMM yyyy"))
        Layout.minimumWidth: Kirigami.Units.gridUnit * 19
        Layout.preferredWidth: Kirigami.Units.gridUnit * 21
        Layout.preferredHeight: Kirigami.Units.gridUnit * 26

        Stage.StagePanel {
            stage: vc
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: pop.u * 0.6
                spacing: pop.u * 0.3

                // month header with paging
                RowLayout {
                    Layout.fillWidth: true
                    Stage.StageButton {
                        stage: vc; icon: "go-previous"; implicitWidth: pop.u * 1.6
                        onClicked: root.shownMonth = new Date(root.shownMonth.getFullYear(), root.shownMonth.getMonth() - 1, 1)
                    }
                    Item {
                        Layout.fillWidth: true
                        implicitHeight: monthCol.implicitHeight
                        Column {
                            id: monthCol
                            anchors.left: parent.left
                            anchors.right: parent.right
                            Stage.StageText {
                                anchors.horizontalCenter: parent.horizontalCenter
                                stage: vc
                                display: true
                                text: root.shownMonth.toLocaleDateString(vc.locale, vc.tr("MMMM yyyy"))
                                font.pixelSize: pop.u * 0.95
                            }
                            Stage.StageText {
                                anchors.horizontalCenter: parent.horizontalCenter
                                stage: vc
                                text: root.shownMonth.getFullYear() + "年" + root.jpMonths[root.shownMonth.getMonth()]
                                color: vc.accent
                                font.pixelSize: pop.u * 0.6
                            }
                        }
                        MouseArea { anchors.fill: parent; onClicked: root.shownMonth = new Date(root.now.getFullYear(), root.now.getMonth(), 1) }
                    }
                    Stage.StageButton {
                        stage: vc; icon: "go-next"; implicitWidth: pop.u * 1.6
                        onClicked: root.shownMonth = new Date(root.shownMonth.getFullYear(), root.shownMonth.getMonth() + 1, 1)
                    }
                }

                GridLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    columns: 7
                    rowSpacing: 2
                    columnSpacing: 2

                    // weekdays Mon–Sun (with Japanese character)
                    Repeater {
                        model: [vc.tr("Mo"), vc.tr("Di"), vc.tr("Mi"), vc.tr("Do"), vc.tr("Fr"), vc.tr("Sa"), vc.tr("So")]
                        Item {
                            id: head
                            required property string modelData
                            required property int index
                            // same base width for all columns, otherwise the grid distributes unevenly
                            Layout.fillWidth: true
                            Layout.preferredWidth: 1
                            implicitHeight: headCol.implicitHeight
                            Column {
                                id: headCol
                                anchors.horizontalCenter: parent.horizontalCenter
                                Stage.StageText {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    stage: vc
                                    text: head.modelData
                                    color: head.index >= 5 ? vc.accent2 : vc.muted
                                    font.pixelSize: pop.u * 0.62
                                    font.weight: Font.Bold
                                }
                                Stage.StageText {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    stage: vc
                                    text: root.jpDays[(head.index + 1) % 7]
                                    color: vc.alpha(head.index >= 5 ? vc.accent2 : vc.muted, 0.6)
                                    font.pixelSize: pop.u * 0.5
                                }
                            }
                        }
                    }
                    Repeater {
                        model: 42
                        Item {
                            id: cell
                            required property int index
                            readonly property int offset: (root.shownMonth.getDay() + 6) % 7
                            readonly property date day: new Date(root.shownMonth.getFullYear(), root.shownMonth.getMonth(), index - offset + 1)
                            readonly property bool inMonth: day.getMonth() === root.shownMonth.getMonth()
                            readonly property bool today: day.toDateString() === root.now.toDateString()
                            readonly property bool weekend: index % 7 >= 5
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.preferredWidth: 1
                            Layout.preferredHeight: 1
                            Rectangle {
                                anchors.centerIn: parent
                                width: Math.min(parent.width, parent.height) * 0.92
                                height: width
                                radius: width / 2
                                visible: cell.today || dayMouse.containsMouse
                                gradient: Gradient {
                                    GradientStop { position: 0; color: cell.today ? vc.accent : vc.alpha(vc.accent, 0.15) }
                                    GradientStop { position: 1; color: cell.today ? vc.accent2 : vc.alpha(vc.accent2, 0.15) }
                                }
                            }
                            Stage.StageText {
                                anchors.centerIn: parent
                                stage: vc
                                text: cell.day.getDate()
                                color: cell.today ? vc.onAccent : (!cell.inMonth ? vc.alpha(vc.muted, 0.4) : (cell.weekend ? vc.accent2 : vc.text))
                                font.weight: cell.today ? Font.Bold : Font.Normal
                                font.pixelSize: pop.u * 0.75
                            }
                            MouseArea { id: dayMouse; anchors.fill: parent; hoverEnabled: true }
                        }
                    }
                }
            }
        }
    }
}
