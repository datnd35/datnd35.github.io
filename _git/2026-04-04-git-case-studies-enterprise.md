---
layout: post
title: "40 Case Study Git Thực Chiến - Senior FE/Angular Enterprise"
categories: git
---

Đây là **40 tình huống Git thực tế** mà bạn sẽ gặp phải trong dự án enterprise, kèm theo **cách xử lý, kinh nghiệm và bài học rút ra**. Không chỉ là lệnh, mà là **wisdom từ những sai lầm thực tế**.

---

## 1) Feature Branch Quá Lâu, Đến Lúc Merge Thì Conflict Nặng

### Bối cảnh

Một dev làm feature trong 2–3 tuần trên branch riêng. Trong lúc đó `develop/main` thay đổi liên tục, đặc biệt là:

- shared component
- service chung
- styles
- environment/config
- routing

Đến lúc mở PR:

- conflict rất nhiều
- code review khó
- bug phát sinh vì code cũ "không còn đúng" với nhánh chính

### Cách xử lý tốt

```text
main/develop
   ├─ merge/rebase vào feature branch thường xuyên
   ├─ chia feature thành PR nhỏ
   └─ tránh giữ branch sống quá lâu
```

### Kinh nghiệm

- Feature branch sống quá lâu gần như luôn gây rủi ro.
- PR nhỏ dễ review hơn PR 3,000 dòng.
- Với Angular app lớn, conflict thường nằm ở:
  - shared module
  - route config
  - UI reusable component
  - translation file
  - styles global

### Bài học

> Đừng để branch trở thành "parallel universe".

---

## 2) Rebase Sai Cách Làm Mất Commit Hoặc Rewrite Lịch Sử Người Khác

### Bối cảnh

Một dev rebase branch đã push lên remote và branch đó có người khác đang dùng chung. Sau đó force push làm:

- commit hash thay đổi
- teammate bị lệch lịch sử
- PR hiển thị diff rất khó hiểu

### Sai lầm phổ biến

- `git push --force` bừa
- rebase branch shared/public
- không hiểu khác biệt giữa `merge` và `rebase`

### Cách làm an toàn

```text
Branch cá nhân:
  có thể rebase trước khi merge cho sạch lịch sử

Branch dùng chung:
  ưu tiên merge
  tránh rewrite history

Nếu buộc phải force push:
  dùng --force-with-lease
```

### Kinh nghiệm

- `--force-with-lease` an toàn hơn `--force`
- Rebase rất tốt cho local cleanup
- Nhưng branch đã public thì phải cực kỳ cẩn thận

### Bài học

> Rebase mạnh, nhưng dùng sai là "vũ khí hủy diệt teamwork".

---

## 3) Hotfix Production Gấp Nhưng Đang Có Nhiều Code Dở Dang

### Bối cảnh

Production lỗi gấp, nhưng branch hiện tại của dev đang có nhiều file chưa xong.

### Cách xử lý

```text
Cách 1: stash tạm
Cách 2: commit WIP riêng
Cách 3: checkout nhánh hotfix từ main/tag release
```

Luồng tốt:

```text
main (production stable)
   ├─ create hotfix branch
   ├─ fix bug
   ├─ test
   ├─ merge về main
   └─ back-merge/cherry-pick sang develop
```

### Kinh nghiệm

- Hotfix phải đi từ code đang chạy thật, không phải từ branch đang develop dở.
- Nhiều team fix trên `develop` rồi mới merge sang `main` => dễ kéo theo code chưa release.

### Bài học

> Hotfix phải tách biệt, nhỏ, nhanh, truy vết rõ.

---

## 4) Fix Ở Production Rồi Nhưng Quên Back-Merge Về Develop

### Bối cảnh

Team fix bug trực tiếp trên hotfix branch và merge vào `main`, nhưng quên đưa fix đó về `develop`.

Kết quả:

- bản release sau bị "regression"
- bug cũ quay lại
- team tưởng fix rồi nhưng thực ra chỉ fix ở một nhánh

### Cách phòng tránh

```text
hotfix -> main
hotfix -> develop
hoặc cherry-pick commit fix sang develop
```

### Kinh nghiệm

Đây là lỗi rất hay xảy ra trong team có nhiều nhánh release.

### Bài học

> Mọi fix production đều phải quay về source branch của tương lai.

