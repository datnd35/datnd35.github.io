---
mode: agent
description: "Create a new System Design post mapped to a chapter group in /system-design/"
---

Create a new System Design post for this repo.

## Must follow

- Target folder: `_architecture/`
- Filename: `YYYY-MM-DD-system-design-<short-slug>.md`
- Front matter required:
  - `layout: post`
  - `title: "<short title>"`
  - `date: YYYY-MM-DD`
  - `categories: architecture`
  - `track: "system-design"`
  - `chapter: "<1..16>"` (string, not number)
  - optional `description`, `tags`

## Content format

Use structure from `_templates/system-design/post-template.md`:

1. Mục tiêu bài viết
2. Context
3. Kiến trúc tổng quan
4. Request/Data flow
5. API/Data contract
6. Trade-offs
7. Tóm tắt + bài học

Include:

- at least one `Figure` section
- at least one text diagram block (` ```text `)
- one API example + one JSON response

## Image convention

- Image folder: `assets/images/system-design/chXX-<slug>/`
- File names: `figure-1-1.png`, `figure-1-2.png`, ...
- If image does not exist yet, still insert markdown placeholders with alt text.

## Integration checks

- Ensure post appears in `/system-design/` chapter grouping via `chapter` value.
- Check changed files for errors.

## Final response format

- What was created
- Chapter mapping used
- Any placeholder images to upload
- Verification result
