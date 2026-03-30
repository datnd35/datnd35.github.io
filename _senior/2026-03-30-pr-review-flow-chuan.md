---
layout: post
title: "PR Review Flow Chuẩn — Reviewer Không Phải Undo Commit Của Dev"
date: 2026-03-30
categories: senior
---

## 🎯 Mục Tiêu Bài Viết

Nhiều dev nhầm tưởng review PR = checkout branch → tự undo commit → so sánh thủ công. Đó là **sai flow hoàn toàn**. Bài này giải thích cách reviewer làm **đúng chuẩn** — như Google, Meta engineering teams.

```
✅ Hiểu mục tiêu thật sự của reviewer
✅ Flow chuẩn: review diff trên PR trước
✅ Khi nào cần checkout local (và khi nào không)
✅ 3 tình huống reviewer được phép sửa code
✅ Diagram rõ ràng toàn bộ review workflow
✅ Checklist reviewer frontend Angular/Vue
✅ Insight phỏng vấn Senior về code review
```

> **Reviewer review trên diff. Reviewer verify trên local nếu cần. Reviewer KHÔNG tự undo commit của author.**

📄 **Bài trước:** [AI Code Review Pipeline — Automation Như Big Tech](/senior/2026/03/29/copilot-pro-automation-review.html)

---

## 🗺️ 1. Big Picture — PR Review Workflow

```
                ┌───────────────────┐
                │   Dev tạo PR      │
                │  (author)         │
                └─────────┬─────────┘
                          │
                          ▼
                ┌───────────────────┐
                │ Reviewer xem diff │
                │ trên PR           │
                └─────────┬─────────┘
                          │
            ┌─────────────┴─────────────┐
            │  Có cần chạy local không? │
            └───────┬───────────┬───────┘
                    │ Không     │ Có
                    ▼           ▼
        ┌─────────────────┐   ┌────────────────────┐
        │ Comment trên PR │   │ Checkout branch PR │
        │ Approve/Request │   │ Run app/test/debug │
        └────────┬────────┘   └─────────┬──────────┘
                 │                       │
                 └──────────┬────────────┘
                            ▼
                 ┌────────────────────┐
                 │ Comment lại trên PR│
                 │ Approve / Request  │
                 └────────────────────┘
```

### Nhầm Lẫn Phổ Biến

```
❌ FLOW SAI (nhiều dev junior đang làm):
   checkout branch của author
   → reset / revert commit của author
   → so sánh thủ công
   → review theo cảm tính

✅ FLOW ĐÚNG:
   Review diff trên PR
   → Checkout local CHỈ khi cần chạy/test
   → Comment trực tiếp trên PR
   → Không tự undo commit của author
```

---

## 🧩 2. Mục Tiêu Của Reviewer Là Gì?

### Reviewer Cần Thấy Rõ

```
┌─────────────────────────────────────────────────────────┐
│              MỤC TIÊU CỦA REVIEWER                      │
│                                                         │
│  1. Code cũ là gì?                                      │
│     → Base branch (develop/main)                        │
│                                                         │
│  2. Code mới thay đổi gì?                              │
│     → Feature branch diff                               │
│                                                         │
│  3. Thay đổi đó có bug không?                          │
│     → Logic review trên diff                            │
│                                                         │
│  4. Có đúng scope không?                               │
│     → PR description + files changed                    │
│                                                         │
│  5. Có ảnh hưởng chỗ khác không?                       │
│     → Side effect analysis                              │
│                                                         │
└─────────────────────────────────────────────────────────┘

👉 Tất cả 5 điều này đều có sẵn trong PR diff
👉 Không cần tự undo commit để xem
```

### GitHub/GitLab Đã Làm Sẵn Cho Bạn

```
PR Diff = base branch vs feature branch

base branch  ──→ code CŨ (trước khi thay đổi)
feature branch ──→ code MỚI (sau khi thay đổi)

PR cung cấp sẵn:
  ├─ Files changed     → danh sách file bị sửa
  ├─ Diff view         → line-by-line so sánh
  ├─ Commits           → từng commit trong PR
  ├─ Conversation      → lịch sử comment
  └─ Checks / CI       → test result tự động

👉 Không cần tự tay "undo" để tạo lại diff này!
```

