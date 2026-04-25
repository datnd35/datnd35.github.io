---
layout: post
title: "☁️ AWS Series #04 — SSH vào EC2 từ Windows bằng MobaXterm"
date: 2026-04-25
categories: cloud
---

> 📺 **Nguồn:** [AWS Zero to Hero — SSH vào EC2 từ Windows](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze&index=2)  
> 📌 **Series:** AWS Zero to Hero — 30 bài từ cơ bản đến thực chiến

---

## 🎯 Mục Tiêu Bài Viết

Bài này dành riêng cho người dùng **Windows** gặp khó khăn khi kết nối vào EC2.

Thay vì dùng PuTTY (phức tạp, cần convert `.pem` → `.ppk`), bài này hướng dẫn dùng **MobaXterm** — cách đơn giản và trực quan hơn nhiều.

```
Mục tiêu:
EC2 Public IP + Username + Private Key (.pem) + MobaXterm
                            ↓
                  SSH vào EC2 thành công
```

---

## 📋 Tổng Quan Bài Học

```
SSH vào EC2 từ Windows
│
├── 1. Tạo EC2 Instance Ubuntu
├── 2. Tạo Key Pair (.pem)
├── 3. Cài MobaXterm trên Windows
├── 4. Tạo SSH Session trong MobaXterm
└── 5. Kết nối thành công & kiểm tra
```

---

## 🆚 1. MobaXterm vs PuTTY — Tại Sao Chọn MobaXterm?

```
PuTTY                            │  MobaXterm
─────────────────────────────────┼──────────────────────────────────
Cần convert .pem → .ppk          │  Dùng trực tiếp file .pem
Cần cài thêm PuTTYgen            │  Không cần tool phụ
Giao diện phức tạp hơn           │  Giao diện trực quan, dễ dùng
Khó lưu nhiều session            │  Lưu được nhiều SSH session
Không thân thiện với người mới   │  Phù hợp người mới học AWS
```

> **Kết luận:** Nếu bạn mới học AWS trên Windows, **MobaXterm là lựa chọn tốt nhất**.

---

## 🛠️ 2. Tạo EC2 Instance Để Thực Hành

```
Create EC2 Instance
│
├── 1. Login AWS Console → Search "EC2"
├── 2. Click "Launch Instance"
├── 3. Đặt tên: test-windows
├── 4. Chọn OS: Ubuntu
├── 5. Chọn Instance Type: t2.micro (Free Tier ✅)
│
├── 6. Tạo Key Pair
│   ├── Name: windows-demo
│   ├── Type: RSA
│   └── Format: .pem  ← quan trọng
│       → File windows-demo.pem tự động tải về máy
│
├── 7. Kiểm tra Network Settings
│   ├── Auto-assign Public IP: Enable ✅
│   └── SSH port 22: Allow ✅
│
└── 8. Click "Launch Instance"
```

---

## 🔑 3. Key Pair — Hiểu Đúng Để Không Bị Lỗi

```
EC2 Key Pair
│
├── Public Key
│   └── AWS tự động gắn vào EC2 instance khi tạo
│
└── Private Key (.pem)
    ├── Tải về máy Windows của bạn
    ├── Ví dụ: windows-demo.pem
    ├── Dùng để xác thực khi SSH
    └── ⚠️ Mất file này = không SSH được vào instance nữa
```

> ⚠️ **Quan trọng:** Lưu file `.pem` ở nơi an toàn. Không share cho ai khác. AWS không cho tải lại file này sau khi đã tạo.

---

## 💻 4. Cài MobaXterm Trên Windows

```
Cài MobaXterm
│
├── 1. Mở browser → Search "download MobaXterm"
├── 2. Vào trang chủ: mobaxterm.mobatek.net
├── 3. Chọn: Home Edition (miễn phí)
├── 4. Chọn: Installer Edition (dễ dùng hơn Portable)
├── 5. File tải về dạng .zip
├── 6. Extract file zip
├── 7. Chạy file installer → Next → Agree → Install
└── 8. Mở MobaXterm từ Start Menu / Windows Search
```

---

## 🔗 5. SSH Vào EC2 Bằng MobaXterm — Từng Bước

```
Connect EC2 bằng MobaXterm
│
├── 1. Vào AWS Console → EC2 → Copy Public IP của instance
│
├── 2. Mở MobaXterm
│
├── 3. Click "Session" (góc trên bên trái)
│
├── 4. Chọn tab "SSH"
│
├── 5. Nhập thông tin:
│   ├── Remote host: <EC2 Public IP>
│   └── Username: ubuntu
│
├── 6. Vào tab "Advanced SSH settings"
│   ├── Tick: ✅ Use private key
│   └── Chọn file: windows-demo.pem
│
├── 7. Click "OK"
│
├── 8. Accept pop-up xác nhận fingerprint
│
└── 9. ✅ Login vào EC2 thành công
```