---

## 5) Commit Quá To, Review Không Nổi

### Bối cảnh

Một PR gồm:

- refactor
- feature mới
- rename file
- format cả project
- fix bug unrelated

Reviewer gần như không thể review đúng trọng tâm.

### Cách xử lý tốt

Tách thành nhiều commit/PR:

1. rename / mechanical changes
2. refactor safe
3. feature logic
4. test
5. cleanup

### Kinh nghiệm

Với Angular, đặc biệt tránh gộp:

- "Angular upgrade" + "UI fix" + "business logic change"
- "format all files" + "real feature changes"

### Bài học

> PR nhỏ không chỉ dễ review, mà còn dễ rollback.

---

## 6) Cherry-Pick Để Đưa Fix Nhỏ Sang Nhánh Khác

### Bối cảnh

Có một fix đúng và nhỏ trên branch A, cần mang sang release branch B mà không muốn merge toàn bộ branch.

### Cách dùng

```bash
git cherry-pick <commit-hash>
```

### Khi nào nên dùng

- hotfix cho release branch
- áp dụng một fix đã kiểm chứng
- backport bug fix

### Rủi ro

- cherry-pick nhiều lần dễ làm lịch sử rối
- dễ bỏ sót commit liên quan

### Kinh nghiệm

- Chỉ cherry-pick commit "độc lập"
- Commit phải sạch, scope rõ

### Bài học

> Cherry-pick rất hữu ích, nhưng chỉ hiệu quả khi commit discipline tốt.

---

## 7) Resolve Conflict Xong Nhưng Vô Tình Làm Mất Logic Của Người Khác

### Bối cảnh

Hai dev sửa cùng file:

- một người sửa UI
- một người sửa business rule

Khi resolve conflict, dev chỉ giữ code "compile được" nhưng vô tình xóa logic bên còn lại.

### Cách xử lý đúng

- đọc kỹ từng đoạn conflict
- hiểu "vì sao file bị sửa"
- test lại flow bị ảnh hưởng
- không resolve theo kiểu "giữ bên mình hết"

### Kinh nghiệm

Conflict resolution không phải là thao tác cơ học. Nó là mini code review.

### Bài học

> "No conflict" chưa chắc là "correct merge".

---

## 8) Accidentally Commit Secret / Token / Env File

### Bối cảnh

Dev commit:

- API key
- `.env`
- service account
- private config

Dù xóa ở commit sau, secret vẫn tồn tại trong Git history.

### Cách xử lý

- rotate secret ngay
- xóa history nếu cần
- thêm `.gitignore`
- dùng secret management thay vì hardcode

### Kinh nghiệm

- Đừng nghĩ "xóa commit mới nhất là xong"
- Secret lọt lên remote phải xem như đã lộ

### Bài học

> Với secret, rollback code không đủ; phải rotate credential.

---

## 9) Muốn Rollback Nhanh Sau Release Lỗi

### Bối cảnh

Release lên production gây lỗi. Team cần rollback nhanh.

### Các cách

```text
1. revert commit
2. revert merge commit
3. redeploy tag cũ
4. checkout release tag ổn định
```

### Kinh nghiệm

- Nếu release theo tag rõ ràng, rollback dễ hơn nhiều.
- Nếu mỗi lần deploy là từ một branch "không rõ commit nào", rollback rất đau.

### Bài học

> Release cần gắn với tag/commit cụ thể, không release theo "cảm giác".

---

## 10) Tìm Commit Gây Lỗi Bằng `git bisect`

### Bối cảnh

Một bug xuất hiện nhưng không rõ commit nào gây ra.

### Cách dùng

```text
git bisect start
git bisect bad
git bisect good <known-good-commit>
```

Git sẽ chia đôi lịch sử để tìm commit lỗi.

### Kinh nghiệm

Cực kỳ hữu ích khi:

- bug xuất hiện sau refactor lớn
- nhiều commit trong thời gian ngắn
- team không nhớ thay đổi nào gây lỗi

### Bài học

> Đừng đoán mò commit lỗi; hãy để Git giúp khoanh vùng.

---

## 11) Rename File/Component Trong Angular Gây Diff Khó Review

### Bối cảnh

Trong Angular project, rename:

- component
- module
- service
- folder structure

Nếu vừa rename vừa sửa logic trong cùng commit:

