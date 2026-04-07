---
layout: post
title: "Tech Leader Mindset: Lên Plan Cho Dự Án Upgrade Lớn"
subtitle: "Tư duy toàn diện khi upgrade Angular từ v9 lên v18"
description: "Hướng dẫn tư duy của Tech Leader khi lên plan cho dự án upgrade lớn — từ business goal, risk mapping, phase plan, đến communication và rollback strategy. Case study: Angular 9 → 18."
tags:
  [
    angular,
    upgrade,
    tech-leader,
    project-planning,
    risk-management,
    architecture,
    leadership,
    enterprise,
  ]
categories: [Development]
---

# Tech Leader Mindset: Lên Plan Cho Dự Án Upgrade Lớn (Angular 9 → 18)

> **Mục tiêu:** Hiểu cách một Tech Leader tư duy khi lên plan cho dự án upgrade lớn — không chỉ là technical plan, mà còn là business plan, risk control plan, execution plan, và communication plan.
>
> **Case study:** Upgrade Angular từ v9 lên v18.

---

## 1. Tư Duy Tổng Thể

Tech Leader không nên nghĩ kiểu:

> "Upgrade từ 9 lên 18 thì làm lần lượt version."

Mà nên nghĩ kiểu:

> "Làm sao nâng version **an toàn**, **kiểm soát rủi ro**, **ít ảnh hưởng business**, **team làm được**, và **có đường lui nếu fail**."

Plan không chỉ là technical plan. Nó phải là:

- **Business plan**
- **Risk control plan**
- **Execution plan**
- **Communication plan**

---

## 2. Diagram Tư Duy Tổng Thể

```text
[Business Goal]
    |
    v
[Define Why]
- Vì sao phải upgrade?
- Nếu không upgrade thì rủi ro gì?
- Thành công được đo bằng gì?
    |
    v
[Current State Assessment]
- Hệ thống đang ở đâu?
- Angular 9 đang phụ thuộc gì?
- Những chỗ nào dễ vỡ?
    |
    v
[Risk Mapping]
- Technical risk
- UI/UX regression risk
- Dependency risk
- Delivery timeline risk
- Team capability risk
    |
    v
[Strategy Design]
- Big bang hay chia phase?
- Upgrade từng bước hay nhảy version?
- Ưu tiên stability hay speed?
    |
    v
[Execution Plan]
- Chia task
- Chia owner
- Chia milestone
- Chia môi trường test/release
    |
    v
[Validation Plan]
- Test gì?
- Ai verify?
- Điều kiện để qua phase?
    |
    v
[Rollback / Contingency Plan]
- Nếu fail thì quay lại thế nào?
- Scope nào có thể cắt?
- Deadline bị trễ thì xử lý ra sao?
    |
    v
[Communication & Tracking]
- Báo cáo cho PM/client/team thế nào?
- Theo dõi progress bằng gì?
- Escalate khi nào?
```

---

## 3. Bước 1 — Xác Định Mục Tiêu Thật Sự

Tech Leader phải hỏi:

```text
Upgrade Angular 9 -> 18 để làm gì?
    |
    +--> Security / support
    +--> Dễ maintain
    +--> Tận dụng ecosystem mới
    +--> Performance tốt hơn
    +--> Giảm technical debt
    +--> Chuẩn hóa codebase cho tương lai
```

> **Lưu ý quan trọng:** Nếu không rõ mục tiêu, plan sẽ dễ bị biến thành chỉ tăng version cho xong, phát sinh bug nhiều, team mệt nhưng business không thấy giá trị.

### Ví dụ mục tiêu thực tế

- Angular 9 đã quá cũ, khó maintain
- Dependency cũ gây conflict
- Angular 18 giúp đồng bộ ecosystem mới
- Giảm rủi ro security / unsupported packages
- Tạo nền tảng cho các feature mới

---

## 4. Bước 2 — Đánh Giá Hiện Trạng

```text
[Current State Assessment]
    |
    +--> Source code complexity
    |      - App lớn hay nhỏ?
    |      - Bao nhiêu module?
    |      - Bao nhiêu shared component?
    |
    +--> Dependencies
    |      - Angular Material?
    |      - RxJS version?
    |      - NgRx?
    |      - Third-party libs?
    |
    +--> UI sensitivity
    |      - Có nhiều form không?
    |      - Có data table phức tạp không?
    |      - Có dialog / stepper / tabs / overlay không?
    |
    +--> Test coverage
    |      - Unit test đủ không?
    |      - E2E có không?
    |      - Manual regression phụ thuộc nhiều không?
    |
    +--> Team capacity
    |      - Team hiểu Angular internals tới đâu?
    |      - Có người mạnh CSS/UI fix không?
    |      - Có người mạnh dependency/debug không?
```

