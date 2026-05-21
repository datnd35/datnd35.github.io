---
track: "unit-testing"
layout: post
title: "Testing Series - Unit Test: Từ Mục Đích Đến Mindset Thực Chiến"
date: 2026-05-22
categories: testing
tags: ["unit-test", "testing", "jest", "angular", "tdd", "frontend"]
description: "Diagram chi tiết về Unit Test theo góc nhìn developer thực tế: mục đích, implement, cách run, tại sao cần mock và mindset đúng khi viết test."
---

## 🎯 Mục Tiêu Bài Viết

Hiểu rõ Unit Test từ gốc rễ — **không chỉ là viết test cho đủ coverage**, mà là nắm được tư duy đúng để test bảo vệ behavior quan trọng khi code thay đổi.

---

# 1. Unit Test là gì?

```text
Unit Test
   |
   |-- Test một "unit" nhỏ nhất trong code
   |
   |-- Unit có thể là:
   |      |-- Function
   |      |-- Method
   |      |-- Component nhỏ
   |      |-- Service
   |      |-- Pipe / Helper / Utility
   |
   |-- Mục tiêu:
          |-- Kiểm tra logic có đúng không
          |-- Phát hiện bug sớm
          |-- Giảm regression khi sửa code
          |-- Giúp refactor tự tin hơn
```

Hiểu đơn giản:

> Unit Test là cách mình viết code để kiểm tra một phần nhỏ của code có chạy đúng như kỳ vọng hay không.

Ví dụ:

```ts
function sum(a: number, b: number) {
  return a + b;
}
```

Unit test sẽ kiểm tra:

```text
sum(1, 2)   có trả về 3 không?
sum(-1, 1)  có trả về 0 không?
sum(0, 0)   có trả về 0 không?
```

---

# 2. Mục đích của Unit Test

```text
Mục đích của Unit Test
   |
   |-- 1. Verify logic
   |      |
   |      |-- Code có chạy đúng requirement không?
   |
   |-- 2. Catch bug early
   |      |
   |      |-- Phát hiện lỗi trước khi lên môi trường test / production
   |
   |-- 3. Prevent regression
   |      |
   |      |-- Sửa logic A nhưng không làm hỏng logic B
   |
   |-- 4. Support refactoring
   |      |
   |      |-- Refactor code nhưng vẫn đảm bảo behavior không đổi
   |
   |-- 5. Document behavior
          |
          |-- Test case giúp người khác hiểu code đang kỳ vọng gì
```

Điểm quan trọng nhất:

```text
Unit Test không phải để chứng minh code không bao giờ có bug.
Unit Test giúp đảm bảo các behavior quan trọng vẫn hoạt động đúng.
```

---

# 3. Unit Test nằm ở đâu trong Testing Pyramid?

```text
Testing Pyramid

                /\
               /  \
              / E2E \
             /------\
            /Integration\
           /------------\
          /  Unit Test   \
         /----------------\
```

Giải thích:

```text
Unit Test
   |
   |-- Nhiều nhất
   |-- Chạy nhanh
   |-- Test logic nhỏ
   |-- Ít phụ thuộc hệ thống thật

Integration Test
   |
   |-- Test nhiều module/service làm việc với nhau
   |-- Có thể liên quan API, database, module khác

E2E Test
   |
   |-- Test flow thật từ góc nhìn user
   |-- Ví dụ: login -> vào dashboard -> tạo order
   |-- Chạy chậm hơn
```

Unit Test là tầng nền vì nó **nhanh, rẻ, dễ chạy thường xuyên**.

---

# 4. Flow tổng quan khi viết Unit Test

```text
Requirement / Expected behavior
        |
        v
Identify unit cần test
        |
        v
Prepare input / mock dependency
        |
        v
Call function / method / component behavior
        |
        v
Assert output / side effect
        |
        v
Run test
        |
        v
Pass / Fail
        |
        v
Fix code hoặc fix test
```

Ví dụ tư duy:

```text
Requirement:
Nếu user chưa nhập email thì disable button submit.

Unit cần test:
Component logic kiểm tra form valid/invalid.

Input:
Email rỗng.

Action:
Trigger validation.

Expected:
Button submit bị disabled.
```

