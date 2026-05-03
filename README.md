# claude-marketplace

Personal Claude Code plugin marketplace.

## Structure

```
.
├── .claude-plugin/
│   └── marketplace.json          # marketplace manifest
└── plugins/
    ├── notify/                   # Windows desktop notifications
    │   ├── .claude-plugin/
    │   │   └── plugin.json
    │   ├── hooks/
    │   │   └── hooks.json        # Notification + Stop hooks
    │   └── scripts/
    │       └── notify.ps1
    └── andrej-karpathy-rules/    # Coding behavior guidelines
        ├── .claude-plugin/
        │   └── plugin.json
        ├── hooks/
        │   └── hooks.json        # SessionStart hook
        ├── rules/
        │   └── conventions.md    # The actual guideline text (edit this)
        └── scripts/
            └── inject.js         # Cross-platform Node.js
```

## Plugins

### `notify`

Windows desktop notifications on `Stop` (response finished) and `Notification` with `permission_prompt` matcher. Uses BurntToast on the primary monitor and a custom WPF toast on the secondary monitor.

**Requirements:** Windows, PowerShell, [BurntToast](https://github.com/Windos/BurntToast) module (`Install-Module BurntToast`).

### `andrej-karpathy-rules`

Andrej Karpathy-style behavioral guidelines (think-before-coding, simplicity-first, surgical changes, goal-driven execution). A `SessionStart` hook injects `rules/conventions.md` into the session as additional context — same effect as a `CLAUDE.md` but distributed and versioned through the marketplace.

To update the guidelines for the whole team: edit `rules/conventions.md`, bump `version` in both `plugin.json` and `marketplace.json`, push, and team members run `/plugin update`.

**Requirements:** Node.js (`node` on PATH). Cross-platform — works on Windows, macOS, and Linux.

Source for the guideline text: <https://github.com/forrestchang/andrej-karpathy-skills>

## Install

```
/plugin marketplace add <owner>/<repo>
/plugin install <plugin-name>@claude-marketplace
```
