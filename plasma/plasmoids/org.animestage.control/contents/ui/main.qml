import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Dialogs
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kquickcontrols as KQuickControls
import org.kde.kirigami as Kirigami
import "stage" as Stage

PlasmoidItem {
    id: root

    property string status: vc.tr("Bereit.")
    property bool busy: false
    property var images: []
    property var backups: []
    property var wall: ({})
    property var wallItems: []
    property var results: []
    property var themed: ({})
    property var updateInfo: ({})
    property var sourceInfo: ({ "current": {}, "options": { "wallpaper": [], "cutouts": [] } })

    function search(text) {
        busy = true;
        status = vc.tr("Suche „%1“ auf AniList …", [text]);
        vc.run(["search", text], "search");
    }

    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground
    // Icon only in the panel; as a window (plasmawindowed) and on the desktop the full UI.
    readonly property bool inPanel: Plasmoid.formFactor === PlasmaCore.Types.Horizontal
                                    || Plasmoid.formFactor === PlasmaCore.Types.Vertical
    preferredRepresentation: inPanel ? compactRepresentation : fullRepresentation
    toolTipMainText: vc.tr("AnimeStage-Kontrollzentrum")

    Stage.StageConfig { id: vc }

    // Runs an animestage command with status display.
    function cli(args, label) {
        busy = true;
        status = label + " …";
        vc.run(args, "cc-" + args[0]);
    }

    function refreshImages() { vc.run(["images", "--json"], "cc-list"); }
    function refreshBackups() { vc.run(["backups"], "cc-backups"); }
    function refreshSources() { vc.run(["source", "list"], "sourcelist"); }
    function refreshUpdate() { vc.run(["update", "status"], "updstatus"); }
    function refreshThemed() { vc.run(["themed", "status"], "themedstatus"); }
    function refreshWall() { vc.run(["wall", "status"], "wallstatus"); vc.run(["wall", "list"], "walllist"); }

    Connections {
        target: vc
        function onCommandFinished(tag, code, stdout, stderr) {
            if (tag === "cc-list") {
                try { root.images = JSON.parse(stdout); } catch (e) {}
                return;
            }
            if (tag === "search") {
                root.busy = false;
                try { root.results = JSON.parse(stdout); root.status = vc.tr("%1 Treffer", [root.results.length]); }
                catch (e) { root.status = vc.tr("✗ Suche fehlgeschlagen – Internet?"); }
                return;
            }
            if (tag === "walllist") {
                try { root.wallItems = JSON.parse(stdout); } catch (e) {}
                return;
            }
            if (tag === "sourcelist") {
                try { root.sourceInfo = JSON.parse(stdout); } catch (e) {}
                return;
            }
            if (tag === "updstatus") {
                try { root.updateInfo = JSON.parse(stdout); } catch (e) {}
                return;
            }
            if (tag === "themedstatus") {
                try { root.themed = JSON.parse(stdout); } catch (e) {}
                return;
            }
            if (tag === "wallstatus") {
                try { root.wall = JSON.parse(stdout); } catch (e) {}
                return;
            }
            if (tag === "cc-backups") {
                root.backups = stdout.trim().length ? stdout.trim().split("\n") : [];
                return;
            }
            if (tag.indexOf("cc-") !== 0) return;
            root.busy = false;
            const lines = (code === 0 ? stdout : (stderr || stdout)).trim().split("\n");
            root.status = (code === 0 ? "✓ " : "✗ ") + (lines[lines.length - 1] || "fertig");
            if (["cc-cuts", "cc-use-image", "cc-anime", "cc-add-folder", "cc-remove-folder"].indexOf(tag) >= 0) root.refreshImages();
            if (tag === "cc-anime" || tag === "cc-set") root.refreshWall();
            if (["cc-themed", "cc-set", "cc-anime", "cc-apps", "cc-wall", "cc-source"].indexOf(tag) >= 0) root.refreshThemed();
            if (tag === "cc-update") root.refreshUpdate();
            if (tag === "cc-source") { root.refreshSources(); root.refreshWall(); root.refreshImages(); }
            if (tag === "cc-gender") { root.refreshWall(); root.refreshImages(); root.refreshThemed(); }
            if (tag === "cc-backup" || tag === "cc-layout") root.refreshBackups();
            if (tag === "cc-wall" || tag === "cc-login") { root.refreshWall(); root.refreshImages(); }
        }
    }

    Component.onCompleted: {
        refreshImages();
        refreshBackups();
        refreshWall();
        refreshThemed();
        refreshSources();
        refreshUpdate();
    }

    compactRepresentation: Kirigami.Icon {
        source: "file://" + vc.dataHome + "/icons/hicolor/scalable/apps/animestage-control.svg"
        MouseArea {
            anchors.fill: parent
            onClicked: root.expanded = !root.expanded
        }
    }

    // ------------------------------------------------------------------ UI
    fullRepresentation: Rectangle {
        id: win

        readonly property real u: Kirigami.Units.gridUnit
        Layout.minimumWidth: u * 46
        Layout.minimumHeight: u * 32
        Layout.preferredWidth: u * 56
        Layout.preferredHeight: u * 38
        color: vc.bg

        component SectionTitle: Stage.StageText {
            stage: vc
            display: true
            font.pixelSize: win.u * 1.2
            Layout.fillWidth: true
            Layout.topMargin: win.u * 0.4
        }
        component Hint: Stage.StageText {
            stage: vc
            color: vc.muted
            font.pixelSize: win.u * 0.7
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }
        component Pill: Rectangle {
            id: pill
            property string text
            property bool active: false
            property bool accentFill: true
            signal clicked
            implicitWidth: pillText.implicitWidth + win.u * 1.6
            implicitHeight: win.u * 2
            radius: height / 2
            color: active ? vc.accent : (pillMouse.containsMouse ? vc.alpha(vc.accent, 0.18) : vc.alpha(vc.text, 0.06))
            border.width: 1
            border.color: vc.alpha(vc.accent, active ? 0 : 0.25)
            opacity: enabled ? 1 : 0.45
            Stage.StageText {
                id: pillText
                anchors.centerIn: parent
                stage: vc
                text: pill.text
                color: pill.active ? vc.onAccent : vc.text
                font.pixelSize: win.u * 0.75
                font.weight: Font.Medium
            }
            MouseArea {
                id: pillMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: pill.clicked()
            }
        }
        component Slide: RowLayout {
            id: slide
            property string label
            property string path
            property real from: 0
            property real to: 1
            property real step: 0.01
            property var applyParts: ["style"]
            property bool percent: true
            Layout.fillWidth: true
            Stage.StageText { stage: vc; text: slide.label; Layout.preferredWidth: win.u * 13; font.pixelSize: win.u * 0.8; elide: Text.ElideRight }
            QQC2.Slider {
                id: sl
                Layout.fillWidth: true
                from: slide.from
                to: slide.to
                stepSize: slide.step
                value: vc.opt(slide.path, slide.from)
                onPressedChanged: if (!pressed) vc.set(slide.path, Math.round(value * 100) / 100)
            }
            Stage.StageText {
                stage: vc
                text: slide.percent ? Math.round(sl.value * 100) + " %" : Math.round(sl.value) + " px"
                color: vc.accent
                Layout.preferredWidth: win.u * 3
                font.pixelSize: win.u * 0.8
            }
        }
        // Own image for terminal background or Firefox: source, own search, preview
        component ThemedPicker: ColumnLayout {
            id: tp
            property string target
            property string srcPath
            property string tagsPath
            property string everyPath
            property string applyPart
            property var sources: []
            readonly property string source: vc.opt(srcPath, "anime")
            readonly property bool fetching: ["anime", "animesuche", "suche"].indexOf(source) >= 0
            readonly property bool searching: source === "animesuche" || source === "suche"
            readonly property var info: root.themed[target] || ({})
            function search(text) {
                root.cli(["themed", "new", tp.target, "--tags", text], vc.tr("Suche „%1“ …", [text]));
            }
            Layout.fillWidth: true
            spacing: win.u * 0.45

            RowLayout {
                Stage.StageText { stage: vc; text: vc.tr("Bild aus"); font.pixelSize: win.u * 0.8; Layout.preferredWidth: win.u * 8 }
                QQC2.ComboBox {
                    textRole: "text"; valueRole: "value"
                    Layout.preferredWidth: win.u * 19
                    model: tp.sources
                    currentIndex: indexOfValue(tp.source)
                    enabled: !root.busy
                    onActivated: root.cli(["set", tp.srcPath, currentValue, "--apply", tp.applyPart], vc.tr("Bild wird eingerichtet"))
                }
            }
            ColumnLayout {
                visible: tp.searching
                Layout.fillWidth: true
                spacing: win.u * 0.35
                RowLayout {
                    Layout.fillWidth: true
                    QQC2.TextField {
                        id: tagField
                        Layout.fillWidth: true
                        text: vc.opt(tp.tagsPath, "")
                        placeholderText: vc.tr("Suchbegriffe, z. B.  night, city  oder  sunset, sea")
                        onAccepted: if (text.trim().length) tp.search(text.trim())
                    }
                    Pill { text: vc.tr("🔍 Suchen"); active: true; enabled: !root.busy && tagField.text.trim().length > 0; onClicked: tp.search(tagField.text.trim()) }
                }
                Flow {
                    Layout.fillWidth: true
                    spacing: win.u * 0.3
                    Repeater {
                        model: [{ t: vc.tr("🌙 Nacht"), v: "night, sky" }, { t: vc.tr("✨ Sterne"), v: "stars" }, { t: vc.tr("🌆 Stadt"), v: "city, night" },
                                { t: vc.tr("🌅 Abendrot"), v: "sunset" }, { t: vc.tr("🌊 Meer"), v: "sea" }, { t: vc.tr("🌸 Kirschblüten"), v: "cherry_blossoms" },
                                { t: vc.tr("🌧 Regen"), v: "rain" }, { t: vc.tr("❄ Schnee"), v: "snow" }, { t: vc.tr("🏞 Landschaft"), v: "scenic" }]
                        Pill {
                            required property var modelData
                            text: modelData.t
                            enabled: !root.busy
                            onClicked: { tagField.text = modelData.v; tp.search(modelData.v); }
                        }
                    }
                }
                Hint { text: tp.source === "suche" ? vc.tr("Sucht auf ganz Konachan (unabhängig vom Anime). Englische Begriffe, mit Komma getrennt – höchstens drei.") : vc.tr("Bilder aus deinem Anime, die zusätzlich zu den Suchbegriffen passen. Findet er nichts, nimm weniger oder allgemeinere Begriffe.") }
            }
            RowLayout {
                visible: tp.source !== "none"
                spacing: win.u * 0.8
                Rectangle {
                    Layout.preferredWidth: win.u * 15
                    Layout.preferredHeight: win.u * 8.4
                    radius: win.u * 0.5
                    color: vc.surfaceAlt
                    clip: true
                    Image {
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                        sourceSize.width: 480
                        source: tp.info.image ? "file://" + tp.info.image : ""
                    }
                    Stage.StageText {
                        anchors.centerIn: parent
                        visible: !tp.info.image
                        stage: vc
                        text: vc.tr("noch kein Bild")
                        color: vc.muted
                        font.pixelSize: win.u * 0.7
                    }
                }
                ColumnLayout {
                    spacing: win.u * 0.35
                    Stage.StageText {
                        stage: vc
                        text: tp.info.id ? "#" + tp.info.id + (tp.info.author ? "  ·  " + tp.info.author : "") : (tp.source === "wallpaper" ? vc.tr("Aktuelles Wallpaper") : "")
                        color: vc.muted
                        font.pixelSize: win.u * 0.72
                    }
                    Pill { visible: tp.fetching; text: vc.tr("⟳ Neues Bild"); active: true; enabled: !root.busy; onClicked: root.cli(["themed", "new", tp.target], vc.tr("Lade neues Bild")) }
                    Stage.StageText {
                        stage: vc
                        visible: tp.fetching && vc.opt(tp.everyPath, true)
                        text: tp.info.ready ? vc.tr("✓ nächstes Bild liegt bereit") : vc.tr("nächstes Bild wird beim Start geladen")
                        color: tp.info.ready ? vc.positive : vc.muted
                        font.pixelSize: win.u * 0.65
                    }
                }
            }
            QQC2.CheckBox {
                visible: tp.fetching
                text: tp.target === "firefox" ? vc.tr("Bei jedem Firefox-Start ein neues Bild") : vc.tr("Bei jedem neuen Terminal-Fenster ein neues Bild")
                checked: vc.opt(tp.everyPath, true)
                enabled: !root.busy
                onToggled: root.cli(["set", tp.everyPath, checked ? "true" : "false", "--apply", tp.applyPart], vc.tr("Einstellung"))
            }
            Hint {
                visible: tp.fetching
                text: vc.tr("Nur Konachan-Bilder mit „safe“. Alte Bilder werden sofort gelöscht – es liegen immer nur das aktuelle und das schon vorbereitete nächste Bild auf der Platte.")
            }
        }

        component Check: QQC2.CheckBox {
            id: chk
            property string path
            property bool fallback: true
            checked: vc.opt(path, fallback)
            onToggled: vc.set(path, checked)
        }

        RowLayout {
            anchors.fill: parent
            spacing: 0

            // ------------------------------------------------ sidebar
            Rectangle {
                Layout.preferredWidth: win.u * 12
                Layout.fillHeight: true
                color: vc.surface

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: win.u * 0.8
                    spacing: win.u * 0.3

                    RowLayout {
                        spacing: win.u * 0.5
                        Layout.bottomMargin: win.u * 0.8
                        Image {
                            source: "file://" + vc.dataHome + "/icons/hicolor/scalable/apps/animestage-control.svg"
                            sourceSize.width: win.u * 2.4
                            Layout.preferredWidth: win.u * 2.4
                            Layout.preferredHeight: win.u * 2.4
                        }
                        ColumnLayout {
                            spacing: 0
                            Stage.StageText { stage: vc; display: true; text: vc.tr("AnimeStage"); font.pixelSize: win.u * 1.05 }
                            Stage.StageText { stage: vc; text: "コントロールセンター"; color: vc.accent; font.pixelSize: win.u * 0.6 }
                        }
                    }

                    Repeater {
                        model: [
                            { icon: "video-television", label: vc.tr("Anime") },
                            { icon: "color-management", label: vc.tr("Farben") },
                            { icon: "image-x-generic", label: vc.tr("Bilder") },
                            { icon: "preferences-desktop-wallpaper", label: vc.tr("Hintergrund") },
                            { icon: "preferences-desktop-theme", label: vc.tr("Oberfläche") },
                            { icon: "utilities-terminal", label: vc.tr("Terminal") },
                            { icon: "internet-web-browser", label: vc.tr("Firefox") },
                            { icon: "preferences-system", label: vc.tr("System") }
                        ]
                        Rectangle {
                            required property var modelData
                            required property int index
                            readonly property bool active: pages.currentIndex === index
                            Layout.fillWidth: true
                            Layout.preferredHeight: win.u * 2.2
                            radius: win.u * 0.5
                            color: active ? vc.alpha(vc.accent, 0.18) : (navMouse.containsMouse ? vc.alpha(vc.text, 0.05) : "transparent")

                            Rectangle {
                                visible: parent.active
                                width: 3
                                height: parent.height * 0.5
                                radius: 1.5
                                anchors.verticalCenter: parent.verticalCenter
                                color: vc.accent
                            }
                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: win.u * 0.7
                                spacing: win.u * 0.6
                                Kirigami.Icon {
                                    source: modelData.icon
                                    Layout.preferredWidth: win.u * 1.1
                                    Layout.preferredHeight: win.u * 1.1
                                    color: parent.parent.active ? vc.accent : vc.text
                                    isMask: true
                                }
                                Stage.StageText {
                                    stage: vc
                                    text: modelData.label
                                    font.pixelSize: win.u * 0.85
                                    font.weight: parent.parent.active ? Font.Bold : Font.Normal
                                    Layout.fillWidth: true
                                }
                            }
                            MouseArea {
                                id: navMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: { pages.currentIndex = index; if (index === 3) root.refreshWall(); if (index === 5 || index === 6) root.refreshThemed(); }
                            }
                        }
                    }

                    Item { Layout.fillHeight: true }

                    Stage.StageAvatar {
                        Layout.preferredWidth: win.u * 5
                        Layout.preferredHeight: win.u * 5
                        Layout.alignment: Qt.AlignHCenter
                        stage: vc
                        source: vc.cover()
                    }
                    Stage.StageText {
                        stage: vc
                        text: vc.info.jp + "  ·  " + vc.info.name
                        color: vc.muted
                        font.pixelSize: win.u * 0.65
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }
                }
            }

            // ------------------------------------------------ content
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                StackLayout {
                    id: pages
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    // ============================ 1 Anime
                    QQC2.ScrollView {
                        id: animeScroll
                        contentWidth: availableWidth
                        ColumnLayout {
                            id: animeCol
                            width: animeScroll.availableWidth - win.u * 2
                            x: win.u
                            spacing: win.u * 0.6

                            function ageMin(age) {
                                const n = String(age || "").match(/\d+/g);
                                return n ? Math.min.apply(null, n.map(Number)) : -1;
                            }

                            Item { Layout.preferredHeight: win.u * 0.4 }
                            SectionTitle { text: vc.tr("Anime wählen") }
                            Hint { text: vc.tr("Suche über AniList. Danach holt AnimeStage Wallpaper von Konachan, Figuren ohne Hintergrund von Danbooru und passt alle Farben an das aktuelle Bild an.") }
                            RowLayout {
                                Layout.fillWidth: true
                                QQC2.TextField {
                                    id: searchField
                                    Layout.fillWidth: true
                                    placeholderText: vc.tr("z. B. Attack on Titan, Frieren, Spy x Family …")
                                    onAccepted: if (text.length) root.search(text)
                                }
                                Pill { text: vc.tr("Suchen"); active: true; enabled: searchField.text.length > 0; onClicked: root.search(searchField.text) }
                            }

                            Flow {
                                Layout.fillWidth: true
                                spacing: win.u * 0.5
                                visible: root.results.length > 0
                                Repeater {
                                    model: root.results
                                    Rectangle {
                                        required property var modelData
                                        width: win.u * 7.5
                                        height: win.u * 13.5
                                        radius: win.u * 0.5
                                        color: resMouse.containsMouse ? vc.alpha(vc.accent, 0.15) : vc.surface
                                        border.width: 1
                                        border.color: resMouse.containsMouse ? vc.accent : vc.alpha(vc.text, 0.08)
                                        ColumnLayout {
                                            anchors.fill: parent
                                            anchors.margins: win.u * 0.35
                                            spacing: 2
                                            Image {
                                                Layout.fillWidth: true
                                                Layout.preferredHeight: win.u * 9.6
                                                source: modelData.cover || ""
                                                fillMode: Image.PreserveAspectCrop
                                                asynchronous: true
                                                clip: true
                                            }
                                            Stage.StageText { stage: vc; text: modelData.title; font.pixelSize: win.u * 0.68; font.weight: Font.Bold; Layout.fillWidth: true; wrapMode: Text.Wrap; maximumLineCount: 2 }
                                            Stage.StageText { stage: vc; text: [modelData.format, modelData.year].filter(x => x).join(" · "); color: vc.muted; font.pixelSize: win.u * 0.58; Layout.fillWidth: true }
                                        }
                                        MouseArea {
                                            id: resMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            enabled: !root.busy
                                            onClicked: {
                                                root.cli(["anime", String(modelData.id), "--apply"], vc.tr("%1 wird eingerichtet (Figuren, Bilder, Farben)", [modelData.title]));
                                                root.results = [];
                                            }
                                        }
                                    }
                                }
                            }

                            // ---- current anime
                            Rectangle {
                                visible: !!vc.anime.id
                                Layout.fillWidth: true
                                Layout.preferredHeight: win.u * 7
                                radius: vc.radius * 0.6
                                color: vc.surfaceAlt
                                clip: true
                                Image {
                                    anchors.fill: parent
                                    source: vc.anime.banner ? "file://" + vc.anime.banner : (vc.anime.cover ? "file://" + vc.anime.cover : "")
                                    fillMode: Image.PreserveAspectCrop
                                    opacity: 0.55
                                }
                                ColumnLayout {
                                    anchors.left: parent.left
                                    anchors.bottom: parent.bottom
                                    anchors.margins: win.u * 0.8
                                    spacing: 0
                                    Stage.StageText { stage: vc; display: true; text: vc.anime.native || ""; font.pixelSize: win.u * 1.4; style: Text.Outline; styleColor: vc.alpha(vc.bg, 0.6) }
                                    Stage.StageText { stage: vc; text: (vc.anime.title || "") + (vc.anime.year ? "  ·  " + vc.anime.year : ""); font.pixelSize: win.u * 0.85; font.weight: Font.Bold; style: Text.Outline; styleColor: vc.alpha(vc.bg, 0.6) }
                                }
                            }
                            Hint { visible: !vc.anime.id; text: vc.tr("Noch kein Anime gewählt.") }

                            SectionTitle { visible: vc.anime.id !== undefined; text: vc.tr("Figuren") }
                            RowLayout {
                                visible: vc.anime.id !== undefined
                                Stage.StageText { stage: vc; text: vc.tr("Zeigen"); font.pixelSize: win.u * 0.8; Layout.preferredWidth: win.u * 5 }
                                QQC2.ComboBox {
                                    textRole: "text"; valueRole: "value"
                                    Layout.preferredWidth: win.u * 16
                                    model: [{ text: vc.tr("Nur weibliche Figuren"), value: "female" }, { text: vc.tr("Alle Figuren"), value: "all" }]
                                    currentIndex: indexOfValue(vc.opt("characters.gender", "female"))
                                    enabled: !root.busy
                                    onActivated: root.cli(["gender", currentValue], vc.tr("Suche Figuren neu"))
                                }
                            }
                            Hint {
                                visible: vc.animeChars.length > 0
                                text: vc.tr("SFW: alle Figuren. Ecchi/NSFW: nur volljährige Figuren. Das Alter kommt von AniList; ist dort keins angegeben (z. B. bei Erwachsenen wie Levi) oder nur ein Fantasy-Alter wie „1000+“, kannst du die Figur selbst als volljährig markieren. Figuren, die laut AniList unter 18 sind, bleiben gesperrt.")
                            }
                            Flow {
                                Layout.fillWidth: true
                                spacing: win.u * 0.4
                                Repeater {
                                    model: vc.animeChars
                                    Rectangle {
                                        required property var modelData
                                        readonly property int age: animeCol.ageMin(modelData.age)
                                        // as in the CLI: 18–99 counts as adult; unknown or fantasy age (≥100) only when marked
                                        readonly property bool lockable: age < 0 || age >= 100
                                        readonly property bool adult: (age >= 18 && age < 100) || (lockable && !!modelData.markedAdult)
                                        width: win.u * 11
                                        height: win.u * 4
                                        radius: win.u * 0.5
                                        color: vc.surface
                                        border.width: 1
                                        border.color: adult ? vc.alpha(vc.accent2, 0.6) : vc.alpha(vc.text, 0.08)
                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.margins: win.u * 0.3
                                            spacing: win.u * 0.4
                                            Stage.StageAvatar {
                                                Layout.preferredWidth: win.u * 3.2
                                                Layout.preferredHeight: win.u * 3.2
                                                stage: vc
                                                cornerRatio: 0.5
                                                ring: 1.5
                                                source: modelData.image ? "file://" + modelData.image : ""
                                            }
                                            ColumnLayout {
                                                Layout.fillWidth: true
                                                spacing: 0
                                                Stage.StageText { stage: vc; text: modelData.name; font.pixelSize: win.u * 0.68; font.weight: Font.Bold; Layout.fillWidth: true }
                                                Stage.StageText {
                                                    stage: vc
                                                    Layout.fillWidth: true
                                                    font.pixelSize: win.u * 0.58
                                                    color: parent.parent.parent.adult ? vc.accent2 : vc.muted
                                                    text: parent.parent.parent.lockable
                                                          ? (modelData.age ? vc.tr("Alter %1", [modelData.age]) + " · " : "") + (modelData.markedAdult ? vc.tr("volljährig (markiert)") : (modelData.age ? vc.tr("nicht markiert") : vc.tr("Alter unklar")))
                                                          : vc.tr("Alter %1", [modelData.age]) + (parent.parent.parent.adult ? "  ·  18+" : "  ·  " + vc.tr("nur SFW"))
                                                }
                                                QQC2.CheckBox {
                                                    visible: parent.parent.parent.lockable
                                                    text: vc.tr("volljährig")
                                                    checked: !!modelData.markedAdult
                                                    enabled: !root.busy
                                                    font.pixelSize: win.u * 0.58
                                                    padding: 0
                                                    onToggled: root.cli(["adult", String(modelData.id), checked ? "on" : "off"], modelData.name)
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            SectionTitle { visible: !!vc.anime.id; text: vc.tr("Stimmung") }
                            Hint { visible: !!vc.anime.id; text: vc.tr("Beeinflusst, welche Wallpaper gesucht werden. Gibt es dazu nichts, wird ohne Stimmung gesucht.") }
                            Flow {
                                visible: !!vc.anime.id
                                Layout.fillWidth: true
                                spacing: win.u * 0.4
                                Repeater {
                                    model: [{ k: "", t: vc.tr("Egal") }, { k: "ruhig", t: vc.tr("🌿 Ruhig") }, { k: "nacht", t: vc.tr("🌙 Nacht") }, { k: "action", t: vc.tr("⚔ Action") },
                                            { k: "gemuetlich", t: vc.tr("☕ Gemütlich") }, { k: "duester", t: vc.tr("🌑 Düster") }, { k: "sommer", t: vc.tr("☀ Sommer") }, { k: "winter", t: vc.tr("❄ Winter") }]
                                    Pill {
                                        required property var modelData
                                        text: modelData.t
                                        active: vc.opt("wallswitch.mood", "") === modelData.k
                                        enabled: !root.busy
                                        onClicked: root.cli(["set", "wallswitch.mood", modelData.k === "" ? '""' : modelData.k], vc.tr("Stimmung: %1", [modelData.t]))
                                    }
                                }
                            }
                            Pill {
                                visible: !!vc.anime.id
                                text: vc.tr("⟳ Jetzt passendes Wallpaper holen")
                                enabled: !root.busy
                                onClicked: root.cli(["wall", "next"], vc.tr("Suche Wallpaper"))
                            }
                        }
                    }

                    // =========================== 2 Colors
                    QQC2.ScrollView {
                        contentWidth: availableWidth
                        ColumnLayout {
                            width: parent.width
                            spacing: win.u * 0.5

                            Item { Layout.preferredHeight: win.u * 0.4 }
                            SectionTitle { text: vc.tr("Farben"); Layout.leftMargin: win.u }
                            Check {
                                Layout.leftMargin: win.u
                                text: vc.tr("Farben automatisch an jedes neue Hintergrundbild anpassen")
                                path: "theme.autoColors"
                                fallback: true
                            }
                            Hint {
                                Layout.leftMargin: win.u
                                Layout.rightMargin: win.u
                                text: vc.tr("Widgets übernehmen Änderungen sofort. „Anwenden“ färbt zusätzlich KDE, Fensterrahmen, Konsole und Startbildschirm um.")
                            }

                            // live preview
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.margins: win.u
                                Layout.preferredHeight: win.u * 5
                                radius: vc.radius
                                color: vc.bg
                                border.color: vc.alpha(vc.accent, 0.4)
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: win.u
                                    spacing: win.u * 0.6
                                    Repeater {
                                        model: ["bg", "surface", "surfaceAlt", "accent", "accent2", "text", "muted"]
                                        Rectangle {
                                            required property string modelData
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            radius: win.u * 0.5
                                            color: vc[modelData]
                                            border.color: vc.alpha(vc.text, 0.15)
                                        }
                                    }
                                }
                            }

                            GridLayout {
                                Layout.leftMargin: win.u
                                Layout.rightMargin: win.u
                                columns: 2
                                columnSpacing: win.u * 2
                                rowSpacing: win.u * 0.3

                                Repeater {
                                    model: [
                                        { key: "accent", label: vc.tr("Akzent") }, { key: "accent2", label: vc.tr("Zweitakzent") },
                                        { key: "bg", label: vc.tr("Hintergrund") }, { key: "surface", label: vc.tr("Fläche") },
                                        { key: "surfaceAlt", label: vc.tr("Fläche (hell)") }, { key: "text", label: vc.tr("Text") },
                                        { key: "muted", label: vc.tr("Text (gedämpft)") }, { key: "positive", label: vc.tr("Positiv") },
                                        { key: "neutral", label: vc.tr("Hinweis") }, { key: "negative", label: vc.tr("Warnung") }
                                    ]
                                    RowLayout {
                                        required property var modelData
                                        Layout.fillWidth: true
                                        Stage.StageText { stage: vc; text: modelData.label; font.pixelSize: win.u * 0.8; Layout.preferredWidth: win.u * 8 }
                                        KQuickControls.ColorButton {
                                            color: vc[modelData.key]
                                            showAlphaChannel: false
                                            dialogTitle: modelData.label
                                            onAccepted: function (c) { vc.set("colors." + modelData.key, c.toString().substring(0, 7)); }
                                        }
                                        Stage.StageText { stage: vc; text: String(vc[modelData.key]).toUpperCase(); color: vc.muted; font.family: "monospace"; font.pixelSize: win.u * 0.7 }
                                    }
                                }
                            }

                            RowLayout {
                                Layout.margins: win.u
                                spacing: win.u * 0.5
                                Pill { text: vc.tr("✓ Farben anwenden"); active: true; enabled: !root.busy; onClicked: root.cli(["apply", "colors", "icons", "deco", "konsole", "kvantum", "splash"], vc.tr("Farben werden angewendet")) }
                                Pill { text: vc.tr("Aus aktuellem Hintergrund übernehmen"); enabled: !root.busy; onClicked: root.cli(["colors-from-wallpaper"], vc.tr("Farben aus dem Hintergrund")) }
                            }
                        }
                    }

                    // =========================== 3 Images
                    ColumnLayout {
                        id: imagePage
                        property string slot: "launcher"
                        property string source: "freisteller"
                        readonly property var slotNames: ({ "launcher": vc.tr("Launcher"), "splash": vc.tr("Startbildschirm") })
                        readonly property var sourceNames: ({ "freisteller": vc.tr("Freisteller"), "figur": vc.tr("Figuren"), "cover": vc.tr("Cover & Banner"), "ordner": vc.tr("📁 Eigene") })
                        spacing: win.u * 0.5

                        Item { Layout.preferredHeight: win.u * 0.4 }
                        SectionTitle { text: vc.tr("Bilder für Launcher & Startbildschirm"); Layout.leftMargin: win.u }
                        Hint {
                            Layout.leftMargin: win.u
                            Layout.rightMargin: win.u
                            text: vc.tr("Freisteller (Figuren ohne Hintergrund) kommen von Danbooru – KI-Bilder sind dort verboten. Platz wählen, dann Bild anklicken. Das Desktop-Wallpaper stellst du unter „Hintergrund“ ein.")
                        }

                        RowLayout {
                            Layout.leftMargin: win.u
                            Layout.rightMargin: win.u
                            spacing: win.u * 0.35
                            Repeater {
                                model: ["launcher", "splash"]
                                Pill {
                                    required property string modelData
                                    text: imagePage.slotNames[modelData]
                                    active: imagePage.slot === modelData
                                    onClicked: imagePage.slot = modelData
                                }
                            }
                            Item { Layout.fillWidth: true }
                            Pill { text: vc.tr("+ Eigenes Bild"); onClicked: fileDialog.open() }
                            Pill {
                                text: root.busy ? vc.tr("lädt …") : vc.tr("⇣ Mehr Freisteller")
                                enabled: !root.busy && !!vc.anime.cutTag
                                onClicked: root.cli(["cuts", "6"], vc.tr("Suche Freisteller auf Danbooru"))
                            }
                        }
                        RowLayout {
                            Layout.leftMargin: win.u
                            spacing: win.u * 0.35
                            Repeater {
                                model: ["freisteller", "figur", "cover", "ordner"]
                                Pill {
                                    required property string modelData
                                    text: imagePage.sourceNames[modelData] + "  " + root.images.filter(it => (modelData === "cover" ? (it.source === "cover" || it.source === "banner") : it.source === modelData)).length
                                    active: imagePage.source === modelData
                                    onClicked: imagePage.source = modelData
                                }
                            }
                            Pill {
                                visible: imagePage.source === "ordner"
                                text: vc.tr("+ Ordner")
                                onClicked: folderDialog.open()
                            }
                        }
                        Flow {
                            visible: imagePage.source === "ordner"
                            Layout.fillWidth: true
                            Layout.leftMargin: win.u
                            spacing: win.u * 0.35
                            Repeater {
                                model: vc.opt("folders", [])
                                Pill {
                                    required property string modelData
                                    text: "✕  " + modelData.replace(/^.*\/(?=[^\/]+$)/, "…/")
                                    onClicked: root.cli(["remove-folder", modelData], vc.tr("Ordner wird entfernt"))
                                }
                            }
                        }
                        Hint {
                            Layout.leftMargin: win.u
                            visible: imagePage.source === "freisteller" && root.images.filter(it => it.source === "freisteller").length === 0
                            text: vc.tr("Für diesen Anime gibt es (noch) keine Freisteller. Probier „Mehr Freisteller“ – sonst nimm ein Figurenbild oder das Cover.")
                        }

                        GridView {
                            id: gallery
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.margins: win.u
                            clip: true
                            cellWidth: win.u * 7
                            cellHeight: win.u * 9
                            QQC2.ScrollBar.vertical: QQC2.ScrollBar {}
                            model: root.images.filter(it => imagePage.source === "cover" ? (it.source === "cover" || it.source === "banner") : it.source === imagePage.source)
                            delegate: Item {
                                required property var modelData
                                readonly property bool chosen: (vc.images[imagePage.slot] || "") === modelData.path
                                width: gallery.cellWidth
                                height: gallery.cellHeight

                                Rectangle {
                                    anchors.fill: parent
                                    anchors.margins: win.u * 0.25
                                    radius: win.u * 0.6
                                    color: vc.surface
                                    border.width: parent.chosen ? 3 : 1
                                    border.color: parent.chosen ? vc.accent : (thumbMouse.containsMouse ? vc.alpha(vc.accent, 0.6) : vc.alpha(vc.text, 0.08))
                                    clip: true
                                    Image {
                                        anchors.fill: parent
                                        anchors.margins: 3
                                        source: "file://" + modelData.thumb
                                        fillMode: modelData.source === "freisteller" ? Image.PreserveAspectFit : Image.PreserveAspectCrop
                                        asynchronous: true
                                    }
                                    Rectangle {
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                        height: win.u * 1.2
                                        color: vc.alpha(vc.bg, 0.75)
                                        visible: thumbMouse.containsMouse && !!modelData.artist
                                        Stage.StageText {
                                            anchors.centerIn: parent
                                            width: parent.width - 8
                                            horizontalAlignment: Text.AlignHCenter
                                            stage: vc
                                            text: (modelData.source === "freisteller" ? "🎨 " : "") + modelData.artist
                                            font.pixelSize: win.u * 0.6
                                        }
                                    }
                                }
                                MouseArea {
                                    id: thumbMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        const s = imagePage.slot;
                                        vc.set("images." + s, modelData.path, s === "splash" ? ["splash"] : []);
                                        root.status = "✓ " + vc.tr("%1: Bild gesetzt", [imagePage.slotNames[s]]);
                                    }
                                }
                            }
                        }

                        FolderDialog {
                            id: folderDialog
                            title: vc.tr("Bilderordner wählen")
                            onAccepted: root.cli(["add-folder", decodeURIComponent(String(selectedFolder).replace("file://", ""))], vc.tr("Ordner wird hinzugefügt"))
                        }

                        FileDialog {
                            id: fileDialog
                            title: vc.tr("Eigenes Bild für %1", [imagePage.slotNames[imagePage.slot]])
                            nameFilters: [vc.tr("Bilder (*.png *.jpg *.jpeg *.webp)")]
                            onAccepted: root.cli(["use-image", decodeURIComponent(String(selectedFile).replace("file://", "")), imagePage.slot], vc.tr("Bild wird übernommen"))
                        }
                    }

                    // =========================== 4 Wallpaper
                    QQC2.ScrollView {
                        id: bgScroll
                        contentWidth: availableWidth
                        ColumnLayout {
                            id: wallCol
                            width: bgScroll.availableWidth - win.u * 2
                            x: win.u
                            spacing: win.u * 0.5

                            readonly property var ws: root.wall.settings || ({})
                            readonly property bool rotating: !!ws.enabled
                            // without favorites the page starts at the most recently loaded images
                            property string source: root.wallItems.some(function (it) { return it.source === "fav"; }) ? "fav" : "neu"
                            readonly property var sourceNames: ({ "fav": vc.tr("♥ Favoriten"), "figur": vc.tr("Figuren"), "neu": vc.tr("Zuletzt geladen") })

                            Item { Layout.preferredHeight: win.u * 0.4 }
                            SectionTitle { text: vc.tr("Hintergrund") }

                            // ---- Current image + actions
                            RowLayout {
                                spacing: win.u
                                Rectangle {
                                    Layout.preferredWidth: win.u * 16
                                    Layout.preferredHeight: win.u * 9
                                    radius: vc.radius * 0.6
                                    color: vc.surfaceAlt
                                    clip: true
                                    Image {
                                        anchors.fill: parent
                                        source: root.wall.thumb ? "file://" + root.wall.thumb : ""
                                        fillMode: Image.PreserveAspectCrop
                                        asynchronous: true
                                        cache: false
                                    }
                                    Stage.StageText {
                                        anchors.right: parent.right
                                        anchors.top: parent.top
                                        anchors.margins: win.u * 0.4
                                        visible: !!root.wall.isFavorite
                                        stage: vc
                                        text: "♥"
                                        color: vc.accent2
                                        font.pixelSize: win.u * 1.4
                                    }
                                }
                                ColumnLayout {
                                    spacing: win.u * 0.4
                                    Stage.StageText {
                                        stage: vc
                                        text: wallCol.rotating ? vc.tr("Wechselt alle %1 Minuten", [wallCol.ws.minutes || 30]) : vc.tr("Festes Bild")
                                        color: vc.accent
                                        font.pixelSize: win.u * 0.9
                                        font.weight: Font.Bold
                                    }
                                    Stage.StageText {
                                        stage: vc
                                        visible: !!root.wall.artist
                                        text: vc.tr("Künstler:in: %1", [root.wall.artist || ""])
                                        color: vc.muted
                                        font.pixelSize: win.u * 0.75
                                    }
                                    Flow {
                                        Layout.preferredWidth: win.u * 22
                                        spacing: win.u * 0.4
                                        Pill { text: vc.tr("⟳ Neues Bild"); active: true; enabled: !root.busy; onClicked: root.cli(["wall", "next"], vc.tr("Lade neues Bild")) }
                                        Pill { text: root.wall.isFavorite ? vc.tr("♥ Favorit") : vc.tr("♡ Merken"); enabled: !root.busy && !!root.wall.current && !root.wall.isFavorite; onClicked: root.cli(["wall", "fav"], vc.tr("Speichere Favorit")) }
                                        Pill { text: vc.tr("✕ Nie wieder"); visible: !!root.wall.page; enabled: !root.busy && !root.wall.isFavorite; onClicked: root.cli(["wall", "ban"], vc.tr("Sortiere aus")) }
                                        Pill { text: vc.tr("Quelle ansehen"); visible: !!root.wall.page; onClicked: Qt.openUrlExternally(root.wall.page) }
                                    }
                                }
                            }

                            // ---- mode
                            SectionTitle { text: vc.tr("Modus") }
                            RowLayout {
                                spacing: win.u * 0.4
                                Pill {
                                    text: vc.tr("Festes Bild")
                                    active: !wallCol.rotating
                                    enabled: !root.busy
                                    onClicked: if (wallCol.rotating) root.cli(["wall", "off"], vc.tr("Wechsel aus"))
                                }
                                Pill {
                                    text: vc.tr("Automatisch wechseln")
                                    active: wallCol.rotating
                                    enabled: !root.busy
                                    onClicked: if (!wallCol.rotating) root.cli(["wall", "on"], vc.tr("Wechsel startet, lade Bilder"))
                                }
                            }
                            Hint {
                                text: wallCol.rotating
                                      ? vc.tr("Lädt laufend neue Bilder des gewählten Anime von Konachan (ohne KI-Tags), passend zu Figur, Filter und Stimmung, und mischt deine Favoriten dazu. Ist eine einzelne Figur gewählt, kommt sie allein im Bild. Ein Klick auf ein Bild unten macht es zum festen Hintergrund.")
                                      : vc.tr("Klick auf ein Bild unten setzt es als Hintergrund. „⟳ Neues Bild“ holt einmalig ein frisches von Konachan.")
                            }

                            GridLayout {
                                visible: wallCol.rotating
                                columns: 2
                                columnSpacing: win.u
                                Stage.StageText { stage: vc; text: vc.tr("Alle"); font.pixelSize: win.u * 0.8 }
                                RowLayout {
                                    QQC2.SpinBox {
                                        from: 1; to: 1440
                                        value: wallCol.ws.minutes || 30
                                        onValueModified: vc.set("wallswitch.minutes", value)
                                    }
                                    Stage.StageText { stage: vc; text: vc.tr("Minuten"); font.pixelSize: win.u * 0.8 }
                                }
                                Stage.StageText { stage: vc; text: vc.tr("Bilder aus"); font.pixelSize: win.u * 0.8 }
                                QQC2.ComboBox {
                                    textRole: "text"; valueRole: "value"
                                    Layout.preferredWidth: win.u * 18
                                    model: [{ text: vc.tr("Neue Bilder + Favoriten"), value: "mix" }, { text: vc.tr("Nur neue Bilder"), value: "konachan" }, { text: vc.tr("Nur Favoriten (offline)"), value: "favorites" }]
                                    currentIndex: indexOfValue(vc.opt("wallswitch.source", "mix"))
                                    onActivated: vc.set("wallswitch.source", currentValue)
                                }
                                Stage.StageText { stage: vc; text: vc.tr("Filter"); font.pixelSize: win.u * 0.8 }
                                QQC2.ComboBox {
                                    textRole: "text"; valueRole: "value"
                                    Layout.preferredWidth: win.u * 18
                                    model: [{ text: vc.tr("Streng – nichts Freizügiges"), value: "strict" }, { text: vc.tr("Aus – alles, was Konachan als „safe“ führt"), value: "safe" }, { text: vc.tr("Ecchi – nur volljährige Figuren"), value: "ecchi" }, { text: vc.tr("NSFW – nur volljährige Figuren"), value: "nsfw" }]
                                    currentIndex: indexOfValue(vc.opt("wallswitch.filter", "strict"))
                                    onActivated: vc.set("wallswitch.filter", currentValue)
                                }
                            }
                            Flow {
                                visible: wallCol.rotating
                                Layout.fillWidth: true
                                spacing: win.u * 0.4
                                readonly property var chars: vc.opt("wallswitch.chars", [])
                                Pill {
                                    text: vc.tr("Ganzer Anime")
                                    active: parent.chars.length === 0
                                    onClicked: vc.set("wallswitch.chars", [])
                                }
                                Repeater {
                                    model: vc.animeChars
                                    Pill {
                                        required property var modelData
                                        readonly property var chars: parent.chars
                                        text: modelData.name
                                        active: chars.indexOf(modelData.tag) >= 0
                                        onClicked: {
                                            let list = chars.slice();
                                            const i = list.indexOf(modelData.tag);
                                            if (i >= 0) list.splice(i, 1); else list.push(modelData.tag);
                                            vc.set("wallswitch.chars", list);
                                        }
                                    }
                                }
                            }
                            Hint {
                                visible: wallCol.rotating
                                text: vc.tr("SFW zeigt alle Figuren. Ecchi/NSFW nur Figuren, die volljährig sind (AniList-Alter oder von dir unter „Anime“ markiert) – und nur, wenn keine andere Figur mit im Bild ist und nichts auf Jüngere hindeutet. Sperrbildschirm, Anmeldung und Terminal zeigen immer nur „safe“. Höchstens 50 Bilder, Favoriten werden nie gelöscht.")
                            }
                            Check { text: vc.tr("Sperrbildschirm zeigt dasselbe Bild"); path: "wallswitch.lock"; fallback: true }
                            RowLayout {
                                spacing: win.u * 0.5
                                Stage.StageText {
                                    stage: vc
                                    text: root.wall.loginOutdated ? vc.tr("⚠ Anmeldebildschirm: Einrichtung veraltet (zeigt noch das Standardbild)") : (root.wall.login ? vc.tr("✓ Anmeldebildschirm zeigt deinen Hintergrund") : vc.tr("Anmeldebildschirm zeigt noch das Standardbild"))
                                    color: root.wall.loginOutdated ? vc.neutral : (root.wall.login ? vc.positive : vc.muted)
                                    font.pixelSize: win.u * 0.8
                                }
                                Pill {
                                    visible: !!root.wall.loginOutdated
                                    text: vc.tr("Neu einrichten (Passwort)")
                                    active: true
                                    enabled: !root.busy
                                    onClicked: root.cli(["login", "setup"], vc.tr("Anmeldebildschirm – bitte Passwort eingeben"))
                                }
                                Pill {
                                    text: root.wall.login ? vc.tr("Entfernen") : vc.tr("Einrichten (einmalig Passwort)")
                                    enabled: !root.busy
                                    onClicked: root.cli(["login", root.wall.login ? "remove" : "setup"], vc.tr("Anmeldebildschirm – bitte Passwort eingeben"))
                                }
                            }

                            // ---- collection
                            SectionTitle { text: vc.tr("Deine Hintergründe") }
                            RowLayout {
                                spacing: win.u * 0.4
                                Repeater {
                                    model: ["fav", "figur", "neu"]
                                    Pill {
                                        required property string modelData
                                        text: wallCol.sourceNames[modelData] + "  " + root.wallItems.filter(function (it) { return it.source === modelData; }).length
                                        active: wallCol.source === modelData
                                        onClicked: wallCol.source = modelData
                                    }
                                }
                                Item { Layout.fillWidth: true }
                                Pill { text: vc.tr("+ Eigenes Bild"); onClicked: wallFileDialog.open() }
                                Pill { text: vc.tr("📁 Ordner"); onClicked: vc.run(["wall", "open-favorites"], "wall-open") }
                            }
                            Hint {
                                visible: wallCol.source === "fav" && root.wallItems.filter(function (it) { return it.source === "fav"; }).length === 0
                                text: vc.tr("Noch keine Favoriten. Gefällt dir ein Hintergrund, klick oben auf „♡ Merken“ – er landet in deinem Bilder-Ordner unter AnimeStage-Favoriten.")
                            }
                            Flow {
                                Layout.fillWidth: true
                                spacing: win.u * 0.4
                                Repeater {
                                    model: root.wallItems.filter(function (it) { return it.source === wallCol.source; })
                                    Rectangle {
                                        required property var modelData
                                        readonly property bool chosen: root.wall.current === modelData.path
                                        width: win.u * 10
                                        height: win.u * 5.8
                                        radius: win.u * 0.5
                                        color: vc.surface
                                        border.width: chosen ? 3 : 1
                                        border.color: chosen ? vc.accent : (wallMouse.containsMouse ? vc.alpha(vc.accent, 0.6) : vc.alpha(vc.text, 0.08))
                                        clip: true
                                        Image {
                                            anchors.fill: parent
                                            anchors.margins: 3
                                            source: "file://" + modelData.thumb
                                            fillMode: Image.PreserveAspectCrop
                                            asynchronous: true
                                        }
                                        Rectangle {
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.bottom: parent.bottom
                                            anchors.margins: 3
                                            height: win.u * 1.1
                                            color: vc.alpha(vc.bg, 0.75)
                                            visible: wallMouse.containsMouse && !!modelData.artist
                                            Stage.StageText {
                                                anchors.centerIn: parent
                                                width: parent.width - 8
                                                horizontalAlignment: Text.AlignHCenter
                                                stage: vc
                                                text: "🎨 " + modelData.artist
                                                font.pixelSize: win.u * 0.6
                                            }
                                        }
                                        MouseArea {
                                            id: wallMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: root.cli(["wall", "set", modelData.path], vc.tr("Setze Hintergrund"))
                                        }
                                    }
                                }
                            }

                            FileDialog {
                                id: wallFileDialog
                                title: vc.tr("Hintergrundbild wählen")
                                nameFilters: [vc.tr("Bilder (*.png *.jpg *.jpeg *.webp)")]
                                onAccepted: root.cli(["wall", "set", decodeURIComponent(String(selectedFile).replace("file://", ""))], vc.tr("Setze Hintergrund"))
                            }
                        }
                    }

                    // =========================== 5 Appearance
                    QQC2.ScrollView {
                        contentWidth: availableWidth
                        ColumnLayout {
                            width: parent.width - win.u * 2
                            x: win.u
                            spacing: win.u * 0.5

                            Item { Layout.preferredHeight: win.u * 0.4 }
                            SectionTitle { text: vc.tr("Oberfläche") }
                            Hint { text: vc.tr("Rundung und Transparenz gelten für Panel, Popups und Widgets. Nach dem Schieben: „Stil anwenden“ (Plasma lädt den Stil kurz neu).") }

                            Slide { label: vc.tr("Ecken-Rundung"); path: "style.radius"; from: 4; to: 24; step: 1; percent: false }
                            Slide { label: vc.tr("Panel-Deckkraft"); path: "style.panelOpacity"; from: 0.3; to: 1 }
                            Slide { label: vc.tr("Popup-Deckkraft"); path: "style.popupOpacity"; from: 0.5; to: 1 }
                            Slide { label: vc.tr("Widget-Deckkraft"); path: "style.widgetOpacity"; from: 0.1; to: 1 }
                            Slide { label: vc.tr("Akzentkante"); path: "style.borderOpacity"; from: 0; to: 1 }

                            SectionTitle { text: vc.tr("Fenster & Programme") }
                            GridLayout {
                                columns: 2
                                columnSpacing: win.u
                                Stage.StageText { stage: vc; text: vc.tr("Fensterrahmen"); font.pixelSize: win.u * 0.8 }
                                QQC2.ComboBox {
                                    textRole: "text"; valueRole: "value"
                                    Layout.preferredWidth: win.u * 18
                                    model: [{ text: vc.tr("Breeze in Theme-Farben (mit Schatten)"), value: "breeze" }, { text: vc.tr("AnimeStage flach (Farbpunkte)"), value: "aurorae" }]
                                    currentIndex: indexOfValue(vc.opt("style.windowDeco", "breeze"))
                                    onActivated: vc.set("style.windowDeco", currentValue, ["deco"])
                                }
                                Stage.StageText { stage: vc; text: vc.tr("Programm-Stil"); font.pixelSize: win.u * 0.8 }
                                QQC2.ComboBox {
                                    Layout.preferredWidth: win.u * 18
                                    textRole: "text"; valueRole: "value"
                                    model: [{ text: vc.tr("Breeze (empfohlen)"), value: "breeze" }, { text: vc.tr("Kvantum (muss installiert sein)"), value: "kvantum" }]
                                    currentIndex: indexOfValue(vc.opt("style.appStyle", "breeze"))
                                    onActivated: vc.set("style.appStyle", currentValue, ["kvantum"])
                                }
                            }
                            RowLayout {
                                Stage.StageText { stage: vc; text: vc.tr("Icons"); font.pixelSize: win.u * 0.8; Layout.preferredWidth: win.u * 7 }
                                QQC2.ComboBox {
                                    Layout.preferredWidth: win.u * 18
                                    textRole: "text"; valueRole: "value"
                                    model: [{ text: vc.tr("Papirus-Dark, Ordner in Akzentfarbe"), value: "papirus" }, { text: vc.tr("Nicht ändern"), value: "keep" }]
                                    currentIndex: indexOfValue(vc.opt("style.icons", "papirus"))
                                    onActivated: vc.set("style.icons", currentValue, currentValue === "papirus" ? ["icons"] : [])
                                }
                            }
                            Check { text: vc.tr("Animationen in Widgets"); path: "style.animations" }
                            Check { text: vc.tr("M PLUS Rounded 1c als Systemschrift verwenden"); path: "style.uiFont"; fallback: false }

                            SectionTitle { text: vc.tr("Taskleiste") }
                            QQC2.CheckBox {
                                text: vc.tr("Fensternamen neben dem Symbol anzeigen (wie bei Windows)")
                                checked: vc.opt("taskbar.labels", true)
                                enabled: !root.busy
                                onToggled: root.cli(["set", "taskbar.labels", checked ? "true" : "false", "--apply", "taskbar"], vc.tr("Taskleiste wird umgestellt (Plasma startet kurz neu)"))
                            }
                            QQC2.CheckBox {
                                text: vc.tr("Fenster desselben Programms zusammenfassen")
                                checked: vc.opt("taskbar.group", false)
                                enabled: !root.busy
                                onToggled: root.cli(["set", "taskbar.group", checked ? "true" : "false", "--apply", "taskbar"], vc.tr("Taskleiste"))
                            }
                            RowLayout {
                                visible: vc.opt("taskbar.labels", true)
                                Stage.StageText { stage: vc; text: vc.tr("Breite der Einträge"); font.pixelSize: win.u * 0.8; Layout.preferredWidth: win.u * 8 }
                                QQC2.ComboBox {
                                    Layout.preferredWidth: win.u * 18
                                    textRole: "text"; valueRole: "value"
                                    model: [{ text: vc.tr("Schmal"), value: "narrow" }, { text: vc.tr("Mittel (KDE-Standard)"), value: "medium" }, { text: vc.tr("Breit"), value: "wide" }]
                                    currentIndex: indexOfValue(vc.opt("taskbar.width", "narrow"))
                                    enabled: !root.busy
                                    onActivated: root.cli(["set", "taskbar.width", currentValue, "--apply", "taskbar"], vc.tr("Taskleiste"))
                                }
                            }
                            Hint { text: vc.tr("Aus = jedes Fenster bekommt einen eigenen Eintrag (zwei Firefox-Fenster → zwei Einträge). Angeheftete Programme bleiben erhalten.") }

                            SectionTitle { text: vc.tr("Launcher") }
                            RowLayout {
                                Stage.StageText { stage: vc; text: vc.tr("Panel-Symbol"); font.pixelSize: win.u * 0.8 }
                                QQC2.ComboBox {
                                    Layout.preferredWidth: win.u * 18
                                    textRole: "text"; valueRole: "value"
                                    model: [{ text: vc.tr("Logo der Distribution"), value: "distro" }, { text: vc.tr("AnimeStage-Stern"), value: "logo" }, { text: vc.tr("Anime-Cover"), value: "cover" }, { text: vc.tr("Launcher-Bild (Freisteller)"), value: "character" }]
                                    currentIndex: indexOfValue(vc.opt("launcher.icon", "distro"))
                                    onActivated: vc.set("launcher.icon", currentValue)
                                }
                                Stage.StageText { stage: vc; text: vc.tr("Spalten"); font.pixelSize: win.u * 0.8; Layout.leftMargin: win.u }
                                QQC2.SpinBox { from: 3; to: 9; value: vc.opt("launcher.columns", 6); onValueModified: vc.set("launcher.columns", value) }
                            }
                            Check { text: vc.tr("Figur im Launcher zeigen"); path: "launcher.showHero" }
                            Check { text: vc.tr("Begrüßung (おはよう / こんにちは …)"); path: "launcher.greeting" }

                            SectionTitle { text: vc.tr("Programme") }
                            Hint { text: vc.tr("VS Code färbt sich bei jedem neuen Anime und jedem Farbwechsel mit (sofort sichtbar). Firefox hat einen eigenen Reiter.") }
                            QQC2.CheckBox {
                                text: vc.tr("VS Code (Fenster, Seitenleiste, Terminal)")
                                checked: vc.opt("apps.vscode", true)
                                enabled: !root.busy
                                onToggled: root.cli(["apps", "vscode", checked ? "on" : "off"], vc.tr("VS Code"))
                            }

                            SectionTitle { text: vc.tr("Uhr") }
                            Check { text: vc.tr("24-Stunden-Format"); path: "clock.use24h" }
                            Check { text: vc.tr("Sekunden anzeigen"); path: "clock.seconds"; fallback: false }
                            Check { text: vc.tr("Japanischer Wochentag (月・火・水 …)"); path: "clock.japanese" }

                            SectionTitle { text: vc.tr("Auslastung") }
                            Check { text: vc.tr("GPU anzeigen"); path: "system.gpu" }
                            Check { text: vc.tr("Temperaturen in der Detailansicht"); path: "system.temps" }

                            RowLayout {
                                Layout.topMargin: win.u * 0.5
                                Pill { text: vc.tr("✓ Stil anwenden"); active: true; enabled: !root.busy; onClicked: root.cli(["apply", "style", "deco", "font"], vc.tr("Plasma-Stil wird neu erzeugt")) }
                            }
                        }
                    }

                    // ============================ 6 Terminal
                    QQC2.ScrollView {
                        id: termScroll
                        contentWidth: availableWidth
                        ColumnLayout {
                            id: termCol
                            width: termScroll.availableWidth - win.u * 2
                            x: win.u
                            spacing: win.u * 0.5

                            readonly property string app: vc.opt("terminal.app", "konsole")
                            readonly property var defaults: ({ "fg": vc.text, "bg": vc.bg, "prompt": vc.accent, "prompt2": vc.accent2, "cursor": vc.accent })

                            Item { Layout.preferredHeight: win.u * 0.4 }
                            SectionTitle { text: vc.tr("Terminal-Programm") }
                            RowLayout {
                                spacing: win.u * 0.4
                                Pill {
                                    text: vc.tr("kitty (modern, GPU, echte Bilder)")
                                    active: termCol.app === "kitty"
                                    enabled: !root.busy
                                    onClicked: root.cli(["terminal", "kitty"], vc.tr("Installiere/aktiviere kitty"))
                                }
                                Pill {
                                    text: vc.tr("Konsole (KDE)")
                                    active: termCol.app === "konsole"
                                    enabled: !root.busy
                                    onClicked: root.cli(["terminal", "konsole"], vc.tr("Konsole als Standard"))
                                }
                            }
                            Hint { text: vc.tr("Das gewählte Programm wird Standard-Terminal (Panel, Dolphin „Terminal hier öffnen“). Beide bekommen dieselben Farben.") }

                            SectionTitle { text: vc.tr("Begrüßung & Prompt") }
                            QQC2.CheckBox {
                                text: vc.tr("Begrüßung mit Bild + Systeminfo, farbiger Prompt, Aliase (ls mit Icons …)")
                                checked: vc.opt("terminal.enabled", false)
                                enabled: !root.busy
                                onToggled: root.cli(["terminal", checked ? "on" : "off"], vc.tr("Terminal wird eingerichtet"))
                            }
                            Pill { text: vc.tr("Extra-Programme prüfen/installieren"); enabled: !root.busy; onClicked: root.cli(["terminal", "on", "--tools"], vc.tr("Installiere starship, eza, bat, zoxide, kitty")) }

                            SectionTitle { text: vc.tr("Bild in der Begrüßung") }
                            Hint { text: vc.tr("Jedes neue Fenster zeigt ein Bild, das im Terminal noch nie dran war. Mit „Konachan“ wird bei jedem Fenster im Hintergrund ein frisches nachgeladen (gleiche Figur und gleicher Filter wie beim Hintergrund).") }
                            GridLayout {
                                columns: 2
                                columnSpacing: win.u
                                Stage.StageText { stage: vc; text: vc.tr("Bilder aus"); font.pixelSize: win.u * 0.8 }
                                QQC2.ComboBox {
                                    textRole: "text"; valueRole: "value"
                                    Layout.preferredWidth: win.u * 18
                                    model: [{ text: vc.tr("Freisteller & Figurenbilder"), value: "figur" }, { text: vc.tr("Neu aus dem Netz (wie Hintergrund)"), value: "konachan" }, { text: vc.tr("Hintergrund-Favoriten"), value: "favoriten" }, { text: vc.tr("Eigener Ordner"), value: "ordner" }]
                                    currentIndex: indexOfValue(vc.opt("terminal.imageSource", "konachan"))
                                    onActivated: vc.set("terminal.imageSource", currentValue)
                                }
                                Stage.StageText { stage: vc; text: vc.tr("Ordner"); font.pixelSize: win.u * 0.8; visible: vc.opt("terminal.imageSource", "konachan") === "ordner" }
                                RowLayout {
                                    visible: vc.opt("terminal.imageSource", "konachan") === "ordner"
                                    Stage.StageText { stage: vc; text: vc.opt("terminal.folder", "– noch keiner –"); color: vc.muted; font.pixelSize: win.u * 0.75; Layout.maximumWidth: win.u * 16 }
                                    Pill { text: vc.tr("Wählen …"); onClicked: termFolderDialog.open() }
                                }
                                Stage.StageText { stage: vc; text: vc.tr("Darstellung"); font.pixelSize: win.u * 0.8 }
                                QQC2.ComboBox {
                                    textRole: "text"; valueRole: "value"
                                    Layout.preferredWidth: win.u * 18
                                    model: [{ text: vc.tr("Echtes Bild (kitty/Konsole)"), value: "auto" }, { text: vc.tr("Pixel-Blockgrafik"), value: "blocks" }, { text: vc.tr("Ohne Bild"), value: "none" }]
                                    currentIndex: indexOfValue(vc.opt("terminal.image", "auto"))
                                    onActivated: vc.set("terminal.image", currentValue)
                                }
                                Stage.StageText { stage: vc; text: vc.tr("Bildhöhe (Zeilen)"); font.pixelSize: win.u * 0.8 }
                                QQC2.SpinBox { from: 6; to: 30; value: vc.opt("terminal.imageRows", 16); onValueModified: vc.set("terminal.imageRows", value) }
                            }
                            ColumnLayout {
                                visible: vc.opt("terminal.imageSource", "konachan") === "konachan"
                                Layout.fillWidth: true
                                spacing: win.u * 0.4
                                Check { text: vc.tr("Bei jedem neuen Fenster frisch von Konachan laden"); path: "terminal.fetchOnOpen"; fallback: true }
                                RowLayout {
                                    Stage.StageText { stage: vc; text: vc.tr("Filter"); font.pixelSize: win.u * 0.8; Layout.preferredWidth: win.u * 6 }
                                    QQC2.ComboBox {
                                        textRole: "text"; valueRole: "value"
                                        Layout.preferredWidth: win.u * 18
                                        model: [{ text: vc.tr("Wie Hintergrund (immer nur „safe“)"), value: "" }, { text: vc.tr("Streng – nichts Freizügiges"), value: "strict" }, { text: vc.tr("Aus – alles mit „safe“"), value: "safe" }]
                                        currentIndex: indexOfValue(vc.opt("terminal.filter", ""))
                                        onActivated: vc.set("terminal.filter", currentValue)
                                    }
                                }
                                Stage.StageText { stage: vc; text: vc.tr("Figuren"); font.pixelSize: win.u * 0.8 }
                                Flow {
                                    id: termChars
                                    Layout.fillWidth: true
                                    spacing: win.u * 0.4
                                    readonly property var chars: vc.opt("terminal.chars", [])
                                    Pill {
                                        text: vc.tr("Wie Hintergrund")
                                        active: termChars.chars.length === 0
                                        onClicked: vc.set("terminal.chars", [])
                                    }
                                    Repeater {
                                        model: vc.animeChars
                                        Pill {
                                            required property var modelData
                                            text: modelData.name
                                            active: termChars.chars.indexOf(modelData.tag) >= 0
                                            onClicked: {
                                                let list = termChars.chars.slice();
                                                const i = list.indexOf(modelData.tag);
                                                if (i >= 0) list.splice(i, 1); else list.push(modelData.tag);
                                                vc.set("terminal.chars", list);
                                            }
                                        }
                                    }
                                }
                                Hint { text: vc.tr("Im Terminal erscheinen immer nur „safe“-Bilder, auch wenn der Hintergrund auf Ecchi/NSFW steht.") }
                            }
                            FolderDialog {
                                id: termFolderDialog
                                title: vc.tr("Ordner mit Bildern für das Terminal")
                                onAccepted: vc.set("terminal.folder", decodeURIComponent(String(selectedFolder).replace("file://", "")))
                            }

                            SectionTitle { text: vc.tr("Hintergrund im Terminal") }
                            QQC2.CheckBox {
                                text: vc.tr("Bild als Terminal-Hintergrund (abgedunkelt, nur „safe“)")
                                checked: vc.opt("terminal.bgImage", true)
                                enabled: !root.busy
                                onToggled: root.cli(["set", "terminal.bgImage", checked ? "true" : "false", "--apply", "konsole"], vc.tr("Terminal-Hintergrund"))
                            }
                            ThemedPicker {
                                visible: vc.opt("terminal.bgImage", true)
                                target: "terminal"
                                srcPath: "terminal.bgSource"
                                tagsPath: "terminal.bgTags"
                                everyPath: "terminal.bgEveryStart"
                                applyPart: "konsole"
                                sources: [{ text: vc.tr("Anime (Figuren wie bei der Begrüßung)"), value: "anime" }, { text: vc.tr("Anime + eigene Suchbegriffe"), value: "animesuche" },
                                          { text: vc.tr("Eigene Suche (ganz Konachan)"), value: "suche" }, { text: vc.tr("Aktuelles Wallpaper"), value: "wallpaper" }]
                            }
                            RowLayout {
                                visible: vc.opt("terminal.bgImage", true)
                                Stage.StageText { stage: vc; text: vc.tr("Bild sichtbar"); font.pixelSize: win.u * 0.8; Layout.preferredWidth: win.u * 8 }
                                QQC2.ComboBox {
                                    Layout.preferredWidth: win.u * 18
                                    textRole: "text"; valueRole: "value"
                                    model: [{ text: vc.tr("Ganz dezent"), value: 0.92 }, { text: vc.tr("Dezent (empfohlen)"), value: 0.86 }, { text: vc.tr("Deutlich"), value: 0.76 }, { text: vc.tr("Kräftig"), value: 0.65 }]
                                    currentIndex: indexOfValue(vc.opt("terminal.bgDim", 0.86))
                                    onActivated: root.cli(["set", "terminal.bgDim", String(currentValue), "--apply", "konsole"], vc.tr("Terminal-Hintergrund"))
                                }
                            }

                            SectionTitle { text: vc.tr("Farben & Schrift") }
                            GridLayout {
                                columns: 2
                                columnSpacing: win.u * 2
                                rowSpacing: win.u * 0.3
                                Repeater {
                                    model: [
                                        { key: "fg", label: vc.tr("Textfarbe") }, { key: "bg", label: vc.tr("Hintergrund") },
                                        { key: "prompt", label: vc.tr("Prompt / Akzent") }, { key: "prompt2", label: vc.tr("Prompt 2 / Rechnername") },
                                        { key: "cursor", label: vc.tr("Cursor") }
                                    ]
                                    RowLayout {
                                        required property var modelData
                                        readonly property string own: vc.opt("terminal." + modelData.key, "")
                                        Stage.StageText { stage: vc; text: modelData.label; font.pixelSize: win.u * 0.8; Layout.preferredWidth: win.u * 8 }
                                        KQuickControls.ColorButton {
                                            color: parent.own.length ? parent.own : termCol.defaults[modelData.key]
                                            showAlphaChannel: false
                                            dialogTitle: modelData.label
                                            onAccepted: function (c) { vc.set("terminal." + modelData.key, c.toString().substring(0, 7), ["konsole"]); }
                                        }
                                        Stage.StageText { stage: vc; text: parent.own.length ? vc.tr("eigene") : vc.tr("wie Figur"); color: vc.muted; font.pixelSize: win.u * 0.7 }
                                    }
                                }
                            }
                            GridLayout {
                                columns: 2
                                columnSpacing: win.u
                                Stage.StageText { stage: vc; text: vc.tr("Schriftgröße"); font.pixelSize: win.u * 0.8 }
                                QQC2.SpinBox { from: 8; to: 20; value: vc.opt("terminal.fontSize", 11); onValueModified: vc.set("terminal.fontSize", value, ["konsole"]) }
                                Stage.StageText { stage: vc; text: vc.tr("Deckkraft"); font.pixelSize: win.u * 0.8 }
                                QQC2.ComboBox {
                                    Layout.preferredWidth: win.u * 18
                                    textRole: "text"; valueRole: "value"
                                    model: [{ text: vc.tr("Undurchsichtig"), value: 1 }, { text: vc.tr("Leicht durchscheinend (97 %)"), value: 0.97 }, { text: vc.tr("Glas (88 %)"), value: 0.88 }, { text: vc.tr("Viel Glas (75 %)"), value: 0.75 }]
                                    currentIndex: indexOfValue(vc.opt("terminal.opacity", 0.97))
                                    onActivated: vc.set("terminal.opacity", currentValue, ["konsole"])
                                }
                            }
                            Pill {
                                text: vc.tr("Farben wieder wie die Figur")
                                enabled: !root.busy
                                onClicked: root.cli(["set", "terminal", JSON.stringify(Object.assign({}, vc.opt("terminal", {}), { fg: "", bg: "", prompt: "", prompt2: "", cursor: "" })), "--apply", "konsole"], vc.tr("Terminal-Farben zurückgesetzt"))
                            }
                        }
                    }

                    // ============================ 7 Firefox
                    QQC2.ScrollView {
                        id: ffScroll
                        contentWidth: availableWidth
                        ColumnLayout {
                            width: ffScroll.availableWidth - win.u * 2
                            x: win.u
                            spacing: win.u * 0.5
                            readonly property bool on: vc.opt("apps.firefox", true)

                            Item { Layout.preferredHeight: win.u * 0.4 }
                            SectionTitle { text: vc.tr("Firefox") }
                            Hint { text: vc.tr("Tabs, Adressleiste und Menüs in passenden Farben, dazu ein Bild auf der Neuer-Tab-Seite. Ändert sich mit jedem Anime – Firefox zeigt Änderungen nach einem Neustart.") }
                            QQC2.CheckBox {
                                text: vc.tr("Firefox-Theme von AnimeStage verwenden")
                                checked: parent.on
                                enabled: !root.busy
                                onToggled: root.cli(["apps", "firefox", checked ? "on" : "off"], vc.tr("Firefox"))
                            }

                            SectionTitle { text: vc.tr("Bild auf der Neuer-Tab-Seite"); visible: parent.on }
                            ThemedPicker {
                                visible: parent.on
                                target: "firefox"
                                srcPath: "firefox.source"
                                tagsPath: "firefox.tags"
                                everyPath: "firefox.everyStart"
                                applyPart: "firefox"
                                sources: [{ text: vc.tr("Anime (Figuren wie beim Hintergrund)"), value: "anime" }, { text: vc.tr("Anime + eigene Suchbegriffe"), value: "animesuche" },
                                          { text: vc.tr("Eigene Suche (ganz Konachan)"), value: "suche" }, { text: vc.tr("Aktuelles Wallpaper"), value: "wallpaper" },
                                          { text: vc.tr("Kein Bild, nur Farben"), value: "none" }]
                            }
                            RowLayout {
                                visible: parent.on && vc.opt("firefox.source", "anime") !== "none"
                                Stage.StageText { stage: vc; text: vc.tr("Bild sichtbar"); font.pixelSize: win.u * 0.8; Layout.preferredWidth: win.u * 8 }
                                QQC2.ComboBox {
                                    Layout.preferredWidth: win.u * 18
                                    textRole: "text"; valueRole: "value"
                                    model: [{ text: vc.tr("Kräftig"), value: 0.15 }, { text: vc.tr("Deutlich (empfohlen)"), value: 0.35 }, { text: vc.tr("Dezent"), value: 0.55 }, { text: vc.tr("Ganz dezent"), value: 0.75 }]
                                    currentIndex: indexOfValue(vc.opt("firefox.dim", 0.35))
                                    enabled: !root.busy
                                    onActivated: root.cli(["set", "firefox.dim", String(currentValue), "--apply", "firefox"], vc.tr("Firefox-Bild"))
                                }
                            }
                            QQC2.CheckBox {
                                visible: parent.on && ["anime", "animesuche", "suche"].indexOf(vc.opt("firefox.source", "anime")) >= 0
                                text: vc.tr("Firefox-Farben aus dem Bild nehmen (sonst wie der Desktop)")
                                checked: vc.opt("firefox.ownColors", true)
                                enabled: !root.busy
                                onToggled: root.cli(["set", "firefox.ownColors", checked ? "true" : "false", "--apply", "firefox"], vc.tr("Firefox-Farben"))
                            }

                            SectionTitle { text: vc.tr("Andere Firefox-Themes") }
                            Hint { text: vc.tr("Brauchst du nicht mehr: AnimeStage passt Firefox bei jedem Anime und jedem neuen Bild selbst an. Installierte Themes kannst du in Firefox unter about:addons → Themes entfernen. Als aktives Theme „Dunkel“ oder „System-Theme“ lassen – darüber legt AnimeStage seine Farben.") }
                        }
                    }

                    // ============================ 8 System
                    QQC2.ScrollView {
                        contentWidth: availableWidth
                        ColumnLayout {
                            width: parent.width - win.u * 2
                            x: win.u
                            spacing: win.u * 0.5

                            Item { Layout.preferredHeight: win.u * 0.4 }
                            SectionTitle { text: "Language" }
                            RowLayout {
                                QQC2.ComboBox {
                                    textRole: "text"; valueRole: "value"
                                    Layout.preferredWidth: win.u * 16
                                    model: [{ text: vc.tr("Automatisch (Systemsprache)"), value: "auto" },
                                            { text: "English", value: "en" }, { text: "Deutsch", value: "de" }, { text: "日本語", value: "ja" },
                                            { text: "Français", value: "fr" }, { text: "Español (España)", value: "es" }, { text: "Português (Brasil)", value: "pt_BR" },
                                            { text: "Italiano", value: "it" }, { text: "Polski", value: "pl" }, { text: "Nederlands", value: "nl" },
                                            { text: "Русский", value: "ru" }, { text: "简体中文", value: "zh_CN" }, { text: "繁體中文（台灣）", value: "zh_TW" },
                                            { text: "한국어", value: "ko" }]
                                    currentIndex: indexOfValue(vc.opt("language", "auto"))
                                    enabled: !root.busy
                                    onActivated: root.cli(["set", "language", currentValue, "--apply", "konsole"], vc.tr("Sprache wird umgestellt"))
                                }
                            }

                            SectionTitle { text: "Updates" }
                            Stage.StageText {
                                stage: vc
                                font.pixelSize: win.u * 0.8
                                text: vc.tr("Installierte Version: %1", [root.updateInfo.current || "?"])
                            }
                            Stage.StageText {
                                stage: vc
                                font.pixelSize: win.u * 0.75
                                Layout.fillWidth: true
                                wrapMode: Text.WordWrap
                                visible: text.length > 0
                                color: root.updateInfo.available ? vc.accent : (root.updateInfo.error ? vc.muted : vc.positive)
                                text: root.updateInfo.available ? vc.tr("Neue Version %1 verfügbar", [root.updateInfo.latest])
                                    : root.updateInfo.error ? root.updateInfo.error
                                    : root.updateInfo.latest ? vc.tr("Du hast die neueste Version")
                                    : ""
                            }
                            Flow {
                                Layout.fillWidth: true
                                spacing: win.u * 0.4
                                Pill { text: vc.tr("Jetzt prüfen"); enabled: !root.busy; onClicked: root.cli(["update", "check"], vc.tr("Suche nach Updates")) }
                                Pill {
                                    text: vc.tr("Update installieren")
                                    active: true
                                    visible: !!root.updateInfo.available
                                    enabled: !root.busy
                                    onClicked: root.cli(["update", "install"], vc.tr("Update wird installiert (Plasma startet kurz neu)"))
                                }
                                Pill { text: vc.tr("Was ist neu?"); visible: !!root.updateInfo.url; onClicked: Qt.openUrlExternally(root.updateInfo.url) }
                            }
                            RowLayout {
                                spacing: win.u * 0.6
                                Stage.StageText { stage: vc; text: vc.tr("Neue Versionen:"); font.pixelSize: win.u * 0.8 }
                                QQC2.ComboBox {
                                    textRole: "text"; valueRole: "value"
                                    Layout.preferredWidth: win.u * 19
                                    model: [{ text: vc.tr("Automatisch installieren"), value: "auto" },
                                            { text: vc.tr("Erinnern (Benachrichtigung)"), value: "remind" },
                                            { text: vc.tr("Aus (nicht nach Updates suchen)"), value: "off" }]
                                    currentIndex: indexOfValue(root.updateInfo.check === false ? "off" : (root.updateInfo.auto ? "auto" : "remind"))
                                    enabled: !root.busy
                                    onActivated: root.cli(["update", currentValue], vc.tr("Einstellung"))
                                }
                            }
                            Hint { text: vc.tr("Updates kommen von github.com/propanisen/AnimeStage. „Automatisch“ installiert neue Versionen selbst, „Erinnern“ zeigt eine Benachrichtigung mit „Jetzt installieren“, „Aus“ sucht gar nicht. Vor jedem Update wird ein Backup angelegt; Einstellungen, Favoriten und Panel bleiben erhalten.") }

                            SectionTitle { text: vc.tr("Bildquellen") }
                            Hint { text: vc.tr("Woher AnimeStage Bilder sucht und lädt (Hintergründe, Terminal, Firefox). Ist eine Seite offline, hier einfach eine andere wählen – die Figuren des Anime werden dort automatisch neu gesucht. Die Schutzregeln gelten für jede Quelle gleich.") }
                            GridLayout {
                                columns: 2
                                columnSpacing: win.u
                                Stage.StageText { stage: vc; text: vc.tr("Hintergründe"); font.pixelSize: win.u * 0.8 }
                                QQC2.ComboBox {
                                    textRole: "text"; valueRole: "value"
                                    Layout.preferredWidth: win.u * 19
                                    model: root.sourceInfo.options.wallpaper
                                    currentIndex: indexOfValue(root.sourceInfo.current.wallpaper || "konachan")
                                    enabled: !root.busy && count > 1
                                    onActivated: root.cli(["source", "set", "wallpaper", currentValue], vc.tr("Wechsle zu %1, suche den Anime dort", [currentText]))
                                }
                                Stage.StageText { stage: vc; text: vc.tr("Freisteller"); font.pixelSize: win.u * 0.8 }
                                QQC2.ComboBox {
                                    textRole: "text"; valueRole: "value"
                                    Layout.preferredWidth: win.u * 19
                                    model: root.sourceInfo.options.cutouts
                                    currentIndex: indexOfValue(root.sourceInfo.current.cutouts || "danbooru")
                                    enabled: !root.busy && count > 1
                                    onActivated: root.cli(["source", "set", "cutouts", currentValue], vc.tr("Wechsle Freisteller-Quelle"))
                                }
                            }
                            Pill { text: vc.tr("Verbindung prüfen"); enabled: !root.busy; onClicked: root.cli(["source", "check"], vc.tr("Prüfe Bildquellen")) }
                            Hint { text: vc.tr("Weitere Quellen trägst du in lib/animestage_sources.py im Projektordner ein (SOURCES und PURPOSES), danach ./update.sh – dann erscheinen sie hier in der Auswahl.") }

                            SectionTitle { text: vc.tr("Theme anwenden") }
                            Hint { text: vc.tr("Wendet alles aus der Config erneut an: Farbschema, Plasma-Stil, Fensterrahmen, Konsole, Hintergrund, Sperr- und Startbildschirm.") }
                            Flow {
                                Layout.fillWidth: true
                                spacing: win.u * 0.4
                                Pill { text: vc.tr("✓ Alles anwenden"); active: true; enabled: !root.busy; onClicked: root.cli(["apply", "all"], vc.tr("Theme wird angewendet")) }
                                Pill { text: vc.tr("Schrift installieren"); enabled: !root.busy; onClicked: root.cli(["fonts"], vc.tr("Lade M PLUS Rounded 1c")) }
                                Pill { text: vc.tr("Standardbilder neu laden"); enabled: !root.busy; onClicked: root.cli(["fetch-defaults"], vc.tr("Lade Standardbilder")) }
                            }

                            SectionTitle { text: vc.tr("Layout") }
                            Hint { text: vc.tr("Setzt das AnimeStage-Panel (Launcher, Taskleiste, Musik, Auslastung, Uhr). Vorher wird automatisch ein Backup angelegt.") }
                            Flow {
                                Layout.fillWidth: true
                                spacing: win.u * 0.4
                                Pill { text: vc.tr("AnimeStage-Layout setzen"); enabled: !root.busy; onClicked: root.cli(["layout"], vc.tr("Layout wird gesetzt")) }
                                Pill { text: vc.tr("Backup jetzt anlegen"); enabled: !root.busy; onClicked: root.cli(["backup"], vc.tr("Backup")) }
                            }

                            SectionTitle { text: vc.tr("Backups") }
                            Hint { text: vc.tr("„original“ ist dein Zustand vor der ersten AnimeStage-Änderung. Wiederherstellen startet die Plasma-Oberfläche neu.") }
                            Repeater {
                                model: root.backups
                                RowLayout {
                                    required property string modelData
                                    Kirigami.Icon { source: "document-save"; Layout.preferredWidth: win.u; Layout.preferredHeight: win.u }
                                    Stage.StageText { stage: vc; text: modelData; font.pixelSize: win.u * 0.8; Layout.preferredWidth: win.u * 12 }
                                    Pill { text: vc.tr("Wiederherstellen"); enabled: !root.busy; onClicked: root.cli(["restore", modelData], vc.tr("Stelle %1 wieder her", [modelData])) }
                                }
                            }

                            SectionTitle { text: vc.tr("Bildnachweise") }
                            Hint { text: vc.tr("Anime-Daten von AniList, Freisteller von Danbooru (KI-Bilder sind dort verboten), Hintergründe von Konachan. Fahre über ein Bild, um die Künstler:in zu sehen. Alle Figuren © ihrer Rechteinhaber – nur privater Gebrauch.") }
                            Pill { text: vc.tr("Credits-Datei schreiben"); onClicked: root.cli(["credits"], vc.tr("Schreibe Credits")) }

                            SectionTitle { text: vc.tr("Deinstallieren") }
                            Hint { text: vc.tr("Entfernt AnimeStage vollständig und stellt deine KDE-Einstellungen von vor der Installation wieder her. Es öffnet sich ein eigenes Fenster mit Rückfrage.") }
                            Pill { text: vc.tr("AnimeStage deinstallieren …"); enabled: !root.busy; onClicked: root.cli(["uninstall"], vc.tr("Deinstallation gestartet")) }
                        }
                    }
                }

                // ------------------------------------------------ status bar
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: win.u * 1.8
                    color: vc.surface
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: win.u
                        anchors.rightMargin: win.u
                        QQC2.BusyIndicator {
                            visible: root.busy
                            running: root.busy
                            Layout.preferredWidth: win.u * 1.3
                            Layout.preferredHeight: win.u * 1.3
                        }
                        Stage.StageText {
                            stage: vc
                            text: root.status
                            color: root.status.indexOf("✗") === 0 ? vc.negative : vc.muted
                            font.pixelSize: win.u * 0.72
                            Layout.fillWidth: true
                        }
                        Stage.StageText { stage: vc; text: "rev " + vc.rev; color: vc.alpha(vc.muted, 0.6); font.pixelSize: win.u * 0.6 }
                    }
                }
            }
        }
    }
}
