---
layout: post
title: "Áp dụng AI vào dự án max4-web: Đừng dùng AI như công cụ viết code, hãy dùng như một kỹ sư trong team"
date: 2026-06-20
categories: ai
tags:
  [ai, max4-web, software-engineering, legacy, regression, testing, workflow]
track: "ai-tools"
---

Cách áp dụng AI hiệu quả nhất cho **max4-web** không phải là yêu cầu AI:

> “Hãy implement task này giúp tôi.”

Thay vào đó, hãy đưa AI vào một quy trình phát triển phần mềm rõ ràng, giống như cách chúng ta làm việc với một kỹ sư trong team:

```text
Customer Task
     ↓
Phân tích yêu cầu
     ↓
Đánh giá phạm vi ảnh hưởng
     ↓
Lập kế hoạch implementation
     ↓
Implement từng phần nhỏ
     ↓
Review theo mindset regression
     ↓
Chạy test và thu thập bằng chứng
     ↓
Gửi PR / cập nhật cho khách hàng
```

AI không nên chỉ tạo ra code.

AI cần hỗ trợ kỹ sư hiểu task, kiểm tra business logic, dự đoán rủi ro và chứng minh rằng thay đổi mới không làm hỏng chức năng cũ.

---

## 1) Chuẩn hóa đầu vào task trước khi đưa cho AI

Trước khi bắt đầu implement, mỗi task nên có tối thiểu:

- Mục tiêu nghiệp vụ
- Phạm vi thực hiện
- Phạm vi không thực hiện
- Dữ liệu đầu vào
- Hành vi mong đợi
- Acceptance criteria
- Những flow cũ có thể bị ảnh hưởng

Ví dụ, thay vì chỉ đưa cho AI một yêu cầu ngắn:

> “Update channel selection for export.”

Nên bổ sung:

```text
Business goal:
Người dùng phải chọn đúng channel trước khi export dữ liệu.

In scope:
- Export Openwind
- Export WindPro
- Channel selection helper

Out of scope:
- Thay đổi cấu trúc API
- Refactor toàn bộ export module

Expected behavior:
- Nếu có channel hợp lệ, sử dụng channel đó.
- Nếu không có channel hợp lệ, hiển thị warning theo pattern hiện tại.
- Không làm thay đổi hành vi của các export flow khác.

Acceptance criteria:
- Openwind export hoạt động đúng.
- WindPro export hoạt động đúng.
- Existing tests vẫn pass.
- Có test cho trường hợp không tìm thấy channel.
```

Nguyên tắc quan trọng:

> Không nên cho AI viết code khi acceptance criteria vẫn chưa rõ.

Nếu yêu cầu từ khách hàng chưa đầy đủ, nhiệm vụ đầu tiên của AI phải là tìm ra những phần còn thiếu, chứ không phải tự đoán business rule.

---

## 2) Cho AI phân tích impact trước khi code

Trong một dự án legacy, thay đổi nhỏ trên giao diện có thể ảnh hưởng đến nhiều tầng khác nhau:

```text
Route
  ↓
Page / View
  ↓
Component
  ↓
Helper / Store
  ↓
Service
  ↓
REST interface
  ↓
Backend API
```

Vì vậy, trước khi implement, hãy yêu cầu AI tìm:

- Route liên quan
- View hoặc component liên quan
- Helper được sử dụng
- Service gọi API
- Error-handling pattern
- Unit test hoặc integration test hiện có
- Các flow khác đang tái sử dụng logic đó

Với **max4-web**, việc phân tích có thể bắt đầu từ:

- `router.js`
- `services.js`

Sau đó lần theo dependency đến các component, helper và API interface liên quan.

Prompt có thể dùng:

> Hãy đọc task này và phân tích phạm vi ảnh hưởng trong max4-web. Liệt kê impacted files theo các nhóm route, view, component, helper, service, API và test. Với mỗi file, giải thích tại sao file đó có thể bị ảnh hưởng. Sắp xếp theo mức độ ưu tiên từ cao xuống thấp.

