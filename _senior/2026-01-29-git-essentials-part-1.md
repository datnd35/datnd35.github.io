---
layout: post
title: "Git Essentials Part 1 - Timeline, History & Debugging"
date: 2026-01-29
categories: senior
---

## 🎯 Tại Sao Senior Dev Cần Thành Thạo Git?

Bạn có thể code Angular/React rất giỏi, nhưng nếu không biết Git chuyên sâu, bạn sẽ:

- ❌ Mất thời gian debug bug đã fix
- ❌ Không trace được ai viết code gây lỗi
- ❌ Không biết revert/reset khi deploy lỗi
- ❌ Không làm việc hiệu quả trong team

**Câu hỏi phỏng vấn Senior thường gặp:**

- "Làm thế nào để tìm commit gây bug trong production?"
- "Phân biệt git reset vs revert vs rebase?"
- "Xử lý conflict khi rebase như thế nào?"
- "Git workflow team bạn dùng là gì?"

→ **Để trả lời tốt, bạn cần hiểu Git ở cấp độ Senior, không chỉ commit/push/pull cơ bản.**

---

## 🔥 Tư Duy Git Của Senior Khác Mid Ở Đâu?

### So Sánh

| Mid-Level Developer | Senior Developer |
|---------------------|------------------|
| Git chỉ để commit code | Git là công cụ debug & audit |
| Chỉ dùng: add, commit, push | Dùng: log, blame, diff, reflog, bisect |
| Sợ conflict | Tự tin resolve conflict |
| Commit lung tung | Commit rõ ràng, có ý nghĩa |
| Không biết rebase | Dùng rebase để clean history |

### Mindset Shift

```
MID:
"Git là nơi lưu code"

SENIOR:
"Git là:
├─ Timeline của codebase
├─ Công cụ debug bug
├─ Audit trail (ai sửa gì, khi nào)
├─ Time machine (quay về code cũ)
└─ Communication tool (commit message)"
```

---

## 📜 1. Xem Lịch Sử Commit (Git Timeline)

### Mục Đích

Biết:
- Ai commit?
- Khi nào commit?
- Commit nào thay đổi gì?

---

### 1.1 Lệnh Cơ Bản

```bash
git log
```

**Output:**

```
commit a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0
Author: Dat Nguyen <dat@example.com>
Date:   Mon Jan 28 10:30:00 2026 +0700

    Fix payment processing bug
    
    - Fixed null pointer exception in PaymentService
    - Added validation for credit card expiry
    - Updated unit tests

commit b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1
Author: John Doe <john@example.com>
Date:   Sun Jan 27 15:20:00 2026 +0700

    Update gulp build configuration
```

---

### 1.2 Lệnh Gọn Cho Dev Dùng Hằng Ngày

```bash
git log --oneline
```

**Output:**

```
a1b2c3 Fix payment bug
b2c3d4 Update gulpfile
c3d4e5 Refactor service
d4e5f6 Add new feature
e5f6g7 Fix typo
```

**👉 Dùng khi:**
- Muốn xem nhanh lịch sử commit
- Tìm commit để checkout/revert/diff
- Code review nhanh

---

### 1.3 Xem Lịch Sử Dạng Graph

```bash
git log --oneline --graph --decorate
```

**Output:**

```
* a1b2c3 (HEAD -> feature/payment) Fix payment bug
* b2c3d4 Update validation
| * c3d4e5 (main) Merge branch 'develop'
|/
* d4e5f6 Refactor service
* e5f6g7 (tag: v1.0.0) Release version 1.0.0
```

**👉 Dùng khi:**
- Debug branch structure
- Hiểu merge history
- Kiểm tra branch divergence

---

### 1.4 Xem Commit Với Thông Tin Chi Tiết

```bash
git log --pretty=format:"%h %ad %an %s" --date=short
```

**Output:**

```
a1b2c3 2026-01-28 Dat Nguyen Fix payment bug
b2c3d4 2026-01-27 John Doe Update gulpfile
c3d4e5 2026-01-26 Jane Smith Refactor service
```

**Format placeholders:**

| Placeholder | Meaning |
|-------------|---------|
| `%h` | Short commit hash |
| `%ad` | Author date |
| `%an` | Author name |
| `%ae` | Author email |
| `%s` | Commit subject |
| `%b` | Commit body |

---

## ⏰ 2. Xem Commit Theo Khoảng Thời Gian

