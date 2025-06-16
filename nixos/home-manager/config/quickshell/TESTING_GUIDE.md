# Caelestia Shell Testing Guide & Status

## Overview
This is a living document tracking the testing and configuration of the Caelestia shell on NixOS. 

**Installation Date**: 2025-06-07  
**Current Status**: Initial setup complete, beginning comprehensive testing

## Installation Summary
- ✅ Quickshell installed via Nix flakes
- ✅ Caelestia scripts packaged as Nix derivation
- ✅ Systemd service configured and running
- ✅ Python script shebangs fixed for NixOS compatibility
- ✅ JetBrains Mono Nerd Font installed
- ✅ Fish completions configured

## Known Issues Fixed
- ✅ Qt5Compat.GraphicalEffects module (added qt6.qt5compat)
- ✅ Python scripts with hardcoded shebangs
- ✅ Fish completion basename errors
- ✅ IPC functionality for shell commands (created caelestia-quickshell wrapper)
- ✅ Added IPC handlers to Visibilities.qml for drawer controls

---

## Testing Progress

### 1. Basic Shell Controls (Using caelestia-quickshell wrapper)
- [x] `caelestia-quickshell shell show dashboard` - Opens dashboard (WORKS)
- [x] `caelestia-quickshell shell show launcher` - Opens app launcher (WORKS)
- [x] `caelestia-quickshell shell show session` - Shows session/power menu (WORKS)
- [x] `caelestia-quickshell shell toggle dashboard` - Toggle on current monitor (WORKS)
- [x] `caelestia-quickshell shell toggle launcher` - Toggle on current monitor (WORKS)
- [ ] `caelestia-quickshell shell reload-css` - Reload styles only
- [ ] `caelestia-quickshell shell reload-config` - Reload entire config

**Notes**: Commands work using `caelestia-quickshell` wrapper. Shell alias `caelestia` available after new terminal session.

### 2. Main UI Components

#### Bar (Top/Bottom panel)
- [ ] Workspaces display correctly
- [ ] Active window title shows
- [ ] Clock displays correct time
- [ ] System tray shows running apps
- [ ] Status icons (network, bluetooth, battery, volume)
- [ ] Click interactions work
- [ ] Right-click menus on tray items

**Notes**: _Add observations here_

#### Dashboard (Super+D)
- [ ] Opens with keyboard shortcut
- [ ] Calendar widget works
- [ ] Media player controls functional
- [ ] System resource monitoring accurate
- [ ] Weather widget configured
- [ ] User info section displays correctly

**Notes**: _Add observations here_

#### Launcher (Super+Space)
- [x] Opens with keyboard shortcut (WORKS - also bound to Super+;)
- [ ] App search works
- [ ] Apps launch correctly
- [ ] Wallpaper selector - Type ">wallpaper " to access
- [ ] Quick actions - Type ">" to access:
  - [ ] `>scheme` - Change color scheme
  - [ ] `>wallpaper` - Open wallpaper selector
  - [ ] `>variant` - Change scheme variant
  - [ ] `>transparency` - Change shell transparency
  - [ ] `>light` - Switch to light mode
  - [ ] `>dark` - Switch to dark mode
  - [ ] `>lock` - Lock session
  - [ ] `>sleep` - Suspend then hibernate

**Notes**: Launcher opens/closes properly. Quick actions accessed by typing ">" prefix.

### 3. Special Workspaces (Direct caelestia commands)
- [ ] `caelestia toggle communication` - Discord/WhatsApp workspace
- [ ] `caelestia toggle music` - Music apps workspace
- [ ] `caelestia toggle sysmon` - System monitor
- [ ] `caelestia toggle todo` - Todo apps

**Notes**: _Add observations here_

### 4. Media Controls (Using caelestia-quickshell wrapper)
- [ ] `caelestia-quickshell shell media play-pause`
- [ ] `caelestia-quickshell shell media next`
- [ ] `caelestia-quickshell shell media previous`
- [ ] `caelestia-quickshell shell media stop`
- [ ] `caelestia-quickshell shell brightness up`
- [ ] `caelestia-quickshell shell brightness down`

**Notes**: _Add observations here_

### 5. Screenshots & Recording (Direct caelestia commands)
- [ ] `caelestia screenshot` - Full screen
- [ ] `caelestia screenshot -r` - Region selection
- [ ] `caelestia record` - Screen recording
- [ ] `caelestia record -s` - With sound
- [ ] `caelestia record -r` - Region recording

**Notes**: _Add observations here_

### 6. Clipboard & Utilities (Direct caelestia commands)
- [ ] `caelestia clipboard` - History works
- [ ] `caelestia emoji-picker` - Picker opens
- [ ] `caelestia pip` - Window to PiP
- [ ] `caelestia pip -d` - PiP daemon

**Notes**: _Add observations here_

### 7. Color Schemes (Direct caelestia commands)
- [ ] List available schemes checked
- [ ] `caelestia scheme` changes work
- [ ] `caelestia variant` options work
- [ ] Scheme persists after reload

**Available Schemes**: _List found schemes here_

**Notes**: Color schemes use direct caelestia commands, not the wrapper

### 8. Wallpaper Management (Direct caelestia commands)
- [x] `caelestia wallpaper -f` - Set specific file (TESTED - Works!)
- [ ] `caelestia wallpaper -d` - Directory selector
- [ ] Wallpaper selection in launcher

**Notes**: Wallpaper command works after fixing Python shebangs

### 9. System Integration
- [ ] Network indicator and menu
- [ ] Bluetooth indicator and controls
- [ ] Battery indicator (if applicable)
- [ ] Audio/volume controls
- [ ] Notifications styling
- [ ] `notify-send` test

**Notes**: _Add observations here_

### 10. Keyboard Shortcuts
- [ ] Super + Space → Launcher
- [ ] Super + D → Dashboard
- [ ] Super + S → Session menu
- [ ] Other configured shortcuts

**Notes**: _Add observations here_

### 11. Performance & Stability
- [ ] Animations smooth
- [ ] CPU usage reasonable
- [ ] Memory usage acceptable
- [ ] No crashes during testing
- [ ] Quick open/close stress test

**Notes**: _Add observations here_

---

## Command Reference

### caelestia-quickshell wrapper (for shell control)
```bash
caelestia-quickshell shell show <drawer>     # Show drawer
caelestia-quickshell shell toggle <drawer>   # Toggle drawer
caelestia-quickshell shell media <action>    # Media controls
```

### Direct caelestia commands (everything else)
```bash
caelestia scheme <name>            # Color schemes
caelestia wallpaper <args>         # Wallpaper management
caelestia screenshot <args>        # Screenshots
caelestia toggle <workspace>       # Special workspaces
caelestia clipboard               # Clipboard history
```

### Shell alias
```bash
caelestia                         # Alias for caelestia-quickshell (after new terminal)
```

---

## Customization Plans

### Immediate Fixes Needed
- _List any broken features_

### Desired Customizations
- _List planned changes_

### Configuration Files Modified
- `~/.config/caelestia/scripts.json` - Toggle workspace apps
- `~/.config/quickshell/caelestia/config/Appearance.qml` - Fonts and styling

---

## Next Steps
1. Begin systematic testing from section 1
2. Document any errors or issues
3. Plan customizations based on findings
4. Create backup of working configuration

---

## Error Log
_Document any errors encountered during testing_

```
Date: 
Error: 
Solution: 
```