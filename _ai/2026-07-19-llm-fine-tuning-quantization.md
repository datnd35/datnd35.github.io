---
layout: post
title: "LLM Fine-Tuning: Quantization – Nén Model Để Chạy Được Ở Mọi Nơi"
date: 2026-07-19
categories: ai
tags:
  [ai, llm, fine-tuning, quantization, machine-learning, fp32, fp16, int8, nlp]
track: "ai-tools"
references:
  - title: "LM Fine-Tune with your custom data"
    url: "https://www.udemy.com/course/llm-fine-tune/"
---

## Tại sao cần Quantization?

Large language model như LLaMA 2 (70B params) hay GPT-3 (175B params) lưu trữ toàn bộ weights dưới dạng **32-bit floating point (FP32)**. Con số này cực kỳ lớn — không thể load vào máy tính thông thường hay deploy lên thiết bị nhỏ.

**Quantization** giải quyết bài toán này bằng cách **chuyển đổi từ format bộ nhớ cao xuống format bộ nhớ thấp hơn**.

```text
  FP32 (32-bit)    FP16 (16-bit)    INT8 (8-bit)
  ─────────────    ─────────────    ────────────
  0 → 4,294,967,296   0 → 65,536      0 → 256
  Chính xác cao    Cân bằng        Nhỏ gọn nhất
  RAM nhiều        RAM ít hơn      RAM thấp nhất
  GPU lớn          Cloud / Colab   Mobile / Edge
```

> Trade-off: **Bộ nhớ giảm → Tốc độ tăng → Độ chính xác giảm một chút**

---

## Floating Point trong Neural Network

Weights trong neural network được biểu diễn dưới dạng **floating point binary**, gồm 3 phần:

```text
  FP32 (32 bits tổng)
  ┌──────┬──────────────────┬───────────────────────────┐
  │  1   │       8          │            23             │
  │ Sign │    Exponent      │          Mantissa         │
  └──────┴──────────────────┴───────────────────────────┘
  (+/-)      Số mũ              Phần thập phân

  FP16 (16 bits tổng)
  ┌──────┬──────────┬──────────────────┐
  │  1   │    5     │       10         │
  │ Sign │ Exponent │    Mantissa      │
  └──────┴──────────┴──────────────────┘

  INT8 (8 bits tổng)
  ┌────────────────────────────────────┐
  │              8 bits               │
  │         Integer only              │
  └────────────────────────────────────┘
```

| Format   | Range              | Dùng cho                        |
| -------- | ------------------ | ------------------------------- |
| **FP32** | ~±3.4×10³⁸         | Training đầy đủ, lưu model gốc  |
| **FP16** | ~±65,504           | Fine-tuning, inference trên GPU |
| **INT8** | 0 → 255 (unsigned) | Deployment, mobile, edge        |

---

## Symmetric Quantization – Min-Max Scaler

Cách đơn giản nhất để convert một dãy số từ range lớn sang range nhỏ:

$$\text{scale} = \frac{X_{max} - X_{min}}{Q_{max} - Q_{min}}$$

$$Q = \text{round}\left(\frac{X}{\text{scale}}\right)$$

```text
  Ví dụ: X = [0, 1000] → Q = [0, 255]

  scale = (1000 - 0) / (255 - 0) = 3.92

  Số 25 trong X → round(25 / 3.92) = 6 trong Q
  Số 500 trong X → round(500 / 3.92) = 128 trong Q

  SYMMETRIC: khoảng cách giữa các giá trị đều nhau
```

---

## Asymmetric Quantization – Thêm Zero Point

Khi dữ liệu **không phân bố đều** (lệch trái hoặc phải), cần thêm **zero point** để căn chỉnh:

$$Q = \text{round}\left(\frac{X}{\text{scale}}\right) + \text{zero\_point}$$

```text
  Ví dụ: X = [-20, 1000] → Q = [0, 255]

  Số -20 → round(-20 / scale) = -5
  Thêm zero_point = +5 → -5 + 5 = 0 ✓

  Zero point đảm bảo giá trị nhỏ nhất của X
  luôn map đúng về 0 trong Q
```

---

## 2 Modes của Quantization

### 1. Post-Training Quantization (PTQ)

Lấy model đã train sẵn → áp dụng **calibration** → ra quantized model.

```text
  Pre-trained Model         Quantized Model
  (weights cố định)  ──►   (weights nén)
         │                       │
    Calibration             Sẵn sàng dùng
  (Platt Scaling /          cho use cases
  Isotonic Regression)
```

**Calibration** là gì? Là quá trình điều chỉnh predicted probabilities của model để khớp với **actual likelihood** thực tế.

- **Platt Scaling** — fit logistic regression lên predicted probabilities
- **Isotonic Regression** — fit piecewise constant non-decreasing function

⚠️ **Nhược điểm PTQ**: model không biết mình sẽ được quantize → có thể giảm accuracy.

---

### 2. Quantization-Aware Training (QAT)

**Dạy model "biết" nó sẽ bị quantize** ngay từ khi training.

```text
  Full Precision Training          QAT
  ─────────────────────            ─────────────────────────
  Weights: FP32                    Weights: FP32
  Không biết sẽ bị nén             Simulate INT8 trong training
  → Deploy INT8 → mất accuracy     → Deploy INT8 → giữ accuracy
```

QAT **mô phỏng** việc rounding weights/activations trong quá trình training → model tự thích nghi với độ chính xác thấp hơn.

**Tham số quan trọng trong QAT:**

- **Scale**: mapping từ float về integer
- **Zero point**: căn chỉnh distribution

```text
  Ví dụ thực tế: App chỉnh ảnh trên smartphone

  Training (máy mạnh)         Deployment (smartphone)
  ─────────────────────       ───────────────────────
  Studio rộng, FP32           Bộ nhớ nhỏ, INT8
  Ảnh full resolution         Ảnh nén vừa màn hình

  PTQ: nén sau khi xong → mất chi tiết
  QAT: train ngay với ý thức "sẽ nén" → giữ chất lượng
```

---

## So sánh PTQ vs QAT

|                  | PTQ                   | QAT                      |
| ---------------- | --------------------- | ------------------------ |
| **Khi dùng**     | Sau khi có model      | Trong quá trình training |
| **Độ chính xác** | Có thể giảm nhiều     | Giảm ít hơn              |
| **Chi phí**      | Thấp, nhanh           | Cao hơn, cần train lại   |
| **Phù hợp**      | Prototype, thử nghiệm | Production, deploy edge  |

---

## Inference – Mục tiêu cuối cùng

Sau khi quantize, model được **deploy để inference** — tức là nhận input mới và sinh output.

```text
  Quantized Model
        │
        ├── HuggingFace Inference API  (web)
        ├── Google Colab / RunPod      (GPU cloud)
        ├── Mobile App                 (INT8, edge)
        └── Smartwatch / IoT           (INT4 / custom)
```

---

## Tóm tắt

```text
  Vấn đề: LLM quá lớn → không thể chạy trên máy thường

  Giải pháp: Quantization
  FP32 → FP16 → INT8
  ↑ Bộ nhớ    ↑ Tốc độ    ↑ Có thể chạy mọi nơi
  ↓ Accuracy  ← cần QAT để giảm thiểu mất mát

  Workflow:
  Base Model → Quantize (PTQ / QAT) → Fine-tune → Deploy → Inference
```

Quantization là **bước nền tảng không thể thiếu** trong fine-tuning LLM — đặc biệt khi bạn muốn chạy model trên máy cá nhân, Google Colab, hoặc thiết bị edge.
