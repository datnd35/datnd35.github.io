---
layout: post
title: "Git Checkout Commit Cũ Để Debug - Cách Làm Đúng Của Tech Lead"
categories: git
---

Câu hỏi này rất chuẩn mindset của Tech Lead 👍 — khi cần **review / debug / rollback** mà không làm mất commit mới.

---

## 🎯 Mục tiêu

> Checkout về **1 commit cũ** để test nhưng **KHÔNG làm mất commit mới**

Đây là việc rất bình thường trong:

- Debug bug sau upgrade (ví dụ: Angular 14 → 16)
- So sánh behavior giữa version cũ vs mới
- Review PR / regression testing

---

## 🔥 Cách đúng nhất (AN TOÀN NHẤT)

### ✅ Cách 1: `git checkout <commit>` (Detached HEAD)

```bash
git checkout <commit-hash>
```

Ví dụ:

```bash
git checkout a1b2c3d
```

---

### 🧠 Điều gì xảy ra?

```
A --- B --- C --- D --- E (main)
        ↑
     checkout here
```

Bạn đang đứng tại commit `B`, nhưng:

- ❌ KHÔNG xóa commit C, D, E
- ❌ KHÔNG ảnh hưởng branch main
- ✅ Chỉ "xem lại trạng thái code lúc đó"

---

### ⚠️ Lưu ý cực quan trọng

Bạn đang ở trạng thái **DETACHED HEAD**, nghĩa là:

- Bạn KHÔNG nằm trên branch nào
- Nếu bạn commit → commit đó dễ bị "mất dấu"

---

### 👉 Quay lại hiện tại

```bash
git checkout main
```

hoặc:

```bash
git switch main
```

---

## 🚀 Cách chuyên nghiệp hơn (Dùng khi debug lâu)

### ✅ Cách 2: Tạo branch từ commit đó

```bash
git checkout -b debug-old-version <commit-hash>
```

Ví dụ:

```bash
git checkout -b debug-angular12 a1b2c3d
```

---

### 🧠 Flow

```
A --- B --- C --- D --- E (main)
        ↑
     new branch: debug-angular12
```

Lúc này bạn có branch riêng, có thể:

- Sửa code thoải mái
- Thêm log để debug
- Chạy test
- Commit không lo ảnh hưởng main

---

### 👉 Ưu điểm

- Không mất commit mới
- Không ảnh hưởng main
- Debug rất tiện, có thể mở song song với IDE

---

## ⚡ Cách 3: Dùng `git switch` (modern syntax)

```bash
git switch --detach <commit>
```

hoặc tạo branch luôn:

```bash
git switch -c debug-old <commit>
```

---

## ❌ Những thứ KHÔNG nên dùng

### 🚫 `git reset --hard`

```bash
git reset --hard <commit>
```

Lệnh này:

- ❌ Di chuyển HEAD + branch pointer
- ❌ Có thể mất commit nếu chưa push
- ❌ Nguy hiểm khi làm việc nhóm

> Chỉ dùng khi bạn **chắc chắn 100%** về hậu quả.

---

## 🧠 Tư duy Tech Lead — Debug Upgrade Angular

### 1. So sánh 2 version

```bash
# Checkout commit cũ (Angular 12)
git checkout old-commit
npm install
ng serve
```

vs

```bash
# Quay lại latest (Angular 14+)
git checkout main
npm install
ng serve
```

---

### 2. Tư duy debug theo hướng

```
OLD VERSION (OK)
       ↓
   git diff
       ↓
NEW VERSION (BROKEN)
```

---

### 3. Công cụ hỗ trợ

Xem diff giữa 2 commit:

```bash
git diff old-commit..new-commit
```

Xem lịch sử commit gọn:

```bash
git log --oneline
```

---

## 🎯 Kết luận

| Mục đích                 | Lệnh                                    |
| ------------------------ | --------------------------------------- |
| Nhanh nhất, xem tạm      | `git checkout <commit>`                 |
| Chuẩn nhất khi debug lâu | `git checkout -b debug-branch <commit>` |
| Modern syntax            | `git switch --detach <commit>`          |
| ❌ Tránh                 | `git reset --hard`                      |

---

## 🔥 Bonus: `git bisect` — Siêu mạnh cho debug upgrade

Nếu bạn đang debug bug sau upgrade Angular mà không biết commit nào gây ra lỗi, dùng:

```bash
git bisect start
git bisect bad                  # commit hiện tại là broken
git bisect good <commit-hash>   # commit cũ còn OK
```

Git sẽ tự động **binary search** qua các commit và chỉ ra chính xác commit nào gây bug. Siêu hữu ích cho case upgrade nhiều dependency cùng lúc.

---

## 📌 Tóm tắt workflow thực chiến

```
1. git log --oneline              → tìm commit cần test
2. git checkout -b debug-xxx <hash>  → tạo branch an toàn
3. npm install && ng serve        → reproduce bug
4. git diff old..new              → tìm nguyên nhân
5. git switch main                → quay lại làm việc bình thường
6. git branch -d debug-xxx        → dọn dẹp sau khi xong
```

> **Nguyên tắc vàng:** Không bao giờ dùng `git reset --hard` khi debug — luôn tạo branch mới để giữ an toàn cho lịch sử commit.