### Mục Đích

Tìm commit theo **ngày** hoặc **khoảng thời gian cụ thể**.

---

### 2.1 Xem Commit Từ Ngày Cụ Thể

```bash
git log --since="2026-01-13" --until="now"
```

---

### 2.2 Xem Commit Với Format Đẹp

```bash
git log --since="2026-01-13" --until="now" \
  --pretty=format:"%h %ad %an %s" --date=local
```

**Output:**

```
ab1234 Mon Jan 20 14:30:00 2026 Dat Nguyen fix proxy config
cd5678 Wed Jan 18 09:15:00 2026 John Doe update gulp build
ef9012 Fri Jan 15 16:45:00 2026 Jane Smith refactor payment service
```

---

### 2.3 Các Tùy Chọn Thời Gian

```bash
# Commit trong 7 ngày qua
git log --since="1 week ago"

# Commit trong 2 tuần qua
git log --since="2 weeks ago"

# Commit trong tháng này
git log --since="1 month ago"

# Commit từ ngày cụ thể
git log --since="2026-01-01"

# Commit trong khoảng thời gian
git log --since="2026-01-01" --until="2026-01-15"

# Commit hôm nay
git log --since="midnight"

# Commit hôm qua
git log --since="yesterday"
```

**👉 Dùng khi:**
- Audit code changes
- Tìm bug xuất hiện trong khoảng thời gian
- Code review theo sprint
- Viết release notes

---

## 📁 3. Xem Commit Liên Quan Đến File

### Mục Đích

Biết **file này bị sửa khi nào** và **ai sửa**.

---

### 3.1 Xem Lịch Sử Của File

```bash
git log app.component.ts
```

**Output:**

```
commit a1b2c3
Author: Dat Nguyen <dat@example.com>
Date:   Mon Jan 28 10:30:00 2026

    Fix change detection issue
    
commit b2c3d4
Author: John Doe <john@example.com>
Date:   Sun Jan 27 15:20:00 2026

    Update component logic
```

---

### 3.2 Xem Gọn Với Oneline

```bash
git log --oneline -- app.component.ts
```

**Output:**

```
a1b2c3 Fix change detection
b2c3d4 Update component logic
c3d4e5 Add new feature
d4e5f6 Refactor component
```

---

### 3.3 Xem Chi Tiết Thay Đổi Của File

```bash
git log -p app.component.ts
```

**Output:**

```
commit a1b2c3
Author: Dat Nguyen <dat@example.com>
Date:   Mon Jan 28 10:30:00 2026

    Fix change detection

diff --git a/app.component.ts b/app.component.ts
index 1234567..abcdefg 100644
--- a/app.component.ts
+++ b/app.component.ts
@@ -10,7 +10,7 @@
 export class AppComponent {
-  value = 10;
+  value = 20;
 }
```

---

### 3.4 Xem File Đã Bị Xóa

```bash
git log --all --full-history -- path/to/deleted-file.ts
```

**👉 Dùng khi:**
- Debug bug liên quan đến file cụ thể
- Tìm commit gây lỗi
- Xem ai và khi nào file bị sửa
- Recovery file đã xóa

---

## 🔍 4. Xem Ai Viết Dòng Code (Git Blame)

### Mục Đích

Biết:
- Dòng code này do **ai viết**
- **Commit nào**
- **Khi nào**

---

### 4.1 Blame Toàn Bộ File

```bash
git blame app.component.ts
```

**Output:**

```
a1b2c3d4 (Dat Nguyen 2026-01-28 10:30:00 +0700  1) import { Component } from '@angular/core';
a1b2c3d4 (Dat Nguyen 2026-01-28 10:30:00 +0700  2)
b2c3d4e5 (John Doe   2026-01-27 15:20:00 +0700  3) @Component({
b2c3d4e5 (John Doe   2026-01-27 15:20:00 +0700  4)   selector: 'app-root',
c3d4e5f6 (Jane Smith 2026-01-26 09:15:00 +0700  5)   templateUrl: './app.component.html',
c3d4e5f6 (Jane Smith 2026-01-26 09:15:00 +0700  6)   styleUrls: ['./app.component.scss']
b2c3d4e5 (John Doe   2026-01-27 15:20:00 +0700  7) })
a1b2c3d4 (Dat Nguyen 2026-01-28 10:30:00 +0700  8) export class AppComponent {
a1b2c3d4 (Dat Nguyen 2026-01-28 10:30:00 +0700  9)   value = 20;
a1b2c3d4 (Dat Nguyen 2026-01-28 10:30:00 +0700 10) }
```

