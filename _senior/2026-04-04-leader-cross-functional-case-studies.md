---
layout: post
title: "Leader với BA, QA, PM - 20 Case Study Thực Chiến Trong Dự Án Enterprise"
date: 2026-04-07
categories: senior
---

## 🎯 Mục Tiêu Bài Viết

Khi làm **Leader trong dự án enterprise**, bạn không chỉ quản team dev — mà còn phải điều phối **cross-functional**: BA, Tester, PM, và cả phía Business/Client.

Bài viết này tổng hợp **20 case study thực chiến**, theo format:

> **Tình huống → Rủi ro → Cách leader xử lý → Cách nói phù hợp → Bài học**

---

## 📋 Mục Lục

| #   | Tình huống                                                                                                                                  |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | [BA viết requirement chưa rõ, dev làm xong mới phát hiện hiểu sai](#1-ba-viết-requirement-chưa-rõ-dev-làm-xong-mới-phát-hiện-hiểu-sai)      |
| 2   | [BA đổi requirement giữa sprint](#2-ba-đổi-requirement-giữa-sprint)                                                                         |
| 3   | [BA quá thiên về business, chưa hiểu hạn chế kỹ thuật](#3-ba-quá-thiên-về-business-chưa-hiểu-hạn-chế-kỹ-thuật)                              |
| 4   | [Tester log bug quá nhiều nhưng không ưu tiên rõ](#4-tester-log-bug-quá-nhiều-nhưng-không-ưu-tiên-rõ)                                       |
| 5   | [Tester báo bug nhưng reproduce step không rõ](#5-tester-báo-bug-nhưng-reproduce-step-không-rõ)                                             |
| 6   | [Tester và Dev tranh luận "đây là bug hay expected"](#6-tester-và-dev-tranh-luận-đây-là-bug-hay-expected)                                   |
| 7   | [PM ép deadline dù scope chưa chốt](#7-pm-ép-deadline-dù-scope-chưa-chốt)                                                                   |
| 8   | [PM liên tục chen task ad-hoc vào sprint](#8-pm-liên-tục-chen-task-ad-hoc-vào-sprint)                                                       |
| 9   | [PM chỉ nhìn deadline, chưa nhìn technical debt](#9-pm-chỉ-nhìn-deadline-chưa-nhìn-technical-debt)                                          |
| 10  | [BA, QA, Dev hiểu khác nhau về "done"](#10-ba-qa-dev-hiểu-khác-nhau-về-done)                                                                |
| 11  | [QA test muộn, gần release mới phát hiện lỗi lớn](#11-qa-test-muộn-gần-release-mới-phát-hiện-lỗi-lớn)                                       |
| 12  | [BA bị áp lực từ business, truyền đạt requirement thiếu ổn định](#12-ba-bị-áp-lực-từ-business-truyền-đạt-requirement-thiếu-ổn-định)         |
| 13  | [PM hứa với client trước khi align với team](#13-pm-hứa-với-client-trước-khi-align-với-team)                                                |
| 14  | [Tester quá cứng nhắc, chỉ test đúng script](#14-tester-quá-cứng-nhắc-chỉ-test-đúng-script)                                                 |
| 15  | [Quá nhiều họp, team mất thời gian sync](#15-quá-nhiều-họp-team-mất-thời-gian-sync)                                                         |
| 16  | [BA và QA đứng ở góc nhìn khác nhau, team bị kéo hai phía](#16-ba-và-qa-đứng-ở-góc-nhìn-khác-nhau-team-bị-kéo-hai-phía)                     |
| 17  | [PM đánh giá team qua "màu xanh" nhưng thực tế risk cao](#17-pm-đánh-giá-team-qua-màu-xanh-nhưng-thực-tế-risk-cao)                          |
| 18  | [UAT phát hiện nhiều issue "không giống mong đợi"](#18-uat-phát-hiện-nhiều-issue-không-giống-mong-đợi)                                      |
| 19  | [PM muốn release, QA muốn test thêm, Dev muốn đúng hạn](#19-pm-muốn-release-qa-muốn-test-thêm-dev-muốn-đúng-hạn)                            |
| 20  | [Các role làm việc kiểu silo, thiếu tinh thần cùng chịu trách nhiệm](#20-các-role-làm-việc-kiểu-silo-thiếu-tinh-thần-cùng-chịu-trách-nhiệm) |

---

## 1) BA viết requirement chưa rõ, dev làm xong mới phát hiện hiểu sai

### Tình huống

BA đưa requirement ở mức business nhưng thiếu flow chi tiết, validation rule, edge case hoặc acceptance criteria. Team dev implement xong thì BA nói _"ý business không phải vậy"_.

### Rủi ro

- Rework tốn effort
- Trễ deadline
- Dev khó chịu vì cảm giác _"làm đúng vẫn bị sửa"_
- Mất niềm tin giữa BA và Dev

### Cách leader xử lý

- Không để dev và BA đổ lỗi qua lại
- Tổ chức **clarification session ngắn** trước khi dev code
- Ép requirement phải rõ ở các phần:

```
📥 Input / Output
📐 Business rule
⚠️ Edge case
❌ Error handling
✅ Acceptance criteria
```

- Với task lớn, yêu cầu BA + Dev align bằng **ví dụ cụ thể hoặc mock data**
- Nếu BA chưa đủ chi tiết, leader phải hỗ trợ _"dịch business sang technical scope"_

### Câu leader nên nói

> _"Mình chốt lại acceptance criteria trước khi code để tránh rework cuối sprint."_

> _"Phần này em cần BA confirm giúp các case invalid và expected behavior."_

### 💡 Bài học

Leader không chờ requirement _"tự rõ"_, mà phải tạo cơ chế để **làm rõ sớm**.

---

## 2) BA đổi requirement giữa sprint

### Tình huống

Task đang làm dở thì BA/Business đổi logic, thêm field, sửa flow, hoặc thay đổi ưu tiên.

### Rủi ro

- Vỡ estimate
- Dev mất tập trung
- Sprint mất kiểm soát
- PM tưởng team _"làm chậm"_

### Cách leader xử lý

Phân loại thay đổi theo mức độ impact:

| Loại       | Định nghĩa                        | Cách xử lý                              |
| ---------- | --------------------------------- | --------------------------------------- |
| **Minor**  | Sửa nhỏ, không ảnh hưởng estimate | Nhận, log lại                           |
| **Medium** | Cần thêm effort, phải re-estimate | Negotiate scope / timeline              |
| **Major**  | Đổi flow lớn                      | Đưa sang sprint sau hoặc change request |

- Không nhận thay đổi **"âm thầm"** — ghi lại rõ:
  - Changed scope là gì
  - Impact tới timeline là gì
  - Phần nào phải bỏ / defer
- Nếu business muốn giữ deadline cũ → yêu cầu **giảm scope tương ứng**

### Câu leader nên nói

> _"Phần thay đổi này không chỉ là sửa label, nó làm đổi validation flow và API mapping."_

> _"Nếu giữ deadline hiện tại, mình cần cắt bớt phần X hoặc chuyển Y sang sprint sau."_

### 💡 Bài học

Leader phải quản **scope**, không chỉ quản người.

---

## 3) BA quá thiên về business, chưa hiểu hạn chế kỹ thuật

### Tình huống

BA yêu cầu flow _"đẹp trên giấy"_ nhưng thực tế kỹ thuật rất tốn effort hoặc rủi ro cao.

### Rủi ro

- Cam kết quá mức
- Solution thiếu thực tế
- Team dev bị ép _"impossible deadline"_

### Cách leader xử lý

- Không bác bỏ cảm tính kiểu _"không làm được"_
- Giải thích bằng **trade-off**:

```
Cách A: nhanh hơn nhưng ít flexible
Cách B: đúng business hơn nhưng effort lớn
```

- Dùng ví dụ cụ thể về impact:
  - Performance
  - Backend limitation
  - Migration cost
  - Testing complexity
- Đề xuất **phased approach**:
  - Phase 1: đáp ứng 80% business need
  - Phase 2: hoàn thiện phần còn lại

### Câu leader nên nói

> _"Business need này hợp lý, nhưng implementation hiện tại sẽ ảnh hưởng performance và timeline."_

> _"Em đề xuất mình đi theo 2 phase để vẫn có giá trị sớm mà giảm risk."_

### 💡 Bài học

Leader giỏi là người **dịch được constraint kỹ thuật thành ngôn ngữ business hiểu được**.

---

## 4) Tester log bug quá nhiều nhưng không ưu tiên rõ

### Tình huống

QA/Tester tạo rất nhiều bug — từ lỗi giao diện nhỏ đến lỗi logic nghiêm trọng — nhưng không phân loại severity/priority rõ ràng.

### Rủi ro

- Team dev rối, không biết fix gì trước
- Mất thời gian vào lỗi nhỏ
- Bug critical bị chậm xử lý
- Sprint dễ bị _"ngập bug"_

### Cách leader xử lý

Thiết lập rule phân loại bug rõ ràng:

| Severity     | Định nghĩa                 | Ưu tiên          |
| ------------ | -------------------------- | ---------------- |
| **Critical** | Chặn luồng chính, mất data | Fix ngay         |
| **High**     | Sai business logic         | Fix trong sprint |
| **Medium**   | Lỗi UI có workaround       | Plan fix         |
| **Low**      | Cosmetic, minor UX         | Backlog          |

- Leader cùng QA **review nhanh bug list** để ra thứ tự xử lý
- Không để dev tự đoán bug nào quan trọng

### Câu leader nên nói

> _"Mình cần tách bug blocker ra khỏi bug cosmetic để team xử lý đúng thứ tự."_

> _"Bug list hiện tại nhiều nhưng chưa đủ rõ về impact business."_

### 💡 Bài học

Không phải nhiều bug là xấu, cái quan trọng là **quản bug có hệ thống**.

---

## 5) Tester báo bug nhưng reproduce step không rõ

### Tình huống

Tester báo _"không work"_, _"sai UI"_, _"không đúng expected"_ nhưng thiếu:

- Environment
- Step reproduce
- Actual result
- Expected result
- Evidence (screenshot/video/log)

### Rủi ro

- Dev tốn thời gian hỏi lại
- Delay fix
- Dễ tranh cãi _"không thấy bug"_

### Cách leader xử lý

Thống nhất **template bug report**:

```
🌐 Environment: staging / prod / local
📊 Data test: user, role, data điều kiện
👣 Steps to reproduce: từng bước rõ
❌ Actual result: thực tế đang xảy ra
✅ Expected result: kỳ vọng đúng là gì
📎 Evidence: screenshot / video / log
```

- Với bug khó tái hiện, cho dev + QA **sync trực tiếp 10 phút**
- Không kéo dài ping-pong qua ticket

### Câu leader nên nói

> _"Để fix nhanh hơn, mình cần bug report có step rõ và expected behavior."_

> _"Bug này khó reproduce, mình sync nhanh giữa QA và Dev để chốt."_

### 💡 Bài học

Leader phải tối ưu **luồng hợp tác**, không để team mệt vì quy trình lỏng.

---

## 6) Tester và Dev tranh luận "đây là bug hay expected"

### Tình huống

Tester nói là bug, dev nói đúng theo code/requirement hiện tại.

### Rủi ro

- Căng thẳng giữa QA và Dev
- Mất thời gian tranh cãi
- PM bị kéo vào việc không cần thiết

### Cách leader xử lý

- Không cho tranh luận cảm tính
- Quay về **3 nguồn sự thật**:

```
📄 Requirement gốc
✅ Acceptance criteria
📹 Behavior đã được approve trước đó
```

- Nếu requirement mơ hồ → **BA là người chốt** business expectation
- Nếu chưa có source rõ → leader **chốt temporary decision** để không block team

### Câu leader nên nói

> _"Mình không tranh luận theo cảm nhận, mình quay về requirement đã chốt."_

> _"Nếu tài liệu chưa rõ, BA giúp confirm expected behavior để team thống nhất."_

### 💡 Bài học

Leader phải kéo mọi người từ **ý kiến cá nhân** về **nguồn sự thật chung**.

---

## 7) PM ép deadline dù scope chưa chốt

### Tình huống

PM muốn commit timeline sớm với client/business, nhưng requirement vẫn chưa rõ hoặc solution chưa đủ phân tích.

### Rủi ro

- Estimate ảo, không thực tế
- Dev bị ép overtime
- Leader bị hỏi trách nhiệm khi trễ

### Cách leader xử lý

- Không nói _"khó lắm"_ chung chung
- Chia estimate theo **mức độ chắc chắn**:

```
✅ Known scope   → estimate được
⚠️ Assumptions  → có thể sai nếu assumption sai
❓ Unknown/Risk  → chưa estimate được
```

- Nói rõ **dependency**:
  - Chờ BA chốt requirement
  - Chờ API spec từ BE
  - Chờ design finalize
- Nếu PM vẫn muốn cam kết → gắn kèm **condition rõ ràng**

### Câu leader nên nói

> _"Timeline này chỉ valid nếu requirement và API được chốt trước ngày X."_

> _"Hiện tại team mới estimate được phần known scope, phần Y còn risk khá cao."_

### 💡 Bài học

Leader cần bảo vệ team bằng **estimate có điều kiện**, không phải estimate mù.

---

## 8) PM liên tục chen task ad-hoc vào sprint

### Tình huống

PM hoặc business cứ bổ sung việc gấp giữa sprint: bug nhỏ, change request, hỗ trợ demo, hotfix...

### Rủi ro

- Sprint plan bị phá
- Team không finish committed work
- Member mất focus liên tục

### Cách leader xử lý

Thiết lập nguyên tắc xử lý ad-hoc:

```
📋 Ad-hoc phải được log rõ
✅ Có người approve reprioritization
🔄 Có task bị đẩy ra nếu thêm task mới vào
```

- Tạo **visible board** cho ad-hoc items
- Nếu việc gấp là thật, leader **chủ động trade-off** thay vì để team ôm hết

### Câu leader nên nói

> _"Team có thể nhận việc mới, nhưng mình cần clear việc nào sẽ bị dời."_

> _"Nếu tất cả đều urgent thì thực tế không còn gì truly urgent nữa."_

### 💡 Bài học

Leader phải bảo vệ **focus của team**.

---

## 9) PM chỉ nhìn deadline, chưa nhìn technical debt

### Tình huống

PM muốn feature ra nhanh, không muốn dành thời gian cho refactor, cleanup, fix gốc lỗi.

### Rủi ro

- Hệ thống ngày càng khó maintain
- Bug lặp lại cùng vùng code
- Velocity giảm mạnh về sau

### Cách leader xử lý

- Không nói technical debt theo kiểu quá kỹ thuật
- Gắn debt với **hậu quả business**:

```
🐛 Bug rate tăng
📉 Estimate khó chính xác hơn
🐢 Feature sau chậm hơn vì phải tránh "mìn"
```

- Đề xuất **budget nhỏ nhưng đều**: mỗi sprint 10–20% cho technical improvement
- Chứng minh bằng data nếu có:
  - Số bug lặp lại
  - Số giờ rework
  - Area thay đổi khó khăn

### Câu leader nên nói

> _"Nếu chỉ vá nhanh liên tục, chi phí delivery của các sprint sau sẽ tăng."_

> _"Em đề xuất xử lý gốc phần này để giảm rework thay vì fix triệu chứng."_

### 💡 Bài học

Leader phải giúp PM thấy rằng **tech debt là chi phí kinh doanh**, không chỉ là chuyện của dev.

---

## 10) BA, QA, Dev hiểu khác nhau về "done"

### Tình huống

Dev nghĩ code chạy là xong. QA nghĩ pass full regression mới xong. BA nghĩ business approve mới xong. PM nghĩ deploy production mới là xong.

### Rủi ro

- Daily/reporting sai lệch
- Team tưởng on track nhưng thực ra chưa
- Tranh cãi cuối sprint

### Cách leader xử lý

Chốt rõ **Definition of Done** cho cả team:

```
☑️ Code complete
☑️ Self-test done
☑️ Code review done
☑️ QA passed
☑️ BA confirmed
☑️ Document updated
☑️ Deployed to UAT / Prod (nếu cần)
```

Dùng trạng thái riêng để tránh nhầm lẫn:

```
In Progress → Dev Done → In QA → In UAT → Done
```

### Câu leader nên nói

> _"Mình cần thống nhất Done là gì, tránh mỗi role hiểu một kiểu."_

> _"Từ nay Dev Done không có nghĩa là ticket Done."_

### 💡 Bài học

Rất nhiều xung đột trong enterprise đến từ việc **từ ngữ giống nhau nhưng nghĩa khác nhau**.

---

## 11) QA test muộn, gần release mới phát hiện lỗi lớn

### Tình huống

Tester chỉ test mạnh ở cuối sprint hoặc sát release nên bug dồn cục, team chữa cháy.

### Rủi ro

- Gấp gáp, chất lượng giảm
- Team phải overtime
- Tăng khả năng miss regression

### Cách leader xử lý

**Shift-left testing** — đưa QA vào sớm hơn:

```
📋 Review requirement từ đầu sprint
📝 Chuẩn bị test case sớm, song song với dev
🧪 Test incremental từng phần khi dev done
🎯 Demo sớm từng phần cho QA / BA
```

- Không để tới cuối mới _"ném nguyên cục"_ sang QA

### Câu leader nên nói

> _"Mình cần shift-left testing để bug lộ sớm hơn."_

> _"Feature này sẽ bàn giao theo từng phần để QA test dần, không dồn cuối sprint."_

### 💡 Bài học

Leader tốt giúp QA tham gia **sớm**, không chỉ xuất hiện ở cuối quy trình.

---

## 12) BA bị áp lực từ business, truyền đạt requirement thiếu ổn định

### Tình huống

BA hôm nay nói một kiểu, mai lại sửa theo business mới, team dev cảm thấy BA _"hay đổi"_.

### Rủi ro

- Team mất niềm tin vào BA
- Requirement rung lắc liên tục
- BA bị kẹt giữa business và team

### Cách leader xử lý

- Không công kích BA — hiểu rằng BA cũng đang chịu áp lực từ business
- Thống nhất **change management**:

```
✅ Change nào đã approved → apply ngay
📋 Change nào mới là draft → hold
⏱️ Change nào sẽ áp dụng từ sprint nào → plan rõ
```

- Dùng **versioned requirement / meeting note / decision log**

### Câu leader nên nói

> _"Để team đỡ hiểu nhầm, mình cần tách phần đã chốt và phần đang chờ business confirm."_

> _"Mỗi thay đổi lớn nên có note ngắn về impact."_

### 💡 Bài học

Leader phải giúp BA và team có **cấu trúc giao tiếp ổn định**.

---

## 13) PM hứa với client trước khi align với team

### Tình huống

PM đã nói với client là _"làm được"_, _"xong trong tuần này"_, nhưng team chưa confirm.

### Rủi ro

- Team bị đặt vào thế đã rồi
- Áp lực không cần thiết
- Mất uy tín nếu fail commitment

### Cách leader xử lý

- **Không làm PM mất mặt** trước client
- Align riêng với PM:
  - Phần nào team confirm được
  - Phần nào cần sửa expectation
- Từ sau, thiết lập rule: **cam kết timeline cần có input từ tech lead / team lead**
- Nếu deadline không khả thi → đề xuất **plan thay thế** thay vì chỉ nói _"không"_

### Câu leader nên nói

> _"Để tránh miss commitment, các mốc delivery nên được align với team kỹ thuật trước khi confirm."_

> _"Hiện tại team có thể commit phần A, còn B cần thêm phân tích."_

### 💡 Bài học

Leader phải vừa **giữ quan hệ**, vừa **giữ kỷ luật cam kết**.

---

## 14) Tester quá cứng nhắc, chỉ test đúng script

### Tình huống

QA chỉ test đúng các case trong tài liệu, ít exploratory testing, ít nhìn góc nhìn người dùng thật.

### Rủi ro

- Pass test nhưng production vẫn lỗi
- Miss edge case quan trọng
- UX tệ nhưng không bị phát hiện sớm

### Cách leader xử lý

Khuyến khích QA test theo nhiều chiều:

```
✅ Happy path
⚠️ Edge case
❌ Invalid input
🔄 Real usage flow (user thật dùng thế nào)
```

- Dev và QA cùng review các **khu vực rủi ro cao**
- Với feature phức tạp, áp dụng **risk-based testing**

### Câu leader nên nói

> _"Ngoài test case chính, mình thử thêm góc nhìn user thực tế xem flow có bị vấp không."_

> _"Phần này có nhiều rule ẩn, QA giúp ưu tiên test theo risk."_

### 💡 Bài học

Leader không để chất lượng chỉ là chuyện **tick checklist**.

---

## 15) Quá nhiều họp, team mất thời gian sync

### Tình huống

Dự án enterprise có quá nhiều cuộc họp: grooming, clarification, bug triage, status update, UAT sync, internal sync...

### Rủi ro

- Team mệt, mất focus
- Update nhiều hơn làm
- Giờ deep work gần bằng 0

### Cách leader xử lý

- Gộp các buổi trùng mục tiêu
- Chỉ mời **đúng người cần tham gia**
- Mọi cuộc họp phải có:

```
🎯 Objective: họp để làm gì
📦 Expected output: kết quả cần ra
👤 Owner: ai chốt decision
```

- Cái gì xử lý async được → **không họp**
- Leader **lọc bớt cuộc họp** cho team khi cần

### Câu leader nên nói

> _"Meeting này cần chốt decision gì? Nếu chỉ để update status thì mình có thể làm async."_

> _"Dev không cần tham gia full meeting nếu phần technical đã clear."_

### 💡 Bài học

Leader phải bảo vệ **thời gian deep work** của team.

---

## 16) BA và QA đứng ở góc nhìn khác nhau, team bị kéo hai phía

### Tình huống

BA muốn đúng business logic, QA muốn đúng expected behavior trong test case — nhưng hai bên không hoàn toàn khớp.

### Rủi ro

- Dev không biết theo ai
- Ticket qua lại nhiều vòng
- Căng thẳng cross-functional tăng cao

### Cách leader xử lý

Tách rõ vai trò:

```
🏢 BA  → xác nhận business expected outcome
🔍 QA  → xác nhận validation quality và reproducibility
```

- Nếu có mâu thuẫn: **BA chốt business intent**, QA cập nhật test case tương ứng
- Leader giữ vai trò điều phối — không để dev đứng giữa tự giải quyết

### Câu leader nên nói

> _"BA giúp xác nhận business behavior cuối cùng, QA sẽ update lại test case theo behavior đã chốt."_

> _"Mình cần 1 source of truth để dev implement và QA verify cùng một hướng."_

### 💡 Bài học

Leader phải **đồng bộ vai trò**, không để team rơi vào vùng xám.

---

## 17) PM đánh giá team qua "màu xanh" nhưng thực tế risk cao

### Tình huống

Báo cáo nhìn ổn nhưng bên trong có dependency chưa clear, API chưa xong, QA chưa test được.

### Rủi ro

- Tới sát deadline mới lộ vấn đề
- PM/client bất ngờ
- Leader bị hỏi vì sao không báo sớm

### Cách leader xử lý

Report theo **2 lớp**:

```
📊 Progress  → % done là bao nhiêu
⚠️ Risk      → đang block gì, dependency nào chưa clear
```

- Không chỉ nói % complete
- Nêu rõ: _nếu không gỡ dependency trước ngày X thì impact gì_
- **Escalate sớm**, không đợi khi đã trễ

### Câu leader nên nói

> _"Status hiện tại đang yellow, không phải red, nhưng có risk nếu dependency chưa được resolve trong 2 ngày tới."_

> _"Phần dev done nhưng QA chưa thể verify vì environment chưa ổn."_

### 💡 Bài học

Leader không chỉ báo tin tốt. Leader phải báo **sự thật có thể hành động được**.

---

## 18) UAT phát hiện nhiều issue "không giống mong đợi"

### Tình huống

Đến UAT, business nói hệ thống _"không đúng như họ nghĩ"_, dù team đã build đúng ticket.

### Rủi ro

- Rework lớn, release delay
- Đổ lỗi giữa BA, PM, Dev, QA
- Client mất tin tưởng

### Cách leader xử lý

Phân loại issue UAT ngay:

| Loại                | Định nghĩa                          | Cách xử lý       |
| ------------------- | ----------------------------------- | ---------------- |
| **Defect**          | Sai so với requirement đã chốt      | Fix trong sprint |
| **Missing req**     | Requirement chưa capture từ đầu     | Re-plan          |
| **Expectation gap** | Business expect khác nhưng chưa nói | Align lại        |
| **Enhancement**     | Tính năng mới, ngoài scope          | Backlog          |

- Không gom tất cả thành _"bug"_
- Về sau: bổ sung **demo sớm / prototype / sample data / walkthrough** trước UAT

### Câu leader nên nói

> _"Mình cần tách rõ đây là defect hay là expectation chưa được capture từ đầu."_

> _"Để giảm UAT surprise, team sẽ demo sớm hơn ở các feature phức tạp."_

### 💡 Bài học

Nhiều vấn đề UAT không phải do code sai, mà do **alignment chưa đủ sớm**.

---

## 19) PM muốn release, QA muốn test thêm, Dev muốn đúng hạn

### Tình huống

Ba bên có mục tiêu xung đột:

- PM muốn release đúng ngày
- QA muốn an toàn, test thêm
- Dev muốn scope hợp lý

### Rủi ro

- Không chốt được release decision
- Tranh luận kéo dài không có kết quả
- Release hoặc quá sớm hoặc quá muộn

### Cách leader xử lý

Dùng **risk-based release decision**:

```
🚨 Bug blocker       → chặn release
⚠️ Bug có workaround → release kèm note
✅ Bug minor         → chấp nhận, fix sau
```

Tạo bảng quyết định đơn giản:

| Bug  | Severity | Impacted users | Workaround | Production risk |
| ---- | -------- | -------------- | ---------- | --------------- |
| #123 | High     | 100%           | Không có   | Cao             |
| #456 | Low      | 5%             | Có         | Thấp            |

- Leader đưa góc nhìn kỹ thuật và impact → **PM chốt business release** với đủ thông tin

### Câu leader nên nói

> _"Không phải bug nào cũng cần chặn release, nhưng blocker thì phải chặn."_

> _"Mình cần quyết định dựa trên impact thực tế chứ không chỉ số lượng bug."_

### 💡 Bài học

Leader phải giúp team chuyển từ tư duy **cảm tính** sang **ra quyết định theo risk**.

---

## 20) Các role làm việc kiểu silo, thiếu tinh thần cùng chịu trách nhiệm

### Tình huống

BA nói _"tôi chỉ viết requirement"_, QA nói _"tôi chỉ test"_, Dev nói _"tôi chỉ code"_, PM nói _"tôi chỉ theo timeline"_.

### Rủi ro

- Không ai ownership outcome chung
- Handover cứng nhắc, tốn thời gian
- Hiệu suất delivery thấp

### Cách leader xử lý

- Nhắc rõ mục tiêu chung là **delivery outcome**, không phải hoàn thành phần việc cục bộ
- Tạo văn hóa:

```
🤝 Clarify sớm — không chờ người khác hỏi
🙋 Hỗ trợ nhau — khi thấy người khác block
🎯 Issue là của team — không phải của riêng role nào
```

- Trong **retro**: phân tích vấn đề theo hệ thống, không blame role

### Câu leader nên nói

> _"Mình có khác vai trò, nhưng cùng chịu trách nhiệm cho outcome."_

> _"Ticket fail không phải lỗi riêng Dev hay QA, mà là lỗ hổng phối hợp của cả flow."_

### 💡 Bài học

Leader enterprise mạnh là người **phá được silo giữa các role**.

---

## 🧰 Framework Xử Lý Xung Đột Cross-Functional

Dùng khung này khi làm việc với BA, QA, PM:

### 1. Quay về mục tiêu chung

```
✅ Release đúng
✅ Chất lượng đủ tốt
✅ Scope rõ
✅ Tránh rework
```

### 2. Tách vấn đề ra 4 lớp

| Lớp                     | Định nghĩa                      |
| ----------------------- | ------------------------------- |
| **Requirement issue**   | Thông tin chưa đủ / chưa rõ     |
| **Communication issue** | Hiểu nhầm giữa các bên          |
| **Process issue**       | Quy trình handover có lỗ hổng   |
| **Ownership issue**     | Không rõ ai chịu trách nhiệm gì |

### 3. Không tranh luận bằng cảm nhận

Luôn quay về:

- Ticket / doc
- Acceptance criteria
- Meeting note
- Demo đã chốt
- Data / impact thực tế

### 4. Ra quyết định theo trade-off

```
⚡ Nhanh hơn    ↔  Ít linh hoạt hơn
🏆 Chất lượng cao ↔  Tốn thời gian hơn
📦 Scope rộng   ↔  Deadline khó hơn
```

### 5. Chốt lại bằng hành động rõ ràng

Sau mỗi conflict phải rõ:

```
👤 Ai làm gì
⏱️ Khi nào xong
✅ Cái gì đã chốt
📋 Cái gì chưa chốt
```

---

## 💬 Mẫu Câu Leader Nên Dùng Khi Làm Việc Với BA / QA / PM

### Với BA

> _"Mình cần clarify thêm edge case trước khi dev implement."_

> _"Business rule nào là bắt buộc, rule nào có thể làm phase sau?"_

### Với QA

> _"Bug này impact ở mức nào để team ưu tiên đúng?"_

> _"Mình sync nhanh để reproduce rõ, tránh ping-pong qua ticket."_

### Với PM

> _"Team có thể commit phần nào chắc chắn, phần nào còn dependency?"_

> _"Nếu thêm scope mới, mình cần adjust timeline hoặc giảm phần khác."_

---

## 🏆 6 Nguyên Tắc Quan Trọng Cho Leader Trong Môi Trường Enterprise

### 1. Đừng để mâu thuẫn kéo dài thành cảm xúc

Xử lý sớm khi còn là vấn đề công việc.

### 2. Luôn làm rõ source of truth

Requirement, AC, demo, decision log — phải có **nơi mọi người cùng nhìn vào**.

### 3. Giao tiếp bằng impact, không bằng than phiền

Không nói _"khó lắm"_, hãy nói **impact tới timeline / quality / scope là gì**.

### 4. Không để team ôm rủi ro im lặng

> Risk phải **visible**.

### 5. Không chọn phe, hãy chọn outcome tốt nhất

Leader không đứng về BA hay Dev hay QA — leader đứng về **delivery đúng**.

### 6. Vấn đề lặp lại là vấn đề hệ thống

Nếu conflict giống nhau lặp đi lặp lại, đừng chỉ chữa người — **hãy sửa process**.

---

## 📌 Tổng Kết

| #   | Tình huống                       | Cốt lõi xử lý                           |
| --- | -------------------------------- | --------------------------------------- |
| 1   | Requirement mơ hồ                | Clarification session sớm               |
| 2   | Requirement đổi giữa sprint      | Phân loại Minor / Medium / Major        |
| 3   | BA không hiểu tech limit         | Dịch constraint thành ngôn ngữ business |
| 4   | Bug list không ưu tiên           | Rule phân loại severity                 |
| 5   | Bug report thiếu thông tin       | Template chuẩn + sync trực tiếp         |
| 6   | Bug vs expected?                 | Quay về source of truth                 |
| 7   | PM ép deadline                   | Estimate có điều kiện                   |
| 8   | Ad-hoc task liên tục             | Trade-off rõ ràng, visible board        |
| 9   | Bỏ qua tech debt                 | Gắn debt với chi phí business           |
| 10  | Hiểu khác nhau về "done"         | Definition of Done rõ ràng              |
| 11  | QA test muộn                     | Shift-left testing                      |
| 12  | BA truyền đạt thiếu ổn định      | Change management có cấu trúc           |
| 13  | PM hứa trước khi align           | Rule: cam kết cần input từ tech         |
| 14  | Tester chỉ test script           | Risk-based + exploratory testing        |
| 15  | Quá nhiều họp                    | Bảo vệ deep work                        |
| 16  | BA vs QA mâu thuẫn               | Tách rõ vai trò, 1 source of truth      |
| 17  | Report màu xanh, risk ẩn         | Report 2 lớp: progress + risk           |
| 18  | UAT issue dồn cục                | Phân loại defect vs gap vs enhancement  |
| 19  | PM vs QA vs Dev xung đột release | Risk-based release decision             |
| 20  | Silo giữa các role               | Culture cùng chịu trách nhiệm outcome   |
