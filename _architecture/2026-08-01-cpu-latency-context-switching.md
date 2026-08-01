---
layout: post
title: "CPU Processing Latency"
date: 2026-08-01
categories: architecture
track: "software-architecture"
section: "performance"
description: "Phân tích 2 nguyên nhân gây CPU Latency: thuật toán kém hiệu quả và Context Switching. Tập trung vào Context Switching – cơ chế hoạt động, chi phí ẩn và cách giảm thiểu."
tags:
  [
    software-architecture,
    performance,
    latency,
    cpu-latency,
    context-switching,
    operating-system,
    throughput,
    tech-lead,
  ]
---

CPU Latency chủ yếu đến từ **2 nguyên nhân**:

1. **Inefficient Algorithms** — thuật toán không tối ưu
2. **Context Switching** — chuyển đổi giữa các Process/Thread

Phần này tập trung vào **Context Switching**, vì đây là nguyên nhân ít được chú ý nhưng có thể làm giảm hiệu năng của toàn bộ hệ thống.

---

## Diagram tổng quan

```text
                    CPU Latency
                         │
        ┌────────────────┴────────────────┐
        │                                 │
        ▼                                 ▼
 Inefficient Algorithm            Context Switching
        │                                 │
        ▼                                 ▼
 More CPU Instructions         Save / Restore Process
        │                                 │
        ▼                                 ▼
 Higher CPU Time             CPU Idle During Switching
        └────────────────┬────────────────┘
                         ▼
                  Higher Response Time
```

---

## 1) Hai nguyên nhân gây CPU Latency

### Inefficient Algorithm

```text
O(n²) → O(n log n)
```

Thuật toán càng tệ → CPU tính toán càng lâu. Đây là vấn đề developer dễ nhìn thấy.

### Context Switching

Không phải CPU tính toán chậm, mà CPU mất thời gian **chuyển đổi giữa các Process hoặc Thread**. Đây mới là trọng tâm của bài.

---

## 2) Context Switching là gì?

Giả sử máy chỉ có **1 CPU Core** và có 2 Process đang chạy.

CPU chỉ chạy được một process tại một thời điểm:

```text
           CPU
            │
            ▼
      +------------+
      | Process 1  |   ← đang chạy
      +------------+

      Process 2 đang chờ
```

Khi Process 1 cần đọc Disk, nó bị block. OS quyết định:

```text
Process 1 Need Disk I/O → Blocked
        │
        ▼
OS Evict Process 1
        │
        ▼
Run Process 2
```

---

## 3) Điều gì xảy ra trong một Context Switch?

```text
Process 1 Running
        │
        ▼
Save Process State
(Register, Stack, PCB)
        │
        ▼
Store To RAM
        │
        ▼
Load Process 2 State
        │
        ▼
Restore Registers
        │
        ▼
Run Process 2
```

OS phải:

1. **Lưu trạng thái Process 1** — Register, Program Counter, Stack Pointer, Process Control Block (PCB) → RAM
2. **Load Process 2** — đọc từ RAM lên CPU
3. **Khôi phục toàn bộ trạng thái** — sau đó Process 2 mới tiếp tục chạy

---

## 4) Context Switching tạo ra thời gian lãng phí

```text
Timeline
──────────────────────────────────────────────>

Process 1   ████████░░░░░░░░░░████████
                    ↑         ↑
             Save Context  Restore Context
                    │         │
                    └────┬────┘
                    (overhead)
Process 2           ████████████
```

Khoảng thời gian Save/Restore không có business logic nào được xử lý. CPU chỉ đang thực hiện overhead.

---

## 5) Vì sao Context Switch xảy ra?

```text
Process
  │
  ▼
Compute
  │
  ▼
Disk Read / Network Call
  │
  ▼
Blocked
  │
  ▼
CPU chuyển sang Process khác
```

Ngày nay, hầu như mọi máy đều chạy nhiều Process/Thread cùng lúc:

```text
Chrome / VSCode / Slack / Docker / Spotify / Database / Terminal
       │
       ▼
CPU luôn phải luân phiên: A → B → C → D → A → ...
```

---

## 6) Context Switching làm chậm hệ thống như thế nào?

Giả sử một Process thực tế chỉ cần **100 ms** để xử lý, nhưng bị Context Switch 3 lần:

```text
Ideal    ██████████████████████  →  100 ms

Reality  ████ · · ███ · · ████ · · ██  →  205 ms
              ↑       ↑       ↑
           switch  switch  switch
           (+35ms) (+40ms) (+30ms)
```

Business logic không thay đổi — nhưng Response Time tăng gấp đôi.

---

## 7) Luồng Context Switching hoàn chỉnh

```text
                Process 1
                    │
                    ▼
             Execute Normally
                    │
             Need Disk / Network
                    │
                    ▼
             Blocked for I/O
                    │
                    ▼
        Operating System Scheduler
                    │
        ┌───────────┴───────────┐
        ▼                       ▼
 Save Process 1          Load Process 2
        │                       │
        └───────────┬───────────┘
                    ▼
               Context Switch
                    │
                    ▼
             Process 2 Executes
```

---

## Tổng kết

```text
                     CPU Latency
                           │
          ┌────────────────┴────────────────┐
          │                                 │
          ▼                                 ▼
 Inefficient Algorithm            Context Switching
          │                                 │
          ▼                                 ▼
  More CPU Work              Save / Restore Process
          │                                 │
          ▼                                 ▼
  Longer Execution               CPU Overhead
          │                                 │
          └────────────────┬────────────────┘
                           ▼
                 Higher Response Time
                           │
                           ▼
              Minimize Unnecessary I/O
              Reduce Context Switching
```

| Nội dung                          | Ý nghĩa                                                                                                          |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| **CPU Latency có 2 nguyên nhân**  | Thuật toán kém hiệu quả và Context Switching                                                                     |
| **Context Switching**             | OS phải lưu trạng thái Process/Thread hiện tại và khôi phục Process/Thread khác trước khi tiếp tục thực thi      |
| **Nguyên nhân phổ biến**          | Process bị block do Disk I/O hoặc Network I/O nên CPU phải chuyển sang Process khác                              |
| **Chi phí của Context Switching** | CPU không xử lý business logic mà chỉ thực hiện lưu/khôi phục trạng thái — tạo ra overhead thuần tuý             |
| **Hậu quả**                       | Một tác vụ lẽ ra hoàn thành trong 100 ms có thể kéo dài đáng kể nếu bị context switch nhiều lần                  |
| **Mục tiêu tối ưu**               | Giảm các I/O không cần thiết và hạn chế context switching để CPU dành nhiều thời gian hơn cho việc xử lý thực sự |
