# Henry-s-game

A Godot game project.

## Godot 4.7 (headless)

This repo targets **Godot 4.7**. The standard Linux editor binary is used in
headless mode (no display needed) via the `--headless` flag.

### Automatic install

A `SessionStart` hook (`.claude/settings.json` →
`.claude/hooks/install-godot.sh`) installs Godot 4.7 to `/usr/local/bin/godot`
automatically at the start of each Claude Code web session. The script is
idempotent and skips the download if the correct version is already present.

### Manual install

```bash
bash .claude/hooks/install-godot.sh
```

### Usage

```bash
godot --version                 # 4.7.stable.official
godot --headless --quit         # boot the engine without a display
godot --headless --import       # import assets in CI / headless
godot --headless --export-release "Linux" build/game.x86_64
```
