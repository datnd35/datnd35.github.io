---
layout: post
title: "CI/CD Enterprise Case Studies - Thực Chiến Cho Team Lead"
date: 2026-04-04
categories: senior
---

## 🎯 Mục Tiêu Bài Viết

Bài viết này tổng hợp **20 case study CI/CD thực chiến** dành cho **Team Lead trong dự án enterprise**, tập trung vào những vấn đề thực sự xảy ra với **Docker, Kubernetes, GitHub Actions, Helm, rollout, secrets, cache, artifact, và environments**.

> Format: **Case → Dấu hiệu nhận biết → Cách xử lý → Sai lầm thường gặp → Bài học**

```
CI/CD ENTERPRISE CASE STUDIES
──────────────────────────────────────────────────────
NHÓM GITHUB ACTIONS
  Case 1  → Hai pipeline deploy cùng lúc vào một môi trường
  Case 2  → Workflow copy-paste, repo nào cũng khác nhau
  Case 3  → Secret cloud credentials sống quá lâu
  Case 4  → Deploy nhầm production từ sai branch hoặc sai actor
  Case 5  → Self-hosted runner trở thành điểm tấn công
  Case 6  → Artifact mất giữa jobs, mỗi job build lại từ đầu
  Case 7  → Context/vars dùng sai, deploy sai target
  Case 8  → Pipeline quá nặng, dev tìm đường bypass

NHÓM DOCKER
  Case 9  → Build Docker quá chậm, cache hit thấp
  Case 10 → Final image quá nặng, mang theo cả tool build

NHÓM KUBERNETES
  Case 11 → Rollout treo vì pod không bao giờ Ready
  Case 12 → Pod rơi vào CrashLoopBackOff sau deploy
  Case 13 → ImagePullBackOff do registry hoặc tag sai
  Case 14 → App chạy nhưng config sai môi trường
  Case 15 → Rolling update làm thiếu năng lực giờ cao điểm
  Case 16 → HPA không scale như kỳ vọng
  Case 17 → Namespace bị tranh chấp tài nguyên

NHÓM HELM
  Case 18 → Helm upgrade fail, rollback chậm và lúng túng
  Case 19 → Helm hooks gây side effects khó đoán

TỔNG HỢP
  Case 20 → Team không biết nhìn gì khi rollout fail
```

---

## ⚙️ NHÓM GITHUB ACTIONS

---

## 📦 Case 1: Hai Pipeline Deploy Cùng Lúc Vào Một Môi Trường

**Case**
Hai PR merge gần nhau, hoặc có người re-run workflow, khiến nhiều workflow cùng deploy vào staging hay production.

**Dấu hiệu nhận biết**

- Release bị "đè" nhau — version trên cluster không phải version team tưởng
- Deployment log khó truy vết, ai deploy cái gì không rõ
- Môi trường lúc đúng lúc sai không giải thích được
- Team phải check lại cluster thủ công sau mỗi merge

**Cách xử lý**

Dùng `concurrency` trong GitHub Actions để gom các run vào cùng một nhóm theo môi trường:

```yaml
concurrency:
  group: deploy-${{ github.ref }}
  cancel-in-progress: true
```

GitHub Actions đảm bảo chỉ một workflow/job trong cùng `concurrency group` chạy tại một thời điểm. Khi run mới vào, run cũ bị cancel thay vì để cả hai chạy song song.

Với production nên dùng `cancel-in-progress: false` để run đang chạy không bị cắt ngang — chỉ queue thêm run mới:

```yaml
concurrency:
  group: deploy-production
  cancel-in-progress: false
```

**Sai lầm thường gặp**

- Chỉ kiểm soát bằng "quy ước team" — không bền
- Không khóa deploy theo môi trường, để mọi branch tự do deploy
- Dùng chung một concurrency group cho tất cả môi trường

**Bài học**

> Deploy an toàn cần **serialization**, không chỉ cần pipeline chạy pass.

---

## 📦 Case 2: Workflow Copy-Paste, Repo Nào Cũng Khác Nhau

**Case**
Nhiều repo Angular/web app có workflow gần giống nhau: lint, test, build image, push registry, deploy — nhưng mỗi repo tự viết một kiểu.

**Dấu hiệu nhận biết**

- Sửa một policy bảo mật phải vào sửa 10 repo riêng lẻ
- Repo này có step security scan, repo kia không
- Quality gate không đồng nhất giữa các team
- Workflow drift — logic tương tự nhau nhưng detail thì lệch

**Cách xử lý**

Dùng **reusable workflows** với trigger `workflow_call` để gom logic CI/CD dùng chung vào một nơi:

```yaml
# .github/workflows/reusable-build.yml
on:
  workflow_call:
    inputs:
      image-name:
        required: true
        type: string
    secrets:
      registry-token:
        required: true

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build and push
        run: |
          docker build -t ${{ inputs.image-name }} .
```

```yaml
# Repo A - .github/workflows/ci.yml
jobs:
  build:
    uses: org/shared-workflows/.github/workflows/reusable-build.yml@main
    with:
      image-name: my-app
    secrets:
      registry-token: ${{ secrets.REGISTRY_TOKEN }}
```

Nếu cần tùy chỉnh nhỏ theo repo, dùng `inputs` để truyền vào thay vì fork workflow.

**Sai lầm thường gặp**

- Mỗi repo tự viết pipeline riêng, không có central template
- Copy workflow rồi quên cập nhật khi policy thay đổi
- Reusable workflow quá generic, thiếu `inputs` rõ ràng

