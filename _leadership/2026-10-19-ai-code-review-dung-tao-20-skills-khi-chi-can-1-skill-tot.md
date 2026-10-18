---
layout: post
title: "🤖 AI Code Review: Đừng tạo 20 Skills khi chỉ cần 1 Skill tốt"
date: 2026-10-19
categories: leadership
track: become-a-better-leader
---

Khi bắt đầu dùng AI để review code, mình từng nghĩ càng nhiều skill chuyên biệt thì chất lượng review càng cao.

Nhưng sau nhiều lần áp dụng, mình nhận ra: **không phải PR nào cũng cần gọi 6–7 skills**.

Nếu gọi quá nhiều, chúng ta dễ gặp các vấn đề:

- Tốn token và chi phí xử lý.
- Nhận xét trùng lặp.
- Quá tải thông tin khi đọc.
- Lỗi quan trọng bị chìm giữa các comment ít giá trị.

Vì vậy, thay vì mặc định dùng nhiều skill, mình chọn cách bắt đầu với **một skill tổng hợp** rồi chỉ mở rộng khi thực sự cần.

## 1) Một skill tổng hợp cho phần lớn PR

Bạn có thể thiết kế skill `review-pr` để cover các nhóm tiêu chí cốt lõi:

- **Architecture:** tách trách nhiệm, module boundaries, khả năng mở rộng.
- **Framework practices:** Composition API, reactivity, lifecycle/watch/computed.
- **State management:** cấu trúc store, side effects, cập nhật state.
- **Performance:** render list lớn, tính toán lặp lại, memory leaks.
- **Testing:** test cases thiếu, assertion yếu, edge cases.
- **Security & maintainability:** input handling, XSS risk, duplication, complexity.

Skill tổng hợp tốt thường xử lý được đa số PR thông thường.

## 2) Tiêu chí kích hoạt skill chuyên biệt (rõ ràng và đo được)

Không loại bỏ skill chuyên biệt — chỉ kích hoạt khi có dấu hiệu cụ thể.

### Router skill (`vue-router-best-practices`)

Kích hoạt khi PR có ít nhất một điều kiện:

- Sửa file router hoặc route config.
- Thay đổi guard (`beforeEach`, `beforeEnter`, v.v.).
- Thay đổi cơ chế lazy-loading route.
- Thêm/sửa route params, meta, redirect.

### Pinia skill (`vue-pinia-best-practices`)

Kích hoạt khi:

- Thay đổi store (`state/getters/actions`).
- Có logic bất đồng bộ trong actions.
- Có side effects liên quan đồng bộ state giữa modules.

### Testing skill (`vue-testing-best-practices`)

Kích hoạt khi:

- PR thêm/sửa unit test.
- Có thay đổi behavior nhưng test không đổi hoặc đổi ít bất thường.
- Có mock phức tạp hoặc flaky test risk.

### E2E skill (`e2e-review-skill`)

Kích hoạt khi:

- PR thêm/sửa test Playwright/Cypress.
- Thay đổi locator strategy hoặc wait strategy.
- Có test chạy pass nhưng không ổn định qua nhiều lần run.

> Quy tắc nhanh: **Không có trigger rõ ràng → không gọi skill chuyên biệt.**

## 3) Workflow đề xuất (gọn và hiệu quả)

```text
Pull Request
   |
   v
[1] review-pr (general)
   |
   +--> Có trigger chuyên biệt?
            |
            +--> Có: gọi skill tương ứng (router/pinia/testing/e2e)
            |
            +--> Không: sang bước xác minh
   |
   v
[2] Verify findings (lọc false positives)
   |
   v
[3] Human review
    - Business logic
    - Requirement & acceptance criteria
    - Edge cases & trade-offs
   |
   v
Final decision
```

## 4) Nguyên tắc 80/20 khi xây dựng AI skills

Mình dùng Pareto như định hướng thực tế:

- **80% nỗ lực:** đầu tư một skill tổng hợp thật tốt, checklist rõ ràng.
- **20% nỗ lực:** thêm skills chuyên biệt cho các case có độ phức tạp cao.

Mục tiêu là cân bằng giữa **chất lượng review**, **chi phí**, và **thời gian**.

**Reviewer giỏi không phải người gọi nhiều skill nhất, mà là người chọn đúng skill cho đúng vấn đề.**

Tham khảo bộ Vue AI Skills:  
[https://github.com/vuejs-ai/skills/tree/main/skills](https://github.com/vuejs-ai/skills/tree/main/skills)

---

💬 **Câu hỏi dành cho mọi người:** Team của bạn đang ưu tiên một skill tổng hợp rồi mở rộng theo trigger, hay đang chạy nhiều skill chuyên biệt cho mọi PR?

#AI #CodeReview #GitHubCopilot #VueJS #SoftwareEngineering #PromptEngineering #DeveloperProductivity #CleanCode
