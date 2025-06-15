# Quickshell Module - Caelestia Shell Configuration

This module IS the Caelestia shell configuration for Quickshell, fully integrated into home-manager.

## Structure

```
quickshell/
├── default.nix              # Module entry point
├── packages.nix            # Nix derivations
├── config.nix             # Configuration management
├── shell.qml              # Shell entry point
├── scripts.json           # Your toggle workspace apps
├── modules/               # UI components
│   ├── bar/              # Status bar
│   ├── dashboard/        # Dashboard widget
│   ├── launcher/         # App launcher
│   └── ...
├── widgets/              # Reusable QML widgets  
├── services/             # System integrations
├── config/               # Appearance settings
└── assets/               # Images and resources
```

## Customization

Everything in this directory (except .nix files) is YOUR shell configuration:

- **shell.qml** - Main entry point
- **modules/** - Modify UI components directly
- **config/** - Change appearance, behavior
- **scripts.json** - Configure toggle workspace apps
- **widgets/** - Create custom widgets

## Usage

```bash
# Commands using caelestia-quickshell wrapper
caelestia-quickshell shell toggle dashboard    # Toggle dashboard
caelestia-quickshell shell toggle launcher     # Toggle launcher  
caelestia-quickshell shell toggle session      # Toggle session menu
caelestia-quickshell shell media play-pause    # Media controls

# Direct caelestia commands (no wrapper needed)
caelestia toggle <workspace>        # Toggle special workspaces
caelestia scheme <name>             # Change color scheme
caelestia wallpaper -f <path>       # Set wallpaper

# Service management
systemctl --user restart caelestia-shell

# Edit shell (opens this directory)
caelestia-edit

# Shell alias (after new terminal session)
caelestia                          # Alias for caelestia-quickshell
```

## Development Workflow

1. Edit any QML files directly in this directory
2. Run `caelestia-quickshell shell reload-config` to see changes
3. Rebuild system only when changing Nix configs
4. All changes are tracked in git

This is YOUR shell - modify it however you want!