---

## 🔵 3. Cách 1 — Review Trực Tiếp Trên PR (Default)

### Flow

```
┌──────────────────────────────────────────────────────────┐
│            REVIEW TRỰC TIẾP TRÊN PR                     │
│                                                          │
│  Step 1: Đọc title + description                        │
│          → Hiểu mục đích của PR                         │
│          → Verify scope: PR làm đúng 1 việc không?      │
│          │                                               │
│          ▼                                               │
│  Step 2: Xem Commits tab                                │
│          → Bao nhiêu commit? Commit message rõ không?   │
│          │                                               │
│          ▼                                               │
│          Step 3: Xem Files Changed                      │
│          → File nào bị thay đổi?                        │
│          → Scope có đúng không? (không sửa lung tung)   │
│          │                                               │
│          ▼                                               │
│  Step 4: Review từng line diff                          │
│          → Click dòng để comment                        │
│          → Flag issues với suggestion                   │
│          │                                               │
│          ▼                                               │
│  Step 5: Check CI/Checks tab                            │
│          → Test pass chưa?                              │
│          → Build success không?                         │
│          │                                               │
│          ▼                                               │
│  Step 6: Submit review                                  │
│          ├─ Approve → LGTM, merge được                  │
│          ├─ Request Changes → cần fix                   │
│          └─ Comment → hỏi thêm, không block             │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

### Ưu Điểm

```
✅ Ưu điểm của review trên PR:
  ├─ Đúng phần changed — không bị distracted bởi code khác
  ├─ Comment bám đúng line code → dễ trace
  ├─ Lịch sử trao đổi được lưu lại
  ├─ Không tốn công checkout nhiều
  └─ Team members khác cũng thấy discussion

✅ Phù hợp khi review:
  ├─ Logic correctness
  ├─ Coding style / convention
  ├─ Scope của thay đổi
  ├─ Test case coverage
  └─ Documentation
```

---

## 🟢 4. Cách 2 — Checkout Branch Local (Khi Cần)

### Khi Nào Cần Checkout Local?

```
┌─────────────────────────────────────────────────────────┐
│          DẤU HIỆU CẦN CHECKOUT LOCAL                    │
│                                                         │
│  🔴 BẮT BUỘC checkout:                                 │
│  ├─ Bug nghi ngờ chỉ reproduce khi chạy app            │
│  ├─ Thay đổi liên quan UI/UX (cần xem mắt)            │
│  ├─ Liên quan performance (cần đo thật)                 │
│  └─ Liên quan env/config/API integration               │
│                                                         │
│  🟡 NÊN checkout:                                      │
│  ├─ Logic phức tạp, khó đọc trên web diff              │
│  ├─ Thay đổi nhiều file liên quan nhau                 │
│  ├─ Liên quan build/test/e2e pipeline                  │
│  └─ Side effect khó đoán chỉ bằng đọc code            │
│                                                         │
│  🟢 KHÔNG CẦN checkout:                                │
│  ├─ Thay đổi nhỏ (typo, rename, refactor đơn giản)    │
│  ├─ Logic đơn giản, rõ ràng trên diff                  │
│  └─ Chỉ thay đổi text/config không phức tạp           │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Cách Checkout Đúng

```bash
# Cách 1: Branch đã có trên remote
git fetch origin
git checkout ten-branch-cua-author

# Cách 2: Tạo local tracking branch
git fetch origin ten-branch-cua-author
git checkout -b review/ten-branch origin/ten-branch-cua-author

# Sau khi checkout → cài deps → chạy
npm install
npm test
npm run dev
```

### Xem Diff Nhanh Tại Local

```bash
# So sánh branch của author với base branch
git fetch origin
git diff origin/develop...origin/ten-branch-cua-author

# Chú ý dấu "..." — cho thấy phần changed của feature branch
# so với common ancestor (không phải HEAD của develop)
```

### Worktree — Giữ Workspace Hiện Tại Sạch

