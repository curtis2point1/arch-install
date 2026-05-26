# GUI Layer

Run this after common bootstrap/Chezmoi when a machine needs desktop applications shared across graphical environments.

```bash
bash gui/run.sh
```

Current scope:

- Desktop applications and graphical tools
- Flatpak and Flathub registration
- Local font installation from `common/fonts/`
- Walker launcher user service

Run a window-manager layer after this when needed:

- `bash gnome/run.sh`
- `bash hyprland/run.sh`
