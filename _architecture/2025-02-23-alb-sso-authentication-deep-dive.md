---
layout: post
title: "AWS ALB SSO Authentication - Deep Dive"
categories: architecture
date: 2025-02-23
excerpt: "Tìm hiểu chi tiết về cách AWS Application Load Balancer xử lý SSO authentication, session cookie, và service-to-service communication trong kiến trúc microservices."
---

# Mục lục

## [1. Tổng quan](#overview)

## [2. ALB Session Cookie là gì?](#session-cookie)

- [Cấu trúc Cookie](#cookie-structure)
- [Điều cookie KHÔNG chứa](#what-not-in-cookie)
- [So sánh Cookie vs Token](#cookie-vs-token)

## [3. Authentication Flow](#auth-flow)

- [Lần đầu login (Cold Start)](#first-login)
- [Request tiếp theo (Authenticated)](#subsequent-requests)
- [Timeline đầy đủ](#full-timeline)

## [4. Giải pháp ngắn hạn - Session Cookie](#interim-solution)

- [Cách hoạt động](#how-it-works)
- [Luồng xử lý](#processing-flow)
- [Service-to-Service Communication](#service-communication)

## [5. Giải pháp dài hạn - Token Exchange](#long-term-solution)

- [On-Behalf-Of Flow](#obo-flow)
- [Least Privilege](#least-privilege)
- [Zero Trust Architecture](#zero-trust)

## [6. So sánh hai phương pháp](#comparison)

## [7. Best Practices](#best-practices)

## [8. Kết luận](#conclusion)

---

<h1 id="overview">1. Tổng quan</h1>

## Bài toán

Làm thế nào để **host nhiều web app phía sau AWS Application Load Balancer (ALB)** với:

- **SSO tập trung** (OIDC hoặc SAML)
- **Backend vẫn xác thực/phân quyền được user**
- **App không tự xử lý login**

## Mục tiêu

> App không hỏi username/password, mọi thứ đi qua ALB

**Kiến trúc tổng thể:**

```
User
 |
 v
ALB (SSO + Session + OIDC headers)
 |
 v
Kubernetes Cluster
 |
 +-- Service 1
 +-- Service 2
 +-- Service N
```

---

<h1 id="session-cookie">2. ALB Session Cookie là gì?</h1>

<h2 id="cookie-structure">Cấu trúc Cookie</h2>

### Về mặt hình thức (Browser nhìn thấy)

```http
Set-Cookie: ALBAuthSessionCookie=eyJhbGciOi...;
            Secure; HttpOnly; SameSite=None
```

Browser chỉ thấy:

- **Tên cookie** (ví dụ: `ALBAuthSessionCookie`)
- **Một chuỗi ngẫu nhiên/đã ký/mã hóa**
- **Flag bảo mật**

> Browser **không đọc được nội dung** bên trong

<h2 id="what-not-in-cookie">Điều cookie KHÔNG chứa</h2>

❌ **KHÔNG chứa:**

- Username
- Password
- Access token
- User info (email, role)
- SSO ID dạng clear text

✅ **CHỈ CHỨA:**

- **Session Identifier** (ID tham chiếu)
- **Signed/Encrypted blob** mà chỉ ALB hiểu

> Cookie là **pointer**, không phải payload

### Thông tin user thật nằm ở đâu?

Nằm trong **session state của ALB/IdP**:

```javascript
ALB Session Store:
  - session_id
  - user_id / SSO subject
  - identity provider
  - issued_at
  - expires_at
  - auth context
```

**Quy trình xác thực:**

1. ALB đọc cookie
2. Map cookie → session nội bộ
3. Xác nhận session còn hiệu lực
4. (Optional) inject header xuống backend

<h2 id="cookie-vs-token">So sánh Cookie vs Token</h2>

| Đặc điểm    | Session Cookie (ALB)   | Access Token (OAuth)    |
| ----------- | ---------------------- | ----------------------- |
| **State**   | Stateful               | Stateless               |
| **Ý nghĩa** | Chỉ có ý nghĩa với ALB | Self-contained (claims) |
| **Sử dụng** | Browser ↔ ALB          | Service-to-service      |
| **Bảo mật** | Pointer đến session    | Chứa claims + signature |
| **Revoke**  | Xóa session ở ALB      | Chờ token expire        |

> **Cookie = vé xe**  
> **Token = thẻ căn cước**

---

<h1 id="auth-flow">3. Authentication Flow</h1>

<h2 id="first-login">Lần đầu login (Cold Start)</h2>

```
[ User Browser ]
        |
        | Request (NO cookie)
        v
[ Application Load Balancer ]
        |
        | Redirect to SSO
        v
[ Identity Provider ]
        |
        | User login successfully
        v
[ Application Load Balancer ]
        |
        | Create SESSION
        | Set-Cookie (ALB session cookie)
        v
[ User Browser ]
```

**Timeline:**

1. User truy cập app lần đầu
2. ALB phát hiện không có cookie → redirect SSO
3. User login tại IdP
4. IdP trả về authentication assertion
5. ALB tạo session + cookie
6. Browser lưu cookie

<h2 id="subsequent-requests">Request tiếp theo (Authenticated)</h2>

```
[ User Browser ]
        |
        | Request + ALB Session Cookie
        v
[ ALB ]
        |
        | Validate session
        | Add headers:
        |   - x-amzn-oidc-data (JWT)
        |   - x-amzn-oidc-identity
        v
[ Backend Service ]
        |
        | Read headers
        | Extract user info
        v
[ Process Business Logic ]
```

**Điểm quan trọng:**

- Cookie **đi xuyên suốt** request chain
- ALB **inject headers** chứa user info
- Backend **tin ALB**, không validate cookie

<h2 id="full-timeline">Timeline đầy đủ</h2>

```
(First time - Login Flow)

Browser → ALB → IdP → ALB → Browser
         (no cookie)  (auth)  (set cookie)


(Subsequent requests - Authenticated Flow)

Browser → ALB → Backend → Response
    (with cookie)  (with headers)
```

---

<h1 id="interim-solution">4. Giải pháp ngắn hạn - Session Cookie</h1>

<h2 id="how-it-works">Cách hoạt động</h2>

**Tư duy:** Dùng session cookie của ALB để truyền user context

**Khuyến nghị cho go-live:**

### 🔐 Xác thực người dùng (Authentication)

- **Không dùng username/password cố định** cho bất kỳ user nào
- **Bắt buộc dùng SSO (Single Sign-On)**
- Hệ thống dựa vào **SSO ID của user** để xác định user/admin

> SSO là nguồn chân lý duy nhất

### 🍪 Xử lý Session Cookie

ALB session cookie phải được:

- Gửi từ **UI**
- Đi qua **Application Load Balancer**
- Forward đầy đủ xuống **Backend**
- Backend đọc cookie để lấy thông tin user/SSO
- Cookie được forward tiếp sang downstream services

> Cookie đi xuyên suốt request chain

<h2 id="processing-flow">Luồng xử lý</h2>

```
1. UI sends request (with cookie)
2. ALB forwards (không strip cookie)
3. Backend:
   - Reads cookie from header
   - Extracts user/SSO info
4. Backend calls downstream service (with cookie)
5. Response returns through same chain
```

> ALB chỉ là "người chuyển thư", không phán xét, không chỉnh sửa

<h2 id="service-communication">Service-to-Service Communication</h2>

**Vấn đề:** Service 1 gọi Service 2 vẫn phải giữ user identity

**Giải pháp tạm thời (Workaround):**

```
[ Service 1 ]
        |
        | 1. Read x-amzn-oidc-data (JWT from ALB)
        | 2. Decode JWT
        | 3. Extract user info (username, email)
        |
        | 4. Create custom header:
        |    x-user-details = { user, email }
        |
        v
[ Service 2 ]
        |
        | Trust x-user-details
        | Continue business logic
```

**Nhận định kỹ thuật:**

❌ **Đây KHÔNG phải best practice**

- Chỉ là stopgap/tạm thời
- Chưa có token delegation đúng nghĩa

**Rủi ro:**

- Header có thể bị giả mạo nếu trust boundary không chặt
- Không có scope/audience rõ ràng
- Khó audit, khó scale security

> Works as interim solution, but not the destination

---

<h1 id="long-term-solution">5. Giải pháp dài hạn - Token Exchange</h1>

<h2 id="obo-flow">On-Behalf-Of Flow (OBO)</h2>

**Định hướng:** Không forward session cookie nữa

**Thay bằng:**

- **Token exchange (on-behalf-of flow)**
- Lấy **token theo audience cụ thể**
- **Least privilege** (đúng quyền – đúng scope – đúng service)

```
[ User Browser ]
        |
        | 1. Login via SSO
        v
[ Backend ]
        |
        | 2. Token Exchange (OBO Flow)
        |    using SSO identity
        |
        |--> Request audience-specific token
        |
        v
[ Identity Provider ]
        |
        | 3. Issue short-lived access token
        |    (least privilege)
        v
[ Backend ]
        |
        | 4. Call downstream with ACCESS TOKEN
        v
[ Downstream Service ]
        |
        | 5. Validate token & scope
```

<h2 id="least-privilege">Least Privilege</h2>

**Nguyên tắc:**

Mỗi service chỉ nhận **token đúng audience** với:

- ✅ Ngắn hạn
- ✅ Ít quyền (minimal scope)
- ✅ Audit-friendly
- ✅ Revoke được ngay

**Ví dụ token claims:**

```json
{
  "aud": "api://ai-foundry",
  "scope": "read:documents",
  "exp": 1234567890,
  "sub": "user@company.com"
}
```

<h2 id="zero-trust">Zero Trust Architecture</h2>

**Triết lý:**

> Never trust, always verify

**Áp dụng:**

1. Không tin vào network boundary
2. Mỗi request phải có token riêng
3. Token phải được validate ở mọi service
4. Least privilege by default

**Chuẩn security bài bản:**

- Scale lớn ✓
- Audit-friendly ✓
- Enterprise-grade ✓

---

<h1 id="comparison">6. So sánh hai phương pháp</h1>

## Một dòng so sánh

```
Ngắn hạn: Trust session cookie (ALB-centric)
Dài hạn:  Trust token + scope (Zero Trust)
```

## Bảng so sánh chi tiết

| Tiêu chí           | Ngắn hạn (Session Cookie) | Dài hạn (Token Exchange) |
| ------------------ | ------------------------- | ------------------------ |
| **Đơn giản**       | ✅ Rất đơn giản           | ⚠️ Phức tạp hơn          |
| **Bảo mật**        | ⚠️ Trung bình             | ✅ Cao                   |
| **Audit**          | ❌ Khó                    | ✅ Dễ                    |
| **Scale**          | ⚠️ Hạn chế                | ✅ Tốt                   |
| **Revoke**         | ⚠️ Chậm                   | ✅ Nhanh                 |
| **Cost**           | ✅ Thấp                   | ⚠️ Cao hơn               |
| **Time to market** | ✅ Nhanh                  | ⚠️ Chậm hơn              |

## Khi nào dùng cái nào?

**Session Cookie (Ngắn hạn):**

- ✅ Go-live nhanh
- ✅ Team nhỏ
- ✅ Monolith hoặc ít services
- ✅ Internal tools

**Token Exchange (Dài hạn):**

- ✅ Microservices nhiều
- ✅ Yêu cầu audit chặt
- ✅ Enterprise security
- ✅ Multi-tenant
- ✅ External APIs

---

<h1 id="best-practices">7. Best Practices</h1>

## Authentication

1. **Không bao giờ** dùng username/password hardcoded
2. **Luôn luôn** dùng SSO làm single source of truth
3. **Validate** session/token ở mọi service
4. **Log** mọi authentication attempt

## Session Cookie

1. **HttpOnly + Secure + SameSite** flags
2. **Short-lived** session (timeout hợp lý)
3. **Revoke** session khi logout
4. **Monitor** cookie hijacking

## Token Exchange

1. **Short-lived** tokens (5-15 phút)
2. **Minimal scope** cho mỗi service
3. **Rotate** secrets thường xuyên
4. **Cache** tokens (nhưng invalidate đúng lúc)

## Service-to-Service

1. **Không forward** user credentials
2. **Dùng** service identity riêng
3. **Validate** caller identity
4. **Encrypt** sensitive data

## Security

1. **Defense in depth** - nhiều lớp bảo vệ
2. **Least privilege** - quyền tối thiểu
3. **Zero trust** - không tin ai
4. **Audit everything** - log tất cả

---

<h1 id="conclusion">8. Kết luận</h1>

## Câu chốt cho sếp/security/architect

> **Ngắn hạn:** Dùng SSO + session cookie xuyên ALB  
> **Dài hạn:** Chuyển sang token exchange, zero-trust đúng nghĩa

## Timeline đề xuất

**Phase 1 (0-3 tháng):**

- Implement ALB + SSO
- Session cookie forwarding
- Basic user context

**Phase 2 (3-6 tháng):**

- Thiết kế token exchange flow
- Implement OBO cho critical services
- Migrate từng bước

**Phase 3 (6-12 tháng):**

- Full zero-trust architecture
- Retire session cookie forwarding
- Enterprise-grade security

## Key Takeaways

1. **Cookie ≠ Token** - Hiểu rõ sự khác biệt
2. **ALB làm SSO** - Không phải app tự làm
3. **Interim works** - Nhưng không ở lại lâu
4. **Token là tương lai** - Plan ngay từ đầu
5. **Security là hành trình** - Không phải đích đến

## Tài liệu tham khảo

- [AWS ALB Authentication](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/listener-authenticate-users.html)
- [OAuth 2.0 On-Behalf-Of Flow](https://datatracker.ietf.org/doc/html/rfc8693)
- [Zero Trust Architecture](https://www.nist.gov/publications/zero-trust-architecture)
- [OIDC Specification](https://openid.net/connect/)

---

**Tags:** #AWS #ALB #SSO #Authentication #OAuth #Microservices #Security #Zero-Trust