---

### 4.2 Blame Một Đoạn Code

```bash
git blame -L 20,40 app.component.ts
```

**Ý nghĩa:** Chỉ xem dòng 20–40

---

### 4.3 Blame Với Format Đẹp Hơn

```bash
git blame -e app.component.ts
```

**Output:** Hiển thị email thay vì tên

```bash
git blame --date=short app.component.ts
```

**Output:** Hiển thị ngày dạng ngắn gọn

---

### 4.4 Xem Commit Chi Tiết Từ Blame

```bash
# Bước 1: Blame để tìm commit
git blame app.component.ts

# Bước 2: Copy commit hash (ví dụ: a1b2c3d4)
git show a1b2c3d4
```

**👉 Dùng khi:**
- Hỏi đúng người khi code khó hiểu
- Tìm context của code
- Hiểu tại sao code được viết như vậy
- Code review

---

## 🔬 5. So Sánh Code (Git Diff)

### Mục Đích

Biết **code khác nhau ở đâu** giữa các versions.

---

### 5.1 So Với Commit Gần Nhất

```bash
git diff
```

**So sánh:**
```
working directory vs HEAD (staged)
```

**Output:**

```diff
diff --git a/app.component.ts b/app.component.ts
index 1234567..abcdefg 100644
--- a/app.component.ts
+++ b/app.component.ts
@@ -8,6 +8,7 @@
 })
 export class AppComponent {
   value = 20;
+  newProperty = 'test';
 }
```

**👉 Dùng khi:**
- Trước khi commit
- Check thay đổi hiện tại

---

### 5.2 So Staged vs HEAD

```bash
git diff --staged
```

hoặc

```bash
git diff --cached
```

**So sánh:** Files đã `git add` vs commit cuối

---

### 5.3 So File Cụ Thể

```bash
git diff app.component.ts
```

---

### 5.4 So Giữa Hai Commit

```bash
git diff commitA commitB
```

**Ví dụ:**

```bash
git diff a1b2c3 d4e5f6
```

---

### 5.5 So File Cụ Thể Giữa Hai Commit

```bash
git diff commitA commitB -- app.component.ts
```

**Ví dụ:**

```bash
git diff a1b2c3 d4e5f6 -- src/app/app.component.ts
```

---

### 5.6 So Giữa Hai Branch

```bash
git diff main feature/payment
```

---

### 5.7 Diff Với Stat (Tổng Quan)

```bash
git diff --stat
```

**Output:**

```
 app.component.ts     | 3 ++-
 payment.service.ts   | 15 +++++++++------
 user.model.ts        | 2 +-
 3 files changed, 12 insertions(+), 8 deletions(-)
```

**👉 Dùng khi:**
- Debug bug xuất hiện sau commit nào
- Code review
- So sánh implementation giữa các branch

---

## 📋 6. Xem Thay Đổi Chi Tiết Của Commit

### 6.1 Xem Files Thay Đổi

```bash
git log --name-only
```

**Output:**

```
commit a1b2c3
Author: Dat Nguyen
Date:   Mon Jan 28 10:30:00 2026

    Fix payment bug

src/payment.service.ts
src/api.service.ts
src/payment.model.ts
```

---

### 6.2 Xem Thống Kê Thay Đổi

```bash
git log --stat
```

**Output:**

```
commit a1b2c3
Author: Dat Nguyen
Date:   Mon Jan 28 10:30:00 2026

    Fix payment bug

 src/payment.service.ts | 25 ++++++++++++++-----------
 src/api.service.ts     | 8 +++-----
 src/payment.model.ts   | 3 ++-
 3 files changed, 19 insertions(+), 17 deletions(-)
```

---

### 6.3 Xem Chi Tiết Code Thay Đổi

```bash
git log -p
```

hoặc với giới hạn số lượng:

```bash
git log -p -2
```

*Chỉ xem 2 commit gần nhất*

**👉 Dùng khi:**
- Code review
- Audit changes
- Hiểu evolution của codebase

---

## 🌿 7. Tìm Commit Giữa Hai Branch

### Mục Đích

Tìm commit **có ở branch A** nhưng **chưa có ở branch B**.