---

# 5. Cấu trúc chuẩn của một Unit Test

```text
Unit Test Structure
   |
   |-- Arrange
   |      |
   |      |-- Chuẩn bị data
   |      |-- Mock dependency
   |      |-- Khởi tạo component/service
   |
   |-- Act
   |      |
   |      |-- Gọi function
   |      |-- Trigger event
   |      |-- Execute behavior cần test
   |
   |-- Assert
          |
          |-- Kiểm tra kết quả có đúng kỳ vọng không
```

Công thức dễ nhớ:

```text
AAA = Arrange -> Act -> Assert
```

Ví dụ:

```ts
describe('sum', () => {
  it('should return total of two numbers', () => {
    // Arrange
    const a = 1;
    const b = 2;

    // Act
    const result = sum(a, b);

    // Assert
    expect(result).toBe(3);
  });
});
```

---

# 6. Unit Test chạy như thế nào?

```text
Developer chạy command
        |
        v
Test Runner khởi động
        |
        v
Tìm các file test
        |
        v
Load test suite
        |
        v
Run từng test case
        |
        v
Compare actual result với expected result
        |
        v
Generate result
        |
        |-- Passed
        |-- Failed
        |-- Skipped
        |
        v
Report ra terminal / browser / CI pipeline
```

Ví dụ command:

```bash
# Jest
npm run test

# Angular
ng test

# Vitest
npx vitest
```

---

# 7. Bên trong một test case xảy ra gì?

```text
Test case
   |
   |-- 1. Setup environment
   |      |
   |      |-- Tạo component/service/function
   |      |-- Tạo mock data
   |
   |-- 2. Execute behavior
   |      |
   |      |-- Gọi method
   |      |-- Click button giả lập
   |      |-- Emit observable
   |
   |-- 3. Check expectation
   |      |
   |      |-- expect(actual).toBe(expected)
   |      |-- expect(method).toHaveBeenCalled()
   |      |-- expect(value).toEqual(...)
   |
   |-- 4. Cleanup
          |
          |-- Reset mock
          |-- Destroy component
          |-- Clear timers/subscriptions
```

---

# 8. Vì sao Unit Test cần mock?

```text
Unit Test
   |
   |-- Chỉ nên test logic của unit hiện tại
   |
   |-- Không nên phụ thuộc trực tiếp vào:
   |      |-- API thật
   |      |-- Database thật
   |      |-- File system thật
   |      |-- Third-party service thật
   |      |-- Network thật
   |
   |-- Vì vậy cần mock
          |
          |-- Mock service
          |-- Mock API response
          |-- Mock dependency
          |-- Mock function callback
```

Lý do:

```text
Nếu unit test gọi API thật:
   |
   |-- Test chậm
   |-- Dễ fail do network
   |-- Không ổn định
   |-- Khó kiểm soát data
   |-- Không còn đúng nghĩa unit test
```

Unit test tốt nên:

```text
Nhanh
Ổn định
Dễ hiểu
Dễ chạy lại
Không phụ thuộc môi trường ngoài
```

---

# 9. Ví dụ thực tế với Service

Giả sử có service:

```ts
class UserService {
  constructor(private api: ApiService) {}

  getUserName(userId: string) {
    return this.api.getUser(userId).name;
  }
}
```

Unit test nên mock `ApiService`:

```ts
describe('UserService', () => {
  it('should return user name', () => {
    // Arrange
    const mockApiService = {
      getUser: () => ({ id: '1', name: 'Dat' })
    };

    const service = new UserService(mockApiService as any);

    // Act
    const result = service.getUserName('1');

    // Assert
    expect(result).toBe('Dat');
  });
});
```

Diagram:

```text
UserService Test
   |
   |-- Unit cần test: UserService
   |
   |-- Dependency thật: ApiService
   |
   |-- Thay bằng: MockApiService
   |
   |-- Input: userId = "1"
   |
   |-- Expected output: "Dat"
```

---

# 10. Ví dụ thực tế với Angular Component

