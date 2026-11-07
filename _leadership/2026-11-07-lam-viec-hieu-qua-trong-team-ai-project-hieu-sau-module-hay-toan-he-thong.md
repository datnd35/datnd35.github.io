---
layout: post
title: "🚀 Làm việc hiệu quả trong team AI Project: Hiểu sâu module của mình hay hiểu toàn bộ hệ thống?"
date: 2026-11-07 09:00:00 +0700
categories: leadership
track: become-a-better-leader
---

Gần đây, mình đang cùng một team phát triển dự án **Manufacturing Knowledge AI Chatbot – Search & Citation**.

Team chia dự án thành nhiều module độc lập:

- **Code Base:** Xây dựng cấu trúc project.
- **Data & Vector Database:** Xử lý dữ liệu và lưu trữ embeddings.
- **LLM Integration:** Tích hợp mô hình ngôn ngữ.
- **Identify Question:** Phân tích intent của người dùng.
- **Search Tool:** Tìm kiếm dữ liệu liên quan.
- **Filter & Validation:** Lọc và xác thực kết quả.
- **Finalize Answer:** Tổng hợp câu trả lời và citation.
- **Orchestrator:** Điều phối toàn bộ workflow bằng LangGraph.

Mỗi thành viên chịu trách nhiệm một phần, mục tiêu cuối cùng là tích hợp thành một AI Chatbot hoàn chỉnh. Khi bắt đầu làm việc theo cách này, mình nhận ra có khá nhiều câu hỏi cần suy nghĩ.

**1. Nên đào sâu module mình phụ trách hay tìm hiểu toàn bộ flow?**

Nếu chỉ tập trung vào module của mình, liệu mình có hiểu module đó giải quyết vấn đề gì và tương tác với thành phần khác ra sao? Ngược lại, nếu dành quá nhiều thời gian tìm hiểu tất cả module, liệu còn đủ thời gian làm tốt phần việc được giao?

**2. Nếu ai cũng hiểu toàn bộ flow thì chia task theo module còn ý nghĩa gì?**

Chia module không phải để mỗi người chỉ biết phần của mình. Mục đích thực sự là:

- Giảm sự phụ thuộc giữa các thành viên.
- Cho phép phát triển song song.
- Phân định trách nhiệm rõ ràng.
- Dễ testing và bảo trì.
- Giảm độ phức tạp khi tích hợp.

Mỗi người không cần biết hết chi tiết implementation của nhau, nhưng cần hiểu module của mình nằm ở đâu trong bức tranh tổng thể.

**3. Không hiểu flow tổng thể thì làm sao phát triển module hiệu quả?**

Với vai trò Orchestrator, mình cần hiểu:

- Identify Question trả về những thông tin gì?
- Search Tool nhận input nào và trả về output nào?
- Validation dựa vào tiêu chí nào để quyết định kết quả hợp lệ?
- Khi không có dữ liệu thì workflow đi đâu?
- Khi LLM hoặc Search bị lỗi thì xử lý thế nào?
- Finalize Answer cần dữ liệu gì để tạo câu trả lời và citation?

Nếu không hiểu những điều này, mình có thể viết được một LangGraph workflow chạy thành công về mặt kỹ thuật, nhưng chưa chắc nó giải quyết đúng bài toán của hệ thống.

---

## 1. Tư duy T-shaped Engineer: Hiểu rộng, đào sâu

**Chiều ngang – System Understanding:** hiểu toàn bộ hệ thống ở mức kiến trúc và luồng dữ liệu.

- Hệ thống giải quyết vấn đề gì?
- Các module có nhiệm vụ gì?
- Dữ liệu đi qua những thành phần nào?
- Input/output của từng module là gì?
- Các module phụ thuộc nhau như thế nào?
- Lỗi và fallback được xử lý ra sao?

**Chiều dọc – Technical Ownership:** đào sâu module mình chịu trách nhiệm.

- Hiểu rõ business logic.
- Nắm vững công nghệ sử dụng.
- Thiết kế interface.
- Xử lý edge cases.
- Viết unit test và integration test.
- Đảm bảo module hoạt động độc lập và ổn định.

> **Hiểu đủ rộng để không phát triển sai hướng, hiểu đủ sâu để tạo ra giá trị thực sự.**

## 2. Không cần hiểu tất cả code, nhưng phải hiểu toàn bộ flow

Ví dụ với Manufacturing AI Chatbot:

```text
User Question
     |
     v
Identify Question
     |
     v
Check Intent
     |
     v
Search Tool
     |
     v
Filter & Validation
     |
     v
Finalize Answer
     |
     v
Response + Citation
```

Mỗi thành viên không cần đọc từng dòng code của mọi module, nhưng nên trả lời được 5 câu hỏi:

1. Module trước mình cung cấp dữ liệu gì?
2. Module mình cần nhận dữ liệu gì?
3. Module mình phải trả về dữ liệu gì?
4. Module tiếp theo sử dụng kết quả của mình như thế nào?
5. Nếu module mình thất bại thì hệ thống xử lý ra sao?

Trả lời được 5 câu này, bạn đã có mental model khá tốt về vị trí của mình trong hệ thống.

## 3. Thống nhất Contract trước khi code

Nguyên nhân phổ biến khiến integration khó khăn là mỗi người tự thiết kế interface theo cách riêng. Ví dụ Search trả về:

```json
{
  "results": []
}
```

Nhưng Validation lại mong đợi:

```json
{
  "documents": []
}
```

Hai module chạy tốt khi test riêng, nhưng kết hợp lại sẽ lỗi. Vì vậy team cần thống nhất trước:

- Shared State.
- Input / Output Schema.
- Function Interface.
- Error Handling.
- Naming Convention.
- Data Contract.

Trong dự án này, `ChatState` là một trong những contract quan trọng nhất giữa các node của LangGraph.

> Đừng chỉ hỏi module của mình cần code gì, hãy hỏi module của mình cần giao tiếp với các module khác như thế nào.

## 4. Phát triển song song nhưng phải integration sớm

Đừng đợi tất cả module hoàn thành 100% mới tích hợp. Có thể chia 3 giai đoạn:

**Giai đoạn 1 – Independent Development**

Mỗi người phát triển module riêng dựa trên contract đã thống nhất, dùng Mock Data, Mock LLM, Mock Search Results và Unit Tests. Mục tiêu: module chạy và kiểm thử độc lập.

**Giai đoạn 2 – Early Integration**

Tích hợp sớm một flow tối thiểu:

```text
Question
   |
   v
Identify (Mock)
   |
   v
Search (Mock)
   |
   v
Validation (Mock)
   |
   v
Finalize (Mock)
   |
   v
Response
```

Sau đó thay dần mock bằng implementation thực tế. Mục tiêu: phát hiện sớm vấn đề về interface, data structure và dependency.

**Giai đoạn 3 – End-to-End Testing**

Kiểm thử toàn bộ workflow với dữ liệu và LLM thực tế, tập trung vào:

- Out of Scope.
- Có dữ liệu liên quan.
- Không tìm thấy dữ liệu.
- Kết quả tìm kiếm nhiễu.
- LLM timeout hoặc API error.
- Citation không chính xác.

## 5. Làm việc nhóm không chỉ là hoàn thành task của mình

**Hoàn thành task cá nhân không đồng nghĩa với việc team đã hoàn thành mục tiêu.** Giá trị của mỗi thành viên không chỉ nằm ở code mình viết mà còn ở khả năng giúp các module kết nối với nhau.

Một số thói quen nên xây dựng:

- Chủ động trao đổi khi chưa rõ requirement.
- Không tự giả định interface của module khác.
- Chia sẻ sớm những vấn đề ảnh hưởng đến integration.
- Commit thường xuyên và tạo Pull Request nhỏ.
- Review code của nhau để hiểu thêm về hệ thống.
- Document các quyết định kỹ thuật quan trọng.
- Chủ động hỗ trợ khi người khác gặp vấn đề liên quan đến dependency.

Khi phát hiện vấn đề, hãy trao đổi theo hướng:

- Vấn đề là gì?
- Ảnh hưởng đến module nào?
- Nguyên nhân có thể nằm ở đâu?
- Đề xuất giải pháp nào?
- Ai cần phối hợp để giải quyết?

Đừng đợi đến cuối sprint mới phát hiện hai module không thể kết nối với nhau.

## 6. Một framework cá nhân: 20 – 60 – 20

**20% – Understand the System**

- Đọc architecture diagram.
- Hiểu business requirements.
- Theo dõi workflow.
- Hiểu dependency giữa các module.
- Nắm contract chung.

**60% – Deep Dive & Implementation**

- Nghiên cứu công nghệ.
- Thiết kế module.
- Implement business logic.
- Viết test.
- Xử lý edge cases.

**20% – Collaboration & Integration**

- Trao đổi với các thành viên.
- Review code.
- Kiểm tra interface.
- Integration testing.
- Cập nhật tài liệu.

Đây không phải công thức cố định. Giai đoạn đầu cần nhiều thời gian hiểu kiến trúc và thống nhất contract; giai đoạn cuối cần tăng thời gian integration và testing.

## 7. Câu hỏi nên tự đặt ra khi tham gia dự án mới

**Về Business**

- Sản phẩm giải quyết vấn đề gì?
- Ai là người sử dụng?
- Use case quan trọng nhất là gì?
- Definition of Done là gì?

**Về Architecture**

- Hệ thống gồm những module nào?
- Data flow đi như thế nào?
- Các module giao tiếp với nhau ra sao?
- Những dependency quan trọng là gì?

**Về Technical Ownership**

- Phạm vi trách nhiệm của mình đến đâu?
- Input / Output của module là gì?
- Những edge cases nào cần xử lý?
- Làm thế nào để test độc lập?

**Về Teamwork**

- Ai phụ trách những dependency liên quan?
- Khi có thay đổi contract thì thông báo ở đâu?
- Branch strategy và Pull Request process thế nào?
- Khi gặp blocker cần phối hợp với ai?

## 8. Kết luận: Từ Individual Contributor đến System Thinker

Làm việc trong một team phần mềm không đơn giản là chia task rồi hoàn thành phần việc được giao. Cần phát triển đồng thời hai năng lực:

1. **Technical Depth:** Giải quyết vấn đề chuyên sâu trong phạm vi mình chịu trách nhiệm.
2. **System Thinking:** Hiểu cách các thành phần kết nối, tương tác và tạo nên giá trị của toàn hệ thống.

Người chỉ hiểu module của mình có thể hoàn thành một task tốt. Người chỉ hiểu tổng thể nhưng không đào sâu kỹ thuật có nhiều ý tưởng nhưng khó biến thành implementation. Người vừa hiểu hệ thống, vừa làm chủ module của mình sẽ đóng góp nhiều nhất cho team.

**Điều quan trọng không phải là biết tất cả mọi thứ, mà là biết mình cần hiểu điều gì, hiểu đến mức nào và chịu trách nhiệm đến đâu.**

Đây cũng là tư duy mình muốn rèn luyện trên hành trình từ Software Engineer lên Senior Engineer và xa hơn là Software Architect.

_Build your module. Understand the system. Collaborate with the team._ 🚀