Tech Leader phải biết **cái gì đang có**, **cái gì sẽ vỡ**, và **team có gánh nổi không**.

Với Angular 9 → 18, các điểm đau lớn thường gặp:

- Angular Material thay đổi nhiều
- SCSS/CSS bị lệch
- RxJS/API cũ không còn phù hợp
- Build config / tsconfig / lint / polyfill thay đổi
- Third-party packages không compatible

---

## 5. Bước 3 — Map Rủi Ro

```text
[Risk Mapping]
    |
    +--> Code compile risk
    |      - package conflict
    |      - TypeScript errors
    |      - deprecated APIs
    |
    +--> Runtime risk
    |      - app chạy nhưng lỗi ngầm
    |      - event binding / change detection issue
    |
    +--> UI regression risk
    |      - layout vỡ
    |      - form field height lệch
    |      - table/dialog/stepper/tab lệch
    |
    +--> Behavior regression risk
    |      - validation sai
    |      - pagination/filter/search khác trước
    |      - overlay/snackbar/modal hoạt động khác
    |
    +--> Release risk
    |      - không kịp deadline
    |      - fix bug quá nhiều
    |
    +--> Team execution risk
           - task chồng chéo
           - merge conflict nhiều
           - dev fix chỗ này vỡ chỗ kia
```

> **Insight quan trọng:** Một Tech Leader giỏi không phải là người "làm nhanh nhất", mà là người **nhìn ra chỗ dễ fail trước**.
>
> Rủi ro lớn nhất không phải compile fail — mà là **build pass nhưng UI/behavior vỡ hàng loạt**.

---

## 6. Bước 4 — Chọn Chiến Lược Upgrade

```text
[Strategy Options]
    |
    +--> Option A: Big Bang
    |      - Upgrade toàn bộ một lần
    |      - Nhanh về mặt timeline tổng
    |      - Nhưng risk cực cao
    |
    +--> Option B: Incremental Upgrade
    |      - Nâng từng major version / nhóm thay đổi
    |      - Dễ debug hơn
    |      - Tốn thời gian hơn
    |
    +--> Option C: Technical upgrade + UI stabilization phases
           - Phase 1: compile/build/run được
           - Phase 2: fix dependencies
           - Phase 3: fix UI regressions
           - Phase 4: regression & hardening
```

### Khuyến nghị cho Angular 9 → 18

```text
Không coi đây là 1 task
Mà coi đây là 1 chương trình gồm nhiều phase
```

Cách chia phase phù hợp:

| Phase   | Tên                    |
| ------- | ---------------------- |
| Phase 1 | Assessment & Spike     |
| Phase 2 | Core Framework Upgrade |
| Phase 3 | Dependency Alignment   |
| Phase 4 | UI Regression Fixing   |
| Phase 5 | Regression Testing     |
| Phase 6 | Release Stabilization  |

---

## 7. Diagram Plan Thực Chiến

```text
              [Angular 9 -> 18 Upgrade Program]
                           |
  ---------------------------------------------------------------
  |                   |                  |                      |
  v                   v                  v                      v
[Phase 1]         [Phase 2]         [Phase 3]             [Phase 4]
Assessment        Core Upgrade      Dependency Fix        UI Stabilization
& Spike           & Build Stable    & Compatibility       & Regression Fix
  |                   |                  |                      |
- Audit code      - Angular core    - Angular Material    - Screen-by-screen fix
- Audit packages  - CLI update      - RxJS                - Dialog/table/form
- Identify        - TS config       - NgRx                - spacing/layout
  blockers        - Build pipeline  - Third-party libs    - visual consistency
- Create risk     - Run app         - Replace deprecated  - behavior consistency
  list
- Define scope

                           |
                           v
                      [Phase 5]
                  Functional Regression
                           |
                 - Smoke test critical flow
                 - Validate with BA/QA
                 - UAT support
                 - Bug triage

                           |
                           v
                      [Phase 6]
                 Release / Hypercare / Close
                           |
                 - Controlled rollout
                 - Production monitoring
                 - Quick fix if needed
                 - Final documentation
```

---

## 8. Chi Tiết Từng Phase

### Phase 1 — Assessment & Spike

**Mục tiêu:** Hiểu hệ thống, biết phạm vi, biết rủi ro, ước lượng sơ bộ.

**Output cần có:**