- diff rất bẩn
- reviewer không thấy phần logic thay đổi thật sự

### Cách tốt

```text
Commit 1: rename only
Commit 2: update imports/path only
Commit 3: logic changes
```

### Kinh nghiệm

Đặc biệt hữu ích khi migrate structure hoặc standalone component.

### Bài học

> Tách "mechanical change" khỏi "behavioral change".

---

## 12) Monorepo: Một Thay Đổi Nhỏ Nhưng Impact Rất Rộng

### Bối cảnh

Trong monorepo, sửa shared library/common utility có thể ảnh hưởng nhiều app.

### Rủi ro

- merge xong mới phát hiện app khác vỡ
- team khác bị block
- khó pinpoint trách nhiệm

### Cách làm tốt

- commit message rõ impact
- PR mô tả affected areas
- chạy selective test/build
- branch protection nghiêm

### Bài học

> Trong monorepo, một commit nhỏ có thể là "global event".

---

## 13) Squash Commit Trước Khi Merge Hay Giữ Nguyên Lịch Sử?

### Bối cảnh

PR có 20 commit kiểu:

- fix
- fix again
- typo
- update
- final final

### Cách quyết định

**Squash khi:**

- lịch sử commit local bẩn
- muốn main sạch
- từng commit riêng lẻ không có giá trị

**Giữ commit riêng khi:**

- mỗi commit có ý nghĩa rõ
- cần trace theo bước
- debugging/revert sau này hưởng lợi

### Kinh nghiệm

Team enterprise thường:

- dev thoải mái commit local
- khi merge vào main thì squash hoặc clean up

### Bài học

> Git history là tài sản chung, không phải nhật ký cá nhân.

---

## 14) Dùng `reflog` Để Cứu Commit "Mất Tích"

### Bối cảnh

Dev reset nhầm, rebase nhầm, checkout lung tung, tưởng mất code.

### Cách cứu

```bash
git reflog
```

Rồi checkout lại commit cũ.

### Kinh nghiệm

Nhiều "commit mất" thật ra chưa mất, chỉ là HEAD không còn trỏ tới.

### Bài học

> Trước khi hoảng, hãy nhớ `reflog`.

---

## 15) Pull Branch Người Khác Để Review Hoặc Hỗ Trợ Fix

### Bối cảnh

Bạn là senior/reviewer, cần checkout PR của dev khác để:

- review kỹ
- run local
- sửa giúp
- pair debugging

### Cách làm tốt

```text
1. fetch remote branch
2. checkout branch đó
3. không rewrite history của bạn ấy nếu chưa thống nhất
4. nếu cần fix giúp:
   - commit riêng
   - hoặc push vào branch PR nếu team cho phép
```

### Kinh nghiệm

- Review bằng mắt trên GitHub/GitLab chưa đủ với bug phức tạp.
- Với Angular UI bug, đôi khi phải pull về chạy thật mới thấy.

### Bài học

> Reviewer giỏi không chỉ comment, mà còn biết khi nào cần checkout branch để xác thực.

---

## 16) "Format All Files" Làm PR Nổ Tung

### Bối cảnh

Một người bật formatter khác chuẩn team, save một phát đổi hàng trăm file.
PR trở nên:

- khó review
- conflict hàng loạt
- che mất business changes

### Cách phòng tránh

- thống nhất formatter
- config trong repo
- pre-commit/CI enforce
- tách PR format riêng

### Bài học

> Formatting không thống nhất là nguyên nhân gây nhiễu review rất lớn.

---

## 17) Merge Nhầm Nhánh Hoặc Deploy Nhầm Commit

### Bối cảnh

Team có nhiều branch:

- main
- develop
- release/\*
- hotfix/\*

Một dev merge nhầm vào `main` hoặc pipeline lấy sai branch.

### Cách phòng tránh

- protected branch
- required review
- CI status checks
- naming convention rõ ràng
- release theo tag

### Bài học

> Branch strategy phải phục vụ sự an toàn, không chỉ phục vụ quy trình.

---

## 18) Commit Message Quá Mơ Hồ, Sau Này Không Ai Hiểu

### Ví dụ commit tệ

```text
update
fix
change code
final
```

### Ví dụ tốt hơn

