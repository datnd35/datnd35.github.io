---
layout: post
title: "Team Lead Case Studies (Part 1) - Nhóm Delivery"
date: 2026-04-04
categories: senior
---

## 🎯 Mục Tiêu Bài Viết

Bài viết này tổng hợp các case study thực chiến dành cho **Team Lead trong dự án Angular enterprise**, tập trung vào nhóm **Delivery** — những tình huống ảnh hưởng trực tiếp đến khả năng ship đúng hạn và đúng scope.

> Format: **Case → Dấu hiệu nhận biết → Cách xử lý → Sai lầm thường gặp → Bài học**

```
NHÓM DELIVERY
──────────────────────────────────────
Case 1  → Angular Upgrade bị trễ
Case 2  → Requirement mơ hồ, dev đã code
Case 3  → API chưa xong, FE bị thúc
Case 4  → Dev estimate quá lạc quan
Case 5  → WIP quá nhiều, velocity thấp
Case 6  → Release cận kề còn nhiều small fixes
Case 7  → Client ép commit date sớm
Case 8  → Deadline gấp nhưng scope quá lớn
```

---

## 📦 Case 1: Angular Upgrade Bị Trễ Và Ngày Càng Nhiều Regression

### Tình huống

Project nâng Angular từ version cũ lên version mới, kéo theo RxJS, Angular Material, build config, và test config thay đổi đồng loạt.

### Dấu hiệu nhận biết

- UI vỡ hàng loạt sau upgrade
- Fix chỗ này hỏng chỗ khác
- Task upgrade không estimate nổi
- Dev ngại đụng shared code

### Cách xử lý

Không upgrade toàn bộ cùng lúc. Chia upgrade thành nhiều lớp độc lập:

```text
Upgrade strategy
   ├─ Layer 1: framework version (Angular core, CLI)
   ├─ Layer 2: component library (Angular Material, CDK)
   ├─ Layer 3: styles / theming
   ├─ Layer 4: tests
   └─ Layer 5: third-party dependencies
```

Thực tế:

- Chọn 1–2 module/screen làm **pilot** trước
- Đo regression ở pilot rồi mới mở rộng
- Freeze feature mới ở vùng đang upgrade
- Chia task theo screen hoặc domain, không theo "loại thay đổi"
- Dùng regression checklist cho từng màn hình sau upgrade

### Sai lầm thường gặp

- **Big bang upgrade**: đổi tất cả trong 1 PR lớn
- Gộp upgrade cùng với feature delivery
- Không có owner rõ theo từng domain/screen
- Đánh giá thấp thời gian test và visual verification

### Bài học

> Upgrade thất bại thường do **cách chia việc sai**, không phải do công nghệ khó.

---

## 📦 Case 2: Requirement Mơ Hồ Nhưng Dev Đã Bắt Đầu Code

### Tình huống

PO/BA mô tả chưa rõ: acceptance criteria thiếu, edge cases không có, rule nghiệp vụ mâu thuẫn. Nhưng team đã vào code vì sợ trễ deadline.

### Dấu hiệu nhận biết

- Task đổi liên tục giữa chừng
- PR bị yêu cầu sửa logic nhiều lần
- Dev than "làm đi làm lại"
- Team estimate không sát thực tế

### Cách xử lý

Dừng assumption sớm. Trước khi dev vào code, ép team làm rõ requirement theo khung sau:

```text
Requirement clarity check
   ├─ confirmed: đã chốt rõ
   ├─ unclear: cần hỏi thêm
   ├─ missing decisions: cần BA/client quyết định
   └─ blocked dependencies: cần bên khác xác nhận
```

Các điểm bắt buộc phải rõ trước khi code:

- Sample input / output
- Error cases & empty states
- Permission cases
- Responsive behavior
- Rule nghiệp vụ đặc biệt

Nếu vẫn chưa rõ, cho team làm **spike / prototype** để validate, không commit full solution ngay.

### Sai lầm thường gặp

- "Cứ làm trước rồi tính" — thường là cách chậm nhất
- Team lead truyền áp lực deadline xuống dev mà không bảo vệ clarity
- Assumption không được ghi lại → mất tracking khi tranh luận sau

### Bài học

> Code nhanh trên requirement mơ hồ thường là cách **đốt capacity** nhanh nhất.

---

## 📦 Case 3: API Chưa Xong Nhưng Frontend Bị Thúc Tiến Độ

### Tình huống

Backend chậm tiến độ hoặc contract chưa ổn định. Frontend bị stakeholder hỏi tiến độ liên tục trong khi không thể làm gì nhiều.

### Dấu hiệu nhận biết

- FE liên tục phải hỏi BE về payload
- Mock data lệch với production response
- Integration test trễ hơn nhiều so với dự kiến
- Dev FE ngồi chờ hoặc làm việc dựa trên giả định sai

### Cách xử lý

Quản lý API dependency như một risk chính thức:

