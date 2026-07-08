# System Design Authoring Skill (Nhất quán format)

Mục tiêu: tất cả bài System Design có cấu trúc đồng nhất, dễ đọc, dễ scan, dễ mở rộng.

## Quy ước bắt buộc

1. Front matter
   - `track: "system-design"`
   - `chapter: "1".."16"` (để map đúng group trong `system-design.md`)
   - `title` ngắn gọn, tránh tiền tố lặp kiểu `System Design Chương X — ...`

2. Cấu trúc nội dung
   - Mục tiêu bài
   - Context
   - Kiến trúc tổng quan
   - Request/Data flow
   - API/Data contract
   - Trade-offs
   - Tóm tắt

3. Hình ảnh
   - Đặt tại: `assets/images/system-design/chXX-<slug>/`
   - Tên file thống nhất:
     - `figure-1-1.png`
     - `figure-1-2.png`
     - `figure-1-3.png`
   - Không cần hiển thị hướng dẫn upload ảnh hoặc placeholder ảnh trong nội dung bài.

4. Diagram trong bài
   - Mỗi bài tối thiểu 1 diagram text (` ```text `) được generate từ ảnh/context.
   - Diagram theo pattern: component -> flow -> response.

## Workflow đề xuất cho mỗi bài mới

1. Copy từ `post-template.md`
2. Điền front matter + chapter
3. Viết nội dung theo các phần cố định (không thêm checklist vào bài)
4. Upload hình theo chuẩn tên + thư mục (nếu có)
5. Generate diagram text từ ảnh/context và chèn vào bài
6. Validate hiển thị ở `/system-design/`

## Checklist (nội bộ, không render trong bài)

- [ ] Title ngắn gọn, không lặp prefix dư thừa.
- [ ] Có `track: system-design` và `chapter` đúng.
- [ ] Ít nhất 1 diagram text trong bài.
- [ ] API/JSON block format hợp lệ.
- [ ] Bài xuất hiện đúng chapter trong `/system-design/`.

## Prompt ngắn để tự generate diagram text

"Hãy tạo diagram text cho bài toán <X> theo format:

- tổng quan architecture
- request flow 1..N
- error path nếu có
  Giữ tối đa 15 dòng/diagram, dễ đọc trong markdown code block."
