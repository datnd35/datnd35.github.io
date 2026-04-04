---
layout: post
title: "Team Lead Case Studies (Part 2) - Nhóm Quality"
date: 2026-04-04
categories: senior
---

## 🎯 Mục Tiêu Bài Viết

Bài viết này tổng hợp các case study thực chiến dành cho **Team Lead trong dự án Angular enterprise**, tập trung vào nhóm **Quality** — những tình huống ảnh hưởng đến chất lượng code, quy trình review, và độ tin cậy của hệ thống.

> Format: **Case → Dấu hiệu nhận biết → Cách xử lý → Sai lầm thường gặp → Bài học**

```
NHÓM QUALITY
──────────────────────────────────────
Case 1  → CI fail khác local
Case 2  → PR quá to, reviewer không review nổi
Case 3  → Code review mang tính hình thức
Case 4  → Bug UI nhỏ lặp lại nhiều lần
Case 5  → Observable leak / RxJS subscription bug
Case 6  → CSS conflict sau khi thêm lib hoặc theme
Case 7  → E2E test flaky làm team mất niềm tin
Case 8  → Không học được gì sau incident hoặc release thất bại
```

---

## 🔍 Case 1: Build Local Chạy Được Nhưng CI Fail

### Tình huống

Dev push code, local pass tất cả, nhưng pipeline CI lại fail. Team mất thời gian debug môi trường thay vì làm việc thực.

### Dấu hiệu nhận biết

- Fail do case-sensitive import (Linux CI vs macOS local)
- Node version khác nhau giữa máy dev và CI
- Lock file không đồng bộ (`package-lock.json` bị ignore hoặc không commit)
- Test chỉ fail trên CI do timing issue hoặc env khác nhau

### Cách xử lý

Chuẩn hóa môi trường để CI và local đồng nhất:

```text
Environment standardization
   ├─ pin Node version (via .nvmrc hoặc engines field)
   ├─ commit lock file (không add vào .gitignore)
   ├─ enforce case-sensitive imports (lint rule)
   └─ CI scripts khớp với scripts local
```

Quy tắc bắt buộc:

- Không merge khi status checks fail, dù "chắc chắn là pass ở local"
- CI là **single source of truth** — không phải "nó pass máy tôi là được"
- Với flaky CI test, tách riêng và xử lý root cause thay vì retry mãi

### Sai lầm thường gặp

- Tin vào local environment quá mức
- Không tái lập môi trường chuẩn cho dev mới
- Skip CI failure vì "chắc do infra"

### Bài học

> CI mới là **nguồn sự thật duy nhất** cho chất lượng build. Local chỉ là bước đầu.

---

## 🔍 Case 2: PR Quá To, Reviewer Không Review Nổi

### Tình huống

Một PR chứa nhiều thứ cùng lúc: feature mới + refactor + rename + bug fix + format changes. Reviewer không biết focus vào đâu.

### Dấu hiệu nhận biết

- PR có 1,000–5,000+ dòng thay đổi
- Reviewer để comment rất ít hoặc chỉ LGTM
- Review kéo dài nhiều ngày
- Bug xuất hiện sau merge mà reviewer "không thấy"

### Cách xử lý

Ép PR nhỏ và có cấu trúc rõ:

```text
PR structure best practices
   ├─ 1 PR = 1 mục đích rõ ràng
   ├─ tách refactor riêng với feature
   ├─ tách rename/format riêng với logic change
   └─ max 300–500 dòng changed per review round
```

Với epic lớn:

- Dùng feature branch → chia nhiều PR nhỏ → merge vào feature branch trước
- Mỗi PR có description rõ: làm gì, tại sao, test gì, risk gì
- PR urgent có SLA review (ví dụ: 4 giờ phải có 1 reviewer phản hồi)

### Sai lầm thường gặp

- Chấp nhận PR 2,000–5,000 dòng vì "không còn thời gian tách"
- Team lead không can thiệp vào cấu trúc delivery
- Dev nghĩ PR to = năng suất cao

### Bài học

> PR to không phải dấu hiệu năng suất — thường là dấu hiệu **rủi ro ẩn**.

---

## 🔍 Case 3: Code Review Mang Tính Hình Thức

### Tình huống

Có hai thái cực cùng gây hại:

- **Trường hợp 1**: Review sơ sài — "LGTM", không check logic, bug lọt production.
- **Trường hợp 2**: Review quá lâu — PR chờ 2–3 ngày, dev bị block, context nguội.

### Dấu hiệu nhận biết

- Bug lọt dù đã có review
- Comment review ít và rất chung chung
- Quality phụ thuộc vào 1–2 người "kỹ tính"
- PR chờ reviewer quá lâu gây frustration

### Cách xử lý

Chuẩn hóa review thành checklist có focus rõ:

```text
Review checklist
   ├─ correctness (logic có đúng không?)
   ├─ edge cases (có handle đủ không?)
   ├─ regression risk (có ảnh hưởng flow khác không?)
   ├─ readability (người mới đọc có hiểu không?)
   ├─ architecture consistency (có đúng pattern codebase không?)
   └─ test coverage (unit/integration đủ không?)
```

Ngoài ra:

- Phân reviewer theo **ownership/domain** thay vì random
- Đặt SLA review rõ ràng (ví dụ: urgent PR review trong 4h, normal trong 1 ngày)
- Comment hướng vào **code và lý do**, không hướng vào con người

### Sai lầm thường gặp

- Xem review là thủ tục thay vì cơ hội kiểm soát chất lượng
- Chỉ review code style, bỏ qua logic và regression
- Review không có tiêu chí → phụ thuộc cảm tính từng người

### Bài học

> Review tốt là **một hệ thống**, không phải một thói quen cá nhân.

---

## 🔍 Case 4: Bug UI Nhỏ Lặp Lại Nhiều Lần Theo Cùng Pattern

### Tình huống

Nhiều bug UI nhỏ xuất hiện liên tục: spacing sai, text overflow, dialog layout lệch, button state không đồng nhất. Mỗi bug riêng lẻ thì nhỏ, nhưng tổng thể làm sản phẩm thiếu polish.

### Dấu hiệu nhận biết

- QA log bug tương tự ở nhiều màn hình khác nhau
- Team xem nhẹ vì "không phải blocker"
- Sau mỗi release vẫn có một list "cosmetic bugs"
- User cảm thấy app thiếu ổn định dù không có lỗi nghiêm trọng

### Cách xử lý

Gom bug theo pattern để tìm nguyên nhân hệ thống:

```text
Bug pattern analysis
   ├─ form controls (input height, spacing, label alignment)
   ├─ dialog / modal (padding, footer layout, scroll)
   ├─ table (column width, empty state, loading)
   ├─ typography (font size inconsistency, overflow)
   └─ responsive (breakpoint behavior)
```

Sau đó xử lý ở tầng hệ thống:

- Có **design token / theming layer** chuẩn, không để local override tràn lan
- Tạo visual checklist để dev self-review trước khi submit PR
- Đo **bug leakage rate** theo release để tracking cải thiện

### Sai lầm thường gặp

- Chỉ chú ý bug crash/data, bỏ qua bug UI
- Fix từng bug rời rạc thay vì tìm pattern
- Không có design system / visual guideline làm reference

### Bài học

> Trong enterprise UI, bug nhỏ lặp lại làm giảm mạnh **niềm tin vào sản phẩm** — dù không có crash nào.

---

## 🔍 Case 5: Observable Leak / RxJS Subscription Bug Xuất Hiện Lặp Lại

### Tình huống

App chậm dần sau một thời gian chạy, có behavior bất thường khi navigate nhiều lần, API được gọi duplicate, event xử lý nhiều lần.

### Dấu hiệu nhận biết

- Navigate qua lại nhiều lần rồi UI hoạt động lạ
- Duplicate API calls xuất hiện trong Network tab
- Event handler chạy nhiều lần hơn dự kiến
- Memory usage tăng dần theo thời gian sử dụng

### Cách xử lý

Chuẩn hóa pattern quản lý subscription:

```text
Subscription management pattern
   ├─ takeUntilDestroyed (Angular 16+)
   ├─ DestroyRef injection pattern
   ├─ async pipe (tự động unsubscribe)
   └─ explicit unsubscribe trong ngOnDestroy nếu cần
```

Hành động hệ thống:

- Review RxJS usage như một phần **bắt buộc** trong PR checklist
- Tạo examples tốt trong codebase để team follow
- Viết test cho các flow mount/unmount quan trọng
- Không để "leak nghi ngờ" sống quá 1 sprint

### Sai lầm thường gặp

- Xem memory leak là bug hiếm, không cần chú ý thường xuyên
- Không huấn luyện team về Angular lifecycle và RxJS lifecycle thực sự
- Fix triệu chứng (thêm takeUntil khắp nơi) thay vì hiểu pattern

### Bài học

> Trong Angular enterprise, lỗi RxJS nhỏ có thể thành **chi phí vận hành lớn** theo thời gian.

---

## 🔍 Case 6: CSS Conflict Sau Khi Thêm Thư Viện Hoặc Theme Mới

### Tình huống

Thêm một lib mới hoặc thay đổi global styles làm vỡ UI cũ: spacing bị lệch, component bị override, dark mode/theming hoạt động bất thường.

### Dấu hiệu nhận biết

- CSS override chồng chéo nhiều layer
- Sửa một class ở chỗ này hỏng chỗ khác
- `!important` xuất hiện ngày càng nhiều để patch
- Dark mode hoặc custom theme vỡ layout không theo quy luật

### Cách xử lý

Xây dựng chiến lược style architecture rõ ràng:

```text
CSS architecture strategy
   ├─ design tokens layer (color, spacing, typography)
   ├─ global resets / base styles
   ├─ shared component styles (scoped)
   ├─ feature-specific overrides
   └─ third-party lib customization (isolated scope)
```