---

### 7.1 Cú Pháp

```bash
git log branchB..branchA --oneline
```

**Ý nghĩa:** Commit có ở `branchA` nhưng chưa có ở `branchB`

---

### 7.2 Ví Dụ Thực Tế

```bash
git log main..feature/payment --oneline
```

**Output:**

```
a1b2c3 Fix payment validation
b2c3d4 Add payment processing
c3d4e5 Update payment model
```

→ 3 commits này có ở `feature/payment` nhưng chưa merge vào `main`

---

### 7.3 Use Case Phổ Biến

```bash
# Xem commit chưa deploy
git log production..develop --oneline

# Xem commit của branch feature
git log main..feature/user-management --oneline

# Xem commit trước khi merge
git log target-branch..current-branch --oneline
```

**👉 Dùng khi:**
- Kiểm tra commit chưa deploy
- Code review trước merge
- Tạo release notes

---

## 🎨 8. Squash Nhiều Commit (Clean History)

### Mục Đích

Gộp nhiều commit thành **1 commit** để history sạch đẹp.

---

### 8.1 Tình Huống

Lịch sử commit hiện tại:

```
A (main)
B fix deploy
C update gulp
D fix typo
E fix again
F add proxy config
G merge branch
```

Bạn muốn squash `B + C + D + E` thành 1 commit.

---

### 8.2 Các Bước Thực Hiện

#### Bước 1: Interactive Rebase

```bash
git rebase -i A
```

hoặc

```bash
git rebase -i HEAD~4
```

*(4 = số commit muốn squash)*

---

#### Bước 2: Editor Mở Ra

```
pick B fix deploy
pick C update gulp
pick D fix typo
pick E fix again
pick F add proxy config
pick G merge branch
```

---

#### Bước 3: Sửa Thành

```
pick B fix deploy
squash C update gulp
squash D fix typo
squash E fix again
pick F add proxy config
pick G merge branch
```

hoặc dùng shorthand:

```
pick B fix deploy
s C update gulp
s D fix typo
s E fix again
pick F add proxy config
pick G merge branch
```

---

#### Bước 4: Save & Close

Editor tiếp theo sẽ mở để bạn viết commit message mới:

```
# Viết commit message cho commit đã squash
Fix deployment and gulp configuration

- Fixed deployment issues
- Updated gulp build process
- Fixed typos in configuration
- Improved error handling
```

---

#### Bước 5: Kết Quả

```
A (main)
B (combined: fix deploy + update gulp + fix typo + fix again)
F add proxy config
G merge branch
```

---

### 8.3 Squash Với Autosquash

```bash
# Commit với fixup
git commit --fixup=<commit-hash>

# Sau đó autosquash
git rebase -i --autosquash <base-commit>
```

**👉 Dùng khi:**
- Clean commit history trước khi merge PR
- Chuẩn hóa history
- Tạo semantic commits
- Làm history dễ đọc

---

## 🗑️ 9. Xóa Branch Remote

### 9.1 Xóa Branch Trên Remote

```bash
git push origin --delete branch-name
```

**Ví dụ:**

```bash
git push origin --delete bugfix/BUG-528901
```

---

### 9.2 Xóa Local Branch

```bash
git branch -d branch-name
```

**Xóa force (nếu chưa merge):**

```bash
git branch -D branch-name
```

---

### 9.3 Xóa Cả Local & Remote

```bash
# Xóa remote trước
git push origin --delete branch-name

# Xóa local sau
git branch -d branch-name
```

---

### 9.4 Xóa Nhiều Branch Cùng Lúc

```bash
# List all merged branches
git branch --merged | grep -v "\*\|main\|develop"

# Delete all merged branches
git branch --merged | grep -v "\*\|main\|develop" | xargs git branch -d
```

**⚠️ Lưu ý:**
- Xóa branch remote cũng xóa luôn PR (nếu có)
- Chỉ xóa branch đã merge
- Backup trước khi xóa

**👉 Dùng khi:**
- Branch đã merge xong
- Cleanup branches cũ
- Maintain repository sạch

---

## 🔄 10. Git Reflog (Cứu Mạng Dev)

### Mục Đích

Xem lịch sử **HEAD đã di chuyển** - công cụ hồi sinh commit đã "mất".

---

### 10.1 Xem Reflog

```bash
git reflog
```

**Output:**