**Luồng kết nối đầy đủ:**

```
MobaXterm (Windows)
│
├── Remote Host: EC2 Public IP
├── Username: ubuntu
└── Private Key: windows-demo.pem
        │
        ↓
    Internet
        │
        ↓
AWS Security Group
    │
    └── Port 22 allowed? → Có → request đi tiếp
        │
        ↓
EC2 Ubuntu Server
    └── ✅ Login successful
```

---

## 👤 6. Username Mặc Định Theo OS

Username SSH **khác nhau tùy OS** bạn chọn khi tạo EC2:

| OS               | Default Username       |
| ---------------- | ---------------------- |
| **Ubuntu**       | `ubuntu`               |
| **Amazon Linux** | `ec2-user`             |
| **Red Hat**      | `ec2-user` hoặc `root` |
| **CentOS**       | `centos`               |
| **Debian**       | `admin` hoặc `debian`  |
| **Windows**      | `Administrator`        |

> Bài này dùng **Ubuntu** → username là `ubuntu`.

---

## ✅ 7. Kiểm Tra Sau Khi Login

Sau khi SSH vào thành công, chạy lệnh sau để xác nhận:

```bash
sudo apt update
```

Nếu lệnh chạy được và hiện danh sách package update → kết nối thành công ✅

---

## 🐛 8. Các Lỗi Thường Gặp & Cách Xử Lý

```
Common Issues
│
├── ❌ Không connect được / timeout
│   ├── EC2 đã ở trạng thái "running" chưa?
│   ├── Public IP có tồn tại không?
│   └── Security Group có mở port 22 không?
│
├── ❌ "Permission denied"
│   ├── Sai username (Ubuntu phải dùng ubuntu)
│   └── Sai file .pem (chọn nhầm key pair)
│
├── ❌ Dùng PuTTY nhưng chọn file .pem
│   └── PuTTY cần file .ppk — dùng MobaXterm để tránh vấn đề này
│
└── ❌ "No public IP found"
    └── Cần bật "Auto-assign Public IP" khi launch instance
```

---

## ✅ 9. Best Practices

```
Best Practices
│
├── ⚠️ Không share file .pem cho ai
├── ✅ Lưu file .pem ở nơi an toàn
├── ✅ Đặt tên key pair rõ ràng (ví dụ: project-dev.pem)
├── ⚠️ Không mở port 22 cho toàn internet (0.0.0.0/0) trong production
├── ✅ Học xong → stop/terminate instance để tránh phát sinh phí
└── ✅ Dùng MobaXterm nếu bạn mới học AWS trên Windows
```

---

## 📝 Bảng Thuật Ngữ Nhanh

| Thuật ngữ          | Ý nghĩa                                                          |
| ------------------ | ---------------------------------------------------------------- |
| **SSH**            | Secure Shell — giao thức kết nối an toàn vào server từ xa        |
| **Public IP**      | Địa chỉ IP để truy cập EC2 từ internet                           |
| **Key Pair**       | Cặp key xác thực — public key trên EC2, private key trên máy bạn |
| **MobaXterm**      | SSH client cho Windows, hỗ trợ trực tiếp file .pem               |
| **PuTTY**          | SSH client phổ biến khác trên Windows, cần file .ppk             |
| **Security Group** | Firewall của EC2, cần mở port 22 để SSH                          |
| **ubuntu**         | Username mặc định khi SSH vào EC2 chạy Ubuntu OS                 |

---

## 💡 Điểm Quan Trọng Nhất Của Bài

> **Nếu bạn dùng Windows, cách đơn giản nhất để SSH vào EC2 là dùng MobaXterm: nhập Public IP, username `ubuntu`, chọn file private key `.pem`, rồi connect.**

```
EC2 Public IP
    +
Username: ubuntu
    +
Private Key: windows-demo.pem
    +
MobaXterm
    =
✅ SSH vào EC2 thành công
```

---

## ➡️ Bài Tiếp Theo

Bài #05 sẽ đi vào: **AWS VPC — Mạng riêng ảo, Subnet, Internet Gateway và cách tổ chức hạ tầng mạng trên AWS.**

> 🌐 _Đã biết cách tạo và SSH vào EC2 — giờ là lúc học cách tổ chức mạng để hệ thống vừa an toàn vừa hiệu quả._