Quy tắc cụ thể:

- Giảm selector quá rộng
- Cấm `!important` trừ override third-party cực chẳng đã
- Khi thêm lib mới, audit global styles impact trước
- Custom theming chỉ qua design token, không hardcode color/size

### Sai lầm thường gặp

- Sửa local override liên tục thay vì tìm root cause
- Không có style architecture strategy — mỗi dev tự sửa kiểu mình
- Thêm lib mới không audit CSS scope

### Bài học

> CSS conflict lặp lại là dấu hiệu style system đang **mất kiểm soát**, không phải do dev không cẩn thận.

---

## 🔍 Case 7: E2E Test Flaky Làm Team Mất Niềm Tin Vào Test

### Tình huống

Pipeline fail ngẫu nhiên vì E2E test. Rerun thì pass. Team bắt đầu ignore test đỏ và coi đó là noise.

### Dấu hiệu nhận biết

- "Chắc flaky thôi, retry lại là pass"
- Team bắt đầu merge dù test fail
- Khi test thật sự báo bug, không ai để ý
- CI feedback loop trở nên vô nghĩa

### Cách xử lý

Phân loại và xử lý flaky tests có hệ thống:

```text
Flaky test root causes
   ├─ timing issue (wait cứng, animation chưa xong)
   ├─ environment issue (test data không sạch, env unstable)
   ├─ selector fragile (id/class thay đổi theo render)
   ├─ test isolation kém (test phụ thuộc nhau)
   └─ network mock không đủ ổn định
```

Hành động:

- Không để flaky test sống quá 1 sprint
- Tách test critical path (luôn phải green) và test less critical
- Xử lý root cause thực sự, không chỉ thêm wait/retry
- Track flaky rate theo thời gian

### Sai lầm thường gặp

- Thêm `waitForTimeout` cứng khắp nơi — không phải giải pháp
- Tắt test thay vì sửa hệ thống
- Coi flaky là bình thường trong dự án lớn

### Bài học

> Test không đáng tin thì còn tệ hơn không có test — vì nó tạo ra **cảm giác an toàn giả**.

---

## 🔍 Case 8: Sau Incident, Team Chỉ Fix Xong Rồi Quên

### Tình huống

Bug production xảy ra, team fix xong, deploy xong, rồi chuyển sang việc khác. Không ai nhìn lại: tại sao xảy ra, vì sao lọt QA, lần sau tránh thế nào.

### Dấu hiệu nhận biết

- Cùng loại lỗi lặp lại ở release sau
- "Lần sau cẩn thận hơn" là kết luận duy nhất
- Không có action items rõ sau incident
- Team không biết phòng ngừa gì

### Cách xử lý

Bắt buộc có **mini postmortem** sau mỗi incident đáng kể:

```text
Postmortem template
   ├─ What happened? (mô tả sự cố)
   ├─ Why did it happen? (root cause thực sự)
   ├─ Why wasn't it caught earlier? (QA, review, monitoring đã bỏ sót gì?)
   ├─ What action prevents recurrence? (thay đổi hệ thống gì?)
   └─ Owner + deadline cho từng action item
```

Quy tắc postmortem:

- **Blameless** — focus vào hệ thống, không phải cá nhân
- Mỗi action item phải có owner và deadline, không chỉ "sẽ cẩn thận hơn"
- Follow-up action items ở sprint tiếp theo
- Chia sẻ kết quả postmortem với cả team để mọi người học cùng

### Sai lầm thường gặp

- Đổ lỗi cá nhân thay vì tìm điểm yếu hệ thống
- "Lần sau cẩn thận hơn" không phải action item
- Không follow-up action items → postmortem chỉ là hình thức

### Bài học

> Fix bug giúp qua được hôm nay. Postmortem giúp **hệ thống tốt hơn cho ngày mai**.

---

## 🧭 Tóm Tắt Nhóm Quality

```text
QUALITY CHECKLIST FOR TEAM LEAD

CI fail?
   → chuẩn hóa môi trường (node version, lock file)
   → CI là source of truth, không phải local

PR quá to?
   → ép PR nhỏ, 1 PR = 1 mục đích
   → tách refactor / rename / logic change riêng

Review hình thức?
   → chuẩn hóa checklist
   → phân reviewer theo ownership
   → SLA review rõ ràng

Bug lặp theo pattern?
   → tìm hệ thống cause, không fix từng bug
   → design token, shared component, visual checklist

RxJS leak?
   → chuẩn hóa unsubscribe pattern
   → review subscription usage trong PR checklist

CSS conflict?
   → audit global styles
   → design token layer, cấm !important tràn lan

E2E flaky?
   → phân loại root cause
   → không để flaky test sống quá 1 sprint

Không học sau incident?
   → bắt buộc mini postmortem
   → action item có owner + deadline + follow-up
```