```bash
# Tạo thư mục riêng để review — KHÔNG làm bẩn workspace hiện tại
git fetch origin
git worktree add ../review-pr-123 origin/ten-branch-cua-author

# Vào thư mục review
cd ../review-pr-123
npm install
npm run dev

# Sau khi review xong, xóa worktree
git worktree remove ../review-pr-123
```

```
Worktree diagram:

  ~/project/           ← workspace của bạn (clean)
  ~/review-pr-123/     ← workspace riêng để review PR
                          (checkout branch của author)

  Hai thư mục hoàn toàn độc lập.
  Không làm ảnh hưởng nhau!
```

---

## ⚖️ 5. So Sánh Hai Cách

| Tiêu chí           | Review trên PR           | Checkout Local       |
| ------------------ | ------------------------ | -------------------- |
| **Setup**          | Không cần                | Cần fetch + checkout |
| **Tốc độ**         | Nhanh                    | Chậm hơn             |
| **Comment**        | ✅ Line-by-line, lưu lại | ❌ Phải quay lại PR  |
| **Chạy app**       | ❌ Không thể             | ✅ Được              |
| **Debug**          | ❌ Không thể             | ✅ Được              |
| **Test manual UI** | ❌ Không thể             | ✅ Được              |
| **Phù hợp**        | Logic, style, scope      | Bug, UI, performance |

### Decision Flow

```
Bắt đầu review PR
       │
       ▼
Đọc title + description
       │
       ▼
Xem Files Changed
       │
       ├── Scope quá lớn / phức tạp? ──→ Yêu cầu tách PR
       │
       ▼
Review diff trên PR
       │
       ├── Logic rõ ràng, không cần chạy? ──→ Comment + Submit
       │
       ├── Cần verify behavior? ──────────→ Checkout local → Chạy app → Comment
       │
       └── CI fail? ──────────────────────→ Request changes ngay
```

---

## 🔄 6. Flow Reviewer Chuẩn (End-to-End)

```
┌──────────────────────────────────────────────────────────┐
│              FULL REVIEWER WORKFLOW                      │
│                                                          │
│  1. PR opened notification                               │
│     │                                                    │
│     ▼                                                    │
│  2. Đọc PR description                                  │
│     - Title rõ không?                                   │
│     - Description giải thích "why" không?               │
│     - Có link ticket/issue không?                       │
│     │                                                    │
│     ▼                                                    │
│  3. Check CI status                                     │
│     - Tests pass? Build OK?                             │
│     - Nếu fail → request fix trước khi review deep     │
│     │                                                    │
│     ▼                                                    │
│  4. Xem scope (Files Changed)                           │
│     - Bao nhiêu file?                                   │
│     - Có đúng 1 concern không?                         │
│     - Có file không liên quan không?                    │
│     │                                                    │
│     ▼                                                    │
│  5. Review diff từng file                               │
│     - Logic đúng không?                                 │
│     - Convention tuân thủ không?                        │
│     - Edge case được handle không?                      │
│     - Test đã cover chưa?                               │
│     │                                                    │
│     ▼                                                    │
│  6. Checkout local (nếu cần)                            │
│     - Chạy app → verify behavior                        │
│     - Run test → xem pass không                         │
│     - Check UI → đúng design không                      │
│     │                                                    │
│     ▼                                                    │
│  7. Submit review                                       │
│     ├─ ✅ Approve                                       │
│     ├─ 🔄 Request Changes                               │
│     └─ 💬 Comment (không block)                         │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

---

## 🔧 7. Ba Tình Huống Reviewer Được Phép Sửa Code

```
┌─────────────────────────────────────────────────────────┐
│         KHI NÀO REVIEWER ĐƯỢC PHÉP SỬA CODE?           │
│                                                         │
│  TÌNH HUỐNG 1: Chỉ được comment (phổ biến nhất)        │
│  ─────────────────────────────────────────────          │
│  - Reviewer CHỈ comment + approve/request changes       │
│  - Không push bất cứ thứ gì vào branch của author      │
│  - Author tự fix theo feedback                          │
│  → Đây là flow chuẩn ở hầu hết team                   │
│                                                         │
│  TÌNH HUỐNG 2: Reviewer push fix nhỏ (team cho phép)   │
│  ─────────────────────────────────────────────          │
│  Điều kiện bắt buộc:                                    │
│  ├─ Team có rule rõ ràng cho phép                       │
│  ├─ Author đồng ý (tránh surprise)                     │
│  └─ Fix thật sự nhỏ, không đổi logic                   │
│                                                         │
│  Chỉ dùng cho:                                          │
│  ├─ Typo trong comment/string                           │
│  ├─ Lint / formatting (nếu không có auto-fix)          │
│  ├─ Import order / missing import                       │
│  └─ Conflict resolution nhỏ                            │
│                                                         │
│  TÌNH HUỐNG 3: Fix lớn / đổi logic                     │
│  ─────────────────────────────────────────────          │
│  ❌ Reviewer KHÔNG tự sửa                              │
│  ✅ Reviewer phải:                                      │
│  ├─ Comment rõ vấn đề + tại sao nó là vấn đề          │
│  ├─ Đề xuất hướng sửa (code suggestion trong PR)       │
│  └─ Để author tự sửa + chịu trách nhiệm logic         │
│                                                         │
│  Lý do: Author phải chịu trách nhiệm chính với logic   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 🚦 8. Những Điều Reviewer Không Nên Làm