```text
Dependency board
   ├─ dependency là gì (API endpoint cụ thể)
   ├─ owner là ai (BE dev)
   ├─ deadline FE cần (để không block integration)
   ├─ fallback là gì (mock/stub)
   └─ current status (in progress / blocked / done)
```

Hành động song song:

- Chốt **contract sớm** bằng example payload (dù BE chưa implement xong)
- Tạo **mock adapter / stub service** ở FE để unblock
- Tách task UI và integration task riêng biệt
- FE làm UI logic hoàn chỉnh trên mock, switch sang real API khi sẵn sàng

### Sai lầm thường gặp

- Chờ API xong mới bắt đầu bất cứ điều gì
- Không version hóa contract → mock lệch khi BE thay đổi
- Không log rõ ai đang block ai → blame game sau

### Bài học

> Team lead phải quản lý **dependency flow**, không chỉ quản lý task nội bộ.

---

## 📦 Case 4: Dev Estimate Quá Lạc Quan

### Tình huống

Dev nói "task này chắc 1 ngày", nhưng thực tế kéo thành 3–5 ngày, chưa kể test và review.

### Dấu hiệu nhận biết

- Liên tục trễ so với estimate ban đầu
- Dev không kể integration, rework, QA fix vào estimate
- Không nhận diện unknowns trước khi đặt con số
- Estimate quá lạc quan với mọi task, kể cả task mới

### Cách xử lý

Không sửa estimate bằng cảm giác. Dạy team estimate theo cấu phần:

```text
Estimate breakdown
   ├─ implementation time
   ├─ integration effort
   ├─ testing (unit + manual)
   ├─ bug fixing buffer
   ├─ code review & rework
   └─ unknown risk buffer (10–20%)
```

Với task mới hoặc high risk, phân biệt ba mức:

```text
Best case  → khi mọi thứ suôn sẻ
Most likely → thực tế thường gặp
Worst case → khi có unknowns hoặc dependency fail
```

Với task hoàn toàn mới, bắt buộc có **discovery sprint** trước khi chốt estimate cuối.

### Sai lầm thường gặp

- Chỉ hỏi "bao lâu xong?" mà không hỏi "bạn đã nghĩ đến những gì?"
- Không huấn luyện tư duy estimation → lặp lại sai lầm mãi
- Accept estimate lạc quan rồi báo lên stakeholder → tạo commitment sai

### Bài học

> Estimate tốt không phải đoán đúng tuyệt đối, mà là **phản ánh được độ không chắc chắn** một cách trung thực.

---

## 📦 Case 5: Team Đang Overload Vì Nhận Quá Nhiều Việc Song Song

### Tình huống

Cùng lúc team phải: fix bug production, support QA, làm feature mới, họp với client, xử lý tech debt. Ai cũng bận nhưng velocity lại thấp.

### Dấu hiệu nhận biết

- Nhiều task ở trạng thái "in progress" nhưng không ai thực sự done
- Context switching liên tục làm giảm chất lượng
- Team mệt mỏi nhưng sprint review có ít item hoàn thành
- Urgent task chen ngang liên tục phá vỡ flow

### Cách xử lý

Giới hạn WIP (work in progress) theo capacity thực tế:

```text
Team capacity allocation
   ├─ delivery tasks (feature)
   ├─ support tasks (QA/bug)
   ├─ maintenance tasks (tech debt)
   └─ buffer for unexpected work (urgent/production)
```

Quy tắc cứng:

- Không mở thêm task mới khi task cũ chưa close
- Task nào bắt đầu thì cố finish trước khi nhận task khác
- Urgent thật sự mới được chen ngang — và phải có người nhường capacity rõ ràng
- Chặn stakeholder chen việc không qua kênh ưu tiên

### Sai lầm thường gặp

- Đồng ý nhận mọi việc, không nói "không"
- Nhầm giữa **busy** và **productive**
- Không phân biệt urgent thật và urgent cảm tính

### Bài học

> Lead giỏi tối ưu **flow**, không chỉ tối ưu effort. Ít việc nhưng dứt điểm luôn tốt hơn nhiều việc dang dở.

---

## 📦 Case 6: Release Cận Kề Nhưng Còn Rất Nhiều Small Fixes

### Tình huống

Sát ngày release, hàng loạt fix nhỏ vẫn tiếp tục merge vào branch. Mỗi fix đòi hỏi retest, làm release ngày càng khó kiểm soát.

### Dấu hiệu nhận biết

- Release branch không ổn định
- Mỗi fix kéo theo một vòng retest mới
- Chất lượng release khó đoán
- QA không có điểm dừng để verify

### Cách xử lý

Đặt code freeze hợp lý và có **go/no-go criteria** rõ ràng:

```text
Release decision framework
   ├─ code freeze date (không merge thêm sau thời điểm này)
   ├─ critical fix only window (chỉ P0/P1 được vào)
   ├─ must-fix list (chặn release nếu chưa xong)
   ├─ can-wait list (đưa vào sprint sau)
   └─ release owner (người chốt quyết định cuối)
```

