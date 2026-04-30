---
layout: post
title: "OAuth 2.0, OpenID Connect và JWT"
subtitle: "Hiểu đúng Authentication & Authorization trong hệ thống hiện đại"
description: "Tóm tắt toàn diện về OAuth 2.0, OpenID Connect và JWT — từ vấn đề cần giải quyết, các flow phổ biến, so sánh token, đến checklist áp dụng thực tế cho Frontend Developer."
tags:
  [
    oauth2,
    openid-connect,
    jwt,
    authentication,
    authorization,
    security,
    identity,
    tech-lead,
  ]
categories: [Technical Manager]
---

# OAuth 2.0, OpenID Connect và JWT

> **Tóm tắt 3 dòng:**  
> OAuth 2.0 → Ủy quyền truy cập (Authorization)  
> OpenID Connect → Xác thực danh tính user (Authentication)  
> JWT → Format token dùng để chứa thông tin

---

## 1. Vấn đề cần giải quyết

```
PROBLEM
    |
    v
How to securely share data between parties?
    |
    v
Làm sao chia sẻ dữ liệu an toàn
mà không đưa password cho bên thứ ba?
```

**Ví dụ thực tế:**

```
User có data trong Google
    |
    v
Muốn Yelp truy cập một phần data đó
    |
    v
Nhưng không muốn đưa Gmail password cho Yelp
```

### Cách làm cũ — nguy hiểm

```
User → Gmail password → Third-party App (Yelp) → Google Account
                                |
                                v
              Có toàn quyền với account:
              Đọc dữ liệu, đổi password,
              xóa dữ liệu, lạm dụng quyền truy cập
```

---

## 2. Lịch sử hình thành OAuth

```
Password Sharing (nguy hiểm)
       |
       v
Provider-specific APIs (mỗi nơi một kiểu)
       |
       v
OAuth 1 (khó hiểu, khó implement)
       |
       v
OAuth 2 (đơn giản hơn, phù hợp web/mobile hiện đại)
```

|                | OAuth 1            | OAuth 2                        |
| -------------- | ------------------ | ------------------------------ |
| Độ phức tạp    | Cao, khó implement | Đơn giản hơn                   |
| Mobile support | Kém                | Tốt                            |
| Dựa trên       | Signing phức tạp   | HTTPS                          |
| Tích hợp       | Khó                | Dễ kết hợp với JWT, OIDC, PKCE |

---

## 3. OAuth 2 nằm ở đâu trong Identity Stack?

```
OpenID Connect     ← Authentication layer
       |
      JWT           ← Token format
       |
      PKCE          ← Bảo mật cho mobile/SPA
       |
    OAuth 2.0       ← Authorization framework
       |
     HTTPS          ← Transport layer
```

---

## 4. OAuth 2.0 là gì?

```
              OAUTH 2.0
                  |
                  v
  Delegated Authorization Framework
                  |
                  v
User cho phép app khác truy cập một phần tài nguyên
mà không cần đưa password
```

**Câu hỏi OAuth 2 trả lời:**

```
Không phải: "User là ai?"
Mà là:      "App này có được phép truy cập tài nguyên này không?"
```

### Analogy: Khách sạn

```
Hotel Manager  →  User / Resource Owner
Handyman       →  Third-party App / Client
Receptionist   →  Authorization Server
Hotel Room     →  Resource Server
Key            →  Access Token
```

---

## 5. OAuth 2 Flow cơ bản

```
[1] User click "Sign in with Google"
        |
        v
[2] Client App (Yelp) redirect sang Google với:
    - client_id
    - redirect_uri
    - scope
    - response_type
    - state
        |
        v
[3] User login tại Google
        |
        v
[4] Google hỏi consent (có đồng ý cấp quyền không?)
        |
        v
[5] User đồng ý
        |
        v
[6] Google redirect về Yelp kèm token / code
        |
        v
[7] Yelp dùng token gọi Google API
        |
        v
[8] Google Resource Server phục vụ request
```

### Ý nghĩa từng tham số request

| Tham số         | Ý nghĩa                              |
| --------------- | ------------------------------------ |
| `client_id`     | ID của app đã đăng ký với Google     |
| `redirect_uri`  | URL Google redirect về sau khi xử lý |
| `scope`         | Quyền app muốn xin                   |
| `response_type` | Loại response app muốn nhận          |
| `state`         | Giá trị bảo mật chống CSRF attack    |

---