```text
fix(auth): preserve returnUrl after SSO redirect
refactor(shared-table): extract pagination state handling
feat(report): add export csv for filtered rows
```

### Kinh nghiệm

Commit message tốt giúp:

- hiểu intent
- đọc lịch sử nhanh
- cherry-pick chính xác
- rollback dễ hơn

### Bài học

> Người đọc commit message trong tương lai rất có thể là chính bạn.

---

## 19) Khi Nào Dùng Merge, Khi Nào Dùng Rebase?

### Tư duy thực tế

**Dùng merge khi:**

- branch shared
- muốn giữ lịch sử thật
- teamwork nhiều người

**Dùng rebase khi:**

- branch cá nhân
- cleanup trước PR
- muốn lịch sử thẳng, gọn

### Quy tắc đơn giản

```text
Local/private branch -> rebase được
Shared/public branch -> cẩn thận, ưu tiên merge
```

---

## 20) Git Không Cứu Được Quy Trình Kém

### Case thực tế

Nhiều team nghĩ vấn đề là "thiếu lệnh Git", nhưng thật ra vấn đề là:

- branch strategy không rõ
- PR quá lớn
- review quá loa
- release không theo tag
- commit message vô nghĩa
- không có protected branch

### Bài học lớn

> Git là công cụ. Chất lượng phụ thuộc vào workflow của team.

---

## 21) Merge Xong Mới Phát Hiện Pipeline Fail Vì Local Khác CI

### Bối cảnh

Trên máy dev:

- chạy build được
- lint pass
- unit test pass

Nhưng lên CI thì fail vì:

- Node version khác
- package manager lock file lệch
- OS khác
- env/config khác

### Tình huống thực tế

Frontend Angular rất hay gặp:

- local dùng Node 20, CI dùng Node 18
- `package-lock.json` không đồng bộ
- import path local chạy được nhưng Linux CI phân biệt hoa/thường nên fail
- file environment bị thiếu

### Bài học

> "Works on my machine" không có giá trị nếu Git history không đi kèm môi trường tái lập được.

### Kinh nghiệm

- pin version Node
- commit lock file đúng chuẩn
- dùng CI như nguồn sự thật cuối
- tránh merge PR khi chưa có status check pass

---

## 22) Git Blame Chỉ Ra "Người Sửa Cuối", Nhưng Không Phải "Người Gây Lỗi"

### Bối cảnh

Có bug trong file A. Team mở `git blame` và thấy dev X là người sửa gần nhất, rồi kết luận dev X gây lỗi.

Nhưng thực tế:

- X chỉ format file
- X chỉ rename
- logic lỗi được introduce từ trước
- bug nằm ở call chain khác

### Bài học

> `git blame` là công cụ điều tra, không phải công cụ quy trách nhiệm.

### Kinh nghiệm

Khi dùng `blame`, phải đọc thêm:

- commit message
- PR context
- related files
- timeline release

Nếu không, team sẽ blame sai người và học sai bài học.

---

## 23) Một Commit "Cleanup" Tưởng Vô Hại Nhưng Làm Vỡ Production

### Bối cảnh

Dev nghĩ chỉ đang:

- xóa dead code
- đổi tên biến
- chuẩn hóa imports
- refactor cho sạch

Nhưng thực tế:

- có side effect ẩn
- có import động
- có logic được dùng gián tiếp
- có feature flag cũ nhưng vẫn active ở production

### Với Angular rất hay dính

- remove service method tưởng không dùng
- xóa observable subscribe "thừa" nhưng thật ra đang trigger logic
- xóa CSS class "không thấy dùng" nhưng template dynamic vẫn cần

### Bài học

> Trong legacy system, "code nhìn như không dùng" chưa chắc là không dùng.

### Kinh nghiệm

- cleanup phải đi kèm search kỹ
- ưu tiên PR nhỏ
- cần smoke test các flow chính
- refactor an toàn phải tách khỏi feature change

---

## 24) Squash Quá Mức Làm Mất Khả Năng Điều tra Lịch Sử

### Bối cảnh

Team có policy squash tất cả PR về 1 commit.

Ưu điểm:

- lịch sử sạch

Nhược điểm:

- mất từng bước thay đổi
- khó bisect
- khó cherry-pick một phần
- khó biết bug xuất hiện ở bước nào

### Bài học