```
╔══════════════════════════════════════════════════════════╗
║          REVIEWER KHÔNG NÊN LÀM                         ║
╚══════════════════════════════════════════════════════════╝

❌ KHÔNG NÊN 1: Tự undo/reset commit của author
   ──────────────────────────────────────────────
   Sai:  checkout branch → git reset HEAD~1 → so sánh thủ công
   Đúng: Dùng PR diff — GitHub/GitLab đã làm sẵn
   Vì sao: Dễ rối history, review sai context, tốn công vô ích

❌ KHÔNG NÊN 2: Merge khi CI chưa pass
   ──────────────────────────────────────
   Sai:  "Nhìn code OK, merge luôn, test sau"
   Đúng: CI phải pass mới review, review xong mới merge
   Vì sao: CI là quality gate tự động, không được bypass

❌ KHÔNG NÊN 3: Review mà không đọc description
   ──────────────────────────────────────────────
   Sai:  Nhảy thẳng vào Files Changed
   Đúng: Đọc title + description + linked ticket trước
   Vì sao: Không hiểu "why" → review không đúng context

❌ KHÔNG NÊN 4: Comment mơ hồ, không actionable
   ──────────────────────────────────────────────
   Sai:  "Code này không đẹp", "Có vẻ sai"
   Đúng: "Line 42: `switchMap` ở đây sẽ cancel request trước,
          nếu muốn chạy song song dùng `mergeMap` thay thế"
   Vì sao: Mơ hồ → author không biết fix cái gì

❌ KHÔNG NÊN 5: Push code vào branch của author không hỏi
   ────────────────────────────────────────────────────────
   Sai:  Tự fix rồi push vào branch của bạn đó
   Đúng: Comment + suggestion → để author tự fix
   Vì sao: Vi phạm ownership, author bị surprise, dễ conflict
```

---

## 📝 9. Checklist Reviewer Frontend Angular/Vue

### Khi Đọc PR Description

```
- [ ] Title mô tả đủ thay đổi chưa?
- [ ] Description giải thích "why" (không chỉ "what") chưa?
- [ ] Có link ticket/issue không?
- [ ] Có screenshot/video nếu thay đổi UI không?
- [ ] PR nhỏ vừa phải (≤ 400 LOC) không?
```

### Khi Review Files Changed

```
- [ ] Scope đúng không? (không có file không liên quan)
- [ ] 1 PR = 1 concern không?
```

### Angular Specific

```
- [ ] Standalone component đúng pattern chưa?
- [ ] Signals dùng đúng chỗ chưa? (không lạm dụng)
- [ ] inject() thay vì constructor injection chưa?
- [ ] OnPush compatible không? (nếu dùng OnPush)
- [ ] takeUntilDestroyed() / unsubscribe đúng chưa?
- [ ] Không có nested subscribe chưa?
- [ ] switchMap/mergeMap/concatMap dùng đúng operator không?
- [ ] Memory leak potential? (setInterval, event listener)
- [ ] Template: trackBy trong *ngFor chưa?
- [ ] Lazy loading đúng chưa?
```