```text
Angular Component Unit Test
   |
   |-- Test component class
   |      |
   |      |-- Method
   |      |-- State
   |      |-- Input / Output
   |
   |-- Test template behavior
   |      |
   |      |-- Button hiển thị không?
   |      |-- Text render đúng không?
   |      |-- Click có gọi method không?
   |
   |-- Test dependency
          |
          |-- Mock service
          |-- Mock route
          |-- Mock dialog
          |-- Mock store
```

Ví dụ:

```text
Requirement:
Khi user click Save button thì gọi method save().

Test:
   |
   |-- Arrange: render component
   |-- Act: click Save button
   |-- Assert: expect(save).toHaveBeenCalled()
```

---

# 11. Unit Test nên test cái gì?

```text
Nên test
   |
   |-- Business logic quan trọng
   |-- Function có nhiều điều kiện if/else
   |-- Validation logic
   |-- Mapping data
   |-- Permission logic
   |-- Calculation logic
   |-- Error handling
   |-- Edge cases
   |-- Observable / async behavior
```

Ví dụ nên test:

```text
Nếu role = admin   -> được edit
Nếu role = viewer  -> không được edit
Nếu data null      -> hiển thị empty state
Nếu API lỗi        -> show error message
Nếu amount < 0     -> invalid
```

---

# 12. Unit Test không nên test cái gì?

```text
Không nên ưu tiên test
   |
   |-- Implementation detail quá nhỏ
   |-- Getter/setter đơn giản
   |-- Code chỉ gọi thư viện bên ngoài
   |-- CSS thuần
   |-- Template quá đơn giản
   |-- Logic không có branch
```

Ví dụ không cần thiết:

```ts
getName() {
  return this.name;
}
```

Test kiểu này thường ít value:

```ts
expect(component.getName()).toBe(component.name)
```

Vì nó chỉ test lại chính implementation, không bảo vệ behavior quan trọng.

---

# 13. Unit Test tốt cần có đặc điểm gì?

```text
Good Unit Test
   |
   |-- Fast
   |      |-- Chạy nhanh
   |
   |-- Isolated
   |      |-- Không phụ thuộc API/database thật
   |
   |-- Repeatable
   |      |-- Chạy nhiều lần vẫn ra cùng kết quả
   |
   |-- Clear
   |      |-- Đọc test hiểu behavior
   |
   |-- Focused
   |      |-- Một test chỉ kiểm tra một behavior chính
   |
   |-- Maintainable
          |-- Không quá phụ thuộc implementation detail
```

Công thức:

```text
A good test should fail only when behavior is broken.
```

Không nên:

```text
Test fail chỉ vì đổi tên biến nội bộ.
Test fail chỉ vì refactor private method.
Test fail dù behavior user thấy vẫn đúng.
```

---

# 14. Unit Test fail thì xử lý thế nào?

```text
Unit Test Failed
   |
   |-- 1. Đọc error message
   |
   |-- 2. Xem expected vs actual
   |
   |-- 3. Xác định nguyên nhân
   |      |
   |      |-- Code sai?
   |      |-- Test sai?
   |      |-- Requirement đổi?
   |      |-- Mock data sai?
   |
   |-- 4. Fix đúng chỗ
   |
   |-- 5. Run lại test
   |
   |-- 6. Commit khi pass
```

Quan trọng:

```text
Không phải test fail là code sai.
Có thể test cũ đang mô tả behavior cũ.
Nếu requirement thay đổi, test cũng cần update.
```

---

# 15. Unit Test trong CI/CD

```text
Developer Push Code
        |
        v
GitHub / GitLab / Azure DevOps
        |
        v
CI Pipeline Triggered
        |
        v
Install dependencies
        |
        v
Run lint
        |
        v
Run unit tests
        |
        v
Check coverage
        |
        v
Build project
        |
        v
Allow merge / block merge
```

Ý nghĩa:

```text
Nếu unit test fail
   |
   |-- PR không được merge
   |-- Team phát hiện lỗi sớm
   |-- Tránh bug đi vào main branch
```

---

# 16. Coverage là gì?

```text
Test Coverage
   |
   |-- Bao nhiêu phần trăm code được test chạy qua?
   |
   |-- Các loại coverage:
          |
          |-- Statement coverage
          |-- Branch coverage
          |-- Function coverage
          |-- Line coverage
```