Kết quả mong đợi không chỉ là danh sách file, mà phải tạo ra được một **impact map**:

```text
Task: Update channel selection
          |
          +-- channelsHelper.js
          |      |
          |      +-- Channel selection rule
          |
          +-- ExportOpenwind.vue
          |      |
          |      +-- Uses selected channel
          |
          +-- ExportWindPro.vue
          |      |
          |      +-- Uses selected channel
          |
          +-- restInterface.js
                 |
                 +-- Warning / Error handling
```

Impact analysis giúp tránh tình trạng AI sửa đúng một component nhưng bỏ sót các flow khác đang dùng chung helper.

---

## 3) Bắt buộc AI lập plan trước khi implement

AI không nên chuyển ngay từ yêu cầu sang code.

Trước khi sửa file, AI cần tạo một implementation plan ngắn, bao gồm:

- Mục tiêu của từng bước
- File dự kiến thay đổi
- Business rule được áp dụng
- Rủi ro regression
- Test cần chạy
- Tiêu chí hoàn thành
- Rollback note

Ví dụ:

```text
Step 1: Characterize current channel behavior
File:
- channelsHelper.js
- Existing helper tests

Verification:
- Ghi nhận hành vi hiện tại bằng test.

Done:
- Test mô tả đúng behavior cũ và đang pass.

Step 2: Update channel selection rule
File:
- channelsHelper.js

Verification:
- Unit test cho valid channel.
- Unit test cho missing channel.
- Unit test cho fallback behavior.

Done:
- Helper trả về kết quả đúng theo acceptance criteria.

Step 3: Verify export consumers
Files:
- ExportOpenwind.vue
- ExportWindPro.vue

Verification:
- Component tests hoặc manual flow.
- Không thay đổi payload ngoài phạm vi task.

Done:
- Hai flow export hoạt động đúng.

Step 4: Regression verification
Commands:
- lint
- test
- test:csv
- build

Done:
- Tất cả command pass.
```

Plan này giúp kỹ sư kiểm soát AI, review từng bước và phát hiện sớm khi AI bắt đầu mở rộng phạm vi không cần thiết.

---

## 4) Implement theo từng lát nhỏ, có thể review được

Một trong những rủi ro lớn nhất khi dùng AI là AI thường muốn “cải thiện” quá nhiều thứ cùng lúc.

Ví dụ, task chỉ cần sửa logic chọn channel nhưng AI có thể đề xuất:

- Refactor helper
- Đổi tên biến
- Tách component
- Thay đổi service
- Chuẩn hóa error handling
- Cập nhật toàn bộ export module

Điều này khiến PR lớn hơn, khó review hơn và tăng regression risk.

Cách tốt hơn là chia thay đổi thành những lát nhỏ:

```text
Test mô tả behavior cũ
        ↓
Thay đổi một helper
        ↓
Test helper
        ↓
Kiểm tra một consumer
        ↓
Kiểm tra consumer còn lại
        ↓
Chạy regression suite
```

Mỗi bước nên trả lời được ba câu hỏi:

1. Bước này thay đổi hành vi nào?
2. Làm sao chứng minh nó hoạt động?
3. Nếu sai thì có thể rollback riêng bước này không?

Nguyên tắc:

> Một task nhỏ không nên biến thành một cuộc refactor lớn chỉ vì AI cho rằng code có thể “đẹp hơn”.

---

## 5) Verification phải giống CI, không chỉ “chạy local thấy được”

Việc ứng dụng chạy được trên máy local chưa chứng minh rằng task đã hoàn thành.

Dự án **max4-web** đã có các command kiểm tra trong `package.json` và pipeline trong `Jenkinsfile`, chẳng hạn:

```text
lint
test
test:csv
build
```

Vì vậy, AI cần được yêu cầu xác minh thay đổi theo cùng tiêu chuẩn với CI.

```text
Code change
    |
    +-- Lint pass?
    |
    +-- Unit tests pass?
    |
    +-- CSV-related tests pass?
    |
    +-- Production build pass?
    |
    +-- Existing behavior preserved?
```

