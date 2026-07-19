---
layout: post
title: "LLM Fine-Tuning: Nền Tảng Từ Pre-trained Model Đến Specialized Model"
date: 2026-07-19
categories: ai
tags:
  [ai, llm, fine-tuning, machine-learning, nlp, bert, gpt, foundation-models]
track: "fine-tuning"
references:
  - title: "LM Fine-Tune with your custom data"
    url: "https://www.udemy.com/course/llm-fine-tune/"
---

## Fine-tuning là gì và tại sao cần?

Fine-tuning là quá trình lấy một **pre-trained model** (BERT, GPT, v.v.) và train thêm trên **dataset nhỏ hơn, chuyên biệt** cho một task cụ thể — text summarization, Q&A, sentiment analysis, NER, v.v.

> Mục tiêu: không train lại từ đầu, mà **tận dụng kiến thức sẵn có** của model lớn, rồi "tinh chỉnh" cho domain của bạn.

```text
  PRE-TRAINED MODEL              FINE-TUNED MODEL
  ┌─────────────────┐            ┌─────────────────┐
  │  BERT / GPT     │            │  BERT / GPT     │
  │  (general)      │  + custom  │  (specialized)  │
  │  175B params    │    data ──>│  your task      │
  └─────────────────┘            └─────────────────┘
  Hiểu ngôn ngữ tổng quát       Làm tốt 1 task cụ thể
```

---

## Pre-trained Models là gì?

Model đã được train trên **lượng dữ liệu khổng lồ** (internet, sách, v.v.), học được ngữ pháp, ngữ nghĩa, và kiến thức tổng quát.

| Model       | Tổ chức    | Params | Mạnh về                   |
| ----------- | ---------- | ------ | ------------------------- |
| **BERT**    | Google     | 340M   | NLP: NER, Q&A, sentiment  |
| **GPT-3**   | OpenAI     | 175B   | Text generation           |
| **GPT-4**   | OpenAI     | ~1.5T  | Đa nhiệm, multilingual    |
| **LLaMA 2** | Meta       | 1.2T   | Open source, fine-tunable |
| **T5**      | Google     | 11B    | Text-to-text tasks        |
| **BLOOM**   | BigScience | 176B   | Multilingual              |

---

## Training vs Fine-tuning: Khác nhau như thế nào?

```text
  TRAINING                          FINE-TUNING
  ─────────────────────────         ─────────────────────────
  Dạy model "biết" ngôn ngữ         Dạy model làm 1 task cụ thể
  Dữ liệu: hàng tỷ records          Dữ liệu: nhỏ, task-specific
  Điều chỉnh: toàn bộ weights       Điều chỉnh: deeper layers
  Chi phí: hàng triệu USD           Chi phí: thấp hơn nhiều
  Kết quả: general model            Kết quả: specialized model
```

**Training**: model học từ dữ liệu khổng lồ, điều chỉnh weights/biases qua embedding + activation functions.

**Fine-tuning**: giữ nguyên initial layers (đã học pattern tổng quát), chỉ điều chỉnh **deeper layers** cho task mới:

- Initial layers → edges, texture, generic features
- Deeper layers → task-specific patterns (sentiment, NER, summarization...)

---

## Foundation Models

Foundation models là pre-trained model quy mô lớn, có thể **adapt cho nhiều task** khác nhau:

```text
                    FOUNDATION MODEL
                   (GPT-4 / LLaMA / BERT)
                          │
        ┌─────────────────┼────────────────────┐
        ▼                 ▼                    ▼
   Q&A / RAG       Sentiment Analysis    Image Captioning
   Summarization   NER / Extraction      Object Recognition
   Classification  Intent Detection      Topic Modeling
```

**3 giai đoạn của Foundation Model:**

1. **Pre-training** — train trên dữ liệu lớn (weeks/months, millions USD)
2. **Fine-tuning** — train thêm trên dataset nhỏ, task-specific
3. **Deployment** — deploy API/web app, nhận input mới, generate prediction

---

## Tại sao nên fine-tune thay vì dùng model lớn?

> **Nghiên cứu của OpenAI**: InstructGPT (1.3B params, fine-tuned) **vượt trội** GPT-3 (175B params) trên cùng task — dù nhỏ hơn 100 lần.

→ **Fine-tuned smaller model thường tốt hơn large general model** cho task cụ thể.

```text
  GPT-3           InstructGPT
  175B params  vs 1.3B params (fine-tuned)
  General          Task-specific
  ❌ Loses         ✅ Wins
```

**Xu hướng: Small Language Models (SLM)** — model nhỏ, chuyên biệt, hiệu quả cao:

- Sentiment analysis cho stock market data
- NER cho news domain
- Summarization cho legal documents
- Q&A trên earnings call transcripts

---

## Các bước fine-tune một Foundation Model

```text
  1. Choose Model      Bert (NLP tasks) vs GPT-3 (generation)
         │
  2. Install Deps      PyTorch / TensorFlow + HuggingFace Transformers
         │
  3. Load Model        Mistral 7B / LLaMA 2 / BERT (cần RAM/GPU)
         │
  4. Prepare Data      Task-specific dataset (input + expected output)
         │
  5. Fine-tune         Transfer learning trên custom data
         │
  6. Test & Evaluate   Accuracy, Precision, Recall, F1 Score
         │
  7. Deploy            API / Web App → nhận data mới → generate output
```

---

## Model Parameters vs Hyperparameters

|                | Model Parameters        | Hyperparameters                   |
| -------------- | ----------------------- | --------------------------------- |
| **Là gì**      | Weights & biases        | Kiểm soát quá trình learning      |
| **Loại**       | Internal                | External                          |
| **Ví dụ**      | weights, biases         | batch size, learning rate, epochs |
| **Điều chỉnh** | Tự điều chỉnh khi train | Developer set thủ công            |

Khi fine-tune qua OpenAI API:

```json
{
  "hyperparameters": {
    "batch_size": 4,
    "learning_rate_multiplier": 0.1,
    "n_epochs": 3
  }
}
```

---

## Chọn model nào để fine-tune?

- **Cần hiểu ngữ cảnh sâu (NER, Q&A, classification)** → BERT / RoBERTa
- **Cần sinh text, summarization** → GPT-3.5 / T5 / LLaMA
- **Open source, chạy local** → LLaMA 2, Mistral 7B (cần GPU tốt)
- **Cloud / API** → OpenAI fine-tuning API, Google Vertex AI
- **Môi trường thử nghiệm** → Google Colab (free GPU)

---

## Tóm tắt

Fine-tuning = **tận dụng intelligence của model lớn + specialized bằng data của bạn**.

Bạn không cần hàng triệu USD hay cluster GPU khổng lồ. Chỉ cần:

1. Dataset nhỏ, chất lượng, đúng task
2. Framework phù hợp (HuggingFace, PyTorch)
3. Hiểu rõ mình muốn model làm gì

**Kết quả**: một specialized language model chính xác hơn general model cho domain của bạn.