## 6. Scope — Giới hạn quyền truy cập

```
scope = profile contacts calendar.write
```

Nghĩa là app chỉ được:

- Đọc profile
- Đọc contacts
- **Ghi** vào calendar (không được đọc)

```
Scope giới hạn quyền của third-party app
→ Nguyên tắc least privilege
```

---

## 7. JWT — JSON Web Token

```
JWT STRUCTURE

eyJhbGci...   (encoded token)
      |
      v
+----------+-----------+------------+
|  Header  |  Payload  | Signature  |
+----------+-----------+------------+
     |           |           |
     v           v           v
Algorithm    Claims/Data  Verify token
Token type   User info    Integrity
```

### Header

```json
{
  "alg": "RS256",
  "typ": "JWT"
}
```

### Payload (Claims)

```json
{
  "iss": "https://accounts.google.com",
  "sub": "123456789",
  "aud": "yelp-client-id",
  "exp": 1710000000,
  "scope": "profile contacts"
}
```

| Claim   | Ý nghĩa                      |
| ------- | ---------------------------- |
| `iss`   | Issuer — ai phát token       |
| `sub`   | Subject — token về ai        |
| `aud`   | Audience — token dành cho ai |
| `exp`   | Expiration — hết hạn lúc nào |
| `scope` | Quyền được cấp               |

### Signature

```
Server lấy Header + Payload
    |
    v
Verify bằng public key / secret
    |
    v
Nếu hợp lệ → token chưa bị thay đổi
```

> ⚠️ JWT thường chỉ **encoded + signed**, không encrypt.  
> Ai cũng có thể decode để đọc, nhưng không thể sửa nếu không có signing key.  
> → Không đặt dữ liệu nhạy cảm vào JWT nếu không encrypt.

---

## 8. OpenID Connect (OIDC)

```
              OPENID CONNECT
                    |
                    v
    Identity Layer on top of OAuth 2
                    |
                    v
    Dùng để Authentication / Login
```

**So sánh đơn giản:**

```
OAuth 2  = "App này có quyền làm gì?"
OIDC     = "User này là ai?"
```

| Tiêu chí       | OAuth 2       | OpenID Connect |
| -------------- | ------------- | -------------- |
| Mục đích       | Authorization | Authentication |
| Token chính    | Access Token  | ID Token       |
| Scope bắt buộc | không         | `openid`       |
| Dùng cho       | API access    | Login / SSO    |

---

## 9. OIDC Login Flow

```
[1] User click "Sign in with Google"
        |
        v
[2] App redirect sang Google với scope = openid profile email
        |
        v
[3] User login + consent
        |
        v
[4] Google redirect về app với:
    - ID Token  ← xác định user là ai
    - Access Token ← gọi API nếu cần
        |
        v
[5] App decode ID Token → biết user là ai
```

---

## 10. Access Token vs ID Token vs Refresh Token

```
ACCESS TOKEN
    |
    v
Dùng để gọi API / resource server
"App này được phép làm gì?"

ID TOKEN
    |
    v
Dùng để login / xác định identity
"User này là ai?"

REFRESH TOKEN
    |
    v
Dùng để xin access token mới khi hết hạn
```

| Token             | Dùng để       | Ai đọc               | Chứa gì                   |
| ----------------- | ------------- | -------------------- | ------------------------- |
| **Access Token**  | Gọi API       | Resource Server      | Scope, permission, expiry |
| **ID Token**      | Xác thực user | Client App           | User identity claims      |
| **Refresh Token** | Xin token mới | Authorization Server | Quyền refresh             |

---

## 11. ID Token ví dụ

```json
{
  "iss": "https://accounts.google.com",
  "sub": "123456789",
  "aud": "yelp-client-id",
  "exp": 1710000000,
  "name": "Sarah",
  "email": "sarah@example.com"
}
```

---

## 12. Các OAuth/OIDC Flow phổ biến

```
                   OAUTH/OIDC FLOWS
                          |
      ------------------------------------------------
      |           |              |                   |
      v           v              v                   v
 Implicit    Auth Code     Auth Code          Client
 Flow        Flow          + PKCE             Credentials
 (cũ)       (server-side) (SPA/mobile)       (server-to-server)
```

### Authorization Code Flow (server-side web app)

```
Browser → Authorization Server
             |
             | Return authorization code
             v
        Backend Server
             |
             | Exchange code + client_secret
             v
        Token Endpoint → Return tokens
             |
             v
        Backend stores tokens securely
```

