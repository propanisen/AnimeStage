import QtQuick
import QtQuick.Effects
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.private.kicker as Kicker
import org.kde.coreaddons as KCoreAddons
import org.kde.kirigami as Kirigami
import org.kde.plasma.private.sessions as Sessions
import "stage" as Stage

PlasmoidItem {
    id: root

    // view: "favorites", "all" or the row number of a category
    property string view: "favorites"
    property int categoryRow: -1
    property string query: ""
    property int heroPick: 0          // changes every time it opens
    property int rootRevision: 0

    readonly property bool searching: query.trim().length > 0
    readonly property string favoritesClient: "org.animestage.launcher.favorites"
    readonly property var defaultFavorites: [
        "preferred://browser", "applications:org.kde.dolphin.desktop", "applications:org.kde.konsole.desktop",
        "applications:systemsettings.desktop", "applications:org.kde.discover.desktop", "applications:steam.desktop",
        "applications:org.animestage.control.desktop"
    ]

    readonly property int allAppsRow: {
        const r = rootRevision;
        for (let i = 0; i < appsModel.count; ++i) {
            const m = appsModel.modelForRow(i);
            if (m && m.description === "KICKER_ALL_MODEL") return i;
        }
        return -1;
    }
    readonly property var categoryRows: {
        const r = rootRevision;
        const rows = [];
        for (let i = 0; i < appsModel.count; ++i) {
            if (i !== allAppsRow && appsModel.modelForRow(i)) rows.push(i);
        }
        return rows;
    }
    readonly property var activeModel: {
        const r = rootRevision;
        if (searching) return runner.count > 0 ? runner.modelForRow(0) : null;
        if (view === "favorites") return appsModel.favoritesModel;
        if (view === "category" && categoryRow >= 0) return appsModel.modelForRow(categoryRow);
        return allAppsRow >= 0 ? appsModel.modelForRow(allAppsRow) : null;
    }

    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground
    switchWidth: Kirigami.Units.gridUnit * 30
    switchHeight: Kirigami.Units.gridUnit * 20
    toolTipMainText: vc.tr("AnimeStage Launcher")
    toolTipSubText: vc.info.jp + " · " + vc.tr("Programme starten")

    Sessions.SessionManagement { id: sessions }

    Stage.StageConfig { id: vc }
    KCoreAddons.KUser { id: kuser }

    Kicker.RootModel {
        id: appsModel
        autoPopulate: false
        appletInterface: root
        appNameFormat: 0
        flat: true
        sorted: true
        showSeparators: false
        showTopLevelItems: true
        showAllApps: true
        showAllAppsCategorized: false
        showRecentApps: false
        showRecentDocs: false
        showPowerSession: false
        showFavoritesPlaceholder: false
        onRefreshed: root.rootRevision += 1
        Component.onCompleted: {
            refresh();
            favoritesModel.initForClient(root.favoritesClient);
            if (favoritesModel.count < 1) favoritesModel.portOldFavorites(root.defaultFavorites);
        }
    }

    Kicker.RunnerModel {
        id: runner
        appletInterface: root
        favoritesModel: appsModel.favoritesModel
        mergeResults: true
        query: root.query.trim()
        runners: ["krunner_services", "krunner_systemsettings", "calculator", "krunner_sessions", "unitconverter"]
    }

    onExpandedChanged: function () {
        if (root.expanded) {
            query = "";
            view = appsModel.favoritesModel && appsModel.favoritesModel.count > 0 ? "favorites" : "all";
        }
    }

    function launch(model, index) {
        if (!model || index < 0 || index >= model.count) return;
        model.trigger(index, "", null);
        root.expanded = false;
    }

    function toggleFavorite(favoriteId) {
        if (!favoriteId) return;
        const fav = appsModel.favoritesModel;
        if (fav.isFavorite(favoriteId)) fav.removeFavorite(favoriteId); else fav.addFavorite(favoriteId);
        root.rootRevision += 1;
    }

    function greeting() {
        const h = new Date().getHours();
        if (h < 5) return "おやすみ";
        if (h < 11) return "おはよう";
        if (h < 18) return "こんにちは";
        return "こんばんは";
    }

    // ------------------------------------------------------------ panel button
    compactRepresentation: MouseArea {
        id: button

        readonly property string mode: vc.opt("launcher.icon", "distro") === "cover" && !vc.cover() ? "distro" : vc.opt("launcher.icon", "distro")
        Layout.minimumWidth: height
        Layout.preferredWidth: height
        hoverEnabled: true
        onClicked: root.expanded = !root.expanded

        // Logo: distribution (Bazzite) or AnimeStage star; accent frame when open
        Image {
            id: logo
            visible: button.mode === "logo" || button.mode === "distro"
            anchors.fill: parent
            anchors.margins: parent.height * 0.1
            source: button.mode === "distro" ? "file:///usr/share/icons/hicolor/scalable/places/distributor-logo.svg"
                                              : "file://" + vc.logoDir + "animestage.svg"
            sourceSize.width: width * 2
            sourceSize.height: height * 2
            smooth: true
            scale: button.pressed ? 0.94 : (button.containsMouse ? 1.06 : 1)
            Behavior on scale { NumberAnimation { duration: 120 } }
        }
        Rectangle {
            visible: logo.visible && root.expanded
            anchors.fill: logo
            anchors.margins: -2
            radius: width * 0.26
            color: "transparent"
            border.width: 2
            border.color: vc.accent
        }

        Stage.StageAvatar {
            anchors.fill: parent
            anchors.margins: parent.height * 0.08
            visible: !logo.visible
            stage: vc
            cornerRatio: 0.3
            source: button.mode === "cover" ? vc.cover() : vc.image("launcher")
        }
    }

    // ------------------------------------------------------------ Popup
    fullRepresentation: Item {
        id: popup

        readonly property real u: Kirigami.Units.gridUnit
        readonly property bool showHero: vc.opt("launcher.showHero", true)
        readonly property int columns: Math.max(3, vc.opt("launcher.columns", 6))

        Layout.minimumWidth: u * 40
        Layout.minimumHeight: u * 28
        Layout.preferredWidth: u * (showHero ? 54 : 40)
        Layout.preferredHeight: u * 34

        Keys.forwardTo: [search]

        Connections {
            target: root
            function onExpandedChanged() {
                if (root.expanded) {
                    root.heroPick = Math.floor(Math.random() * 1000);
                    search.text = "";
                    search.forceActiveFocus();
                }
            }
        }

        RowLayout {
            anchors.fill: parent
            spacing: 0

            // -------------------------------------------- stage with character
            Item {
                id: hero
                visible: popup.showHero
                Layout.preferredWidth: popup.u * 14
                Layout.fillHeight: true
                clip: true

                // own launcher image, otherwise a different cutout of the anime every time it opens
                readonly property var heroes: vc.anime.heroCuts || []
                readonly property string figure: vc.image("launcher")
                    || (heroes.length ? "file://" + heroes[root.heroPick % heroes.length] : "")

                // the anime's banner as stage, darkened and tinted
                Item {
                    id: stageArt
                    anchors.fill: parent
                    Rectangle { anchors.fill: parent; color: vc.surfaceAlt }
                    Image {
                        anchors.fill: parent
                        source: vc.anime.banner ? "file://" + vc.anime.banner : vc.cover()
                        fillMode: Image.PreserveAspectCrop
                        sourceSize.height: 900
                        asynchronous: true
                        opacity: 0.5
                    }
                    Rectangle {
                        anchors.fill: parent
                        gradient: Gradient {
                            GradientStop { position: 0; color: vc.alpha(vc.accent, 0.30) }
                            GradientStop { position: 0.5; color: vc.alpha(vc.bg, 0.35) }
                            GradientStop { position: 1; color: vc.alpha(vc.bg, 0.92) }
                        }
                    }
                }
                // year as watermark
                Stage.StageText {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: popup.u * 0.8
                    stage: vc
                    display: true
                    text: vc.info.number
                    color: vc.alpha(vc.text, 0.10)
                    font.pixelSize: popup.u * 4.5
                }

                Image {
                    id: heroImg
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: plate.top
                    anchors.topMargin: popup.u * 1.2
                    anchors.bottomMargin: -popup.u * 0.5
                    source: hero.figure
                    fillMode: Image.PreserveAspectFit
                    verticalAlignment: Image.AlignBottom
                    sourceSize.height: Math.ceil(height * 1.5)
                    asynchronous: true
                    mipmap: true
                    opacity: status === Image.Ready ? 1 : 0
                    Behavior on opacity { NumberAnimation { duration: 250 } }
                }
                // let the character fade softly into the name plate at the bottom
                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: plate.top
                    anchors.bottomMargin: -popup.u * 0.5
                    height: popup.u * 3
                    gradient: Gradient {
                        GradientStop { position: 0; color: vc.alpha(vc.bg, 0) }
                        GradientStop { position: 1; color: vc.alpha(vc.bg, 0.85) }
                    }
                }

                ColumnLayout {
                    id: plate
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: popup.u * 0.8
                    spacing: popup.u * 0.3

                    Stage.StageText {
                        stage: vc
                        visible: vc.opt("launcher.greeting", true)
                        text: root.greeting() + ", " + (kuser.fullName || kuser.loginName) + "!"
                        color: vc.accent
                        font.pixelSize: popup.u * 0.85
                        font.weight: Font.Bold
                        Layout.fillWidth: true
                    }
                    Stage.StageText {
                        stage: vc
                        display: true
                        text: vc.info.jp
                        font.pixelSize: popup.u * 1.6
                        Layout.fillWidth: true
                    }
                    Stage.StageText {
                        stage: vc
                        text: vc.info.name.toUpperCase() + (vc.info.format ? "  ·  " + vc.info.format : "")
                        color: vc.muted
                        font.pixelSize: popup.u * 0.6
                        font.letterSpacing: popup.u * 0.1
                        Layout.fillWidth: true
                    }

                    RowLayout {
                        Layout.topMargin: popup.u * 0.4
                        spacing: popup.u * 0.35
                        Repeater {
                            // Like Kickoff via Plasma's SessionManagement – shows Plasma's normal
                            // confirmation dialog.
                            model: [
                                { icon: "system-lock-screen", tip: vc.tr("Sperren"), act: "lock" },
                                { icon: "system-suspend", tip: vc.tr("Standby"), act: "suspend" },
                                { icon: "system-log-out", tip: vc.tr("Abmelden"), act: "logout" },
                                { icon: "system-reboot", tip: vc.tr("Neustart"), act: "reboot" },
                                { icon: "system-shutdown", tip: vc.tr("Herunterfahren"), act: "shutdown" }
                            ]
                            Stage.StageButton {
                                required property var modelData
                                stage: vc
                                implicitWidth: popup.u * 1.9
                                icon: modelData.icon
                                tooltip: modelData.tip
                                onClicked: {
                                    root.expanded = false;
                                    switch (modelData.act) {
                                    case "lock": sessions.lock(); break;
                                    case "suspend": sessions.suspend(); break;
                                    case "logout": sessions.requestLogout(); break;
                                    case "reboot": sessions.requestReboot(); break;
                                    case "shutdown": sessions.requestShutdown(); break;
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // -------------------------------------------- Apps
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: popup.u * 0.8
                spacing: popup.u * 0.6

                RowLayout {
                    Layout.fillWidth: true
                    spacing: popup.u * 0.5

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: popup.u * 2.4
                        radius: height / 2
                        color: vc.alpha(vc.bg, 0.6)
                        border.width: search.activeFocus ? 2 : 1
                        border.color: search.activeFocus ? vc.accent : vc.alpha(vc.accent, 0.3)

                        Kirigami.Icon {
                            id: searchIcon
                            anchors.left: parent.left
                            anchors.leftMargin: popup.u * 0.8
                            anchors.verticalCenter: parent.verticalCenter
                            width: popup.u
                            height: width
                            source: "search"
                            color: vc.accent
                            isMask: true
                        }

                        TextInput {
                            id: search
                            anchors.left: searchIcon.right
                            anchors.right: parent.right
                            anchors.leftMargin: popup.u * 0.6
                            anchors.rightMargin: popup.u
                            anchors.verticalCenter: parent.verticalCenter
                            color: vc.text
                            selectionColor: vc.accent
                            selectedTextColor: vc.onAccent
                            font.family: vc.font
                            font.pixelSize: popup.u * 0.95
                            clip: true
                            focus: true
                            onTextChanged: root.query = text

                            Stage.StageText {
                                anchors.verticalCenter: parent.verticalCenter
                                stage: vc
                                visible: search.text.length === 0
                                text: vc.tr("Suchen …  検索")
                                color: vc.muted
                                font.pixelSize: popup.u * 0.95
                            }

                            Keys.onEscapePressed: {
                                if (text.length) text = ""; else root.expanded = false;
                            }
                            Keys.onReturnPressed: root.launch(root.activeModel, Math.max(0, grid.currentIndex))
                            Keys.onEnterPressed: root.launch(root.activeModel, Math.max(0, grid.currentIndex))
                            Keys.onDownPressed: { grid.forceActiveFocus(); if (grid.currentIndex < 0) grid.currentIndex = 0; }
                            Keys.onTabPressed: { grid.forceActiveFocus(); if (grid.currentIndex < 0) grid.currentIndex = 0; }
                        }
                    }

                    Stage.StageButton {
                        stage: vc
                        implicitWidth: popup.u * 2.4
                        icon: "file://" + vc.dataHome + "/icons/hicolor/scalable/apps/animestage-control.svg"
                        mask: false
                        iconScale: 0.7
                        tooltip: vc.tr("AnimeStage-Kontrollzentrum")
                        onClicked: {
                            root.expanded = false;
                            vc.shell("plasmawindowed org.animestage.control", "control");
                        }
                    }
                }

                // categories as chips
                ListView {
                    id: chips
                    visible: !root.searching
                    Layout.fillWidth: true
                    Layout.preferredHeight: popup.u * 1.9
                    orientation: ListView.Horizontal
                    spacing: popup.u * 0.35
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    model: {
                        const r = root.rootRevision;
                        const items = [{ key: "favorites", label: vc.tr("★ Favoriten"), row: -1 }, { key: "all", label: vc.tr("Alle"), row: -1 }];
                        for (let i = 0; i < root.categoryRows.length; ++i) {
                            const row = root.categoryRows[i];
                            items.push({ key: "category", label: appsModel.labelForRow(row), row: row });
                        }
                        return items;
                    }
                    delegate: Rectangle {
                        required property var modelData
                        readonly property bool active: root.view === modelData.key && (modelData.key !== "category" || root.categoryRow === modelData.row)
                        height: chips.height
                        width: chipText.implicitWidth + popup.u * 1.4
                        radius: height / 2
                        color: active ? vc.accent : (chipMouse.containsMouse ? vc.alpha(vc.accent, 0.18) : vc.alpha(vc.text, 0.06))
                        Behavior on color { ColorAnimation { duration: 140 } }

                        Stage.StageText {
                            id: chipText
                            anchors.centerIn: parent
                            stage: vc
                            text: modelData.label
                            color: parent.active ? vc.onAccent : vc.text
                            font.pixelSize: popup.u * 0.72
                            font.weight: Font.Medium
                        }
                        MouseArea {
                            id: chipMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.view = modelData.key;
                                root.categoryRow = modelData.row;
                                grid.currentIndex = -1;
                            }
                        }
                    }
                    WheelHandler {
                        onWheel: function (event) { chips.flick(event.angleDelta.y * 8, 0); }
                    }
                }

                Stage.StageText {
                    visible: root.searching
                    stage: vc
                    text: grid.count > 0 ? vc.tr("Ergebnisse für „%1“", [root.query.trim()]) : vc.tr("Nichts gefunden …")
                    color: vc.muted
                    font.pixelSize: popup.u * 0.75
                    Layout.fillWidth: true
                    Layout.preferredHeight: popup.u * 1.9
                    verticalAlignment: Text.AlignVCenter
                }

                GridView {
                    id: grid
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: root.activeModel
                    cellWidth: Math.floor(width / popup.columns)
                    cellHeight: popup.u * 5.2
                    currentIndex: -1
                    keyNavigationWraps: true
                    boundsBehavior: Flickable.StopAtBounds
                    highlightFollowsCurrentItem: true
                    highlight: Rectangle {
                        radius: vc.radius * 0.7
                        color: vc.alpha(vc.accent, 0.2)
                        border.width: 1
                        border.color: vc.accent
                    }
                    QQC2.ScrollBar.vertical: QQC2.ScrollBar {}

                    Keys.onReturnPressed: root.launch(root.activeModel, currentIndex)
                    Keys.onEnterPressed: root.launch(root.activeModel, currentIndex)
                    Keys.onEscapePressed: search.forceActiveFocus()
                    Keys.onPressed: function (event) {
                        if (event.text.length > 0 && event.text.trim().length > 0 && !(event.modifiers & Qt.ControlModifier)) {
                            search.text += event.text;
                            search.forceActiveFocus();
                            event.accepted = true;
                        }
                    }

                    delegate: Item {
                        id: cell
                        required property int index
                        required property var model
                        width: grid.cellWidth
                        height: grid.cellHeight

                        readonly property string favId: model.favoriteId || ""
                        readonly property bool fav: {
                            const r = root.rootRevision;
                            return favId.length > 0 && appsModel.favoritesModel.isFavorite(favId);
                        }

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 2
                            radius: vc.radius * 0.7
                            color: cellMouse.containsMouse && grid.currentIndex !== cell.index ? vc.alpha(vc.text, 0.06) : "transparent"
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: popup.u * 0.4
                            spacing: popup.u * 0.25

                            Kirigami.Icon {
                                source: cell.model.decoration
                                Layout.preferredWidth: popup.u * 2.4
                                Layout.preferredHeight: popup.u * 2.4
                                Layout.alignment: Qt.AlignHCenter
                                scale: cellMouse.pressed ? 0.9 : (cellMouse.containsMouse ? 1.08 : 1)
                                Behavior on scale { NumberAnimation { duration: 120 } }
                            }
                            Stage.StageText {
                                stage: vc
                                text: cell.model.display || ""
                                font.pixelSize: popup.u * 0.7
                                horizontalAlignment: Text.AlignHCenter
                                wrapMode: Text.Wrap
                                maximumLineCount: 2
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                        }

                        Kirigami.Icon {
                            visible: cell.fav && root.view !== "favorites"
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.margins: popup.u * 0.4
                            width: popup.u * 0.8
                            height: width
                            source: "starred-symbolic"
                            color: vc.accent2
                            isMask: true
                        }

                        MouseArea {
                            id: cellMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            cursorShape: Qt.PointingHandCursor
                            onClicked: function (mouse) {
                                if (mouse.button === Qt.RightButton) {
                                    menu.favId = cell.favId;
                                    menu.isFav = cell.fav;
                                    menu.popup();
                                } else {
                                    root.launch(root.activeModel, cell.index);
                                }
                            }
                        }
                    }

                    QQC2.Menu {
                        id: menu
                        property string favId: ""
                        property bool isFav: false
                        QQC2.MenuItem {
                            enabled: menu.favId.length > 0
                            text: menu.isFav ? vc.tr("Aus Favoriten entfernen") : vc.tr("Zu Favoriten hinzufügen")
                            icon.name: menu.isFav ? "non-starred-symbolic" : "starred-symbolic"
                            onTriggered: root.toggleFavorite(menu.favId)
                        }
                    }
                }

                Stage.StageText {
                    stage: vc
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignRight
                    text: vc.tr("Rechtsklick: Favorit  ·  Tippen: Suche  ·  Enter: Start")
                    color: vc.alpha(vc.muted, 0.7)
                    font.pixelSize: popup.u * 0.55
                }
            }
        }
    }
}