```
a1b2c3 HEAD@{0}: commit: Fix payment bug
b2c3d4 HEAD@{1}: checkout: moving from main to feature
c3d4e5 HEAD@{2}: reset: moving to HEAD~1
d4e5f6 HEAD@{3}: commit: Add feature
e5f6g7 HEAD@{4}: pull: Fast-forward
f6g7h8 HEAD@{5}: commit: Initial commit
```

---

### 10.2 Hiểu Output

```
<commit-hash> HEAD@{n}: <action>: <description>
```

| Phần | Ý nghĩa |
|------|---------|
| `a1b2c3` | Commit hash |
| `HEAD@{0}` | Reference (0 = mới nhất) |
| `commit` | Action type |
| `Fix payment bug` | Description |

---

### 10.3 Các Action Phổ Biến

```
commit: Commit mới
checkout: Chuyển branch
reset: Reset HEAD
rebase: Rebase
merge: Merge branch
pull: Pull từ remote
cherry-pick: Cherry-pick commit
```

---

### 10.4 Recovery Use Cases

#### Case 1: Lỡ Reset Hard

```bash
# Lỡ reset
git reset --hard HEAD~3

# Xem reflog
git reflog

# Output:
# a1b2c3 HEAD@{0}: reset: moving to HEAD~3
# d4e5f6 HEAD@{1}: commit: Important work

# Phục hồi
git reset --hard HEAD@{1}
```

---

#### Case 2: Mất Commit Sau Rebase

```bash
# Xem reflog
git reflog

# Output:
# a1b2c3 HEAD@{0}: rebase finished
# d4e5f6 HEAD@{1}: commit: Lost commit

# Phục hồi
git cherry-pick d4e5f6
```

---

#### Case 3: Xóa Nhầm Branch

```bash
# Xem reflog
git reflog

# Tìm commit cuối của branch đã xóa
# f6g7h8 HEAD@{5}: commit: Last commit on deleted branch

# Tạo lại branch
git branch recovered-branch f6g7h8
```

---

### 10.5 Reflog Với Time

```bash
# Xem reflog theo thời gian
git reflog --date=relative

# Output:
# a1b2c3 HEAD@{2 hours ago}: commit: Fix bug
# b2c3d4 HEAD@{1 day ago}: checkout: moving from main
```

---

### 10.6 Reflog Của Branch Cụ Thể

```bash
git reflog show branch-name
```

**👉 Dùng khi:**
- Lỡ reset/rebase sai
- Mất commit
- Xóa nhầm branch
- Cần quay lại trạng thái cũ
- Debug Git operations

---

## 🚀 11. Checkout Commit Cũ (Time Travel)

### Mục Đích

Test code ở **commit cũ** để debug hoặc verify bug.

---

### 11.1 Các Bước Thực Hiện

#### Bước 1: Tìm Commit

```bash
git log --oneline
```

**Output:**

```
a1b2c3 Add payment feature
d4e5f6 Fix refund bug
h7i8j9 Refactor service
k1l2m3 Initial commit
```

---

#### Bước 2: Checkout Commit

```bash
git checkout d4e5f6
```

**Git báo:**

```
Note: switching to 'd4e5f6'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.
```

---

#### Bước 3: Test/Debug

Lúc này bạn có thể:
- Run code
- Debug
- Test features
- Verify bug existence

---

#### Bước 4: Quay Lại Branch

```bash
git checkout main
```

hoặc

```bash
git switch main
```

---

### 11.2 Checkout File Từ Commit Cũ

```bash
# Checkout 1 file từ commit cụ thể
git checkout d4e5f6 -- src/payment.service.ts

# Checkout nhiều files
git checkout d4e5f6 -- src/payment.service.ts src/api.service.ts
```

**👉 Dùng khi:**
- Recovery file đã xóa/sửa
- Compare implementations

---

## 🔓 12. Detached HEAD State

### 12.1 Detached HEAD Là Gì?

**Định nghĩa:** HEAD không trỏ vào branch mà trỏ trực tiếp vào commit.

**Normal state:**

```
main → a1b2c3
       ↑
      HEAD
```

**Detached state:**

```
main → a1b2c3

d4e5f6 ← HEAD (detached)
```

---

### 12.2 Khi Nào Rơi Vào Detached HEAD?