### Authorization Code + PKCE (SPA / Mobile)

```
Không cần client_secret trong frontend
→ Chống authorization code bị đánh cắp
→ Phù hợp SPA hiện đại, native app, mobile app
```

### Client Credentials (Server-to-Server)

```
Payment Service → Auth Server → Access Token → Invoice Service API

Không có user trực tiếp — service gọi service
```

---

## 13. Token Lifetime

```
Access Token
    |-- Short-lived (minutes / hours)
    |-- Dùng để gọi API

Refresh Token
    |-- Long-lived
    |-- Dùng xin access token mới

Revocation
    |-- User revoke → token bị invalidate
    |-- Third-party app mất quyền truy cập
```

---

## 14. Authentication vs Authorization

```
Authentication             Authorization
      |                          |
      v                          v
"Who are you?"            "What can you do?"
"Bạn là ai?"              "Bạn được làm gì?"
      |                          |
      v                          v
   OIDC / Login              OAuth 2 / Scope
```

---

## 15. Diagram tổng hợp toàn bộ

```
SECURE IDENTITY & ACCESS
        |
        v
Problem: Share data without sharing password
        |
        v
     OAuth 2
        |
        v
Delegated Authorization
        |
    -------------------------
    |                       |
    v                       v
Access Token             Scope
"Key to API"             "Allowed permissions"
    |
    v
Client accesses resource server
        |
        v
But OAuth is NOT login
        |
        v
Need identity → OpenID Connect
        |
        v
Authentication layer on OAuth 2
        |
        v
     ID Token
        |
        v
User identity claims
        |
        v
      JWT
        |
        v
Header + Payload + Signature
```

---

## 16. Flow thực tế: Sign in with Google

```
[1] User clicks button
[2] App redirects → Google (client_id, redirect_uri, scope, state)
[3] User logs in at Google
[4] Google shows consent screen
[5] User approves
[6] Google redirects back with ID Token + Access Token
[7] App decodes ID Token → user identity
[8] App uses Access Token → gọi Google API nếu cần
```

---

## 17. Checklist cho Frontend Developer

### 1. Xác định dùng OAuth hay OIDC

```
Login user?           → OIDC (scope = openid)
Gọi API thay user?    → OAuth 2
```

### 2. Chọn flow phù hợp

```
SPA hiện đại          → Authorization Code + PKCE
Backend web app       → Authorization Code Flow
Server-to-server      → Client Credentials
```

### 3. Lưu token an toàn

```
Tránh localStorage nếu có rủi ro XSS cao
Ưu tiên secure, httpOnly cookie nếu phù hợp architecture
```

### 4. Backend phải verify token

```
[ ] Verify signature
[ ] Verify issuer (iss)
[ ] Verify audience (aud)
[ ] Verify expiration (exp)
[ ] Verify scope / permission
```

### 5. Logout đúng cách

```
[ ] Clear session phía app
[ ] Revoke token nếu provider hỗ trợ
```

---

## 18. Những hiểu nhầm phổ biến

| Hiểu nhầm                     | Thực tế                                                     |
| ----------------------------- | ----------------------------------------------------------- |
| "OAuth dùng để login"         | OAuth là authorization. Login dùng OIDC                     |
| "JWT là bảo mật tuyệt đối"    | JWT chỉ là format. Bị leak vẫn dùng được đến khi hết hạn    |
| "Decode JWT là đủ để tin"     | Phải verify signature + claims, không chỉ decode            |
| "Access token dùng để login"  | Access token cho API. ID token mới cho identity             |
| "Refresh token lưu thoải mái" | Refresh token rất nhạy cảm, phải bảo vệ kỹ hơn access token |

---

## Tóm tắt cực ngắn để nhớ

```
OAuth 2     = Authorization  → "App được phép làm gì?"
OIDC        = Authentication → "User là ai?"
JWT         = Token format   → Header + Payload + Signature
Access Token  = Key to API
ID Token      = User identity
Refresh Token = Get new access token
Scope         = Giới hạn quyền
State         = Chống CSRF
```

**Câu chốt:**

```
Trước đây: User đưa password cho app → Nguy hiểm
OAuth 2:   User ủy quyền qua access token → An toàn hơn
OIDC:      App biết user là ai qua ID token
JWT:       Format chuẩn để đóng gói thông tin trong token

OAuth 2 ≠ Login
OIDC = Login đúng nghĩa
```
