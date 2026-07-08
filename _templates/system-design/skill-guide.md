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
   - Luôn có alt text mô tả ngữ nghĩa.

4. Diagram trong bài
   - Mỗi bài tối thiểu 1 diagram text (` ```text `) để khi chưa load ảnh vẫn hiểu được flow.
   - Diagram theo pattern: component -> flow -> response.

## Workflow đề xuất cho mỗi bài mới

1. Copy từ `post-template.md`
2. Điền front matter + chapter
3. Viết nội dung theo 7 phần cố định
4. Upload hình theo chuẩn tên + thư mục
5. Thêm diagram text song song với hình
6. Validate hiển thị ở `/system-design/`

## Prompt ngắn để tự generate diagram text

"Hãy tạo diagram text cho bài toán <X> theo format:

- tổng quan architecture
- request flow 1..N
- error path nếu có
  Giữ tối đa 15 dòng/diagram, dễ đọc trong markdown code block."
