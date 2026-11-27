# COSMIC shortcuts for AeroSpace

Super is **Option (⌥)**. COSMIC's additional Alt modifier becomes **Command (⌘)**.
Based on https://github.com/pop-os/cosmic-comp/blob/master/data/keybindings.ron
and https://support.system76.com/support/pop-cosmic-keyboard-shortcuts.

| Shortcut | Action |
| --- | --- |
| ⌥ + arrows / H J K L | Focus window |
| ⌥⇧ + arrows / H J K L | Move window |
| ⌥⌃ + arrows / H J K L | Previous/next workspace |
| ⌥⌃⇧ + arrows / H J K L | Move window to previous/next workspace and follow |
| ⌥⌘ + arrows / H J K L | Focus display |
| ⌥⌘⇧ + arrows / H J K L | Move window to display and follow |
| ⌥1–9 | Workspace 1–9 |
| ⌥⇧1–9 | Move window to workspace and follow |
| ⌥0 / ⌥⇧0 | Last workspace / move window there |
| ⌥Tab / ⌥⇧Tab | Next/previous window in workspace tree order |
| Tap ⌥ alone | Spotlight (Karabiner rule sends ⌘Space) |
| ⌥Q / ⌥F4 | Close window |
| ⌥M | AeroSpace fullscreen (maximize within workspace) |
| ⌥F11 | Native macOS fullscreen |
| ⌥G | Toggle focused window floating/tiling |
| ⌥Y | Float all current workspace windows; tile all if all are floating |
| ⌥O | Toggle horizontal/vertical orientation |
| ⌥S | Toggle accordion/tiles |
| ⌥X, then direction | Swap with neighboring window, then return to main mode |
| ⌥R, then direction | Grow width (left/right) or height (up/down) by 50 |
| ⌥⇧R, then direction | Shrink width (left/right) or height (up/down) by 50 |
| Escape / Enter | Exit resize or swap mode |
| ⌥T | Ghostty |
| ⌥F | Finder |
| ⌥B | Firefox |
| ⌥A | macOS Apps |
| ⌥W | Mission Control |
| ⌥/ | Spotlight |
| ⌥⌃⇧C | Reload configuration (extra convenience binding) |

Command app shortcuts and macOS screen lock, screenshots, input-source switching,
zoom, media controls, and Command-Tab retain their native behavior.

## Differences from COSMIC

- AeroSpace cannot bind a modifier key alone; Karabiner-Elements covers tapping ⌥.
  Parent/child container selection (COSMIC Super-U/I) is not mapped.
- Accordion approximates stacking; it does not provide COSMIC's actual tabs.
- Resize modes stay active until Escape/Enter and resize dimensions rather than
  a particular edge. You can keep Option/Shift held while using direction keys.
- Workspace tiling toggles existing windows only. Newly opened windows still tile,
  and toggling back does not restore the previous container structure or distinguish
  windows that were already floating. It does not disable AeroSpace globally.
- Window cycling uses workspace tree order, not COSMIC's visual window switcher.
- Directional window moves use AeroSpace's boundary behavior rather than COSMIC's
  automatic progression across workspaces and displays.
- Last workspace means the last entry in AeroSpace's workspace order.
- Native macOS fullscreen may require Fn with F11 depending on keyboard settings.

Previous configuration: aerospace.toml.backup-20260904-225538