Có bốn mức verification khác nhau:

### Mức 1: Static verification

- Lint
- Type check nếu dự án hỗ trợ
- Import và syntax validation

### Mức 2: Unit verification

- Helper
- Service
- Business rules
- Edge cases

### Mức 3: Flow verification

- Component interaction
- Request payload
- Warning/error behavior
- Export result

### Mức 4: Regression verification

- Existing test suite
- Build production
- Các flow dùng chung logic vừa thay đổi

Chỉ “compile pass” không có nghĩa là business logic đúng.

---

## 6) Với code legacy, hãy thêm characterization test trước

Một điểm cần lưu ý trong **max4-web** là dự án vẫn còn khoảng trống test ở các vùng legacy, thể hiện qua ignore pattern trong `jest.config.js`.

Khi thay đổi một vùng code cũ nhưng chưa có test, không nên sửa trực tiếp.

Nên thêm **characterization test** trước.

Characterization test không nhằm chứng minh behavior hiện tại là tối ưu. Nó ghi lại hệ thống đang hoạt động như thế nào trước khi chúng ta thay đổi.

```text
Legacy code chưa có test
        ↓
Viết test ghi nhận behavior hiện tại
        ↓
Chạy test và xác nhận baseline
        ↓
Thay đổi business rule
        ↓
Cập nhật hoặc bổ sung test mới
        ↓
So sánh behavior trước và sau
```

Điều này đặc biệt quan trọng khi:

- Code được viết từ lâu
- Business rule không có tài liệu
- Nhiều component dùng chung helper
- Khách hàng chỉ mô tả một phần yêu cầu
- Không chắc behavior cũ là chủ ý hay bug

Nguyên tắc:

> Không refactor rộng một flow legacy khi chưa có baseline test.

---

## 7) Tuân theo error-handling pattern hiện có

Trong **max4-web**, API và error handling đã có logic tập trung tại `restInterface.js`.

Vì vậy, khi implement, không nên để AI tự tạo một cơ chế xử lý lỗi mới trong từng component.

AI cần được yêu cầu:

- Đọc pattern Warning/Error hiện tại
- Xác định trường hợp nào là warning
- Xác định trường hợp nào là error
- Tái sử dụng message format hiện có
- Không swallow error
- Không hiển thị trùng thông báo
- Không thay đổi hành vi API ngoài phạm vi task

```text
API Response
     ↓
restInterface.js
     |
     +-- Success → Return normalized data
     |
     +-- Warning → Existing warning pattern
     |
     +-- Error   → Existing error pattern
```

Prompt có thể dùng:

> Hãy đọc cách `restInterface.js` đang xử lý Warning và Error. Khi implement task này, phải tuân theo pattern hiện tại. Không tạo cơ chế xử lý lỗi mới nếu chưa chứng minh pattern hiện tại không đáp ứng được yêu cầu.

Đây là cách hạn chế việc AI tạo ra code đúng về mặt kỹ thuật nhưng không nhất quán với kiến trúc dự án.

---

## 8) Chọn pilot AI ở phạm vi nhỏ nhưng có tác động thật

Không nên bắt đầu áp dụng AI bằng một module quá lớn.

Một khu vực phù hợp để thử nghiệm trong **max4-web** là helper chọn channel tại:

```text
channelsHelper.js
```

Logic này có phạm vi đủ nhỏ để kiểm soát, nhưng lại ảnh hưởng trực tiếp đến các flow thực tế như:

```text
channelsHelper.js
       |
       +-- ExportOpenwind.vue
       |
       +-- ExportWindPro.vue
```

Đây là một pilot tốt vì có thể đánh giá được:

- AI có tìm đúng dependency không?
- AI có hiểu business rule từ code hiện tại không?
- AI có phát hiện được hai consumer không?
- AI có thêm test phù hợp không?
- AI có giữ nguyên error-handling pattern không?
- AI có chứng minh được không regress không?

Sau khi workflow hoạt động ổn định ở phạm vi này, mới mở rộng sang service hoặc module lớn hơn.

---

