# Plans

Repo-local planning for the Arch bootstrap and Chezmoi setup workstream.

## Active Plans

- **chezmoi-role-migration.md**: Move all post-bootstrap setup and configuration from this repo into Chezmoi role-based scripts. This repo remains the central AI working repo and knowledge base for managing both Chezmoi and the bootstrap script, but should only own pre-Chezmoi bootstrap code directly.

## Completed Or Superseded Plans

- **chezmoi-common-arch-bootstrap-spec.md**: Common Arch setup migration into Chezmoi; implemented for the common package/tooling/service baseline.
- **layered-setup-refactor.md**: Completed layered refactor, now superseded by the decision to move scenario layers into Chezmoi roles and return this repo to bootstrap-only scripts.

## Conventions

- Keep active multi-step work in `plans/`.
- Use root `scratchpad.md` for recent repo-local context and short-lived transition notes.
- Keep durable setup reference in `docs/`.
- Do not run `bootstrap.sh`, Chezmoi apply/update, or scenario `run.sh` scripts as verification unless Curtis explicitly asks.
