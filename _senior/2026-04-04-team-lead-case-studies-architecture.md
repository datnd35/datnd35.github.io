---
layout: post
title: "Team Lead Case Studies (Part 3) - Nhóm Architecture"
date: 2026-04-04
categories: senior
---

## 🎯 Mục Tiêu Bài Viết

Bài viết này tổng hợp các case study thực chiến dành cho **Team Lead trong dự án Angular enterprise**, tập trung vào nhóm **Architecture** — những tình huống liên quan đến cấu trúc code, quyết định kiến trúc, và quản lý nợ kỹ thuật.

> Format: **Case → Dấu hiệu nhận biết → Cách xử lý → Sai lầm thường gặp → Bài học**

```
NHÓM ARCHITECTURE
──────────────────────────────────────
Case 1  → Shared component trở thành bottleneck
Case 2  → Legacy module không ai dám sửa
Case 3  → Migration kiến trúc gây tranh cãi
Case 4  → Over-abstraction làm code khó hiểu
Case 5  → State management thiếu nhất quán
Case 6  → Tech debt không được business ưu tiên
Case 7  → Hai dev tranh luận giải pháp quá lâu
Case 8  → Team muốn refactor lớn nhưng không có thời gian
```

---

## 🏗️ Case 1: Shared Component Trở Thành Bottleneck Của Cả Team

### Tình huống

Một shared table/form/modal component được quá nhiều module/team dùng chung. Mỗi lần thay đổi đều kéo theo conflict, regression, và tranh luận về ownership.

### Dấu hiệu nhận biết

- File shared component conflict liên tục trong mọi PR
- Mỗi lần change đều kéo theo regression ở nhiều màn hình khác
- Không ai dám sửa vì sợ ảnh hưởng chỗ khác
- Dev thêm `@Input()` mới cho mọi case → component phình to không kiểm soát

### Cách xử lý

Kiểm tra xem component có đang ôm quá nhiều trách nhiệm không:

```text
Shared component health check
   ├─ responsibility: component này làm bao nhiêu thứ khác nhau?
   ├─ variability: có bao nhiêu input/config khác nhau?
   ├─ coupling: thay đổi ở đây ảnh hưởng bao nhiêu nơi?
   └─ ownership: ai là người cuối cùng quyết định behavior?
```

Giải pháp theo mức độ:

- **Nhẹ**: tách core behavior và custom extension points (content projection, slots)
- **Trung bình**: tách thành base component và specialized versions
- **Nặng**: chấp nhận local duplication có kiểm soát cho các case đặc biệt, thay vì ép reuse không phù hợp

### Sai lầm thường gặp

- Cố reuse mọi thứ — "reuse" không phải lúc nào cũng tốt
- Nhồi thêm `@Input()` cho mọi case đặc biệt
- Không có ai làm ownership rõ ràng cho shared component

### Bài học

> Shared component không tốt nếu nó trở thành **điểm nghẽn của cả team**.

---

## 🏗️ Case 2: Legacy Module Không Ai Dám Sửa

### Tình huống

Một module Angular cũ, viết từ nhiều năm trước: nhiều side effects ẩn, ít test, logic rải rác, chỉ có 1–2 người hiểu, dev mới sợ đụng vào.

### Dấu hiệu nhận biết

- Dev né task ở module đó vì "sợ vỡ cái khác"
- Bug fix rất chậm vì phải trace logic khắp nơi
- Estimate task ở module này luôn cao bất thường
- Khi người hiểu module vắng, team bị block

### Cách xử lý

Không "refactor toàn bộ" — thay vào đó tiếp cận có chiến lược:

```text
Legacy recovery approach
   ├─ step 1: map module chính (data flow, entry points, outputs)
   ├─ step 2: xác định hot spots (thay đổi nhiều nhất)
   ├─ step 3: khoanh vùng risky areas (side effects ẩn)
   ├─ step 4: thêm guard rails (logging, smoke tests, unit tests nhỏ)
   └─ step 5: cải tiến từng bước gắn với business need
```

Nguyên tắc:

- Đọc flow business trước, đừng đọc code trực tiếp
- Thêm logging/monitoring ở vùng hay lỗi trước khi sửa
- Chỉ refactor khi có business reason (đang cần thêm feature ở đây, đang fix bug ở đây)
- Ghi lại knowledge vào docs ngay khi hiểu được