## 9) Ba prompt có thể sử dụng hằng ngày

### Prompt phân tích task

> Hãy đọc task này và phân tích phạm vi ảnh hưởng trong max4-web. Liệt kê impacted files theo route, view, component, helper, service, API interface và test. Với mỗi file, giải thích business logic liên quan, regression risk và cách xác minh. Sắp xếp findings từ mức độ ảnh hưởng cao xuống thấp. Không implement code ở bước này.

### Prompt lập kế hoạch trước khi code

> Hãy tạo implementation plan theo từng bước nhỏ và review được. Mỗi bước cần có: mục tiêu, business rule, file thay đổi, thay đổi hành vi dự kiến, test xác minh, regression risk, tiêu chí Done và rollback note. Không refactor ngoài phạm vi acceptance criteria.

### Prompt review trước khi mở PR

> Hãy review thay đổi này theo mindset regression. Tìm các khác biệt hành vi, side effect, edge case, business rule đang bị suy đoán, lỗi xử lý Warning/Error và test còn thiếu. Ưu tiên findings quan trọng nhất trước. Với mỗi finding, cung cấp file, lý do, mức độ rủi ro và cách sửa đề xuất.

---

## 10) Evidence cần gửi cho khách hàng hoặc đính kèm PR

Một PR tốt không chỉ nói rằng:

> “Task đã hoàn thành.”

Nó cần cung cấp bằng chứng:

```text
What changed?
Why was it changed?
Which flows are affected?
Which flows are intentionally not affected?
What tests passed?
What risks remain?
```

Template ngắn có thể sử dụng:

```text
Summary:
- Updated channel selection logic.
- Reused the existing Warning/Error handling pattern.

Affected flows:
- Openwind export
- WindPro export

Not affected:
- Other export formats
- API contract
- Routing

Verification:
- Lint: Passed
- Unit tests: Passed
- CSV tests: Passed
- Production build: Passed
- Manual Openwind flow: Passed
- Manual WindPro flow: Passed

Remaining risks:
- Some legacy flows still have limited automated test coverage.
```

Cách báo cáo này giúp khách hàng hiểu được không chỉ “đã sửa gì”, mà còn biết đội phát triển đã kiểm soát rủi ro như thế nào.

---

## Nguyên tắc vàng khi dùng AI trong dự án legacy

1. Không cho AI code khi chưa có acceptance criteria.
2. Không merge chỉ vì code compile hoặc build pass.
3. Không refactor rộng khi chưa có baseline test cho flow cũ.
4. Không để AI tự đoán business rule.
5. Luôn yêu cầu AI trích dẫn business rule từ code, test hoặc tài liệu hiện có.
6. Luôn phân tích các consumer của helper hoặc service dùng chung.
7. Luôn review thay đổi theo mindset regression.
8. AI đề xuất, nhưng kỹ sư chịu trách nhiệm quyết định.

---

## Kết luận

Giá trị lớn nhất của AI trong **max4-web** không nằm ở việc viết code nhanh hơn.

Giá trị thực sự nằm ở khả năng hỗ trợ kỹ sư:

- Hiểu task nhanh hơn
- Lần theo business logic trong codebase
- Xác định phạm vi ảnh hưởng
- Lập kế hoạch rõ ràng
- Phát hiện regression risk
- Tạo và bổ sung test
- Review thay đổi có hệ thống
- Chuẩn hóa bằng chứng trước khi gửi khách hàng

Quy trình đề xuất:

```text
Task Intake
    ↓
Clarify Acceptance Criteria
    ↓
Impact Analysis
    ↓
Implementation Plan
    ↓
Characterization Test
    ↓
Small Implementation
    ↓
Regression Review
    ↓
CI Verification
    ↓
Evidence for PR / Customer
```

Đừng dùng AI như một công cụ autocomplete nâng cao.

Hãy sử dụng AI như một kỹ sư trong team — nhưng là một kỹ sư luôn cần được cung cấp đúng context, giới hạn phạm vi, review kết quả và yêu cầu chứng minh mọi thay đổi.
