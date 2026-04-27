---
layout: post
title: "☁️ AWS Series #23 — AWS Load Balancers: ALB vs NLB vs GWLB"
date: 2026-04-27
categories: cloud
---

> 📺 Nguồn: [AWS Zero to Hero – YouTube Series](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze)

---

## 1. AWS Load Balancers — Tổng quan

AWS có 3 loại Load Balancer chính:

```text
AWS Load Balancers
├── ALB  — Application Load Balancer → Layer 7
├── NLB  — Network Load Balancer     → Layer 4
└── GWLB — Gateway Load Balancer     → Virtual appliances (firewall, IDS/IPS, VPN)
```

> **Câu dễ nhớ:**
> - ALB = route theo HTTP path/header/host
> - NLB = latency thấp, throughput cao, TCP/UDP
> - GWLB = traffic qua security/network appliances

---

## 2. Load Balancer là gì?

Load Balancer đứng trước nhiều server để phân phối traffic.

```text
Không có Load Balancer:
Many Users → Single EC2 → Slow / Downtime / Bad UX

Có Load Balancer:
Many Users
        ↓
Load Balancer
        ↓
EC2 1 | EC2 2 | EC2 3
```

**Lợi ích:**

```text
├── Phân phối request đến nhiều server
├── Giảm tải cho một server đơn lẻ
├── Tăng availability, giảm downtime
├── Tăng khả năng scale
├── Health check backend instances
└── Chỉ gửi traffic đến target healthy
```

Ví dụ round robin:

```text
100 Requests → LB → EC2 1 (33) | EC2 2 (33) | EC2 3 (34)
```

---

## 3. OSI 7 Layers — Liên quan Load Balancer

```text
+------------------------------------------------+
| Layer 7 - Application                          |
| HTTP, HTTPS, FTP                               |
| → AWS Load Balancer: ALB                       |
+------------------------------------------------+
| Layer 6 - Presentation  | TLS/SSL, encryption  |
| Layer 5 - Session       | Session management   |
+------------------------------------------------+
| Layer 4 - Transport                            |
| TCP, UDP, port                                 |
| → AWS Load Balancer: NLB                       |
+------------------------------------------------+
| Layer 3 - Network   | IP routing               |
| Layer 2 - Data Link | Switches, MAC            |
| Layer 1 - Physical  | Cables                   |
+------------------------------------------------+
```

> ALB hoạt động ở **Layer 7**. NLB hoạt động ở **Layer 4**. GWLB dùng cho appliance traffic.

---

## 4. ALB — Application Load Balancer

ALB hoạt động ở **Layer 7 — Application Layer**. Nó hiểu HTTP/HTTPS request.

```text
ALB có thể inspect:
├── Host
├── Path
├── HTTP headers
├── Query string
├── HTTP method
└── Cookies
```

### ALB Routing Patterns

```text
Path-based routing:
├── /payments  → Payment Service
├── /login     → Login Service
└── /products  → Product Service

Host-based routing:
├── api.example.com   → API Service
└── admin.example.com → Admin Service

Header-based routing:
└── x-version: v2 → v2-service

Weighted / canary routing:
├── 90% → stable version
└── 10% → canary version
```

### ALB diagram

```text
User
        ↓ HTTPS request
Application Load Balancer (Layer 7)
        ↓
├── /api      → API Target Group
├── /admin    → Admin Target Group
├── /payment  → Payment Target Group
└── /login    → Login Target Group
```

### ALB SSL/TLS Termination

```text
TLS Termination:
Client → ALB: HTTPS | ALB → Backend: HTTP

End-to-end TLS:
Client → ALB: HTTPS | ALB → Backend: HTTPS (bảo mật hơn)
```

### Ưu / Nhược điểm ALB

```text
Ưu điểm:
├── Routing thông minh theo HTTP layer
├── Path / host / header / query / weighted routing
├── Tích hợp tốt với ECS / EKS / EC2 / Lambda
├── Hỗ trợ WebSocket, TLS termination
└── Phù hợp web app / microservices

Nhược điểm:
├── Có thêm processing so với NLB
├── Latency cao hơn NLB
└── Không phù hợp raw TCP/UDP high-throughput
```