### Sai lầm thường gặp

- "Refactor toàn bộ" → thường thất bại hoặc kéo dài vô hạn
- Né không đụng vào mãi → module ngày càng khó hơn
- Không ghi lại knowledge → mãi mãi chỉ có 1–2 người hiểu

### Bài học

> Với legacy, mục tiêu đầu tiên không phải đẹp hơn, mà là **hiểu hơn và an toàn hơn**.

---

## 🏗️ Case 3: Migration Kiến Trúc Gây Tranh Cãi Trong Team

### Tình huống

Team muốn chuyển sang standalone components, signals, new control flow, hoặc architecture pattern mới. Một số người muốn migrate toàn bộ ngay, một số sợ regression.

### Dấu hiệu nhận biết

- Tranh luận dài trong meeting không đi đến kết luận
- Một số dev đã dùng pattern mới ở một số chỗ, chỗ khác vẫn dùng cũ
- Không có nguyên tắc coexistence rõ ràng
- PR review tranh luận về pattern thay vì logic

### Cách xử lý

Không để migration trở thành cuộc chiến quan điểm. Đưa về thực nghiệm có kiểm soát:

```text
Architecture migration framework
   ├─ define goal rõ (tại sao migrate? benefit cụ thể là gì?)
   ├─ pilot area (1–2 module nhỏ để thử trước)
   ├─ success criteria (đo được gì sau pilot?)
   ├─ coexistence rules (old và new sống cùng như thế nào?)
   └─ rollout plan (migrate dần theo business schedule)
```

Với Angular migration cụ thể:

- Standalone components: chỉ áp dụng cho module mới / khi refactor có business reason
- Signals: dùng ở new features, không migrate toàn bộ rxjs cùng lúc
- Có naming/folder convention để phân biệt old và new

### Sai lầm thường gặp

- Biến migration thành "dự án lớn riêng" → bị deprioritize mãi
- Hoặc ngược lại: migrate tràn lan không kiểm soát → inconsistency khắp nơi
- Không có tiêu chí thành công → migration "đang làm" mãi mãi

### Bài học

> Architecture change cần **thực nghiệm có kiểm soát**, không phải niềm tin hay phán quyết.

---

## 🏗️ Case 4: Reusable Abstraction Quá Mức Làm Code Khó Hiểu

### Tình huống

Team tạo generic component/service/directive quá mạnh để "enterprise-ready". Kết quả là code rất khó đọc, khó debug, và khó mở rộng đúng cách.

### Dấu hiệu nhận biết

- API của component/service có quá nhiều config options
- Dev mới mất nhiều giờ để hiểu cách dùng
- Fix 1 case cụ thể làm ảnh hưởng nhiều case khác
- "Linh hoạt" nhưng thực tế không ai dùng hết các tính năng

### Cách xử lý

Kiểm tra lại mức độ thay đổi thực sự giữa các use cases:

```text
Abstraction decision framework
   ├─ có ≥ 3 use cases thực sự khác nhau không?
   ├─ các use cases đó đã ổn định chưa?
   ├─ abstraction này làm code đơn giản hơn hay phức tạp hơn?
   └─ người không viết code này có đọc hiểu ngay không?
```

Nguyên tắc:

- **Rule of Three**: abstract sau khi có ≥ 3 case thực sự, không trước
- Ưu tiên clarity hơn DRY trong giai đoạn đầu
- Chấp nhận duplication nhỏ để giữ từng use case dễ đọc

### Sai lầm thường gặp

- Abstract quá sớm vì "tương lai có thể cần"
- Đồng nhất "reusable" với "chất lượng cao"
- Không đánh giá cognitive load cho người đọc code

### Bài học

> Abstraction tốt phải làm code **đơn giản hơn**, không phải "thông minh hơn" hay "enterprise hơn".

---

## 🏗️ Case 5: State Management Thiếu Nhất Quán Trong Codebase

### Tình huống

Trong cùng một codebase: chỗ dùng local state, chỗ dùng service, chỗ dùng NgRx store, chỗ dùng Signals, chỗ dùng RxJS BehaviorSubject trực tiếp. Dev mới không biết follow pattern nào.

### Dấu hiệu nhận biết

