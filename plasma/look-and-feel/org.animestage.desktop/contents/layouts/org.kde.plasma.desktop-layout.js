// AnimeStage default layout (also used by `animestage layout`)

var wall = "";
var old = panels();
for (var i = 0; i < old.length; ++i) { old[i].remove(); }

var panel = new Panel;
panel.location = "bottom";
panel.height = Math.round(gridUnit * 2.8);
try { panel.floating = true; } catch (e) {}
try { panel.lengthMode = "fill"; } catch (e) {}
panel.addWidget("org.animestage.launcher");
var tasks = panel.addWidget("org.kde.plasma.taskmanager");
tasks.currentConfigGroup = ["General"];
tasks.writeConfig("groupingStrategy", 0);
tasks.writeConfig("taskMaxWidth", 0);
tasks.writeConfig("separateLaunchers", false);
tasks.writeConfig("launchers", ["applications:org.kde.dolphin.desktop", "applications:org.kde.konsole.desktop", "preferred://browser", "applications:org.animestage.control.desktop"]);
panel.addWidget("org.kde.plasma.marginsseparator");
panel.addWidget("org.animestage.media");
panel.addWidget("org.animestage.system");
panel.addWidget("org.kde.plasma.systemtray");
panel.addWidget("org.animestage.clock");

var ds = desktops();
for (var j = 0; j < ds.length; ++j) {
    var d = ds[j];
    if (wall) {
        d.wallpaperPlugin = "org.kde.image";
        d.currentConfigGroup = ["Wallpaper", "org.kde.image", "General"];
        d.writeConfig("Image", "file://" + wall);
        d.writeConfig("FillMode", "2");
    }
    var w = d.widgets();
    for (var k = 0; k < w.length; ++k) {
        if (String(w[k].type).indexOf("org.animestage.") === 0) { w[k].remove(); }
    }
    // The desktop stays empty – everything important lives in the panel.
}
