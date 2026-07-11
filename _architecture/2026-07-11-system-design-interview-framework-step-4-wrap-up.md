---
layout: post
title: "Framework System Design Interview: Step 4"
date: 2026-07-11
categories: architecture
track: "system-design"
chapter: "3"
chapter_order: 5
description: "Cách wrap up một system design interview: recap thiết kế, nêu bottleneck/cải tiến, bàn về error cases, vận hành, scale tiếp theo và phân bổ thời gian hợp lý."
tags: [system-design, interview, wrap-up, communication, time-management]
---

> **Nguồn tham khảo:** System Design Interview — Chapter 3: A Framework for System Design Interviews.

## 1) Mục tiêu bài viết

- Biết cách kết thúc phiên system design interview một cách chủ động và có chiều sâu.
- Trình bày được bottleneck, hướng cải tiến và giới hạn của thiết kế hiện tại.
- Tổng kết rõ ràng để giúp interviewer “đóng vòng” sau một buổi thảo luận dài.
- Nắm checklist Dos/Don’ts và phân bổ thời gian cho từng step.

---

## 2) Context

Step 4 là đoạn kết, nhưng không phải “phần phụ”. Đây là thời điểm bạn tạo ấn tượng cuối bằng tư duy phản biện:

- Không bao giờ nói thiết kế đã hoàn hảo.
- Chủ động nêu điểm có thể cải tiến.
- Thể hiện bạn hiểu hệ thống không chỉ ở thiết kế mà còn ở vận hành và mở rộng.

Interviewer có thể:

- hỏi follow-up về bottleneck,
- yêu cầu kế hoạch scale từ 1M lên 10M users,
- hỏi về error cases, monitoring, rollout,
- hoặc cho bạn tự đề xuất refinements nếu có thêm thời gian.

---

## 3) Kiến trúc tổng quan

### Figure 3-5 — Wrap-up decision map trong 3–5 phút cuối

```text
[Recap design in 30-60s]
          |
          v
[State bottlenecks + trade-offs]
          |
          v
[Discuss reliability + operations]
  - failure scenarios
  - monitoring/logging
  - rollout strategy
          |
          v
[Next scale curve]
  - 1M -> 10M users
          |
          v
[Optional refinements if more time]
```

### Figure 3-6 — Time allocation guide cho interview 45 phút

```text
Step 1) Understand problem & scope       : 3 - 10 min
Step 2) High-level design + buy-in       : 10 - 15 min
Step 3) Deep dive                        : 10 - 25 min
Step 4) Wrap up                          : 3 - 5 min
```

---

## 4) Request/Data flow

```text
1) Candidate recap ngắn toàn bộ thiết kế (objective + core components + key flow).
2) Candidate nêu 1-2 bottleneck chính và phương án cải tiến ưu tiên.
3) Candidate bàn về error cases: server failure, network loss, partial outage.
4) Candidate mô tả vận hành: metrics, logs, alerting, deployment/rollback.
5) Candidate nói về kế hoạch scale tiếp theo (vd. 1M -> 10M users).
6) Candidate chốt bằng đề xuất cải tiến nếu có thêm thời gian.
```

Ví dụ “final impression” tốt:

- “Thiết kế hiện tại đáp ứng mục tiêu P95 dưới 200ms ở 1M users; để lên 10M, em sẽ ưu tiên tách read/write path và tăng mức async fanout.”

---

## 5) API / Data contract

Ví dụ endpoint nội bộ để tổng hợp trạng thái readiness trước release:

```http
GET /api/v1/system-design/review/summary?targetUsers=10000000
Authorization: Bearer <token>
```

Ví dụ response JSON:

```json
{
  "status": "ok",
  "currentCapacityUsers": 1000000,
  "targetCapacityUsers": 10000000,
  "bottlenecks": [
    "fanout worker throughput",
    "hot-key pressure on news-feed cache"
  ],
  "improvements": [
    "increase queue partitions",
    "apply backpressure + retry with DLQ",
    "add regional read replicas"
  ],
  "operations": {
    "metrics": ["p95_latency", "queue_lag", "cache_hit_ratio", "error_rate"],
    "rollout": "canary_then_gradual",
    "rollback": "automated_on_slo_breach"
  }
}
```

---

## 6) Trade-offs

| Hướng wrap-up                       | Ưu điểm                            | Nhược điểm                        | Khi nào dùng                               |
| ----------------------------------- | ---------------------------------- | --------------------------------- | ------------------------------------------ |
| Recap ngắn + rõ                     | Giúp interviewer nhớ mạch thiết kế | Nếu quá dài sẽ mất thời gian      | Luôn nên dùng cuối phiên                   |
| Tập trung bottleneck + improvements | Thể hiện critical thinking mạnh    | Cần chọn đúng điểm nóng           | Khi đã có high-level/deep-dive ổn          |
| Bàn sâu 1 lỗi kỹ thuật nhỏ          | Cho thấy kỹ tính                   | Dễ bỏ lỡ big picture              | Chỉ nên dùng khi interviewer hỏi trực tiếp |
| Nêu roadmap scale tiếp theo         | Tín hiệu senior, thực tế           | Có thể quá rộng nếu thiếu timebox | 2-3 phút cuối của wrap-up                  |

### Dos

- Luôn hỏi lại để làm rõ nếu có ambiguity.
- Hiểu đúng yêu cầu trước khi khẳng định quyết định kỹ thuật.
- Nói to suy nghĩ, giao tiếp liên tục với interviewer.
- Đề xuất nhiều approach nếu phù hợp, rồi chốt theo trade-off.
- Sau khi thống nhất blueprint, đào sâu vào component quan trọng trước.
- Xem interviewer như teammate để trao đổi hai chiều.
- Không bỏ cuộc khi bí; chủ động xin hint khi cần.

### Don’ts

- Không nhảy vào solution khi chưa rõ yêu cầu/assumption.
- Không đi quá sâu một component ngay từ đầu.
- Không im lặng quá lâu.
- Không nghĩ interview kết thúc ngay sau khi đưa ra design đầu tiên.
- Không nói thiết kế “perfect, không cần cải tiến”.

---

## 7) Tóm tắt + bài học

- Step 4 là cơ hội vàng để chốt signal về tư duy phản biện và khả năng cộng tác.
- Một wrap-up mạnh luôn có: recap rõ, bottleneck rõ, kế hoạch cải tiến rõ.
- Design interview không kết thúc khi bạn vẽ xong sơ đồ; nó kết thúc khi hai bên cùng đóng vòng thảo luận.
- Quản lý thời gian tốt cho cả 4 step giúp bạn tối đa hóa chất lượng tín hiệu trong 45 phút.
