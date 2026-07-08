# Copilot Slash Prompts for this repo

These prompt files can be used from Copilot Chat as slash commands.

## Available commands

- `/create-new-post`
  - Create a new post in any collection with repo-consistent format.

- `/create-new-system-design-post`
  - Create a System Design post in `_architecture` with chapter mapping for `/system-design/`.

## Notes

- Prompt files are stored in `.github/prompts/*.prompt.md`.
- Keep `chapter` as **string** (`"1".."16"`) for System Design posts.
- Reuse template: `_templates/system-design/post-template.md`.
