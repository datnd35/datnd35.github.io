---
layout: post
title: "flutter lifecycle"
categories: misc
---

# Roadmap

## 1. **Cơ bản về Dart**

Flutter sử dụng Dart, vì vậy bạn cần hiểu các khái niệm sau:

- Cú pháp cơ bản (biến, kiểu dữ liệu, toán tử, vòng lặp, điều kiện)
- Lập trình hướng đối tượng trong Dart (class, object, inheritance, mixins)
- Future, async/await, Stream
- Collections (List, Set, Map)

## 2. **Flutter Fundamentals**

- Cấu trúc dự án trong Flutter
- Widget cơ bản (StatelessWidget, StatefulWidget)
- Quản lý trạng thái (setState, InheritedWidget)
- Navigation và Routing
- Xử lý sự kiện và tương tác người dùng

## 3. **Giao diện UI/UX**

- Layout system (Row, Column, Stack, Expanded, Flex)
- Widget nâng cao (ListView, GridView, PageView, CustomPaint)
- Themes & Custom Styles

## 4. **Quản lý trạng thái (State Management)**

- Provider (cơ bản và nâng cao)
- Riverpod, Bloc, Redux (nếu cần mô hình phức tạp hơn)

## 5. **Tương tác với Backend**

- HTTP Requests (Dio, http package)
- Xử lý API (RESTful API, GraphQL)
- Local Storage (SharedPreferences, Hive, SQLite)

## 6. **Tích hợp và nâng cao**

- Firebase (Authentication, Firestore, Push Notification)
- Xử lý đa nền tảng (Android & iOS setup)
- Testing (Unit Test, Widget Test)
- CI/CD (Codemagic, GitHub Actions)

# Diagram

```mermaid
graph TD
  A[Dart Cơ Bản] -->|1| A1[Cú pháp: biến, kiểu dữ liệu, vòng lặp, điều kiện]
  A -->|2| A2[OOP: class, object, inheritance, mixins]
  A -->|3| A3[Future, async/await, Stream]
  A -->|4| A4[Collections: List, Set, Map]

  B[Flutter Fundamentals] -->|1| B1[Cấu trúc dự án]
  B -->|2| B2[Widget cơ bản: StatelessWidget, StatefulWidget]
  B -->|3| B3[Quản lý trạng thái: setState, InheritedWidget]
  B -->|4| B4[Navigation và Routing]
  B -->|5| B5[Xử lý sự kiện và tương tác người dùng]

  C[Giao diện UI/UX] -->|1| C1[Layout System: Row, Column, Stack]
  C -->|2| C2[Widget nâng cao: ListView, GridView, PageView]
  C -->|3| C3[Themes & Custom Styles]

  D[Quản lý trạng thái] -->|1| D1[Provider: cơ bản và nâng cao]
  D -->|2| D2[Riverpod, Bloc, Redux]

  E[Tương tác với Backend] -->|1| E1[HTTP Requests: Dio, http package]
  E -->|2| E2[Xử lý API: RESTful API, GraphQL]
  E -->|3| E3[Local Storage: SharedPreferences, Hive, SQLite]

  F[Tích hợp và nâng cao] -->|1| F1[Firebase: Authentication, Firestore, Push Notification]
  F -->|2| F2[Hỗ trợ đa nền tảng: Android & iOS Setup]
  F -->|3| F3[Testing: Unit Test, Widget Test]
  F -->|4| F4[CI/CD: Codemagic, GitHub Actions]

  %% Kết nối các nhóm kiến thức
  A --> B
  B --> C
  C --> D
  D --> E
  E --> F
```
