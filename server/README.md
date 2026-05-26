# Server Layer

Run this after the common `bootstrap.sh` and Chezmoi setup when the machine needs server-oriented tools.

```bash
bash server/run.sh
```

Current scope:

- Docker Engine and Compose
- `lazydocker`
- Docker service enablement
- Current user membership in the `docker` group

Do not put common packages, dotfiles, Tailscale, Resilio Sync, SSH, GitHub auth, `mise`, `uv`, or editor setup here; Chezmoi owns those.