---

## 5. NLB — Network Load Balancer

NLB hoạt động ở **Layer 4 — Transport Layer**. Route dựa trên:

```text
NLB Routing Basis:
├── TCP / UDP / TLS
├── IP address
├── Port
└── Connection level
```

NLB **không** inspect HTTP path/header/host như ALB.

```text
NLB không biết: /payments, HTTP headers, query string
NLB biết:       TCP/UDP connection, source/dest IP, port
```

### NLB diagram

```text
User / Client
        ↓ TCP/UDP traffic
Network Load Balancer (Layer 4)
Low latency / High throughput
        ↓
Server 1 | Server 2 | Server 3
```

### Vì sao NLB nhanh hơn ALB?

```text
ALB:
Request → Inspect HTTP host/path/header → Decide target → Forward

NLB:
Connection → Route by TCP/UDP/IP/Port → Forward quickly (ít processing hơn)
```

### Khi nào dùng NLB?

```text
Use NLB when:
├── Cần latency cực thấp
├── Cần throughput cao
├── TCP / UDP traffic
├── Long-lived connections
├── Static IP support
├── Game servers
├── Video / content streaming
├── Real-time systems (IoT, gRPC)
└── Không cần routing theo HTTP path/header
```

### Ưu / Nhược điểm NLB

```text
Ưu điểm:
├── Latency rất thấp
├── Throughput cao
├── TCP/UDP/TLS support
├── Static IP per AZ
└── Phù hợp streaming, game, realtime

Nhược điểm:
├── Không route theo HTTP path/header
└── Không thông minh ở application layer như ALB
```

---

## 6. GWLB — Gateway Load Balancer

GWLB dùng cho các **virtual appliances**:

```text
Virtual Appliances:
├── Firewall
├── IDS / IPS (Intrusion Detection/Prevention)
├── VPN appliance
├── Deep packet inspection
└── Network security appliance
```

GWLB không phải lựa chọn thông thường cho web app.

```text
Web app / microservice → ALB
TCP/UDP high performance → NLB
Firewall / VPN appliance → GWLB
```

### GWLB diagram

```text
Network Traffic
        ↓
Gateway Load Balancer
        ↓
Firewall 1 | Firewall 2 | Firewall 3
        ↓
Protected Application / Network
```

### Khi nào dùng GWLB?

```text
Use GWLB when:
├── Deploy firewall / IDS/IPS appliances
├── Deploy VPN / security appliances
├── Cần inspect network traffic
├── Cần appliance fleet auto scaling
├── Làm network / security platform
└── Traffic phải đi qua appliance trước khi đến app
```

---

## 7. So sánh ALB vs NLB vs GWLB

| Tiêu chí | ALB | NLB | GWLB |
|---|---|---|---|
| OSI Layer | Layer 7 | Layer 4 | Appliance routing |
| Protocol | HTTP/HTTPS | TCP/UDP/TLS | Varies |
| Path routing | Có | Không | Không |
| Host routing | Có | Không | Không |
| Latency | Trung bình | Thấp nhất | - |
| Use case | Web app, microservices | Game, streaming, real-time | Firewall, IDS/IPS, VPN |
| Targets | EC2, ECS, EKS, Lambda, IP | EC2, IP, ALB | Virtual appliances |

---

## 8. Bảng chọn Load Balancer theo use case

| Use Case | Load Balancer |
|---|---|
| Web app HTTP/HTTPS | ALB |
| Microservices path routing | ALB |
| API routing by host/path | ALB |
| Canary / weighted HTTP routing | ALB |
| Game server | NLB |
| Video streaming | NLB |
| TCP/UDP service | NLB |
| Low-latency high-throughput | NLB |
| Firewall appliance | GWLB |
| IDS/IPS appliance | GWLB |
| VPN / security appliance | GWLB |

---

## 9. Real-world Examples

**Example 1 — E-commerce platform:**

```text
User → ALB → /login → Login Service
           → /products → Product Service
           → /cart → Cart Service
           → /payments → Payment Service
→ Chọn ALB vì cần path-based routing ở HTTP layer
```

