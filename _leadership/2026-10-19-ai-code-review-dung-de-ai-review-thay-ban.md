---
layout: post
title: "🤖 AI Code Review: Đừng để AI review thay bạn, hãy dùng AI để review tốt hơn"
date: 2026-10-19
categories: leadership
track: become-a-better-leader
---

Trong quá trình sử dụng GitHub Copilot để hỗ trợ phát triển phần mềm, mình nhận ra một vấn đề khá thú vị:

**AI có thể giúp chúng ta review code nhanh hơn, nhưng không đồng nghĩa với việc chúng ta đang review code tốt hơn.**

Nếu chỉ đưa Pull Request cho AI và hỏi *“Review this PR”*, chúng ta có thể nhận được rất nhiều nhận xét về naming, code smells, duplicated code hay refactoring.

Nhưng liệu những nhận xét đó có thực sự giúp hệ thống tốt hơn?

Mình nghĩ rằng, để sử dụng AI hiệu quả trong Code Review, chúng ta cần thay đổi cách tiếp cận.

## 1. AI nên làm gì trong Code Review?

AI đặc biệt hữu ích với những công việc có thể chuẩn hóa thành các quy tắc và checklist.

🔹 **Coding Standards**
- Naming convention và code formatting.
- Unused imports và biến không cần thiết.
- Magic numbers và duplicated code.
- Hàm quá dài hoặc có quá nhiều trách nhiệm.

🔹 **Code Quality**
- Phát hiện code smells.
- Đề xuất cải thiện readability.
- Kiểm tra error handling.
- Phát hiện các trường hợp thiếu unit tests.

🔹 **Security & Performance**
- Nhận diện các dấu hiệu có nguy cơ gây lỗi bảo mật.
- Phát hiện những thao tác có thể gây performance issues.
- Kiểm tra các trường hợp xử lý dữ liệu chưa an toàn.

Tuy nhiên, đây chỉ là những gợi ý cần được xác minh. AI có thể tạo ra false positives, bỏ sót lỗi hoặc đề xuất giải pháp không phù hợp với hệ thống thực tế.

## 2. Những gì AI khó thay thế được

Một đoạn code có thể đúng về mặt kỹ thuật nhưng vẫn sai về mặt nghiệp vụ.

Ví dụ:

```typescript
if (equipment.status !== 'ACTIVE') {
  return;
}
```

AI có thể nhận xét rằng logic này hợp lệ và dễ đọc.

Nhưng trong business context thực tế, chúng ta cần đặt thêm câu hỏi:

- Thiết bị ở trạng thái `PENDING` có được phép xử lý không?
- Requirement mới có thay đổi quy tắc nghiệp vụ không?
- Có trường hợp nào cần xử lý ngoại lệ?
- Logic này có nhất quán với các module khác không?

Đây không chỉ là vấn đề syntax hay best practices.

Nó đòi hỏi reviewer phải hiểu requirement, domain knowledge và kiến trúc hệ thống.

**AI phân tích code. Reviewer đánh giá code trong bối cảnh thực tế.**

## 3. Workflow Code Review khi kết hợp AI

Đây là workflow mình cho rằng có thể áp dụng hiệu quả trong team development.

```text
        Business Requirement
                 |
                 v
          Pull Request
                 |
                 v
       1. Human Review
          - Understand scope
          - Read acceptance criteria
                 |
                 v
        2. AI-Assisted Review
          - Coding standards
          - Code smells
          - Security checks
          - Test coverage
                 |
                 v
       3. Human Verification
          - Business logic
          - Edge cases
          - Architecture
          - Performance impact
                 |
                 v
       4. Final Decision
          - Approve
          - Request changes
          - Discuss trade-offs
```

Điểm quan trọng là AI không cần thay thế toàn bộ quy trình review.

Thay vào đó, AI hỗ trợ reviewer phát hiện vấn đề sớm hơn để con người tập trung vào những quyết định quan trọng hơn.

## 4. Đừng chỉ viết prompt, hãy xây dựng Review Checklist

Thay vì mỗi lần review lại yêu cầu AI theo cách khác nhau, chúng ta có thể xây dựng custom prompt hoặc skill dựa trên coding standards của team.

Ví dụ:

```text
Review this Pull Request using our team guidelines.

1. Correctness and business logic
2. Architecture and design principles
3. Error handling and edge cases
4. Security and performance
5. Unit test coverage
6. Code duplication and maintainability
7. Accessibility and UX, where applicable

For every finding:
- Identify the affected file and line.
- Explain the potential impact.
- Provide a concrete example or reproduction scenario.
- Suggest a minimal fix.
- Assign a severity level.
- State any assumptions or uncertainties.

Do not report speculative issues as confirmed bugs.
Do not suggest refactoring without a clear benefit.
```

Khi kết hợp checklist với coding conventions, architecture guidelines và các quyết định đã thống nhất của team, AI có thể đưa ra những nhận xét nhất quán hơn.

Tất nhiên, checklist tốt không đảm bảo AI sẽ tìm được mọi lỗi. Chúng ta vẫn cần xác minh từng finding.

## 5. Giá trị lớn nhất không phải là review nhanh hơn

Hãy thử so sánh:

**Trước khi sử dụng AI**
- Dành nhiều thời gian cho naming và formatting.
- Phải kiểm tra thủ công những lỗi lặp đi lặp lại.
- Dễ bỏ qua các chi tiết nhỏ khi review nhiều PR.

**Khi kết hợp AI đúng cách**
- Tự động hóa một phần kiểm tra cơ học.
- Chuẩn hóa tiêu chí review giữa các thành viên.
- Có thêm thời gian để phân tích business logic.
- Tập trung vào architecture, trade-offs và long-term maintainability.

Đặc biệt với Tech Lead hoặc Senior Developer, giá trị không nằm ở việc viết nhiều comment hơn, mà ở việc giúp team đưa ra những quyết định kỹ thuật tốt hơn.

## 6. Một nguyên tắc mình muốn áp dụng

**AI là Copilot, không phải Autopilot.**

Copilot giúp chúng ta nhìn thấy nhiều vấn đề hơn, nhưng không nên khiến chúng ta ngừng suy nghĩ.

Một reviewer giỏi không phải là người tìm được nhiều lỗi nhất, mà là người xác định được những vấn đề thực sự quan trọng, giải thích được tác động và giúp team lựa chọn giải pháp phù hợp.

Vì vậy, câu hỏi không nên chỉ là:

❌ *How can AI review my code?*

Mà nên là:

✅ *How can I use AI to become a better code reviewer?*

Đó mới là cách mình muốn tiếp cận AI trong Software Engineering: không phụ thuộc vào AI, mà sử dụng AI để nâng cao năng lực của chính mình.

---

💬 **Câu hỏi dành cho mọi người:**

Trong team của bạn, AI đang được sử dụng như một công cụ hỗ trợ Code Review, một reviewer tự động trong CI/CD, hay đã trở thành một phần trong quy trình engineering standards?

#CodeReview #GitHubCopilot #AI #SoftwareEngineering #PullRequest #TechLead #CleanCode #EngineeringExcellence
