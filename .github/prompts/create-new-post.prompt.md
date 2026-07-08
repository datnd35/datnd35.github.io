---
mode: agent
description: "Create a new post with consistent front matter and structure for this Jekyll blog"
---

Create a new blog post in this repository with consistent format.

## Requirements

1. Detect target collection from user intent (examples: `_architecture`, `_communication`, `_ai`, `_backend`, etc.).
2. Create filename using date prefix: `YYYY-MM-DD-slug.md`.
3. Use consistent front matter based on collection conventions in this repo.
4. Write concise, scannable Vietnamese-first content (keep English technical terms when clearer).
5. If this is a System Design post:
   - set `track: "system-design"`
   - set `chapter` as string (`"1".."16"`)
   - follow template at `_templates/system-design/post-template.md`
6. Add at least one text diagram block (` ```text `).
7. If images are needed, use `assets/images/<collection-or-topic>/<slug>/` and reference with clear alt text.
8. After creating files, check for errors in changed files.

## Output behavior

- Do not ask unnecessary questions.
- If critical info is missing (e.g., chapter number), make a reasonable default assumption and state it briefly.
- Finish by summarizing:
  - files created/edited
  - assumptions used
  - verification status