**Example 2 — Video streaming:**

```text
User watches video → NLB → Streaming Servers
→ Chọn NLB vì cần low latency, high throughput, long-lived connections
```

**Example 3 — Game backend:**

```text
Game Client → TCP/UDP → NLB → Game Servers
→ Chọn NLB vì game traffic cần latency thấp, connection-level routing
```

**Example 4 — Firewall product company:**

```text
Network Traffic → GWLB → Firewall Appliance Fleet → Protected Resources
→ Chọn GWLB vì traffic cần đi qua virtual security appliances
```

---

## 10. Security Group + Load Balancer Best Practice

```text
❌ Không nên:
EC2 allow 0.0.0.0/0 trực tiếp từ Internet

✅ Nên làm:
Internet (80/443)
        ↓
ALB Security Group
        ↓ (chỉ allow từ ALB SG)
App Security Group (EC2/ECS)
```

> EC2 app chỉ nên nhận traffic từ ALB Security Group, không từ Internet trực tiếp.

---

## 11. Health Check

```text
Target healthy   → Load Balancer gửi traffic
Target unhealthy → Load Balancer ngừng gửi traffic

Ví dụ:
EC2 1: Healthy   ✓ receives traffic
EC2 2: Healthy   ✓ receives traffic
EC2 3: Unhealthy ✗ no traffic
```

---

## 12. Câu trả lời phỏng vấn mẫu

**Load Balancer là gì?**

```text
A load balancer distributes incoming traffic across multiple backend targets
such as EC2 instances, containers, or IP addresses.

It improves availability, scalability, and reliability.
It performs health checks and stops sending traffic to unhealthy targets.

In AWS, the main types are ALB, NLB, and GWLB.
```

**ALB vs NLB?**

```text
ALB works at Layer 7 — best for HTTP/HTTPS workloads.
It can inspect host, path, headers, and query strings.
Useful for web apps, APIs, and microservices needing smart routing.

NLB works at Layer 4 — best for TCP, UDP, or TLS workloads.
Designed for low latency and high throughput.
Useful for game servers, streaming platforms, real-time applications.
```

**When to use GWLB?**

```text
I use GWLB when deploying virtual appliances such as firewalls,
IDS/IPS systems, VPN appliances, or deep packet inspection appliances.

GWLB routes traffic transparently through appliance fleets.
For normal web apps → ALB. For low-latency TCP/UDP → NLB.
```

**How do you choose ALB/NLB/GWLB?**

```text
HTTP/HTTPS + path/host/header routing → ALB
Low latency + TCP/UDP + streaming/game → NLB
Firewall/VPN/security appliance routing → GWLB
```

---

## 13. Diagram tổng hợp

```text
AWS Load Balancers
│
├── ALB (Layer 7)
│   ├── HTTP/HTTPS aware
│   ├── Path / host / header routing
│   ├── Weighted / canary routing
│   ├── TLS termination
│   └── Best for: web apps, microservices, APIs
│
├── NLB (Layer 4)
│   ├── TCP / UDP / TLS
│   ├── Low latency / high throughput
│   ├── Long-lived connections
│   ├── Static IP per AZ
│   └── Best for: game, streaming, real-time, gRPC
│
└── GWLB (Appliance)
    ├── Firewall / IDS/IPS / VPN
    ├── Virtual appliance fleet
    ├── Transparent traffic forwarding
    └── Best for: network/security appliance routing
```

---

## 14. Key Takeaways

```text
Day 23 Key Takeaways
│
├── Load Balancer phân phối traffic → tăng availability & scalability
├── ALB hoạt động ở Layer 7 (HTTP/HTTPS)
├── ALB hỗ trợ path / host / header / weighted routing
├── ALB phù hợp web app, API, microservices
├── NLB hoạt động ở Layer 4 (TCP/UDP)
├── NLB latency thấp, throughput cao
├── NLB phù hợp game, streaming, real-time
├── GWLB dùng cho firewall/VPN/security appliances
├── Hiểu OSI layer giúp chọn đúng loại LB
└── EC2 nên nhận traffic từ LB SG, không từ Internet trực tiếp
```