```text
- Dependency inventory
- Risk list
- Danh sách package incompatible
- Danh sách màn hình nhạy cảm
- Upgrade approach
- Rough estimation
```

**Tech Leader cần hỏi:**

- Chỗ nào chặn upgrade?
- Có package nào phải thay thế không?
- Có cần POC trước không?

---

### Phase 2 — Core Upgrade & Build Stable

**Mục tiêu:** App build được, app run được — chưa cần đẹp ngay.

**Output:**

```text
- Angular version upgraded
- Build pass
- App boot lên được
- Core flows có thể chạy
```

> **Lưu ý:** Đừng cố fix toàn bộ UI ở phase này. Nếu vừa upgrade core vừa polish UI luôn, team sẽ rất loạn.

---

### Phase 3 — Dependency Fix & Compatibility

**Mục tiêu:** Đồng bộ ecosystem, dọn deprecated code, xử lý compatibility issues.

**Output:**

```text
- Material compatible
- RxJS compatible
- NgRx compatible
- Build warning giảm
- Deprecated APIs được xử lý
```

> **Tư duy:** Không phải bug nào cũng fix theo triệu chứng. Nhiều bug đến từ **dependency mismatch**.

---

### Phase 4 — UI Stabilization

Đây thường là phase nặng nhất. Nên chia theo screen để hiệu quả hơn:

```text
[UI Stabilization]
    |
    +--> Dashboard
    +--> Visualize
    +--> Project Details
    +--> Shared Dialogs
    +--> Shared Form Controls
    +--> Shared Table Components
```

**Vì sao chia theo screen?**

- Dev dễ ownership
- Dễ track progress
- Giảm conflict
- Chỗ nào fail dễ cô lập

> Tách UI bugs thành task riêng theo từng màn hình là **rất đúng tư duy Tech Leader**.

---

### Phase 5 — Functional Regression

**Mục tiêu:** Đảm bảo không chỉ đẹp mà còn đúng behavior.

**Validate các nhóm chính:**

```text
- Navigation
- Search/filter
- Table/pagination
- Forms/validation
- Dialog/modal
- Snackbar/error
- Import/export
- Permission-based UI
```

> **Nhắc nhở:** UI đúng nhưng behavior sai vẫn fail như thường.

---

### Phase 6 — Release / Hypercare

**Mục tiêu:** Release có kiểm soát, theo dõi bug sau release, phản ứng nhanh.

**Output:**

```text
- Rollout plan
- Rollback plan
- Hotfix owner
- Post-release monitoring
```

---

## 9. Cách Chia Task Như Một Tech Leader

```text
Không chia task theo kiểu:
- fix linh tinh từng bug nhỏ

Mà chia theo kiểu:
- theo phase
- theo screen
- theo ownership
- theo mức độ rủi ro
```

### Ví dụ Structure

```text
Program: Angular 9 -> 18 Upgrade

  Epic 1: Core Upgrade
    - Update Angular core/cli
    - Update TypeScript configs
    - Fix build errors
    - Fix runtime boot issues

  Epic 2: Dependency Alignment
    - Update Angular Material
    - Update RxJS usage
    - Replace incompatible libraries
    - Remove deprecated APIs

  Epic 3: UI Stabilization
    - Dashboard UI fixes
    - Visualize UI fixes
    - Project Details UI fixes
    - Shared dialogs / forms fixes

  Epic 4: Functional Regression
    - Smoke test key flows
    - Fix regression issues
    - BA/QA validation support

  Epic 5: Release Stabilization
    - UAT support
    - Production readiness
    - Hypercare bug fixing
```

---

## 10. Tư Duy Estimate Đúng

Tech Leader không estimate kiểu _"chắc tầm 2 tuần"_.

Phải estimate theo:

$$\text{Estimate} = \text{Known Work} + \text{Risk Buffer} + \text{Unknown Discovery}$$

```text
[Estimate]
    |
    +--> Known tasks
    |      - update config
    |      - fix compile
    |      - migrate packages
    |
    +--> Regression tasks
    |      - screen fixes
    |      - behavior fixes
    |
    +--> Validation effort
    |      - QA support
    |      - re-test cycles
    |
    +--> Risk buffer
           - hidden dependency issues
           - unexpected UI breakage
           - merge conflicts
```

> **Chú ý:** Upgrade lớn luôn có unknowns. Nếu plan không có buffer, plan đó gần như sai từ đầu.

---

## 11. Tư Duy Communication Của Tech Leader

Bạn không chỉ làm plan, mà còn phải **làm cho mọi người hiểu plan**.

