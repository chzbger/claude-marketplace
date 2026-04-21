# claude-marketplace

Personal Claude Code plugin marketplace.

## Structure

```
.
├── .claude-plugin/
│   └── marketplace.json          # marketplace manifest
└── plugins/
    └── notify/                   # Windows desktop notifications
        ├── .claude-plugin/
        │   └── plugin.json
        ├── hooks/
        │   └── hooks.json        # Notification + Stop hooks
        └── scripts/
            └── notify.ps1
```

## Plugins

### `notify`

Windows desktop notifications on `Stop` (response finished) and `Notification` with `permission_prompt` matcher. Uses BurntToast on the primary monitor and a custom WPF toast on the secondary monitor.

**Requirements:** Windows, PowerShell, [BurntToast](https://github.com/Windos/BurntToast) module (`Install-Module BurntToast`).

## Install

Add this marketplace and install a plugin from it:

```
/plugin marketplace add C:/00wj/src/my/claude-marketplace
/plugin install notify@claude-marketplace
```

Or from GitHub once published:

```
/plugin marketplace add <owner>/<repo>
/plugin install notify@claude-marketplace
```
