---
layout: post
title: "☁️ AWS Series #01 — Cloud Computing & AWS là gì? Nền tảng bạn cần hiểu trước khi bắt đầu"
date: 2026-04-25
categories: cloud
---

> 📺 **Nguồn:** [AWS Zero to Hero — Episode 1](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze&index=2)  
> 📌 **Series:** AWS Zero to Hero — 30 bài từ cơ bản đến thực chiến

---

## 🎯 Mục Tiêu Bài Viết

Trước khi học bất kỳ dịch vụ AWS nào, bạn cần hiểu rõ:

- **Cloud Computing** là gì và tại sao nó ra đời?
- Sự khác biệt giữa **Private Cloud** và **Public Cloud**
- Tại sao **AWS** lại phổ biến và phù hợp cho người mới bắt đầu?
- **Cloud Repatriation** — xu hướng ngược chiều ít ai nhắc đến

> **Hiểu nền tảng tốt = học AWS nhanh hơn, nhớ lâu hơn, ứng dụng thực tế tốt hơn.**

---

## 📋 Tổng Quan Bài Học

```
AWS ZERO TO HERO — EPISODE 1
│
├── 1. Cloud là gì?
├── 2. Virtualization
├── 3. Private Cloud
├── 4. Public Cloud
├── 5. Vì sao Public Cloud phổ biến?
├── 6. Vì sao AWS phổ biến?
├── 7. Cloud Repatriation
└── 8. Tạo AWS Account
```

---

## 🏢 1. Trước Khi Có Cloud — Thời "Tự Lo Tất"

Ngày xưa, khi một công ty muốn chạy một ứng dụng, họ phải:

```
Công ty truyền thống (On-premises)
│
├── Mua server vật lý
├── Tự dựng data center
├── Tự quản lý network, điện, nhiệt độ
├── Tự bảo trì, bảo mật, nâng cấp
└── Tự xử lý khi server bị lỗi
```

**Vấn đề thực tế:**

| Vấn đề                              | Hệ quả                                       |
| ----------------------------------- | -------------------------------------------- |
| Chi phí đầu tư ban đầu rất lớn      | Cần mua server trước khi biết cần bao nhiêu  |
| Lãng phí tài nguyên                 | Server chạy 10% CPU nhưng vẫn tốn điện, tiền |
| Khó scale khi traffic tăng đột biến | Mua server mới mất hàng tuần/tháng           |
| Cần team vận hành riêng             | Chi phí nhân sự cao                          |

---

## 💡 2. Virtualization — Bước Đột Phá Đầu Tiên

Virtualization cho phép **chia một server vật lý lớn thành nhiều máy ảo (VM)** nhỏ hơn.

```
Trước Virtualization:
┌─────────────────────┐
│   Physical Server   │
│   (32 CPU, 256 RAM) │
│                     │
│   1 App duy nhất    │  ← Lãng phí 80% tài nguyên
└─────────────────────┘

Sau Virtualization:
┌──────────────────────────────────────────┐
│             Physical Server              │
│         (32 CPU, 256 RAM)                │
│                                          │
│  ┌────────┐ ┌────────┐ ┌────────┐       │
│  │  VM 1  │ │  VM 2  │ │  VM 3  │ ...   │
│  │ App A  │ │ App B  │ │ App C  │       │
│  └────────┘ └────────┘ └────────┘       │
└──────────────────────────────────────────┘
→ Tận dụng tài nguyên tối đa
```

> **Virtualization chính là nền tảng kỹ thuật của Cloud Computing.**

---

## 🏠 3. Private Cloud — Cloud "Tự Xây"

**Private Cloud** là hệ thống cloud do chính công ty xây dựng và vận hành nội bộ.

```
Private Cloud
│
├── Công ty tự mua server
├── Tự dựng data center
├── Dùng VMware / OpenStack để tạo cloud riêng
├── Team nội bộ tạo VM, storage khi cần
└── Chỉ dùng trong nội bộ tổ chức
```

**Phù hợp với ai?**

- Ngân hàng, tài chính, y tế — nơi dữ liệu nhạy cảm không thể để bên ngoài quản lý
- Tổ chức cần kiểm soát toàn bộ hạ tầng
- Công ty đã có sẵn đội ngũ IT mạnh