```text
[Communication Layer]
    |
    +--> Với team
    |      - scope
    |      - owner
    |      - coding approach
    |      - done criteria
    |
    +--> Với PM
    |      - timeline
    |      - risk
    |      - dependency
    |      - blocker
    |
    +--> Với QA/BA
    |      - area cần focus test
    |      - expected changes
    |      - known limitations
    |
    +--> Với client
           - progress
           - visible risks
           - mitigation plan
           - release confidence
```

**Một Tech Leader tốt phải nói được:**

- Chúng ta đang ở phase nào
- Cái gì done
- Cái gì risk
- Cần ai support
- Quyết định tiếp theo là gì

---

## 12. Khung Tư Duy Ưu Tiên Bug

Khi nhiều bug upgrade xuất hiện cùng lúc, dùng khung này:

```text
[Prioritization]
    |
    +--> 1. Blocker?
    |      - không build được
    |      - không chạy được
    |
    +--> 2. Business critical?
    |      - flow chính bị hỏng
    |
    +--> 3. User visible?
    |      - UI lệch lớn / khó dùng
    |
    +--> 4. Shared impact?
    |      - 1 fix ảnh hưởng nhiều màn hình
    |
    +--> 5. Cosmetic only?
           - để sau
```

> Không nên cho team lao vào fix các lỗi cosmetic trước khi xử lý blocker và flow critical.

---

## 13. Definition of Done

```text
[Definition of Done for Upgrade]
    |
    +--> Build pass
    +--> App run ổn định
    +--> Critical flows hoạt động
    +--> Không còn blocker/high issues
    +--> UI các screen chính được verify
    +--> QA sign-off / stakeholder aligned
    +--> Có release & rollback plan
```

> Nếu không có "done criteria", upgrade sẽ kéo dài vô tận.

---

## 14. Diagram Hoàn Chỉnh — Tech Leader Mindset

```text
              TECH LEADER MINDSET FOR UPGRADE PLAN
                     (Angular 9 -> 18)

[1. Why]
- Vì sao phải upgrade?
- Giá trị business là gì?
- Không upgrade thì rủi ro gì?

        |
        v

[2. Assess Current State]
- Codebase phức tạp tới đâu?
- Dependencies nào đang dùng?
- Screen nào nhạy cảm?
- Test coverage tới đâu?
- Team mạnh/yếu chỗ nào?

        |
        v

[3. Map Risks]
- Compile/build risk
- Runtime risk
- UI regression risk
- Functional regression risk
- Timeline risk
- Team execution risk

        |
        v

[4. Choose Strategy]
- Không coi là 1 task
- Coi là 1 program nhiều phase
- Ưu tiên stability + control risk

        |
        v

[5. Phase Plan]
    |
    +--> Phase 1: Assessment & Spike
    +--> Phase 2: Core Upgrade
    +--> Phase 3: Dependency Alignment
    +--> Phase 4: UI Stabilization
    +--> Phase 5: Functional Regression
    +--> Phase 6: Release & Hypercare

        |
        v

[6. Task Breakdown]
- Chia theo epic
- Chia theo screen
- Chia owner rõ ràng
- Giảm merge conflict
- Dễ track progress

        |
        v

[7. Validation]
- Smoke test
- Critical flow test
- UI verification
- QA/UAT support

        |
        v

[8. Rollback / Backup]
- Nếu fail thì quay về thế nào?
- Scope nào cắt được?
- Deadline trễ thì ưu tiên gì?

        |
        v

[9. Communication]
- Team biết đang làm gì
- PM biết risk và timeline
- QA biết test gì
- Client biết progress và confidence

        |
        v

[10. Success]
- Build ổn
- Run ổn
- Critical flows ổn
- UI ổn
- Release an toàn
- Team kiểm soát được hệ thống
```

---

## 15. Công Thức Tư Duy Cốt Lõi

Một Tech Leader lên plan upgrade tốt sẽ nghĩ theo 5 câu này:

```text
1. Mục tiêu thật sự là gì?
2. Cái gì dễ vỡ nhất?
3. Chia phase thế nào để giảm rủi ro?
4. Chia task/owner thế nào để team làm hiệu quả?
5. Làm sao biết khi nào thật sự done?
```

### Công thức ngắn gọn

$$
\text{Upgrade Plan Mindset} = \text{Understand Why}
+ \text{Assess State}
+ \text{Predict Risks}
+ \text{Split Phases}
+ \text{Assign Ownership}
+ \text{Validate}
+ \text{Communicate}
+ \text{Rollback}
$$