**Bài học**

> Pipeline cũng là **sản phẩm nội bộ** — nên có platform thinking, không nên copy-paste mãi.

---

## 📦 Case 3: Secret Cloud Credentials Sống Quá Lâu

**Case**
Team lưu AWS/GCP/Azure credentials dạng long-lived keys trong GitHub Actions secrets. Keys tồn tại hàng tháng, hàng năm.

**Dấu hiệu nhận biết**

- Rotation khó — không ai biết key này còn dùng chỗ nào
- Khó kiểm soát scope: cùng một key dùng cho dev, staging, prod
- Lo ngại rò rỉ vì key sống quá lâu và có quyền rộng
- Audit log không rõ: job nào dùng key nào

**Cách xử lý**

Ưu tiên **OIDC federation** thay cho long-lived cloud secrets. Thay vì lưu AWS Access Key, GitHub Actions sẽ nhận short-lived token từ cloud provider:

```yaml
permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    steps:
      - name: Configure AWS credentials via OIDC
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::123456789012:role/GitHubActionsRole
          aws-region: ap-southeast-1
```

Token này chỉ valid trong scope của job đang chạy, hết job thì hết hiệu lực. Không có gì để rotate, không có gì để leak lâu dài.

Với GitHub Environments, gắn secret riêng theo từng môi trường:

```yaml
jobs:
  deploy-prod:
    environment: production
    steps:
      - run: echo "Secret này chỉ có trong environment production"
```

**Sai lầm thường gặp**

- Nhét access key vào repo secrets rồi để nhiều năm không đụng
- Dùng chung một credential cho tất cả môi trường
- Không gắn policy theo branch/environment, key nào cũng deploy được vào prod

**Bài học**

> CI/CD bảo mật tốt là **cấp quyền ngắn hạn, đúng ngữ cảnh**, không phải cất thật nhiều secret.

---

## 📦 Case 4: Deploy Nhầm Production Từ Sai Branch Hoặc Sai Actor

**Case**
Một workflow pass build và vô tình đi thẳng tới production — từ branch feature, từ fork, hoặc từ người không có quyền.

**Dấu hiệu nhận biết**

- Deploy xảy ra từ branch không phải `main`/`release`
- Không có bước approval trước khi vào production
- Khó biết ai đã trigger deployment nào
- Secret production bị dùng ở cả staging workflow

**Cách xử lý**

Dùng **GitHub Environments** với protection rules:

```yaml
jobs:
  deploy-production:
    environment: production # gắn environment ở đây
    runs-on: ubuntu-latest
    steps:
      - run: helm upgrade --install my-app ./chart
```

Trong Settings → Environments → production, cấu hình:

- **Required reviewers**: phải có người approve trước khi job chạy
- **Deployment branches**: chỉ `main` hoặc pattern `release/*` mới được deploy
- **Environment secrets**: secret riêng, không leak sang môi trường khác

Kết hợp với branch protection rules để `main` không ai push thẳng được.

**Sai lầm thường gặp**

- Dùng chung secret cho mọi môi trường trong repo-level secrets
- Không tách staging và prod — cùng một job deploy cả hai
- Xem approval production là "rườm rà" và bỏ qua

**Bài học**

> Production không nên chỉ là **một job cuối trong YAML** — nó phải là một môi trường có hàng rào.

---

## 📦 Case 5: Self-Hosted Runner Trở Thành Điểm Tấn Công

**Case**
Team dùng self-hosted runner để vào private network, private registry, private cluster — nhưng không kiểm soát đủ.

**Dấu hiệu nhận biết**

- Runner chứa nhiều credentials, token, kubeconfig lưu tại chỗ
- Nhiều repo dùng chung cùng một runner pool
- Khó dọn state sau mỗi run — file, env var có thể leak sang job khác
- Public fork có thể trigger workflow chạy trên runner nội bộ

**Cách xử lý**

Phân nhóm runner theo mức độ tin cậy:

```yaml
jobs:
  deploy:
    runs-on: [self-hosted, production, linux]
```

Dùng **runner groups** trong Organization Settings để chỉ cho phép repo nội bộ dùng runner production. Không để runner production tiếp xúc public repo hoặc fork.

Nếu chạy trong Kubernetes, dùng **Actions Runner Controller (ARC)** để ephemeral runner — mỗi job được cấp một pod mới, sau khi xong tự xóa:

```yaml
# runner mới cho mỗi job, không giữ state
containerMode:
  type: "dind"
```

Với mỗi runner, tối thiểu hóa credentials được cấp — chỉ đủ để làm việc trong context đó.

**Sai lầm thường gặp**

- Dùng chung một runner pool cho cả organization không phân nhóm
- Để public fork chạm runner nội bộ có access private resources
- Không phân vùng quyền theo runner group

**Bài học**

> Self-hosted runner không chỉ là "máy chạy job" — đó là **một bề mặt tấn công** cần được quản lý như infrastructure.

---

## 📦 Case 6: Artifact Mất Giữa Jobs, Mỗi Job Build Lại Từ Đầu

**Case**
Job `build` tạo ra `dist/` hoặc Docker image, nhưng job `deploy` không dùng lại được nên phải build tiếp.

**Dấu hiệu nhận biết**

- Workflow chậm vì cùng một thứ build nhiều lần
- Deploy từ source chứ không deploy từ artifact đã được test
- Không đảm bảo artifact deploy là artifact đã pass CI
- Pipeline log khó truy vết version nào đã được deploy

**Cách xử lý**