> Lịch sử sạch là tốt, nhưng "quá sạch" có thể làm mất forensic value.

### Kinh nghiệm

Không phải PR nào cũng nên squash tuyệt đối.
Một số PR lớn có thể giữ vài commit có nghĩa:

- refactor nền
- migration script
- business logic
- tests

---

## 25) Resolve Nhầm Binary File / Lock File Gây Lỗi Dây Chuyền

### Bối cảnh

Conflict không nằm ở source code mà ở:

- `package-lock.json`
- `pnpm-lock.yaml`
- asset generated
- snapshot file
- config machine-generated

Dev resolve bằng tay hoặc "chọn đại một bên".

Kết quả:

- cài dependency lỗi
- CI fail
- build inconsistency
- team khác pull về bị vỡ

### Bài học

> File generated không nên resolve kiểu cảm tính.

### Kinh nghiệm

Với lock file:

- nên regenerate lại sau khi resolve
- reinstall sạch
- verify bằng CI

---

## 26) Release Branch Tồn Tại Quá Lâu Thành Nửa Sống Nửa Chết

### Bối cảnh

Team tạo `release/x.y.z`, rồi:

- fix bug trên đó
- patch thêm feature nhỏ
- cherry-pick linh tinh
- vài tuần sau branch này khác xa `develop`

Kết quả:

- merge back cực đau
- không biết source of truth là đâu
- release process ngày càng rối

### Bài học

> Release branch nên sống ngắn và có mục đích rõ ràng.

### Kinh nghiệm

Release branch chỉ nên dùng để:

- stabilization
- bug fixes nhỏ
- release notes
- final verification

Không nên biến nó thành nhánh phát triển thứ hai.

---

## 27) Một PR "Fix Conflict" Nhưng Thực Ra Đưa Thêm Bug Mới

### Bối cảnh

Dev mở PR chỉ để "resolve conflict".
Nghe có vẻ harmless.

Nhưng khi resolve:

- reorder imports
- đổi logic
- bỏ mất null check
- sửa lại template binding

Kết quả: PR tên "resolve conflicts" nhưng impact rất lớn.

### Bài học

> "Conflict fix" cũng là code change thật, phải review như code bình thường.

### Kinh nghiệm

Đừng chủ quan với PR kiểu:

- merge latest main
- resolve conflict
- sync branch

Đây là nơi bug rất dễ chui vào.

---

## 28) Force-Push Làm Comment Review Bị "Outdated" Hết

### Bối cảnh

Reviewer comment rất chi tiết trên PR.
Author rebase + force push mạnh tay.
Kết quả:

- comment bị outdated
- reviewer mất context
- khó track đã sửa gì chưa

### Bài học

> Rewrite history có thể làm sạch commit, nhưng lại làm bẩn quá trình review.

### Kinh nghiệm

Trong lúc review đang diễn ra:

- hạn chế rebase lớn
- ưu tiên add commit mới
- chỉ cleanup trước merge nếu team cho phép

---

## 29) Tách Branch Sai Mức Độ Làm Team Bị Block Nhau

### Bối cảnh

Một team 3–5 dev cùng sửa 1 epic lớn.
Có team tách branch kiểu:

- mỗi người một branch riêng
- không có integration branch
- đến cuối mới merge chung

Kết quả:

- integration pain cực lớn
- bug chồng bug
- conflict cả logic lẫn UI

### Bài học

> Epic lớn cần chiến lược branch phù hợp, không chỉ "mỗi người 1 branch".

### Kinh nghiệm

Với epic lớn nên cân nhắc:

- feature flags
- integration branch tạm
- contract rõ giữa các phần
- merge sớm, merge nhỏ, merge thường xuyên

---

## 30) Rename Folder/Path Trong Angular Làm Import Alias Vỡ Hàng Loạt

### Bối cảnh

Refactor structure:

- `shared/` đổi thành `core/`
- component path đổi
- barrel file đổi
- tsconfig paths thay đổi

Nếu làm ẩu:

- IDE local auto-fix một phần
- CI fail phần còn lại
- test path alias fail
- lazy-load route import vỡ

### Bài học

> Structural refactor phải xem như change cấp kiến trúc, không phải đổi tên thư mục đơn giản.

### Kinh nghiệm

- đổi theo từng bước
- commit rename riêng
- commit import fix riêng
- verify build/test sau mỗi bước

