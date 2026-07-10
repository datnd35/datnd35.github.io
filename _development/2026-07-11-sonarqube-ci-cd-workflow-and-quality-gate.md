---
track: "angular-code-quality"
layout: post
title: "SonarQube trong CI/CD: Kiến trúc, Luồng hoạt động và Quality Gate"
subtitle: "Hiểu end-to-end cách SonarQube bảo vệ chất lượng mã nguồn trong pipeline"
description: "Bài viết tổng hợp kiến trúc SonarQube trong CI/CD, flow phân tích code, Quality Gate PASS/FAIL, và ví dụ áp dụng thực tế với Angular."
tags:
  [
    sonarqube,
    ci-cd,
    quality-gate,
    static-analysis,
    code-quality,
    devops,
    angular,
    testing,
    coverage,
  ]
categories: [Development]
---

> Mục tiêu của bài viết là giúp team nhìn rõ **toàn bộ vòng đời kiểm soát code quality**: từ lúc developer push code cho đến khi pipeline quyết định **deploy hay dừng** dựa trên Quality Gate.

---

## 1. Tổng quan kiến trúc SonarQube

```text
                    +----------------+
                    |   Developer    |
                    | VSCode/IntelliJ|
                    +-------+--------+
                            |
                    Commit / Push Code
                            |
                            v
                    +----------------+
                    | Git Repository |
                    | GitHub/GitLab  |
                    +-------+--------+
                            |
                Trigger CI/CD Pipeline
                            |
                            v
        +------------------------------------+
        | Jenkins / GitHub Actions / GitLab  |
        +----------------+-------------------+
                         |
                  Build & Unit Test
                         |
              Generate Coverage Report
                (JaCoCo, LCOV, etc.)
                         |
                         v
                Sonar Scanner Execute
                         |
        sonar-project.properties
        sonar.host.url
        sonar.login/token
                         |
                         v
               +----------------------+
               |      SonarQube       |
               |----------------------|
               | Rule Engine          |
               | Code Smells          |
               | Bugs                 |
               | Vulnerabilities      |
               | Coverage             |
               | Duplicated Code      |
               | Quality Gate         |
               +----------+-----------+
                          |
             Store Analysis Result
                          |
                          v
                  +---------------+
                  | PostgreSQL DB |
                  +---------------+
                          |
                          v
                 SonarQube Dashboard
                          |
          +---------------+----------------+
          |                                |
          v                                v
   Developers                     Tech Lead / Manager
```

---

## 2. Luồng hoạt động end-to-end

```text
Developer
    |
    | Commit Code
    v
Git Repository
    |
    | Trigger Pipeline
    v
CI/CD
    |
    +--> Build
    |
    +--> Unit Test
    |
    +--> Generate Coverage
    |
    +--> Run Sonar Scanner
              |
              v
        SonarQube Server
              |
      Analyze Source Code
              |
      Compare with Rules
              |
      Generate Report
              |
      Evaluate Quality Gate
              |
      +--------+---------+
      |                  |
      | PASS             | FAIL
      |                  |
      v                  v
 Deploy Continue     Stop Pipeline
```

Điểm quan trọng:

- **SonarQube không build ứng dụng thay CI**; nó dùng output từ build/test/coverage để phân tích sâu hơn.
- **Quality Gate là cơ chế ra quyết định** để bảo vệ production khỏi mã nguồn chất lượng kém.

---

## 3. Thành phần chính và vai trò

## Developer

Lập trình viên viết code và commit lên repository.

Ví dụ code đơn giản:

```ts
function add(a, b) {
  return a + b;
}
```

---

## Git Repository

Nơi lưu source code và kích hoạt pipeline khi có thay đổi.

Ví dụ:

- GitHub
- GitLab
- Bitbucket

---

## CI/CD

Các nền tảng thường dùng:

- Jenkins
- GitHub Actions
- Azure DevOps
- GitLab CI

Pipeline điển hình:

```text
Checkout

↓

Install Dependencies

↓

Build

↓

Run Unit Test

↓

Generate Coverage

↓

Run Sonar Scanner

↓

Deploy
```

---

## Sonar Scanner

Thành phần gửi source code và report lên SonarQube.

Ví dụ lệnh:

```bash
sonar-scanner
```

```bash
mvn sonar:sonar
```

```bash
./gradlew sonarqube
```

Scanner thường gửi:

- Source Code
- Coverage Report
- Test Report
- Branch metadata
- Commit information

---

## SonarQube Server

Đây là "bộ não" phân tích chất lượng mã nguồn.

### Bugs

Ví dụ rủi ro null:

```java
if (name.equals(null))
```

Có thể gây `NullPointerException`.

### Vulnerabilities

Ví dụ SQL Injection:

```java
String sql = "SELECT * FROM User WHERE id=" + id;
```

### Code Smells

Ví dụ hàm quá nhiều nhánh lồng nhau:

```java
public void process() {
  if (...) {
    ...
  } else if (...) {
    ...
  } else if (...) {
    ...
  } else if (...) {
    ...
  }
}
```

### Duplicated Code

Ví dụ logic trùng lặp nhiều nơi:

```java
calculateTax();
...
calculateTax();
```

### Coverage

SonarQube đọc dữ liệu từ:

- JaCoCo
- LCOV
- Cobertura

Ví dụ:

```text
Coverage = 82%
```

### Maintainability

Đánh giá:

- Độ dễ đọc
- Độ dễ sửa
- Complexity