- Dev mới hỏi "tôi nên lưu state này ở đâu?"
- Bug sync state xuất hiện lặp lại
- Logic data flow nằm rải rác khắp codebase
- PR review tranh luận về cách lưu state mỗi lần

### Cách xử lý

Định nghĩa rõ guideline: khi nào dùng loại state nào:

```text
State management guideline
   ├─ local component state
   │     → UI-only state, không cần share
   │     → ví dụ: isOpen, isLoading cục bộ
   │
   ├─ service-level state (singleton service)
   │     → shared giữa vài component trong cùng feature
   │     → ví dụ: form draft, selection state
   │
   ├─ feature store (NgRx/Signal store per feature)
   │     → shared rộng hơn trong feature
   │     → cần side effects, async flows
   │
   └─ global state
         → cần share toàn app
         → ví dụ: user info, app config, permissions
```

Chuẩn hóa pattern cho async state:

```text
Async state pattern
   ├─ loading: boolean
   ├─ error: Error | null
   ├─ data: T | null
   └─ consistency: khi nào reset, khi nào cache
```

### Sai lầm thường gặp

- Chạy theo trend (dùng NgRx cho mọi thứ, hoặc Signals cho mọi thứ)
- Mỗi dev chọn pattern theo sở thích riêng
- Không review architectural consistency trong PR

### Bài học

> Team scale được khi state strategy có **ranh giới rõ ràng và được cả team đồng thuận**.

---

## 🏗️ Case 6: Tech Debt Ngày Càng Nặng Nhưng Business Không Ưu Tiên

### Tình huống

Code ngày càng khó làm việc: rework tăng, fix bug chậm, regression nhiều. Nhưng mỗi sprint business vẫn ưu tiên feature mới.

### Dấu hiệu nhận biết

- Mỗi task mới chậm hơn sprint trước
- Fix bug kéo dài vì code quá rối
- Regression xảy ra ngay cả với thay đổi nhỏ
- Team bắt đầu demotivated vì làm việc trong codebase khó

### Cách xử lý

Không pitch "cho em 2 tuần refactor" — thường sẽ fail. Thay vào đó:

```text
Tech debt proposal (business language)
   ├─ pain hiện tại (cost đang mất mỗi sprint)
   ├─ projected cost nếu không xử lý (tăng dần)
   ├─ specific risk (bug rate, regression rate)
   └─ incremental plan (không cần dừng feature)
```

Ví dụ cụ thể:

```text
Hiện tại: mỗi bug ở module X mất thêm 20% thời gian vì quá rối
Nếu không xử lý: Angular upgrade sẽ mất gấp đôi thời gian
Đề xuất: refactor dần trong 3 sprint, song song với feature
```

Chiến lược thực tế:

- Chèn tech debt fixes vào task liên quan ("refactor khi chạm vào")
- Không xin thêm sprint riêng — xin % capacity mỗi sprint
- Track debt bằng số: bug rate, rework %, time per task

### Sai lầm thường gặp

- Trình bày tech debt bằng ngôn ngữ kỹ thuật thuần túy
- Hoặc bỏ mặc hoàn toàn → team mất tinh thần
- Pitch "refactor toàn bộ" thay vì incremental plan

### Bài học

> Muốn được cấp thời gian xử lý tech debt, phải nói bằng **ngôn ngữ rủi ro và chi phí**, không chỉ bằng ngôn ngữ kỹ thuật.

---

## 🏗️ Case 7: Hai Dev Tranh Luận Giải Pháp Kỹ Thuật Quá Lâu

### Tình huống

Một người muốn refactor chuẩn, reusable, scalable. Người kia muốn fix nhanh, ít impact, kịp deadline. Cả hai đều có lý. Tranh luận kéo dài không có hồi kết.

### Dấu hiệu nhận biết

- Cùng một argument được lặp lại nhiều lần trong meeting
- Delivery bị đứng trong khi chờ quyết định
- Không ai chịu nhường vì cả hai đều nghĩ mình đúng
- Lead né không chốt vì sợ mất lòng ai

### Cách xử lý

Không để tranh luận ở mức "ý kiến cá nhân". Ép đưa về tiêu chí khách quan:

```text
Technical decision criteria
   ├─ delivery deadline (bao lâu nữa phải ship?)
   ├─ regression risk (giải pháp nào an toàn hơn?)
   ├─ maintainability (ai sẽ maintain 6 tháng sau?)
   ├─ reusability (có thực sự reuse không hay chỉ giả định?)
   ├─ future change likelihood (khả năng requirement đổi cao không?)
   └─ implementation cost (effort thực tế là bao nhiêu?)
```

Quyết định theo context:

```text
deadline gấp, low risk area → giải pháp local, an toàn, ít impact
nền tảng dùng lâu dài → đầu tư structure tốt hơn
không chắc requirement stable → defer abstraction, làm đơn giản trước
```

Ghi lại **decision log** ngắn gọn: quyết định gì, tiêu chí nào, trade-off nào.

### Sai lầm thường gặp

- Quyết định dựa trên ai nói to hơn hoặc senior hơn
- Tìm giải pháp "hoàn hảo" thay vì "đủ tốt cho context hiện tại"
- Không ghi lại rationale → tranh luận lại từ đầu lần sau

### Bài học

> Tech decision nên dựa trên **tiêu chí**, không dựa trên người nói to hơn.

---

## 🏗️ Case 8: Team Muốn Refactor Lớn Nhưng Business Không Cho Thời Gian

### Tình huống

Code đang xấu, team rất muốn sửa. Nhưng business ưu tiên feature liên tục. Refactor proposal bị từ chối nhiều lần.

### Dấu hiệu nhận biết

- Team demotivated vì làm việc trong code xấu
- Mỗi feature mới chậm hơn vì technical debt
- Proposals refactor bị "để đó sau" liên tục
- Senior dev bắt đầu nói về chuyện ra đi

### Cách xử lý

Đổi cách tiếp cận — từ "xin thời gian" sang "trình bày business impact":

```text
Refactor proposal (reframed)
   ├─ pain point cụ thể (không trừu tượng)
   ├─ cost đang mất mỗi sprint (số liệu)
   ├─ risk nếu không xử lý (scenario cụ thể)
   ├─ incremental plan (không cần dừng delivery)
   └─ milestone nhỏ để đo kết quả
```

Ví dụ thực tế cách pitch:

```text
Vấn đề: shared component X đang gây regression ở 3 flow chính mỗi sprint
Chi phí: tốn thêm ~2 ngày QA mỗi release
Risk: nếu Angular upgrade với component này → estimate x2–x3
Đề xuất: refactor component X trong sprint tới song song với feature Y (cùng area)
```

Ngoài ra:

- Refactor nhỏ gắn vào feature task có cùng area ("làm sạch khi chạm vào")
- Không xin sprint riêng — xin 20–30% capacity ongoing
- Show kết quả bằng metric: giảm bug rate, tăng velocity

### Sai lầm thường gặp

- Pitch "cho em 2 tuần refactor toàn bộ" → bị từ chối 100%
- Trình bày bằng ngôn ngữ kỹ thuật ("code xấu", "pattern sai")
- Không theo dõi và show kết quả sau khi được approve

### Bài học

> Muốn business cấp thời gian cho tech debt, phải nói bằng **ngôn ngữ rủi ro và chi phí**, không chỉ bằng ngôn ngữ kỹ thuật.

---

## 🧭 Tóm Tắt Nhóm Architecture

```text
ARCHITECTURE CHECKLIST FOR TEAM LEAD

Shared component bị bottleneck?
   → kiểm tra responsibility quá nhiều
   → tách core vs extension points
   → chấp nhận controlled duplication nếu cần

Legacy module không ai dám sửa?
   → map flow trước khi sửa code
   → thêm guard rails (logging, smoke test)
   → refactor gắn với business need

Migration gây tranh cãi?
   → pilot area + success criteria
   → coexistence rules rõ ràng
   → không migrate tràn lan

Over-abstraction?
   → Rule of Three: abstract sau khi có ≥ 3 cases thực
   → clarity > DRY ở giai đoạn đầu

State management inconsistent?
   → guideline rõ: local / feature / global
   → chuẩn hóa async state pattern

Tech debt không được ưu tiên?
   → trình bày bằng cost/risk cụ thể
   → incremental plan, không pitch "2 tuần refactor"

Decision kỹ thuật kéo dài?
   → timebox discussion
   → decision criteria rõ
   → decision owner + ghi lại rationale
```