---

## 🌐 4. Public Cloud — Cloud "Thuê Dùng"

**Public Cloud** là cloud do các nhà cung cấp lớn vận hành. Bạn chỉ cần tạo tài khoản và dùng.

```
Public Cloud (AWS / Azure / GCP)
│
├── Provider mua server, dựng data center
├── Provider quản lý network, điện, bảo mật
├── Bạn chỉ cần: tạo tài khoản → request resource
└── Trả tiền theo mức sử dụng (pay-as-you-go)
```

**Ví dụ thực tế:**

- Cần server? → Click tạo EC2 instance trên AWS → chạy trong vài phút
- Hết dùng? → Xóa đi → không tốn tiền nữa

---

## ⚡ 5. So Sánh Private Cloud vs Public Cloud

```
PRIVATE CLOUD                    │  PUBLIC CLOUD
─────────────────────────────────┼─────────────────────────────────
Công ty tự mua server            │  AWS/Azure/GCP mua server
Công ty tự dựng data center      │  Provider quản lý data center
Công ty tự quản lý hạ tầng       │  Người dùng chỉ cần tạo resource
Chi phí đầu tư ban đầu cao       │  Pay-as-you-go, không cần đầu tư
Kiểm soát toàn bộ hệ thống       │  Kiểm soát ở mức ứng dụng
Phù hợp dữ liệu nhạy cảm        │  Phù hợp startup / mid-size
Cần team vận hành mạnh           │  Scale nhanh, hàng trăm service
```

---

## 🔥 6. Vì Sao Public Cloud Phổ Biến?

Nhiều người nghĩ lý do chính là **tiết kiệm chi phí** — nhưng thực ra lý do lớn hơn là:

> **Giảm gánh nặng vận hành (operational overhead)**

```
Với Public Cloud, công ty KHÔNG CẦN tự lo:
│
├── ❌ Mua và bảo trì server vật lý
├── ❌ Quản lý data center (điện, nhiệt, network)
├── ❌ Xử lý bảo mật tầng hạ tầng
├── ❌ Backup và disaster recovery phức tạp
├── ❌ Đội ngũ vận hành 24/7
└── ❌ Scale thủ công khi traffic tăng

Thay vào đó, tập trung vào:
└── ✅ Xây dựng sản phẩm và phát triển business
```

**Lợi ích cụ thể:**

| Lợi ích              | Giải thích                                                 |
| -------------------- | ---------------------------------------------------------- |
| **Tốc độ**           | Tạo resource trong vài phút, không mất tuần chờ mua server |
| **Flexibility**      | Scale up/down theo nhu cầu thực tế                         |
| **Pay-as-you-go**    | Dùng bao nhiêu trả bấy nhiêu                               |
| **Global reach**     | Deploy ứng dụng ở nhiều region trên thế giới dễ dàng       |
| **Managed services** | Database, AI, monitoring... đều có sẵn                     |

---

## 🏆 7. Vì Sao Nên Học AWS?

```
Thị phần Cloud (2024)
│
├── AWS ████████████████ ~31%   ← Lớn nhất
├── Azure ████████████   ~25%
├── GCP  █████           ~11%
└── Others ████          ~33%
```

**Lý do AWS phù hợp cho người mới:**

- **First mover advantage** — AWS ra mắt năm 2006, đi trước Azure/GCP nhiều năm
- **Thị phần lớn nhất** — nhiều công ty đang dùng AWS → nhiều job hơn
- **Hơn 200 services** — từ VM, database đến AI, IoT, blockchain
- **Tài liệu phong phú** — community lớn, nhiều tutorial, khóa học miễn phí
- **AWS Free Tier** — học và thực hành miễn phí trong 12 tháng

> **Học AWS = mở ra nhiều cơ hội việc làm nhất trong ngành Cloud hiện nay.**

---

## 🔄 8. Cloud Repatriation — Xu Hướng Ngược Chiều

**Cloud Repatriation** là khi một số công ty **chuyển từ Public Cloud trở về On-premises hoặc Private Cloud**.

```
Public Cloud → On-premises / Private Cloud
(Repatriation)

Lý do:
├── Bảo mật và compliance nghiêm ngặt
├── Chi phí không được tối ưu (dùng cloud sai cách)
└── Không thấy lợi ích rõ ràng từ Public Cloud
```

