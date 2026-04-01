---
description: Update AGENTS.md to reflect the current state of the nixvim config
---

Read every file in `config/` and update `AGENTS.md` so it accurately reflects the current state of the project. Specifically:

1. **Project structure** — list every `.nix` file currently in `config/` with a one-line description
2. **Keybinds** — extract all keybinds from `config/*.nix` and update the keybind tables
3. **Plugins section** — one entry per config file describing what it does and any notable options
4. **LSP section** — reflect the current servers and their purpose
5. **Formatters section** — reflect the current none-ls sources

Do not change the "How to add a plugin", "Running / testing", or "Agent instructions" sections unless they are factually wrong.

Keep the writing concise and consistent with the existing style.