### Reliability

Đánh giá theo nhóm lỗi Bugs và mức độ ổn định.

### Security

Đánh giá theo nhóm lỗ hổng Vulnerabilities.

---

## Database

SonarQube lưu kết quả vào PostgreSQL.

Ví dụ dữ liệu lưu trữ:

```text
Project
History
Issues
Users
Rules
Quality Gate
```

---

## Dashboard

Dashboard cung cấp số liệu để developer và quản lý theo dõi.

```text
Project

Coverage
78%

Duplications
2.1%

Bugs
5

Vulnerabilities
1

Code Smells
92
```

Bạn có thể click vào từng issue để xem chính xác file, line và rule bị vi phạm.

---

## 4. Quality Gate (trung tâm kiểm soát chất lượng)

Ví dụ điều kiện gate:

```text
Coverage > 80%

AND

Bugs = 0

AND

Critical Vulnerabilities = 0

AND

Duplicated < 3%
```

Nếu không đạt:

```text
Quality Gate = FAILED
```

Pipeline có thể dừng ở bước kiểm soát chất lượng để ngăn deploy.

### Diagram Quality Gate

```text
               SonarQube Analysis

                     |
                     |
        +------------+-------------+
        |                          |
 Coverage >=80% ?             Bugs == 0 ?
        |                          |
        +------------+-------------+
                     |
        Vulnerabilities == 0 ?
                     |
             Duplication <3% ?
                     |
             +-------+-------+
             |               |
            PASS           FAIL
             |               |
             v               v
      Continue CI      Stop Deployment
```

---

## 5. Ví dụ thực tế với Angular

```text
Angular Project

src/

app/

components/

services/

...

↓

npm test -- --code-coverage

↓

coverage/lcov.info

↓

sonar-scanner

↓

SonarQube

↓

Dashboard
```

SonarQube sẽ đọc file sau để tính coverage:

```text
coverage/lcov.info
```

---

## 6. Quy trình đầy đủ trong doanh nghiệp

```text
                 Developer
                     |
              Write Feature Code
                     |
                     v
                Local Unit Test
                     |
                     v
               Commit / Push Git
                     |
                     v
              GitHub / GitLab Repo
                     |
                     v
             CI/CD Pipeline Trigger
                     |
          +----------+-----------+
          |                      |
          | Build Application    |
          |                      |
          +----------+-----------+
                     |
               Run Unit Tests
                     |
                     v
         Generate Coverage Report
                     |
                     v
              Sonar Scanner
                     |
                     v
          +-----------------------+
          |    SonarQube Server   |
          |-----------------------|
          | Static Code Analysis  |
          | Bugs                  |
          | Code Smells           |
          | Vulnerabilities       |
          | Coverage              |
          | Duplications          |
          | Maintainability       |
          | Reliability           |
          +-----------+-----------+
                      |
              Save into Database
                      |
             Evaluate Quality Gate
                      |
         +------------+------------+
         |                         |
         | PASS                    | FAIL
         |                         |
         v                         v
   Continue Deploy          Stop Pipeline
         |
         v
      Production
```

---

## 7. Tóm tắt vai trò từng thành phần

| Thành phần           | Vai trò                                                                                                      |
| -------------------- | ------------------------------------------------------------------------------------------------------------ |
| **Developer**        | Viết và commit code.                                                                                         |
| **Git Repository**   | Lưu trữ mã nguồn và kích hoạt pipeline khi có thay đổi.                                                      |
| **CI/CD**            | Build, chạy test, tạo báo cáo coverage và gọi Sonar Scanner.                                                 |
| **Sonar Scanner**    | Thu thập mã nguồn và báo cáo (coverage, test) rồi gửi lên SonarQube.                                         |
| **SonarQube Server** | Phân tích chất lượng mã: Bugs, Vulnerabilities, Code Smells, Duplications, Coverage và áp dụng Quality Gate. |
| **PostgreSQL**       | Lưu lịch sử phân tích, cấu hình, quy tắc và kết quả.                                                         |
| **Dashboard**        | Hiển thị báo cáo chi tiết để Developer, Tech Lead và Manager theo dõi và xử lý vấn đề.                       |
| **Quality Gate**     | Đưa ra quyết định PASS/FAIL; nếu không đạt, pipeline có thể dừng và không cho phép triển khai.               |

### Ví dụ pipeline Angular điển hình

1. Developer push code lên Git.
2. CI chạy `npm install`.
3. Build ứng dụng bằng `ng build`.
4. Chạy `ng test --code-coverage` để tạo `coverage/lcov.info`.
5. Chạy `sonar-scanner`.
6. SonarQube phân tích:
   - Code Smells
   - Bugs
   - Vulnerabilities
   - Coverage
   - Duplicated Code
7. Nếu **Quality Gate = PASS**, pipeline tiếp tục deploy; nếu **FAIL**, pipeline dừng để team khắc phục trước khi triển khai.

---

## Kết luận

SonarQube không chỉ là công cụ "báo lỗi", mà là một **quality control layer** trong DevOps. Khi kết hợp đúng với CI/CD và Quality Gate, team sẽ:

- Phát hiện lỗi sớm trước production
- Chuẩn hóa chất lượng code giữa nhiều developer
- Giảm technical debt theo thời gian
- Tăng độ tin cậy khi release

Nếu bạn đang xây dựng quy trình engineering bài bản, hãy xem SonarQube là một checkpoint bắt buộc trong pipeline — giống như test và build.