**Nhưng đừng lo lắng quá:**

> Tỷ lệ Repatriation rất thấp, chỉ khoảng **1–2%**. Public Cloud vẫn là xu hướng chủ đạo và tiếp tục tăng trưởng mạnh.

Repatriation thường xảy ra vì **dùng cloud sai cách**, không phải vì cloud không tốt.

---

## 🛠️ 9. Tạo AWS Account — Bước Đầu Tiên

Để bắt đầu học AWS thực hành, bạn cần tạo tài khoản:

```
Các bước tạo AWS Account:
│
├── 1. Truy cập aws.amazon.com → Create Account
├── 2. Nhập email (đây sẽ là root user email)
├── 3. Verify email qua link xác nhận
├── 4. Tạo password mạnh cho root user
├── 5. Chọn loại account: Personal hoặc Business
├── 6. Nhập thông tin cá nhân / tổ chức
├── 7. Nhập số điện thoại để xác minh
├── 8. Thêm thẻ debit/credit (để verify, AWS sẽ giữ ~$1)
└── 9. Hoàn tất → bắt đầu dùng AWS Free Tier
```

> ⚠️ **Lưu ý quan trọng:** Sau khi tạo xong, **bật MFA (Multi-Factor Authentication)** cho root account ngay để bảo mật.

---

## 🗺️ 10. Toàn Cảnh Hành Trình Từ On-premises Đến Cloud

```
Traditional On-premises
│  Mua server vật lý, dựng data center, cài app trực tiếp
│  → Lãng phí tài nguyên, khó scale, chi phí vận hành cao
│
▼
Virtualization
│  Một server vật lý → nhiều virtual machines
│  → Tận dụng tài nguyên tốt hơn
│
▼
Private Cloud
│  Công ty tự xây cloud nội bộ bằng VMware/OpenStack
│  → Linh hoạt hơn, nhưng vẫn tự vận hành hạ tầng
│
▼
Public Cloud (AWS / Azure / GCP)
│  Provider vận hành toàn bộ hạ tầng
│  Người dùng tạo VM, storage, database khi cần
│  → Pay-as-you-go, scale nhanh, không lo data center
```

---

## 📝 Bảng Thuật Ngữ Nhanh

| Thuật ngữ              | Ý nghĩa                                                       |
| ---------------------- | ------------------------------------------------------------- |
| **Cloud**              | Thuê tài nguyên IT qua internet                               |
| **AWS**                | Amazon Web Services — nhà cung cấp Public Cloud lớn nhất      |
| **EC2**                | Elastic Compute Cloud — máy chủ ảo (Virtual Machine) trên AWS |
| **Private Cloud**      | Cloud công ty tự xây và tự quản lý                            |
| **Public Cloud**       | Cloud do Provider xây, mình thuê dùng                         |
| **Pay-as-you-go**      | Dùng bao nhiêu trả bấy nhiêu                                  |
| **Virtualization**     | Chia server vật lý thành nhiều VM                             |
| **Cloud Repatriation** | Chuyển từ Public Cloud về On-premises/Private Cloud           |
| **Free Tier**          | Gói miễn phí của AWS để học và thực hành                      |

---

## 💡 Điểm Quan Trọng Nhất Của Bài

> **Public Cloud không chỉ giúp tiết kiệm chi phí, mà quan trọng hơn là giúp công ty tránh phải tự quản lý hạ tầng phức tạp: server, data center, network, điện, bảo mật và maintenance.**

Với người mới học cloud, **AWS là lựa chọn tốt nhất** vì:

- ✅ Thị phần lớn nhất → nhiều cơ hội việc làm
- ✅ Community và tài liệu phong phú nhất
- ✅ Free Tier để học thực hành miễn phí
- ✅ Hơn 200 services → bao phủ mọi nhu cầu

---

## ➡️ Bài Tiếp Theo

Bài #02 sẽ đi vào thực hành: **Khám phá AWS Console, IAM Users & cách quản lý quyền truy cập an toàn ngay từ đầu.**

> 🔒 _Tạo xong AWS Account rồi — bước tiếp theo là bảo mật nó đúng cách trước khi làm bất cứ điều gì khác._
