"""Small adapters for COSMIC shortcuts not directly provided by AeroSpace."""
import subprocess
import sys

AEROSPACE = "/opt/homebrew/bin/aerospace"

def run(*args):
    return subprocess.check_output([AEROSPACE, *args], text=True).strip()

def main(action):
    if action in ("last-workspace", "move-last-workspace"):
        workspaces = run("list-workspaces", "--all").splitlines()
        if not workspaces:
            return
        # Last in AeroSpace's workspace order, not the previously focused workspace.
        target = workspaces[-1]
        if action == "last-workspace":
            run("workspace", target)
        else:
            run("move-node-to-workspace", "--focus-follows-window", target)
    elif action == "toggle-workspace-tiling":
        workspace = run("list-workspaces", "--focused")
        rows = run("list-windows", "--workspace", workspace,
                   "--format", "%{window-id} %{window-layout}").splitlines()
        windows = [row.split() for row in rows]
        target = "floating" if any(layout != "floating" for _, layout in windows) else "tiling"
        for window_id, _ in windows:
            run("layout", "--window-id", window_id, target)
    else:
        raise ValueError(action)

if __name__ == "__main__":
    main(sys.argv[1])