---

## 31) Team Lạm Dụng Cherry-Pick Đến Mức Mất Dấu Luồng Thay Đổi

### Bối cảnh

Bug fix/feature liên tục được cherry-pick giữa:

- main
- develop
- release/\*
- hotfix/\*

Sau vài vòng:

- không biết commit gốc ở đâu
- có commit trùng nội dung nhưng hash khác
- release notes khó tổng hợp
- dễ miss một nhánh

### Bài học

> Cherry-pick nên là ngoại lệ chiến thuật, không phải chiến lược chính.

### Kinh nghiệm

Nếu team thấy cherry-pick diễn ra quá thường xuyên, thường là dấu hiệu:

- branch strategy có vấn đề
- release flow quá rối
- source-of-truth không rõ

---

## 32) Commit Test Data/Mock Tạm Thời Rồi Quên Xóa

### Bối cảnh

Trong quá trình debug, dev commit:

- mock data
- bypass auth
- debug logs
- fake API response
- hardcoded ID

Sau đó merge vì reviewer không để ý.

### Bài học

> Git không phân biệt "tạm thời" với "chính thức"; commit vào rồi là lịch sử thật.

### Kinh nghiệm

Rất nên review kỹ các thay đổi kiểu:

- environment
- mock file
- temporary flags
- console/debug code

---

## 33) Accidentally Commit File Quá Lớn Làm Repo Chậm Dần

### Bối cảnh

Một dev commit:

- video
- build artifact
- screenshot nặng
- log file
- node_modules phần nào đó

Ban đầu chưa ai để ý.
Về lâu dài:

- clone chậm
- fetch chậm
- CI chậm
- repo phình to

### Bài học

> Một commit lớn có thể để lại "technical debt ở cấp repo".

### Kinh nghiệm

- `.gitignore` phải chuẩn
- không commit artifact build
- nếu lỡ commit file lớn, có thể cần dọn history

---

## 34) Tag Release Không Nhất Quán Làm Rollback Và Audit Cực Khó

### Bối cảnh

Có team release nhưng:

- lúc dùng tag, lúc không
- tag đặt tên lung tung
- tag không map rõ với version/app/environment

Đến khi hỏi:

- production đang chạy commit nào?
- release 1.8.2 gồm những gì?
- rollback về bản ổn định trước là bản nào?

Không ai chắc chắn.

### Bài học

> Tag không chỉ để đẹp; tag là neo định vị của release management.

### Kinh nghiệm

Nên có convention như:

```text
v1.8.2
webapp-prod-2026-04-04
release/customer-a/v2.3.1
```

---

## 35) Git Hook Quá Nặng Khiến Dev Tìm Cách Bypass

### Bối cảnh

Team thêm pre-commit quá nhiều thứ:

- lint full repo
- unit test full
- build full app
- scan đủ loại

Kết quả:

- commit quá chậm
- dev dùng `--no-verify`
- hook mất tác dụng

### Bài học

> Automation tốt phải cân bằng giữa bảo vệ và tốc độ.

### Kinh nghiệm

Pre-commit chỉ nên chạy:

- staged formatting
- staged lint
- check nhanh

Còn nặng hơn để CI làm.

---

## 36) Một File Bị Sửa Liên Tục Bởi Nhiều Người Vì Thiết Kế Module Chưa Tốt

### Bối cảnh

Có những file trở thành "điểm nóng conflict":

- shared routing
- environment config
- constants chung
- mega component
- central module export

Mỗi tuần conflict 5–10 lần.

### Bài học

> Conflict nhiều không chỉ là vấn đề Git; nó còn là tín hiệu thiết kế codebase đang quá tập trung.

### Kinh nghiệm

Nếu một file conflict liên tục, cần hỏi:

- có nên tách module?
- có nên phân layer?
- có nên giảm coupling?
- có thể dùng feature config riêng không?

Git conflict đôi khi là dấu hiệu của architectural smell.

---

## 37) Review Chỉ Nhìn "Files Changed" Mà Không Xem Commit History

### Bối cảnh

Reviewer chỉ xem snapshot cuối cùng của PR.
Không xem từng commit.

Kết quả:

- bỏ lỡ việc author đã thử nhiều hướng nguy hiểm
- khó hiểu intent
- khó review migration/refactor nhiều bước