### Vue Specific

```
- [ ] ref() vs reactive() đúng use case chưa?
- [ ] Không destructure reactive object chưa?
- [ ] Composable có cleanup onUnmounted chưa?
- [ ] defineProps<T> / defineEmits<T> typed đúng chưa?
- [ ] v-for có :key đúng chưa?
- [ ] v-html có được sanitize không?
- [ ] Watcher không bị leak không?
```

### TypeScript (Chung)

```
- [ ] Không có `any` không?
- [ ] Interface / Type đúng pattern chưa?
- [ ] Null safety đúng chưa? (optional chaining)
- [ ] Generic đúng không? (không over-generic)
```

### Error Handling

```
- [ ] API call có error handling không?
- [ ] Loading state được handle không?
- [ ] Empty state được handle không?
- [ ] Edge case: null/undefined/empty array?
```

### Tests

```
- [ ] Unit test đã cover logic mới chưa?
- [ ] Test case có cover edge cases không?
- [ ] Test name mô tả đủ "given/when/then" chưa?
- [ ] Có regression test cần không?
```

---

## 📊 10. Tổng Kết — Cheat Sheet

| Tình huống              | Reviewer làm gì?                    |
| ----------------------- | ----------------------------------- |
| Review logic/style      | Comment trên PR diff                |
| Cần verify UI/behavior  | Checkout branch → chạy local        |
| CI fail                 | Request changes ngay, chưa review   |
| Fix nhỏ (typo/lint)     | Push nếu team cho phép + hỏi author |
| Fix lớn / đổi logic     | Comment + suggestion → author fix   |
| Muốn xem "trước vs sau" | Dùng PR diff, không undo commit     |
| Giữ workspace sạch      | Dùng `git worktree`                 |

### Mid vs Senior Perspective

```
MID-LEVEL:
"Review = checkout branch → đọc code → comment."
"Tự undo commit để xem code cũ."
"Comment chung chung: 'Cần refactor chỗ này'."
"Merge khi approve, không cần check CI."

SENIOR:
"Review diff trên PR trước — GitHub đã làm sẵn."
"Checkout local CHỈ khi cần chạy/test/debug."
"Comment phải actionable: line số + lý do + suggestion."
"CI phải pass → review → approve → merge. Thứ tự quan trọng."
"Reviewer review context. Author chịu trách nhiệm logic."
"1 PR = 1 concern. PR lớn = request tách trước."
```

---

## 🎯 Nguyên Tắc Vàng

```
╔══════════════════════════════════════════════════════════╗
║              NGUYÊN TẮC VÀNG CỦA REVIEWER               ║
║                                                          ║
║  1. Review trên DIFF, không phải toàn bộ code           ║
║  2. Checkout local CHỈ khi cần chạy / verify            ║
║  3. KHÔNG tự undo commit của author để review           ║
║  4. Comment phải ACTIONABLE (line + lý do + fix gợi ý)  ║
║  5. Chỉ sửa code khi có rule rõ ràng của team           ║
║  6. Fix lớn → comment + suggestion → để author fix      ║
║  7. CI phải PASS trước khi review deep                  ║
║  8. 1 PR = 1 concern — PR lớn → yêu cầu tách           ║
║                                                          ║
╚══════════════════════════════════════════════════════════╝
```

---

## 📚 Tài Liệu Tham Khảo

- **Guide:** [Google Engineering Practices — Code Review](https://google.github.io/eng-practices/review/)
- **Guide:** [How to Do Code Reviews Like a Human](https://mtlynch.io/human-code-reviews-1/)
- **Docs:** [GitHub Pull Request Reviews](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/about-pull-request-reviews)
- **Tool:** [git worktree](https://git-scm.com/docs/git-worktree)

---

_"The goal of code review is not to find bugs. It's to share knowledge, maintain quality, and catch what the author couldn't see."_