```bash
# Checkout commit cụ thể
git checkout a1b2c3

# Checkout tag
git checkout v1.0.0

# Checkout remote branch (không track)
git checkout origin/main
```

---

### 12.3 Trong Detached HEAD Có Thể Làm Gì?

✅ **An toàn:**
- Đọc code
- Run & test
- Debug
- View files

❌ **Nguy hiểm:**
- Commit (sẽ mất khi switch branch)
- Push

---

### 12.4 Nếu Commit Trong Detached HEAD

```bash
# Đang ở detached HEAD
git checkout a1b2c3

# Commit
git commit -m "Experimental change"
# Tạo commit mới: x1y2z3

# Switch về main
git checkout main
# → Commit x1y2z3 sẽ "mất" (không accessible)
```

---

### 12.5 Cứu Commit Trong Detached HEAD

```bash
# Trước khi switch, tạo branch
git checkout -b experimental-branch

# Hoặc sau khi switch, dùng reflog
git reflog
git branch recovered-branch x1y2z3
```

---

### 12.6 Thoát Detached HEAD

```bash
# Switch về branch
git checkout main

# Hoặc
git switch main
```

**👉 Nhớ:**
- Detached HEAD chỉ để **read-only**
- Nếu muốn edit → tạo branch mới

---

## 🌳 13. Tạo Branch Từ Commit Cũ

### 13.1 Use Case

Muốn **fix bug** hoặc **test** từ commit cũ.

---

### 13.2 Các Bước

#### Option 1: Checkout & Create Branch

```bash
# Checkout commit
git checkout d4e5f6

# Tạo branch mới
git checkout -b debug-old
```

---

#### Option 2: Create Branch Directly

```bash
git checkout -b debug-old d4e5f6
```

hoặc

```bash
git branch debug-old d4e5f6
git checkout debug-old
```

---

### 13.3 Ví Dụ Thực Tế

```bash
# Scenario: Bug xuất hiện từ commit d4e5f6

# Bước 1: Tạo branch từ commit đó
git checkout -b debug-payment-bug d4e5f6

# Bước 2: Fix bug
# ... edit files ...

# Bước 3: Commit fix
git commit -m "Fix payment bug"

# Bước 4: Merge fix vào main
git checkout main
git merge debug-payment-bug
```

**👉 Dùng khi:**
- Debug bug ở version cũ
- Create hotfix
- Test experimental changes

---

## 💡 14. Reset vs Checkout vs Revert

### 14.1 So Sánh Tổng Quan

| Command | Purpose | Thay đổi history? | An toàn? |
|---------|---------|-------------------|----------|
| `checkout` | Di chuyển HEAD | ❌ Không | ✅ An toàn |
| `reset` | Thay đổi history | ✅ Có | ⚠️ Nguy hiểm |
| `revert` | Tạo commit đảo ngược | ❌ Không | ✅ An toàn |

---

### 14.2 Git Checkout

**Mục đích:** Di chuyển HEAD

```bash
# Checkout branch
git checkout main

# Checkout commit
git checkout a1b2c3

# Checkout file
git checkout -- file.ts
```

**Đặc điểm:**
- ✅ Không thay đổi history
- ✅ An toàn
- ✅ Reversible

---

### 14.3 Git Reset

**Mục đích:** Thay đổi history

```bash
# Soft reset (giữ changes)
git reset --soft HEAD~1

# Mixed reset (unstage changes)
git reset HEAD~1

# Hard reset (xóa changes)
git reset --hard HEAD~1
```

**Đặc điểm:**
- ⚠️ Thay đổi history
- ⚠️ Có thể mất code
- ⚠️ Chỉ dùng khi chắc chắn

**Phân biệt 3 modes:**

| Mode | Working Dir | Staging | History |
|------|-------------|---------|---------|
| `--soft` | Giữ nguyên | Giữ nguyên | Reset |
| `--mixed` | Giữ nguyên | Clear | Reset |
| `--hard` | Clear | Clear | Reset |

---

### 14.4 Git Revert

**Mục đích:** Đảo ngược commit (tạo commit mới)

```bash
git revert a1b2c3
```

**Đặc điểm:**
- ✅ Không thay đổi history
- ✅ An toàn với public branch
- ✅ Traceable

**Ví dụ:**

```
Before:
A → B → C → D

git revert C

After:
A → B → C → D → C' (đảo ngược C)
```

---

### 14.5 Khi Nào Dùng Gì?