### Bài học

> Có những PR cần review cả "final diff" lẫn "evolution of commits".

### Kinh nghiệm

Đặc biệt với:

- refactor lớn
- migration Angular
- dependency upgrade
- conflict-heavy PR

---

## 38) Team Phụ Thuộc Quá Nhiều Vào GUI, Không Hiểu Bản Chất Git

### Bối cảnh

Dev dùng SourceTree/GitHub Desktop/VS Code UI rất nhiều.
Điều đó không sai.

Nhưng đến lúc gặp:

- detached HEAD
- rebase conflict
- reflog recovery
- cherry-pick conflict
- revert merge commit

Thì không hiểu chuyện gì đang xảy ra.

### Bài học

> GUI giúp nhanh, nhưng senior cần hiểu model của Git: commit, HEAD, branch pointer, index, working tree.

### Kinh nghiệm

Không cần "thuộc lòng 100 lệnh", nhưng phải hiểu:

- merge là gì
- rebase là gì
- reset tác động ở đâu
- revert khác reset thế nào
- force push nguy hiểm ra sao

---

## 39) Dùng Git Để Hỗ Trợ Forensic Sau Incident Production

### Bối cảnh

Production incident xảy ra.
Team cần trả lời:

- commit nào lên prod?
- ai review?
- thay đổi nào liên quan?
- release note có gì?
- patch nào chưa back-merge?

### Bài học

> Git không chỉ để code collaboration; còn là hệ thống forensic và audit trail.

### Kinh nghiệm

Muốn làm được điều này tốt thì cần:

- commit message rõ
- PR linked rõ
- tag release rõ
- branch discipline tốt

---

## 40) Bài Học Lớn Nhất: Git Issue Thường Là Symptom, Không Phải Root Cause

### Thực tế

Nhiều vấn đề tưởng là "Git problem" nhưng gốc rễ là:

- PR quá lớn
- release flow rối
- ownership không rõ
- module coupling cao
- code review yếu
- team thiếu convention

### Kết luận

> Git chỉ phơi bày chất lượng collaboration và architecture của team.

---

## Những Bài Học Senior-Level Rất Đáng Nhớ

```text
1. Conflict nhiều = có thể codebase coupling quá cao
2. Cherry-pick nhiều = branch strategy có thể đang sai
3. Force-push nhiều = review flow có thể đang thiếu ổn định
4. PR to = downstream cost cao cho review, test, rollback
5. Release không có tag = vận hành thiếu truy vết
6. Hook bị bypass nhiều = automation đang không thực tế
7. File hot-spot conflict = nên xem lại thiết kế module
8. Git history xấu = chi phí debug và audit tăng dần theo thời gian
```

---

## Workflow Git Thực Tế Cho Team Enterprise

```text
main
 └─ production-ready only

develop
 └─ integration branch (nếu team cần)

feature/*
 └─ nhánh ngắn, PR nhỏ, update thường xuyên

hotfix/*
 └─ tách riêng từ main, fix nhanh, merge ngược lại

release/*
 └─ chỉ dùng nếu quy trình release phức tạp
```

Nếu team nhỏ và delivery nhanh, có thể dùng:

```text
main
 └─ protected
feature/*
 └─ PR vào main
tag
 └─ cho release
```

Đây thường thực tế hơn GitFlow full.

---

## Kết Luận

Nếu gom lại thành 1 câu:

> Dùng Git giỏi không phải là nhớ nhiều lệnh, mà là biết **giữ lịch sử sạch, giảm conflict, hỗ trợ review, và làm rollback an toàn**.

Và với Senior Frontend/Angular trong environment enterprise:

> Các case Git bạn sẽ gặp nhiều nhất thường liên quan đến **Angular upgrade branch sống quá lâu**, **conflict ở shared module/routing/styles**, **UI fix + business logic bị nhét chung 1 PR**, **format toàn project gây nhiễu review**, **hotfix quên merge ngược**, **structural refactor làm vỡ import/path alias**, và **reviewer phải checkout branch để verify UI**.

Khi bạn hiểu được **Git history là tài sản chung của team**, **conflict là tín hiệu kiến trúc**, và **commit message là tương lai**, bạn sẽ trở thành senior không chỉ về kỹ năng Git lệnh, mà là **Git discipline và culture**.
