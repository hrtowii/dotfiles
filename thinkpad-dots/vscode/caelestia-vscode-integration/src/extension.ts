import { existsSync } from "fs";
import { readFile, writeFile } from "fs/promises";
import { homedir } from "os";
import { join } from "path";
import { ConfigurationTarget, extensions, RelativePattern, workspace, type ExtensionContext } from "vscode";
import theme from "./theme";

const getSchemeDir = () => join(process.env.XDG_STATE_HOME ?? join(homedir(), ".local", "state"), "caelestia");
const getSchemePath = () => join(getSchemeDir(), "scheme.json");

const update = async () => {
    const schemePath = getSchemePath();

    if (!existsSync(schemePath)) {
        console.log("No current scheme.");
        return;
    }

    // Update theme colours with scheme
    const scheme = JSON.parse(await readFile(schemePath, "utf-8"));
    const colours = Object.fromEntries(Object.entries(scheme.colours).map(([n, c]) => [n, `#${c}`]));
    await writeFile(join(__dirname, "..", "themes", "caelestia.json"), JSON.stringify(theme(colours)));

    // Sync icon theme
    const workbench = workspace.getConfiguration("workbench");
    if (
        workbench.get("colorTheme") === "Caelestia" &&
        /catppuccin-(latte|frappe|macchiato|mocha)/.test(workbench.get("iconTheme") ?? "") &&
        extensions.getExtension("catppuccin.catppuccin-vsc-icons")
    ) {
        workbench.update(
            "iconTheme",
            `catppuccin-${scheme.mode === "light" ? "latte" : "mocha"}`,
            ConfigurationTarget.Global
        );
    }

    console.log("Updated scheme.");
};

export const activate = (context: ExtensionContext) => {
    update();
    const watcher = workspace.createFileSystemWatcher(new RelativePattern(getSchemeDir(), "scheme.json"));
    context.subscriptions.push(watcher, watcher.onDidCreate(update), watcher.onDidChange(update));
    console.log(`Watching for changes to ${getSchemePath()}`);
};