#### Dùng Checkout Khi:
```
✅ Muốn xem code cũ
✅ Switch branch
✅ Restore file
✅ Test commit cũ
```

#### Dùng Reset Khi:
```
✅ Local branch chưa push
✅ Sửa commit message
✅ Squash commits
⚠️ KHÔNG dùng với public branch
```

#### Dùng Revert Khi:
```
✅ Public branch (đã push)
✅ Cần rollback production
✅ Cần giữ history
✅ Teamwork
```

---

## 📊 15. Tổng Kết Git Timeline & History

### 15.1 Mental Model

```
Git = Camera An Ninh Của Codebase

├─ git log → Xem timeline
├─ git blame → Ai viết dòng code
├─ git diff → Code khác nhau gì
├─ git reflog → Lịch sử Git operations
├─ git checkout → Time travel
└─ git revert → Undo an toàn
```

---

### 15.2 Workflow Thực Tế

#### Scenario 1: Debug Bug

```bash
# 1. Tìm commit gây bug
git log --oneline

# 2. Xem chi tiết commit
git show a1b2c3

# 3. Xem file bị ảnh hưởng
git log --stat

# 4. Blame dòng code lỗi
git blame src/payment.service.ts

# 5. Xem history của file
git log -p src/payment.service.ts
```

---

#### Scenario 2: Code Review

```bash
# 1. Xem commits giữa 2 branch
git log main..feature/payment --oneline

# 2. Xem diff
git diff main feature/payment

# 3. Xem files thay đổi
git log main..feature/payment --name-only
```

---

#### Scenario 3: Recovery

```bash
# 1. Xem reflog
git reflog

# 2. Tìm commit cần phục hồi
git show HEAD@{3}

# 3. Phục hồi
git reset --hard HEAD@{3}
```

---

### 15.3 Best Practices

```
✅ DO:
├─ Commit thường xuyên
├─ Message rõ ràng
├─ Squash trước merge
├─ Review diff trước commit
└─ Dùng reflog khi rối

❌ DON'T:
├─ Reset public branch
├─ Force push (trừ khi cần)
├─ Commit code chưa test
├─ Message vô nghĩa ("fix", "update")
└─ Quên backup trước reset
```

---

## 🎯 16. Checklist Tự Đánh Giá

### Git Timeline & History

- [ ] Xem được lịch sử commit với `git log`?
- [ ] Dùng được `git log --oneline --graph`?
- [ ] Lọc commit theo thời gian?
- [ ] Xem lịch sử của file cụ thể?

### Git Blame & Diff

- [ ] Dùng được `git blame` để tìm author?
- [ ] So sánh code với `git diff`?
- [ ] Diff giữa commits/branches?
- [ ] Hiểu output của diff?

### Git Reflog & Recovery

- [ ] Hiểu `git reflog` là gì?
- [ ] Recovery commit sau reset?
- [ ] Recovery branch đã xóa?
- [ ] Dùng reflog để debug?

### Advanced Operations

- [ ] Squash commits với rebase?
- [ ] Checkout commit cũ để test?
- [ ] Hiểu detached HEAD state?
- [ ] Tạo branch từ commit cũ?

### Reset vs Revert

- [ ] Phân biệt reset vs revert?
- [ ] Biết khi nào dùng gì?
- [ ] Hiểu 3 modes của reset?
- [ ] Revert commit an toàn?

---

## 📚 Tài Liệu Tham Khảo

- **Book:** "Pro Git" - Scott Chacon & Ben Straub
- **Resource:** git-scm.com/doc
- **Interactive:** learngitbranching.js.org
- **Practice:** github.com/git-game

---

## 💡 Câu Chốt

```
Git không chỉ là version control.
Git là:
├─ Time machine của code
├─ Audit trail
├─ Debug tool
├─ Communication platform
└─ Safety net cho developers

Senior dev phải master Git.
Không chỉ commit/push/pull.
```

---

## 🚀 What's Next?

**Git Essentials Part 2** sẽ cover:
1. **Reset vs Revert vs Rebase Deep Dive**
2. **Git Workflow cho Team (PR/Squash/Rebase)**
3. **Debug Production Bug với Git Bisect**
4. **Conflict Resolution Strategies**
5. **Git Hooks & Automation**

---

_"Git is not about commits. It's about understanding the story of your codebase."_ - Senior Developer Mindset
