// Reads ~/.config/animestage/config.json live and provides colors, images and
// character info to all AnimeStage widgets. Writing always goes through
// the animestage CLI, so there is exactly one source of truth.
import QtQuick
import QtCore
import org.kde.plasma.plasma5support as P5Support

Item {
    id: stage

    visible: false
    width: 0
    height: 0

    property var config: ({})
    property bool loaded: false
    property int pollInterval: 2000
    property string _raw: ""
    property int _serial: 0

    readonly property string dataHome: String(StandardPaths.writableLocation(StandardPaths.GenericDataLocation)).replace("file://", "")
    readonly property string logoDir: dataHome + "/animestage/logos/"
    readonly property string cli: "\"$HOME/.local/bin/animestage\""

    readonly property int rev: config.rev || 0
    readonly property var anime: config.anime || ({})
    readonly property var colors: config.colors || ({})
    readonly property var style: config.style || ({})
    readonly property var images: config.images || ({})

    readonly property color accent: colors.accent || "#39C5BB"
    readonly property color accent2: colors.accent2 || "#E12885"
    readonly property color bg: colors.bg || "#0A1113"
    readonly property color surface: colors.surface || "#10191C"
    readonly property color surfaceAlt: colors.surfaceAlt || "#172428"
    readonly property color text: colors.text || "#E4F5F3"
    readonly property color muted: colors.muted || "#86A6A4"
    readonly property color positive: colors.positive || "#5BE0A0"
    readonly property color neutral: colors.neutral || "#F5C35B"
    readonly property color negative: colors.negative || "#FF5C7A"
    readonly property color onAccent: luminance(accent) > 0.30 ? Qt.darker(bg, 1.3) : "#FFFFFF"

    readonly property real radius: opt("style.radius", 14)
    readonly property real widgetOpacity: opt("style.widgetOpacity", 0.72)
    readonly property real borderOpacity: opt("style.borderOpacity", 0.35)
    readonly property bool animations: opt("style.animations", true)
    readonly property string font: opt("style.font", "M PLUS Rounded 1c")

    // Current anime: name = title, jp = original title, number = year
    readonly property var info: ({
        name: anime.title || "AnimeStage",
        jp: anime.native || anime.title || "アニメ",
        number: anime.year ? String(anime.year) : "",
        format: anime.format || ""
    })
    readonly property var animeChars: anime.characters || []

    signal commandFinished(string tag, int code, string stdout, string stderr)

    // ---- Translations: source strings are German, i18n/<lang>.json holds the translation.
    // Language from the config ("auto" = system language), fallback: English, then German.
    readonly property string language: normalizeLanguage(opt("language", "auto") === "auto"
                                                         ? Qt.locale().name : opt("language", "auto"))
    // date formats/weekdays in the selected language
    readonly property var locale: Qt.locale(language === "en" ? "en_US" : (language.indexOf("_") > 0 ? language : language + "_" + language.toUpperCase()).replace("ja_JA", "ja_JP").replace("ko_KO", "ko_KR"))
    property var dict: ({})
    property var dictFallback: ({})

    function normalizeLanguage(code) {
        code = String(code || "").split(".")[0].replace("-", "_");
        const known = ["en", "de", "ja", "fr", "es", "pt_BR", "it", "pl", "nl", "ru", "zh_CN", "zh_TW", "ko"];
        if (known.indexOf(code) >= 0) return code;
        const base = code.split("_")[0];
        if (base === "zh") return ["TW", "HK", "MO"].indexOf(code.split("_")[1]) >= 0 ? "zh_TW" : "zh_CN";
        if (base === "pt") return "pt_BR";
        return known.indexOf(base) >= 0 ? base : "en";
    }

    // tr("Text") – translated; tr("Noch %1 Bilder", [n]) – with placeholders %1, %2 …
    function tr(text, args) {
        let out = stage.dict[text] || stage.dictFallback[text] || text;
        if (args) {
            for (let i = 0; i < args.length; ++i) out = out.split("%" + (i + 1)).join(String(args[i]));
        }
        return out;
    }

    onLanguageChanged: loadLanguage()
    Component.onCompleted: loadLanguage()
    function loadLanguage() {
        const dir = "\"${XDG_DATA_HOME:-$HOME/.local/share}/animestage/i18n/";
        if (stage.language === "de") { stage.dict = {}; stage.dictFallback = {}; return; }
        i18nReader.connectSource("cat " + dir + stage.language + ".json\" 2>/dev/null #lang:" + stage.language);
        if (stage.language !== "en") i18nReader.connectSource("cat " + dir + "en.json\" 2>/dev/null #lang:en-fallback");
        else stage.dictFallback = {};
    }

    function opt(path, fallback) {
        let node = stage.config;
        const keys = path.split(".");
        for (let i = 0; i < keys.length; ++i) {
            if (node === null || typeof node !== "object" || !(keys[i] in node)) {
                return fallback;
            }
            node = node[keys[i]];
        }
        return node === undefined || node === null ? fallback : node;
    }

    function luminance(c) {
        function ch(v) { return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4); }
        return 0.2126 * ch(c.r) + 0.7152 * ch(c.g) + 0.0722 * ch(c.b);
    }

    function alpha(c, a) {
        return Qt.rgba(c.r, c.g, c.b, a);
    }

    function image(slot) {
        const path = images[slot] || "";
        return path.length > 0 ? "file://" + path : "";
    }

    function cover() {
        return anime.cover ? "file://" + anime.cover : "";
    }

    function quote(value) {
        return "'" + String(value).replace(/'/g, "'\\''") + "'";
    }

    // Runs `animestage <args...>`; the result arrives via commandFinished.
    function run(args, tag) {
        const parts = [cli];
        for (let i = 0; i < args.length; ++i) {
            parts.push(quote(args[i]));
        }
        shell(parts.join(" "), tag || args[0]);
    }

    function shell(command, tag) {
        stage._serial += 1;
        // The comment makes every source unique, so identical commands
        // can run again back to back.
        const source = command + " #" + (tag || "cmd") + ":" + stage._serial + ":" + Date.now();
        runner.connectSource(source);
    }

    function set(path, value, applyParts) {
        const args = ["set", path, typeof value === "string" ? value : JSON.stringify(value)];
        if (applyParts && applyParts.length) {
            args.push("--apply");
            for (let i = 0; i < applyParts.length; ++i) {
                args.push(applyParts[i]);
            }
        }
        run(args, "set:" + path);
    }

    function reload() {
        reader.disconnectSource(reader.readCommand);
        reader.connectSource(reader.readCommand);
    }

    P5Support.DataSource {
        id: reader

        readonly property string readCommand: "cat \"${XDG_CONFIG_HOME:-$HOME/.config}/animestage/config.json\" 2>/dev/null"

        engine: "executable"
        interval: stage.pollInterval
        connectedSources: [readCommand]

        onNewData: function (source, result) {
            const out = result["stdout"] || "";
            if (out.length === 0 || out === stage._raw) {
                return;
            }
            try {
                stage.config = JSON.parse(out);
                stage._raw = out;
                stage.loaded = true;
            } catch (e) {
                // Half-written file – read again on the next tick.
            }
        }
    }

    P5Support.DataSource {
        id: i18nReader
        engine: "executable"
        onNewData: function (source, result) {
            i18nReader.disconnectSource(source);
            let data = {};
            try { data = JSON.parse(result["stdout"] || "{}"); } catch (e) {}
            if (source.indexOf("#lang:en-fallback") >= 0) stage.dictFallback = data;
            else if (source.indexOf("#lang:" + stage.language) >= 0) stage.dict = data;
        }
    }

    P5Support.DataSource {
        id: runner

        engine: "executable"

        onNewData: function (source, result) {
            runner.disconnectSource(source);
            const marker = source.lastIndexOf(" #");
            const tag = marker >= 0 ? source.substring(marker + 2).split(":")[0] : "";
            stage.commandFinished(tag, result["exit code"] || 0, result["stdout"] || "", result["stderr"] || "");
            stage.reload();
        }
    }
}