Ví dụ:

```text
Coverage 80% không có nghĩa code chắc chắn đúng.
Nó chỉ nói rằng 80% dòng code đã được test chạy qua.
```

Quan trọng hơn coverage:

```text
Test có cover đúng behavior quan trọng không?
Test có cover edge cases không?
Test có giúp giảm regression không?
```

---

# 17. Mindset đúng khi viết Unit Test

```text
Wrong Mindset
   |
   |-- Viết test cho đủ coverage
   |-- Test implementation detail
   |-- Test cho có
   |-- Mock tất cả mà không hiểu behavior
   |-- Test quá nhiều case không quan trọng

Right Mindset
   |
   |-- Test behavior quan trọng
   |-- Test risk cao trước
   |-- Test edge cases
   |-- Test để tự tin refactor
   |-- Test như một tài liệu sống của requirement
```

Câu hỏi nên tự hỏi trước khi viết test:

```text
Nếu logic này sai, user/client có bị ảnh hưởng không?
Nếu sau này refactor, test này có bảo vệ behavior quan trọng không?
Case nào dễ gây regression nhất?
Dependency nào cần mock để test ổn định?
Expected behavior thật sự là gì?
```

---

# 18. Diagram tổng hợp toàn bộ Unit Test

```text
                         UNIT TEST
                             |
        ------------------------------------------------
        |                      |                       |
     Purpose              Implementation             Execution
        |                      |                       |
        |                      |                       |
  ----------------       ----------------       ----------------
  |              |       |              |       |              |
Verify        Prevent   Arrange        Mock    Test Runner    Report
logic         regression data          deps    runs tests     result
  |              |       |              |       |              |
Catch bug     Support   Act            Assert  Pass/Fail      Coverage
early         refactor  behavior       result  feedback       CI gate
        |
        v
  Developer Confidence
        |
        v
  Safer Change / Better Delivery
```

---

# 19. Unit Test theo góc nhìn Frontend Lead

Với vai trò Frontend Lead, bạn không nên nhìn Unit Test chỉ là "test code", mà nên nhìn nó như một **công cụ quản lý rủi ro**.

```text
Frontend Lead Mindset
   |
   |-- Feature có risk cao?
   |      |
   |      |-- Permission
   |      |-- Validation
   |      |-- Calculation
   |      |-- Shared component
   |      |-- Data transformation
   |
   |-- Có khả năng regression?
   |      |
   |      |-- Code dùng chung nhiều màn hình
   |      |-- Logic cũ khó hiểu
   |      |-- Requirement nhiều edge cases
   |
   |-- Có cần unit test không?
          |
          |-- Có, nếu behavior quan trọng
          |-- Có, nếu refactor shared logic
          |-- Có, nếu bug từng xảy ra trước đó
```

Cách nói với team:

```text
Không phải chỗ nào cũng cần test nhiều.
Nhưng những logic có risk cao, dễ regression, hoặc ảnh hưởng nhiều flow
thì nên có unit test để bảo vệ behavior.
```

---

# 20. Tóm tắt ngắn gọn

```text
Unit Test
   |
   |-- Là test cho một phần nhỏ của code
   |
   |-- Mục đích:
   |      |-- Kiểm tra logic
   |      |-- Bắt bug sớm
   |      |-- Giảm regression
   |      |-- Hỗ trợ refactor
   |
   |-- Cách viết:
   |      |-- Arrange
   |      |-- Act
   |      |-- Assert
   |
   |-- Cách chạy:
   |      |-- Test runner tìm file test
   |      |-- Run từng test case
   |      |-- So sánh actual với expected
   |      |-- Report pass/fail
   |
   |-- Nên test:
   |      |-- Business logic
   |      |-- Validation
   |      |-- Edge cases
   |      |-- Error handling
   |      |-- Permission
   |
   |-- Không nên test:
          |-- Implementation detail quá nhỏ
          |-- Logic quá đơn giản
          |-- Code không có risk
```

---

> **Unit Test không phải để test mọi dòng code, mà để bảo vệ những behavior quan trọng khỏi bị hỏng khi code thay đổi.**