Sau code freeze:

- Chỉ allow critical bug fix đã được triage bởi release owner
- Mọi "small fix" phải qua đánh giá: impact vs risk nếu defer
- QA có bản stable để test end-to-end mà không bị thay đổi giữa chừng

### Sai lầm thường gặp

- Cố nhét thêm "một fix nhỏ nữa" — luôn có thêm "một cái nữa"
- Không có tiêu chí go/no-go → quyết định release mang tính cảm tính
- Release owner không rõ ràng → ai cũng quyết định → không ai quyết định

### Bài học

> Release ổn định đòi hỏi **kỷ luật cắt scope**, không chỉ nỗ lực thêm.

---

## 📦 Case 7: Client Ép Commit Date Khi Team Còn Nhiều Unknowns

### Tình huống

Stakeholder muốn một ngày cam kết cụ thể dù requirement chưa rõ, discovery chưa xong, nhiều assumption chưa được validate.

### Dấu hiệu nhận biết

- Lead bị ép "just give me a date"
- Dev không tự tin khi estimate
- Nhiều task còn dựa trên assumption chưa confirmed
- Sau khi chốt date, team liên tục bị overload để "kịp hứa"

### Cách xử lý

Không chốt một ngày tuyệt đối khi chưa đủ clarity. Thay vào đó:

```text
Commitment approach
   ├─ discovery phase first (1–2 days spike)
   ├─ estimate range thay vì 1 con số (best / most likely / worst)
   ├─ milestone-based commitment (sau mỗi phase xác nhận lại)
   ├─ risk drivers được trình bày rõ
   └─ "date sẽ chốt sau discovery X ngày"
```

Nói với stakeholder theo kiểu:

```text
Với thông tin hiện tại, chúng tôi estimate X–Y ngày.
Risk chính là [A, B, C].
Nếu discovery tuần này confirm [điều kiện], chúng tôi có thể chốt date cụ thể.
```

### Sai lầm thường gặp

- Chốt date để "cho yên chuyện" → tạo commitment sai → mất trust về sau
- Để team gánh hệ quả của lời hứa không thực tế
- Không trình bày risk → stakeholder không hiểu sao bị trễ

### Bài học

> Lead cần quản lý **niềm tin của stakeholder bằng minh bạch**, không bằng lạc quan.

---

## 📦 Case 8: Deadline Gấp Nhưng Scope Quá Lớn

### Tình huống

Client muốn xong trong 2 tuần, nhưng team nhìn vào biết rõ: scope lớn, dependency nhiều, test chưa đủ, risk cao.

### Dấu hiệu nhận biết

- Team estimate nội bộ gấp 2–3 lần deadline client đưa ra
- Requirement vẫn còn nhiều phần chưa chốt
- Dependency cross-team chưa được xác nhận
- Không ai dám nói thẳng với client

### Cách xử lý

Không trả lời kiểu "team sẽ cố". Tách scope và biến thành **trade-off minh bạch**:

```text
Scope triage
   ├─ Must have  (release blocker)
   ├─ Should have (important nhưng có thể defer)
   └─ Nice to have (low priority)
```

Đưa ra options rõ ràng cho stakeholder:

```text
Option A: giữ full scope → tăng thời gian / giảm chất lượng / tăng risk
Option B: giữ deadline  → cắt scope xuống Must have
Option C: chia 2 phase  → release phần critical trước, phase 2 sau
```

Không để team âm thầm gánh quyết định không được phép biết.

### Sai lầm thường gặp

- "Cứ nhận rồi tính" → burnout, quality thấp, mất trust dài hạn
- Không có scope triage → ai cũng nghĩ việc của mình là "must have"
- Không record lại quyết định trade-off → xảy ra tranh luận sau

### Bài học

> Team Lead không chỉ nhận deadline, mà phải **quản lý kỳ vọng** và biến uncertainty thành quyết định có chủ đích.

---

## 🧭 Tóm Tắt Nhóm Delivery

```text
DELIVERY CHECKLIST FOR TEAM LEAD

Scope quá lớn?
   → scope triage (must / should / nice to have)
   → present trade-offs rõ ràng

Requirement mơ hồ?
   → discovery sprint trước khi code
   → document confirmed / unclear / blocked

Dependency block?
   → mock/stub contract để unblock
   → theo dõi dependency như risk

Estimate sai liên tục?
   → dạy estimate theo cấu phần
   → dùng best/likely/worst case

WIP quá nhiều?
   → giới hạn task đang mở
   → ưu tiên finish trước khi start

Release mất kiểm soát?
   → code freeze + go/no-go criteria
   → release owner rõ ràng

Commitment date bị ép?
   → trình bày risk drivers
   → commit theo milestone, không phải ngày tuyệt đối
```
