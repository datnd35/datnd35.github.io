---
layout: post
title: "Git Review"
categories: misc
---

[Link](https://github.com/datnd35-angular/git-review/tree/main)

## Staging area & Working directory

**_Staging area (Index):_**

- Là khu vực trung gian nơi bạn đưa các thay đổi vào bằng cách dùng lệnh git add.
- Các file trong staging area sẽ được đưa vào commit tiếp theo.

**_Working directory:_**

- Là nơi chứa các file mà bạn đang làm việc trực tiếp trên máy tính.
- Bất kỳ thay đổi nào chưa được thêm vào staging area vẫn nằm ở đây.

## Git reset

**_1. Quay lại commit trước đó nhưng giữ tất cả thay đổi:_**

- `git reset --soft HEAD~1` HEAD~1 là id của commit
- Giữ nguyên các thay đổi trong staging area, bạn có thể ko cần gõ lệnh git add . lần nữa và commit này sẽ là commit chung cho tất cả những commit sau HEAD~1 và nếu file của bạn hiện tại đang có thay đổi thì nó sẽ là 1 commit khác.

**_2. Hủy bỏ staging file mà không làm mất thay đổi trong working directory:_**

- `git reset --mixed HEAD`
- Di chuyển HEAD và xóa các thay đổi trong staging area, đồng nghĩa với vệc bạn phải gõ lại lệnh git add . để đưa những thay đổi mới cũng như những thay đổi của những commit sau HEAD vào staging sau đó nhập lệnh git commit -m "" để tạo lại 1 commit mới.

**_3. Xóa toàn bộ thay đổi trong working directory và staging area:_**

- `git reset --hard HEAD~2`
- Xoá sạch dự liệu của những commit sau HEAD~2
- **_Chú ý_** lệnh này có thể làm mất dữ liệu

## Git stash

- Dùng để **_tạm thời lưu trữ (stash) các thay đổi trong working directory và/hoặc staging area mà chưa được commit._** Lệnh này giúp bạn chuyển sang một công việc khác mà không cần phải commit các thay đổi dang dở.
- Ví dụ: Khi bạn đang làm trên nhánh A có 1 số fields đã thay đổi nhưng bạn vẫn chưa muốn commit và bạn muốn tạo một nhánh mới B từ nhánh A không chứa những thay đổi mới (nhánh B sẽ tạo mới bắt đầu từ commit cuối cùng của nhánh A) để làm được như vậy thì nhánh A phải back về commit cuối cùng và những thay đổi mới sẽ phải xoá sạch, Git stash có thể giải quyết bằng cách back về commit cũ nhất của A, và lưu các thay đổi vào đâu đó, sẽ hồi lại khi cần.

**_1. Lưu_**

- `git stash save "Mô tả chi tiết"` lưu thay đổi với mô tả or `git stash ` lưu thay đổi ko mô tả

**_2. Xem danh sách tash_**

- `git stash list` Xem danh sách stash.

```
    stash@{0}: WIP on main: 123abc Commit message
    stash@{1}: WIP on feature: 456def Another message
```

**_3. Khôi phục_**

- `git stash pop` Khôi phục và xóa khỏi stash.
- `git stash pop` khôi phục từ stash mới nhất (trong trường hợp bạn tạo nhiều stash) và phải commit stash hiện tại mới pop được stash cũ hơn.
- `git stash pop stash@{X}` khi muốn khôi phục một stash chỉ định nào đó.

- `git stash apply` Khôi phục và giữ lại trong stash.

**_4. Xoá_**

- `git stash drop stash@{0}` Xóa một stash cụ thể.
- `git stash clear` Xóa tất cả stash.

  ## Git Reflog (reference log)

  Nó ghi lại mọi thay đổi đối với các tham chiếu trong repository **_giúp khôi phục dữ liệu khi xóa commit, nhánh, hoặc thực hiện các thay đổi lịch sử không mong muốn_**, bao gồm:

- Reset (git reset)
- Merge (git merge)
- Rebase (git rebase)
- Cherry-pick (git cherry-pick)
- Checkout (git checkout)

**_1. Cú pháp_**

- `git reflog`

```
0f2c9a1 HEAD@{0}: commit: Added new feature
92b2a81 HEAD@{1}: reset: moving to HEAD~1
34e2c1a HEAD@{2}: checkout: moving from main to feature-branch
a9d3e21 HEAD@{3}: commit: Updated README.md

HEAD@{n}: Cho biết thứ tự sự kiện gần đây, với {0} là sự kiện mới nhất.
Thông tin commit hash (0f2c9a1): Tham chiếu đến commit cụ thể trong lịch sử.
Mô tả hành động (reset, checkout, commit): Cho biết loại thay đổi đã diễn ra.
```

**_2. Tạo nhánh từ một commit trong reflog_**

- Nếu bạn muốn tạo nhánh từ một commit cụ thể (ví dụ, a9d3e21)
- `git branch recovered-branch a9d3e21`

<img width="698" alt="image" src="https://github.com/user-attachments/assets/27c98b0f-0f46-4d19-abd9-1f35a0fd55ec">
<img width="698" alt="image" src="https://github.com/user-attachments/assets/0ddc77a0-4fa8-4f46-be06-187953f3c9cf">

- ví dụ hiện tại đang đứng ở nhánh `dev-1-clone-1` và mình muốn tạo một nhánh khác có tên `new-branch` bắt đầu từ commit id
  `7b84522` và nội dung `commit 4`

**_3. Khôi phục dữ liệu với git reflog_**

- **_Lỡ xóa nhánh:_**

  - Giả sử bạn đã xóa nhánh feature-branch `git branch -d feature-branch`
  - Dùng git reflog để tìm commit cuối cùng của nhánh: `git reflog` (**_bạn nên tìm theo nội dung của commit_**)
    <img width="1008" alt="image" src="https://github.com/user-attachments/assets/8ca88b68-67f4-4080-98e1-fe730b63ca93">

  - ví dụ `661bf67` là commit cuối của nhánh dev-1-clone-1 tracking theo nội dung commit `commit 12`
  - Tạo lại nhánh từ commit cuối:`git branch feature-branch <commit-hash>`

- **_Lỡ xóa commit hoặc bạn chạy git reset --hard và mất các commit_**
  - Chạy `git reflog` để xem commit cuối cùng.
  - Tìm commit cuối cùng trước khi reset và khôi phục: `git reset --hard <commit-hash>` (**_bạn nên tìm theo nội dung của commit_**)

## Git cherry-pick

- Dùng để **_sao chép một commit cụ thể từ một nhánh hoặc lịch sử và áp dụng nó vào nhánh hiện tại._** Lệnh này cực kỳ hữu ích khi bạn muốn trích xuất một hoặc nhiều commit từ nơi khác mà không cần merge toàn bộ lịch sử.

**_Cách sử dụng cơ bản_**

- Cú pháp `git cherry-pick <commit-hash>`

- **_ví dụ_**

  - Giả sử bạn có nhánh feature với lịch sử:
    ```
    A - B - C (main)
     \
      D - E (feature)
    ```
  - Bạn muốn lấy commit E từ nhánh feature và áp dụng vào nhánh main.

    ```
    Chuyển sang main
    git checkout main

    Chạy lệnh cherry-pick:
    git cherry-pick <hash-của-E>
    ```

  - Sau lệnh, lịch sử của main sẽ trở thành:
    ```
    A - B - C - E (main)
     \
      D - E (feature)
    ```

## Squash commit

- **_Quá trình kết hợp nhiều commit thành một commit duy nhất trước khi mợt nhánh_** trong trường hợp muốn dọn dẹp commit không cần thiết hay là commit rác.

**_Cách thực hiện squash commit:_**

- Bắt đầu interactive rebase: `git rebase -i HEAD~N`

  - N là số commit gần đây bạn muốn squash. Ví dụ, nếu muốn squash 3 commit cuối, bạn thay N bằng 3.

- Màn hình chỉnh sửa sẽ xuất hiện:
  ```
  pick abc123 First commit
  pick def456 Second commit
  pick ghi789 Third commit
  ```
- Thay đổi `pick` thành `squash` (hoặc viết tắt là s):
  ```
  pick abc123 First commit
  squash def456 Second commit
  squash ghi789 Third commit
  ```
- Lưu file và thoát
- Hoàn tất rebase

## Rebase commit

- Hiện tại bạn đang đứng ở nhánh A và muốn đồng bộ code vào nhánh `develop` tránh trường hợp gây lộn xộn khi push code lên vì thứ tự code được sắp xếp theo lịch sử. Bạn có thể dùng **_Rebase commit_** push tất cả commit trên nhánh A vào đầu của nhánh `develop`. Giúp code gọn gàng hơn.