Dùng `actions/upload-artifact` và `actions/download-artifact` để truyền build output giữa jobs:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci && npm run build
      - uses: actions/upload-artifact@v4
        with:
          name: dist-${{ github.sha }}
          path: dist/
          retention-days: 7

  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: dist-${{ github.sha }}
          path: dist/
      - run: ./deploy.sh
```

Với Docker image, push image với tag là `github.sha` lên registry, rồi deploy job pull đúng tag đó — không build lại:

```yaml
env:
  IMAGE_TAG: ${{ github.sha }}

jobs:
  build:
    steps:
      - run: docker build -t my-app:$IMAGE_TAG . && docker push my-app:$IMAGE_TAG

  deploy:
    needs: build
    steps:
      - run: helm upgrade my-app ./chart --set image.tag=$IMAGE_TAG
```

**Sai lầm thường gặp**

- Build lại ở mỗi stage để "đảm bảo fresh"
- Deploy từ source branch chứ không deploy từ artifact đã test
- Không có retention policy — artifact tích lũy vô hạn

**Bài học**

> Muốn pipeline đáng tin, phải tách rõ **source → artifact → deployment** — không được để chúng lẫn lộn.

---

## 📦 Case 7: Context/Vars Dùng Sai, Deploy Sai Target

**Case**
Workflow dựa vào branch name, tag, actor, inputs để chọn môi trường hoặc image tag — nhưng expression logic sai.

**Dấu hiệu nhận biết**

- Branch `feature/*` bị route sang staging
- Tag format lộn xộn, không nhất quán
- Step dùng nhầm `env`, `vars`, `secrets`, `inputs`
- Debug bằng cách re-run tới khi pass — không hiểu tại sao

**Cách xử lý**

Chuẩn hóa naming convention và review expression như review code:

```yaml
# Xác định môi trường rõ ràng
jobs:
  set-env:
    outputs:
      environment: ${{ steps.set.outputs.env }}
    steps:
      - id: set
        run: |
          if [[ "${{ github.ref }}" == "refs/heads/main" ]]; then
            echo "env=production" >> $GITHUB_OUTPUT
          elif [[ "${{ github.ref }}" == refs/heads/release/* ]]; then
            echo "env=staging" >> $GITHUB_OUTPUT
          else
            echo "env=development" >> $GITHUB_OUTPUT
          fi

  deploy:
    needs: set-env
    environment: ${{ needs.set-env.outputs.environment }}
```

Hiểu rõ phân cấp context trong GitHub Actions:

- `github.*` — thông tin về event, repo, actor
- `secrets.*` — bí mật theo scope (repo/environment)
- `vars.*` — biến không nhạy cảm theo scope
- `inputs.*` — giá trị được truyền vào từ workflow_call hoặc workflow_dispatch
- `needs.<job>.outputs.*` — output từ job trước

**Sai lầm thường gặp**

- Viết expression ad-hoc, không có convention
- Không có branch/tag naming convention — mỗi người đặt tên một kiểu
- Dùng `env` context để truyền dữ liệu giữa jobs (không hoạt động) thay vì `outputs`

**Bài học**

> Workflow YAML cũng là code — **sai ở pipeline logic** có thể nguy hiểm hơn sai ở app code.

---

## 📦 Case 8: Pipeline Quá Nặng, Dev Tìm Đường Bypass

**Case**
Mỗi PR phải chạy quá nhiều bước chậm, hoặc deploy path có quá nhiều approval thủ công không cần thiết.

**Dấu hiệu nhận biết**

- Dev ngại push nhỏ vì sợ phải chờ pipeline 20–30 phút
- Re-run workflow rất nhiều lần trong ngày
- Người ta tìm đường tắt ngoài chuẩn: push thẳng, skip CI với `[skip ci]`
- Pipeline compliance cao nhưng developer experience tệ

**Cách xử lý**

Tách pipeline theo mục đích và áp dụng nguyên tắc **fail fast trước, full check sau**:

```yaml
# PR check - nhanh, chỉ những gì cần thiết để validate
on: [pull_request]
jobs:
  quick-check:
    steps:
      - run: npm run lint
      - run: npm run test:unit  # unit test thôi, không e2e
      - run: npm run build      # verify build pass

# Merge to main - đầy đủ hơn
on:
  push:
    branches: [main]
jobs:
  full-check:
    steps:
      - run: npm run test:e2e
      - run: npm run security-scan
      - run: docker build && docker push
```

Tận dụng cache để giảm thời gian:

```yaml
- uses: actions/cache@v4
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
    restore-keys: ${{ runner.os }}-node-
```

Dùng `paths` filter để chỉ chạy khi file liên quan thay đổi:

```yaml
on:
  push:
    paths:
      - "src/**"
      - "package*.json"
```

**Sai lầm thường gặp**

- Một workflow làm mọi thứ: lint + test + build + scan + deploy
- Không phân tầng quality gates theo mục đích
- Tối ưu compliance mà quên developer experience

**Bài học**

> CI/CD tốt phải **vừa an toàn vừa có throughput** — nếu chỉ an toàn mà chậm, team sẽ tự sinh shadow process.

---

## 🐳 NHÓM DOCKER

---

## 📦 Case 9: Build Docker Quá Chậm, Cache Hit Thấp

**Case**
Pipeline build image cho Angular/Nginx app mất rất lâu, gần như build lại từ đầu mỗi lần có thay đổi nhỏ.

**Dấu hiệu nhận biết**

- Build time cao dù chỉ đổi vài dòng code
- Cache hit thấp hoặc không có
- CI cost tăng vô lý
- Dev phải chờ lâu mới thấy kết quả deploy

**Cách xử lý**

Sắp xếp Dockerfile theo nguyên tắc **ít thay đổi lên trước, hay thay đổi xuống sau** để tận dụng layer cache:

```dockerfile
# ❌ Sai - COPY source sớm, invalidate cache mọi thứ phía sau
FROM node:20-alpine AS builder
COPY . .
RUN npm ci
RUN npm run build

# ✅ Đúng - Install dependencies trước, copy source sau
FROM node:20-alpine AS builder
WORKDIR /app

# Layer này chỉ invalidate khi package.json/lock thay đổi
COPY package.json package-lock.json ./
RUN npm ci

# Layer này invalidate khi source thay đổi
COPY . .
RUN npm run build
```

Với GitHub Actions, bật `cache-from` và `cache-to` qua registry:

```yaml
- uses: docker/build-push-action@v5
  with:
    context: .
    push: true
    tags: my-app:${{ github.sha }}
    cache-from: type=registry,ref=my-app:buildcache
    cache-to: type=registry,ref=my-app:buildcache,mode=max
```

**Sai lầm thường gặp**

- `COPY . .` quá sớm trong Dockerfile — invalidate cache của tất cả layer phía sau
- Không tách `npm ci` (dependencies) khỏi `COPY source`
- Không dùng registry cache, chỉ dùng local cache (mất khi runner thay đổi)

**Bài học**

> Docker build nhanh không đến từ máy mạnh hơn — mà từ **Dockerfile có cấu trúc đúng** và cache strategy phù hợp.

---

## 📦 Case 10: Final Image Quá Nặng, Mang Theo Cả Tool Build

**Case**
Image production chứa cả Node modules build-time, TypeScript compiler, Angular CLI, test tools — những thứ không cần khi runtime.

**Dấu hiệu nhận biết**

- Image size vài GB thay vì vài chục MB
- Pull image chậm khi deploy
- Security scan ra hàng trăm CVE từ packages không cần thiết
- Node process đang chạy trong production thay vì Nginx serve static

**Cách xử lý**

Dùng **multi-stage build** để tách hoàn toàn build environment khỏi runtime image:

```dockerfile
# Stage 1: Build - dùng Node để build Angular app
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build --configuration=production

# Stage 2: Runtime - chỉ cần Nginx để serve static files
FROM nginx:alpine AS runtime
COPY --from=builder /app/dist/my-app /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

Kết quả:

- Stage `builder`: ~800MB (Node, npm cache, Angular CLI, TypeScript...)
- Stage `runtime`: ~25MB (chỉ Nginx + static files)
- Final image chỉ có runtime stage

Thêm `.dockerignore` để tránh copy file thừa vào build context:

```
node_modules
dist
.git
*.md
.env*
coverage
```

**Sai lầm thường gặp**

- Một Dockerfile một stage — final image chứa mọi thứ
- Dùng `node:20` (full image) thay vì `node:20-alpine` cho cả runtime
- Không có `.dockerignore` — COPY context chứa `node_modules` nặng hàng GB

**Bài học**

> Image production tốt là image **chạy được**, không phải image **chứa mọi thứ để tiện** — multi-stage là baseline, không phải optimization.

---

## ☸️ NHÓM KUBERNETES

---

## 📦 Case 11: Rollout Treo Vì Pod Không Bao Giờ Ready

**Case**
`kubectl apply` hoặc `helm upgrade` xong nhưng rollout không complete — Deployment đứng ở trạng thái progressing mãi.

**Dấu hiệu nhận biết**

- `kubectl rollout status` treo hoặc báo timeout
- Pod ở trạng thái Running nhưng service không nhận traffic
- Deployment cũ vẫn còn, Deployment mới không lên
- `kubectl describe pod` hiện readiness probe failing liên tục

**Cách xử lý**

Kiểm tra và cấu hình đúng **readiness probe** — đây là điều kiện để pod được coi là Ready và nhận traffic:

```yaml
spec:
  containers:
    - name: my-app
      image: my-app:latest
      readinessProbe:
        httpGet:
          path: /health/ready
          port: 8080
        initialDelaySeconds: 10 # đợi app startup
        periodSeconds: 5
        failureThreshold: 3
      livenessProbe:
        httpGet:
          path: /health/live
          port: 8080
        initialDelaySeconds: 30 # liveness check sau readiness
        periodSeconds: 10
      startupProbe: # cho app startup lâu (ví dụ: Spring Boot, SSR)
        httpGet:
          path: /health/live
          port: 8080
        failureThreshold: 30 # 30 * 10s = 5 phút để startup
        periodSeconds: 10
```

Phân biệt rõ vai trò:

- `startupProbe` — app đã start chưa? (chỉ chạy 1 lần lúc đầu)
- `readinessProbe` — app có sẵn sàng nhận request không? (kiểm soát traffic)
- `livenessProbe` — app có còn sống không? (trigger restart nếu fail)

Rollback khi cần:

```bash
kubectl rollout status deployment/my-app
kubectl rollout history deployment/my-app
kubectl rollout undo deployment/my-app
```

**Sai lầm thường gặp**

- Dùng cùng một endpoint `/health` cho cả ba loại probe
- Readiness check quá sớm — `initialDelaySeconds` quá nhỏ
- App startup lâu nhưng không có `startupProbe` — liveness kill pod trước khi kịp ready

**Bài học**

> Rollout tốt không chỉ là pod "Running" — mà là pod **Ready đúng nghĩa**, phục vụ được traffic thật.

---

## 📦 Case 12: Pod Rơi Vào CrashLoopBackOff Sau Deploy

**Case**
Image lên cluster xong, pod cứ restart liên tục với status `CrashLoopBackOff`.

**Dấu hiệu nhận biết**

- Pod restart count tăng nhanh
- App chết ngay sau khi start
- Rollout không tiến được
- `kubectl logs` chỉ thấy một đoạn ngắn rồi mất

**Cách xử lý**

Điều tra theo thứ tự có cấu trúc:

```bash
# Bước 1: Xem trạng thái pod
kubectl get pods -n my-namespace

# Bước 2: Xem events của pod
kubectl describe pod <pod-name> -n my-namespace

# Bước 3: Xem logs của lần chạy trước (trước khi restart)
kubectl logs <pod-name> --previous -n my-namespace

# Bước 4: Xem init containers nếu có
kubectl logs <pod-name> -c init-container-name -n my-namespace
```

Các nguyên nhân phổ biến và cách kiểm tra:

| Nguyên nhân             | Dấu hiệu                | Kiểm tra                        |
| ----------------------- | ----------------------- | ------------------------------- |
| Missing env/config      | App crash vì thiếu biến | `kubectl exec` + `printenv`     |
| Secret không mount được | Error mount             | `kubectl describe pod` → Events |
| Command/entrypoint sai  | Exit code 127           | `image.command` trong spec      |
| Port sai                | Connection refused      | So sánh `containerPort` và app  |
| Probe quá gắt           | Bị kill trước khi ready | `liveness` settings             |
| OOMKilled               | Exit code 137           | `resources.limits.memory`       |

**Sai lầm thường gặp**

- Chỉ nhìn logs container chính mà quên init containers
- Chỉnh probe bừa để "cho pod sống" thay vì fix root cause
- Deploy image chưa được test local, chỉ test trên CI

**Bài học**

> `CrashLoopBackOff` là **triệu chứng**, không phải root cause — điều tra đúng thứ tự sẽ tìm ra nguyên nhân nhanh hơn sửa bừa.

---

## 📦 Case 13: ImagePullBackOff Do Registry Private Hoặc Tag Sai

**Case**
Pod không kéo được image sau khi deploy — cluster báo `ImagePullBackOff` hoặc `ErrImagePull`.

**Dấu hiệu nhận biết**

- `kubectl describe pod` hiện `Failed to pull image`
- Cluster không authenticate được với private registry
- Image tag không tồn tại trên registry
- Chỉ xảy ra ở một số namespace, cluster, hoặc environment

**Cách xử lý**

**TH1: Registry private — chưa có imagePullSecret**

```bash
# Tạo secret từ docker credentials
kubectl create secret docker-registry regcred \
  --docker-server=registry.example.com \
  --docker-username=<username> \
  --docker-password=<token> \
  -n my-namespace
```

```yaml
# Gắn vào Pod/Deployment
spec:
  imagePullSecrets:
    - name: regcred
  containers:
    - name: my-app
      image: registry.example.com/my-app:v1.2.3
```

Hoặc gắn vào ServiceAccount để tự động áp dụng cho tất cả pod trong namespace:

```bash
kubectl patch serviceaccount default \
  -p '{"imagePullSecrets": [{"name": "regcred"}]}' \
  -n my-namespace
```

**TH2: Tag sai hoặc image không tồn tại**

```bash
# Verify image tồn tại trên registry
docker manifest inspect registry.example.com/my-app:v1.2.3

# Kiểm tra pipeline có push thành công không
# Xem workflow run logs
```

Quy tắc đặt tag:

- Dùng `git sha` hoặc semantic version — tránh `latest` trong production
- Pipeline push image trước, sau đó mới trigger deploy

**Sai lầm thường gặp**

- Tạo `imagePullSecret` ở namespace này nhưng quên sync sang namespace khác
- Dùng `latest` tag — không biết đang chạy version nào
- Build pipeline push thất bại nhưng deploy vẫn chạy vì không kiểm tra dependency

**Bài học**

> Deploy image thành công phụ thuộc cả **registry auth**, **naming/tagging**, và **namespace hygiene** — thiếu một trong ba là fail.

---

## 📦 Case 14: App Chạy Nhưng Config Sai Môi Trường

**Case**
Deploy xong app vẫn sống, nhưng chỉa sai API endpoint, sai feature flag, sai domain — vì config bị bake vào image.

**Dấu hiệu nhận biết**

- Pod healthy nhưng behavior sai hoàn toàn
- Cùng image lên dev/staging/prod ra kết quả khác ngoài ý muốn
- Phải rebuild image chỉ để đổi một URL hoặc một biến môi trường
- Dev và staging dùng chung config của nhau

**Cách xử lý**

Tách hoàn toàn config ra khỏi image bằng **ConfigMap** và **Secret**:

```yaml
# ConfigMap cho non-sensitive config
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-app-config
  namespace: production
data:
  API_URL: "https://api.production.example.com"
  FEATURE_NEW_UI: "true"
  LOG_LEVEL: "warn"

---
# Secret cho sensitive config
apiVersion: v1
kind: Secret
metadata:
  name: my-app-secret
  namespace: production
type: Opaque
stringData:
  DATABASE_URL: "postgresql://user:pass@db.internal:5432/prod"
  JWT_SECRET: "..."
```

```yaml
# Inject vào container
spec:
  containers:
    - name: my-app
      image: my-app:v1.2.3 # cùng image, khác config
      envFrom:
        - configMapRef:
            name: my-app-config
        - secretRef:
            name: my-app-secret
```

Với Helm, quản lý values theo môi trường:

```
chart/
├── values.yaml          # defaults
├── values.dev.yaml      # dev overrides
├── values.staging.yaml  # staging overrides
└── values.prod.yaml     # production overrides
```

```bash
helm upgrade my-app ./chart -f values.prod.yaml -n production
```

**Sai lầm thường gặp**

- Bake config môi trường vào image lúc build (`ARG`, `ENV` cứng)
- Nhét cả secret vào ConfigMap — ConfigMap không được mã hóa
- Không version hóa values/config change — không biết production đang dùng giá trị gì

**Bài học**

> Image nên mang **application**, không nên mang **identity của môi trường** — cùng image, khác config là nguyên tắc cơ bản.

---

## 📦 Case 15: Rolling Update Làm Thiếu Năng Lực Phục Vụ Giờ Cao Điểm

**Case**
Deploy đúng lúc traffic cao, rolling update làm giảm số pod available hoặc pod mới lên chậm — gây latency tăng và lác đác 5xx.

**Dấu hiệu nhận biết**

- Latency tăng đúng trong khoảng thời gian rollout
- 5xx error tăng nhẹ — sau đó bình thường
- Cluster có pod mới nhưng chưa gánh nổi traffic ngay
- Rolling update hoàn thành nhưng đã có SLA impact

**Cách xử lý**

Cấu hình deployment strategy phù hợp với SLA của app:

```yaml
spec:
  replicas: 6
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 0 # không giảm capacity trong khi update
      maxSurge: 2 # tạo thêm 2 pod mới trước khi xóa pod cũ
  template:
    spec:
      containers:
        - name: my-app
          readinessProbe:
            httpGet:
              path: /health/ready
              port: 8080
            initialDelaySeconds: 15
            periodSeconds: 5
          lifecycle:
            preStop:
              exec:
                command: ["/bin/sh", "-c", "sleep 5"] # drain gracefully
```

Giải thích:

- `maxUnavailable: 0` — không bao giờ giảm số pod available khi update
- `maxSurge: 2` — tạo thêm 2 pod mới, sau khi ready mới xóa pod cũ
- `preStop sleep` — cho load balancer kịp ngừng route traffic vào pod cũ

Với app cần warm-up (cache, connection pool):

```yaml
readinessProbe:
  initialDelaySeconds: 30 # đợi app warm up xong mới nhận traffic
minReadySeconds: 10 # pod phải ready ít nhất 10s mới tính là stable
```

**Sai lầm thường gặp**

- Để mặc định `maxUnavailable: 25%` — với 4 replicas thì 1 pod bị kill ngay
- Không test rollout dưới load thực tế
- Probe pass quá sớm khi app chưa warm up — traffic vào pod chưa sẵn sàng

**Bài học**

> Zero-downtime không đến từ "dùng Deployment" — mà từ **rollout parameters đúng với hành vi thật của app**.

---

## 📦 Case 16: HPA Không Scale Như Kỳ Vọng

**Case**
App chậm lúc traffic tăng nhưng số replicas không tăng, hoặc tăng quá muộn — dù đã có HPA.

**Dấu hiệu nhận biết**

- CPU/memory cao mà pods không scale hợp lý
- HPA object tồn tại nhưng `REPLICAS` không thay đổi
- Scale xảy ra nhưng app vẫn nghẽn — scale sai metric
- `kubectl describe hpa` hiện `<unknown>` ở metrics

**Cách xử lý**

Đảm bảo **resource requests được đặt** — HPA tính utilization dựa trên requests, không dựa trên limits hay số tuyệt đối:

```yaml
spec:
  containers:
    - name: my-app
      resources:
        requests:
          cpu: "250m" # PHẢI có để HPA tính được %
          memory: "256Mi"
        limits:
          cpu: "1000m"
          memory: "512Mi"
```

```yaml
# HPA config
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: my-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70 # scale khi CPU trung bình > 70% của requests
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 60 # đợi 60s trước khi scale up
    scaleDown:
      stabilizationWindowSeconds: 300 # đợi 5 phút trước khi scale down
```

Debug HPA:

```bash
kubectl describe hpa my-app-hpa -n my-namespace
kubectl get hpa my-app-hpa -n my-namespace
# Xem TARGETS: 45%/70% -> đang ở 45%, sẽ scale khi > 70%
```

**Sai lầm thường gặp**

- Bật HPA nhưng không set `requests` — HPA không tính được utilization
- Scale dựa trên CPU nhưng nút thắt thực sự là I/O hoặc memory
- Không có Metrics Server trong cluster — HPA không có data để scale

**Bài học**

> Autoscaling chỉ hoạt động tốt khi **capacity model và resource model của app được định nghĩa rõ** — không có requests thì HPA chỉ là object trang trí.

---

## 📦 Case 17: Namespace Bị Tranh Chấp Tài Nguyên

**Case**
Nhiều workload chạy chung cluster/namespace, workload này "ăn" hết CPU/RAM của workload khác.

**Dấu hiệu nhận biết**

- Pod bị evict hoặc throttle không giải thích được
- Môi trường shared rất khó đoán — lúc ổn lúc không
- Deploy feature mới xong thì app khác chậm hẳn
- Node pressure cao dù tổng workload có vẻ bình thường

**Cách xử lý**

Đặt requests/limits cho tất cả container — đây là baseline:

```yaml
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "500m"
    memory: "256Mi"
```

Dùng **LimitRange** để set default cho namespace — container nào không khai báo sẽ được áp default:

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: default-limits
  namespace: my-namespace
spec:
  limits:
    - default:
        cpu: "500m"
        memory: "256Mi"
      defaultRequest:
        cpu: "100m"
        memory: "128Mi"
      type: Container
```

Dùng **ResourceQuota** để giới hạn tổng tiêu thụ của namespace:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: namespace-quota
  namespace: my-namespace
spec:
  hard:
    requests.cpu: "4"
    requests.memory: "8Gi"
    limits.cpu: "8"
    limits.memory: "16Gi"
    pods: "20"
```

**Sai lầm thường gặp**

- Để workload không có requests/limits — scheduler không thể planning tốt
- Coi shared cluster như máy riêng — deploy thoải mái không kiểm soát resource
- Chỉ xử lý sau khi có incident, không có guardrail trước

**Bài học**

> CI/CD tốt không dừng ở deploy thành công — còn phải **bảo vệ multi-tenant stability** trong shared cluster.

---

## ⛵ NHÓM HELM

---

## 📦 Case 18: Helm Upgrade Fail, Rollback Chậm Và Lúng Túng

**Case**
Dùng Helm để deploy, một bản values/config/chart mới gây lỗi — team loay hoay rollback vì không nắm rõ quy trình.

**Dấu hiệu nhận biết**

- `helm upgrade` xong nhưng release không healthy
- Team không chắc revision nào ổn gần nhất
- Rollback mất thời gian vì phải nhớ lệnh và revision number
- Values file không được version hóa rõ — không biết đang chạy config gì

**Cách xử lý**

Nắm vững flow Helm release management:

```bash
# Xem lịch sử release
helm history my-app -n production

# Output:
# REVISION  UPDATED    STATUS     CHART        APP VERSION  DESCRIPTION
# 1         ...        superseded my-app-1.0.0  v1.0.0      Install complete
# 2         ...        superseded my-app-1.0.1  v1.1.0      Upgrade complete
# 3         ...        failed     my-app-1.0.2  v1.2.0      Upgrade failed
# 4         ...        deployed   my-app-1.0.1  v1.1.0      Rollback to 2

# Rollback về revision ổn gần nhất
helm rollback my-app 2 -n production

# Verify sau rollback
helm status my-app -n production
kubectl rollout status deployment/my-app -n production
```

Upgrade có kiểm soát:

```bash
# Upgrade với timeout và atomic (tự rollback nếu fail)
helm upgrade my-app ./chart \
  -f values.prod.yaml \
  --atomic \           # tự rollback nếu deploy fail
  --timeout 5m \       # timeout rõ ràng
  --wait \             # đợi resources healthy
  -n production
```

Cờ `--atomic` rất hữu ích cho automation — nếu rollout fail thì Helm tự rollback về revision trước, không cần can thiệp thủ công.

**Sai lầm thường gặp**

- Không lưu/review values theo môi trường — production values nằm trong đầu
- Rollback bằng tay qua nhiều bước YAML rời rạc thay vì `helm rollback`
- Không biết revision hiện tại và revision ổn gần nhất

**Bài học**

> Muốn release nhanh, phải **luyện rollback nhanh hơn nữa** — `helm rollback` trong 30 giây tốt hơn loay hoay 30 phút.

---

## 📦 Case 19: Helm Hooks Gây Side Effects Khó Đoán

**Case**
Dùng Helm hooks để chạy DB migration, preload config, backup/restore — nhưng gây hành vi bất ngờ khi upgrade.

**Dấu hiệu nhận biết**

- Chart install/upgrade có hành vi "bí ẩn" — thứ tự thực hiện không rõ
- Fail ở hook nhưng team chỉ nhìn Deployment, không nhìn Job
- Migration chạy lặp lại hoặc sai thứ tự
- Không có observability cho hook job — không biết hook đang chạy hay xong

**Cách xử lý**

Hiểu rõ hook lifecycle và dùng có kỷ luật:

```yaml
# Job chạy migration TRƯỚC khi upgrade deployment
apiVersion: batch/v1
kind: Job
metadata:
  name: db-migrate
  annotations:
    "helm.sh/hook": pre-upgrade # chạy trước upgrade
    "helm.sh/hook-weight": "-5" # thứ tự trong cùng hook phase
    "helm.sh/hook-delete-policy": hook-succeeded # xóa Job sau khi success
spec:
  template:
    spec:
      restartPolicy: Never
      containers:
        - name: migrate
          image: my-app:{{ .Values.image.tag }}
          command: ["./migrate.sh"]
          envFrom:
            - secretRef:
                name: db-secret
```

Nguyên tắc dùng hooks:

- Chỉ dùng khi thực sự cần can thiệp tại lifecycle của chart (pre/post install/upgrade)
- Hook job phải **idempotent** — chạy nhiều lần vẫn an toàn
- Luôn có timeout và monitoring cho hook job
- Tách hook logic ra khỏi app image nếu có thể

Debug hook:

```bash
# Xem hook jobs
kubectl get jobs -n my-namespace

# Xem logs của hook job
kubectl logs job/db-migrate -n my-namespace

# Nếu hook bị stuck
kubectl describe job/db-migrate -n my-namespace
```

**Sai lầm thường gặp**

- Nhét quá nhiều business logic vào hook — hook thành "script thần kỳ" không ai hiểu
- Hook không idempotent — chạy hai lần thì data bị duplicate hoặc corrupt
- Không có observability cho hook job — fail âm thầm

**Bài học**

> Hook mạnh thì phải **đơn giản và quan sát được** — nếu không debug được thì không nên dùng.

---

## 🔭 TỔNG HỢP

---

## 📦 Case 20: Team Không Biết Nhìn Gì Khi Rollout Fail

**Case**
Deploy lỗi nhưng mỗi người kiểm tra một kiểu, không có thứ tự — mất nhiều thời gian mà không ra nguyên nhân.

**Dấu hiệu nhận biết**

- Người xem GitHub Actions log, người xem pod logs, người sửa values — không ai điều phối
- Không có checklist chung
- Team "fix bừa" — thay đổi nhiều thứ cùng lúc không biết cái nào fix vấn đề
- Senior nhớ nhiều lệnh, junior không biết bắt đầu từ đâu

**Cách xử lý**

Tạo **rollout failure runbook** theo thứ tự từ ngoài vào trong:

```
ROLLOUT FAILURE RUNBOOK
──────────────────────────────────────────────

1. PIPELINE LAYER (GitHub Actions)
   ├─ Workflow run có pass không?
   ├─ Build job có artifact/image không?
   ├─ Image được push lên registry chưa?
   └─ Deploy job có trigger không?

2. HELM LAYER
   ├─ helm status my-app -n namespace
   ├─ helm history my-app -n namespace
   └─ Revision nào đang deployed? Revision nào ổn gần nhất?

3. KUBERNETES LAYER
   ├─ kubectl rollout status deployment/my-app
   ├─ kubectl get pods -n namespace
   ├─ kubectl describe pod <pod> -n namespace  → Events
   └─ kubectl logs <pod> --previous -n namespace

4. POD DETAIL
   ├─ Probe status (readiness, liveness, startup)
   ├─ Init container logs
   ├─ Exit code và termination reason
   └─ Events: ImagePullBackOff? OOMKilled? CrashLoop?

5. CONFIG/SECRET LAYER
   ├─ Env vars đúng không?
   ├─ Secret có mount được không?
   └─ ConfigMap có đúng namespace không?

6. RESOURCE LAYER
   ├─ Node có đủ capacity không?
   ├─ Pod có bị throttle không?
   └─ HPA có hoạt động không?

7. ROLLBACK DECISION
   ├─ Impact đang ở mức nào?
   ├─ helm rollback ngay vs tiếp tục điều tra?
   └─ Ai là người quyết định rollback?
```

Sau khi ổn định, làm **mini postmortem**:

```
POSTMORTEM
├─ What happened?           → Mô tả timeline
├─ Why did it happen?       → Root cause thật sự
├─ Why wasn't it caught?    → Tại sao lọt qua CI/CD
├─ Prevent recurrence?      → Action items cụ thể
└─ Owner + deadline         → Ai làm gì, trước khi nào
```

**Sai lầm thường gặp**

- Nhảy vào sửa ngay mà không điều tra — thay đổi nhiều thứ cùng lúc
- Rollback quá muộn — ngại rollback vì "chắc sắp xong"
- Không có incident owner — mọi người cùng làm mọi thứ gây loạn

**Bài học**

> Khi deploy fail, thứ cứu team không phải "senior nhớ nhiều lệnh" — mà là **runbook rõ và thứ tự chẩn đoán đúng**.

---

## 🗺️ Framework Tổng Quan: CI/CD Incident Layers

```
CI/CD INCIDENT — KIỂM TRA THEO TẦNG
──────────────────────────────────────────────────

BUILD LAYER
   ├─ Source đúng branch/tag chưa?
   ├─ Cache/artifact có hợp lệ không?
   └─ Image được build và push thành công chưa?

DEPLOY LAYER
   ├─ Đúng environment/namespace chưa?
   ├─ Secrets/config đúng môi trường chưa?
   └─ Chart/manifest đang dùng revision/values nào?

RUNTIME LAYER
   ├─ Image pull được không? (auth, tag, registry)
   ├─ Pod start được không? (command, env, config)
   ├─ Probes pass không? (readiness, liveness, startup)
   ├─ Resources đủ không? (requests, limits, node capacity)
   └─ Rollout complete? (maxUnavailable, maxSurge, minReadySeconds)

RECOVERY LAYER
   ├─ Rollback về revision nào?
   ├─ Impact đang ở mức nào để quyết định?
   └─ Postmortem action items là gì?
```

---

## 💡 Bài Học Lớn Nhất Theo Nhóm

| Nhóm               | Bài học cốt lõi                                                                                                           |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------- |
| **GitHub Actions** | Dùng `concurrency`, reusable workflows, environments, OIDC, và artifacts từ sớm để pipeline không loạn và bớt rủi ro      |
| **Docker**         | Multi-stage build và cache strategy đúng là khoản đầu tư lời nhất cho tốc độ CI và chất lượng image                       |
| **Kubernetes**     | Phần lớn rollout fail thực tế xoay quanh probes, config/secret, image pull, và resources — không phải "Kubernetes bị lỗi" |
| **Helm**           | Nếu dùng Helm thì phải luyện cả upgrade lẫn rollback — `--atomic` và `helm rollback` là hai lệnh quan trọng nhất          |

---

> **Team Lead không chỉ cần biết pipeline chạy pass.**
> Cần biết khi nào nó fail, tại sao nó fail, và team rollback được trong bao nhiêu phút.
