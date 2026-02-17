#!/bin/bash

# Script tự động di chuyển và dọn dẹp các file

echo "🚀 Bắt đầu tổ chức lại cấu trúc blog..."

# Tạo các thư mục mới
echo "📁 Tạo các thư mục collection..."
mkdir -p _development _architecture _leadership _learning

# Di chuyển file Development
echo "💻 Di chuyển file Development..."
mv _posts/2024-10-29-javascript.md _development/ 2>/dev/null
mv _posts/2024-10-25-document-object-model.md _development/ 2>/dev/null
mv _posts/2024-12-11-git-review.md _development/ 2>/dev/null
mv _posts/2024-12-25-git-quizz.md _development/ 2>/dev/null
mv _posts/2024-10-24-frontend-design-system.md _development/ 2>/dev/null
mv _posts/2025-01-10-frontend-system.md _development/ 2>/dev/null
mv _posts/2024-10-29-security.md _development/ 2>/dev/null
mv _posts/2024-10-30-CRP.md _development/ 2>/dev/null
mv _posts/2025-01-03-web-view.md _development/ 2>/dev/null
mv _posts/2025-01-03-frontend-optimize-performance.md _development/ 2>/dev/null
mv _posts/2025-01-03-computer-overview.md _development/ 2>/dev/null

# Di chuyển file Architecture
echo "🏗️ Di chuyển file Architecture..."
mv _posts/2025-01-23-solid.md _architecture/ 2>/dev/null
mv _posts/2025-01-10-docker.md _architecture/ 2>/dev/null
mv _posts/2025-01-03-authentication-strategies.md _architecture/ 2>/dev/null
mv _posts/2025-01-04-authentication.md _architecture/ 2>/dev/null
mv _posts/2025-01-04-hybrid-cross-flatform.md _architecture/ 2>/dev/null
mv _posts/2025-01-04-ionic-capacitor.md _architecture/ 2>/dev/null
mv _posts/2025-01-04-ionic-portals.md _architecture/ 2>/dev/null
mv _posts/2025-01-04-ionic.md _architecture/ 2>/dev/null
mv _posts/2025-02-16-redis.md _architecture/ 2>/dev/null

# Di chuyển file Leadership
echo "👔 Di chuyển file Leadership..."
mv _posts/2024-10-30-team-lead.md _leadership/ 2>/dev/null
mv _posts/2025-01-03-estimate-software-development.md _leadership/ 2>/dev/null
mv _posts/2024-11-10-metting.md _leadership/ 2>/dev/null
mv _experiences/2024-10-30-case-study.md _leadership/ 2>/dev/null
mv _experiences/2024-11-21-oar-model.md _leadership/ 2>/dev/null

# Di chuyển file Learning
echo "📚 Di chuyển file Learning..."
mv _posts/2024-10-30-developer.md _learning/ 2>/dev/null
mv _posts/2024-12-6-great-software-developer.md _learning/ 2>/dev/null
mv _posts/2025-01-31-flutter-lifecycle.md _learning/ 2>/dev/null
mv _posts/2025-01-31-flutter-roadmap.md _learning/ 2>/dev/null
mv _experiences/2024-10-26-takenote.md _learning/ 2>/dev/null
mv _experiences/2024-11-27-ielts-speaking.md _learning/ 2>/dev/null
mv _experiences/2024-5-31-engish-grammar-diagram.md _learning/ 2>/dev/null
mv _experiences/2025-1-19-english-documents.md _learning/ 2>/dev/null

# Di chuyển file Communication
echo "💬 Di chuyển file Communication..."
mv _experiences/2024-10-25-communication-framework.md _communication/ 2>/dev/null
mv _experiences/2024-11-20-pyramid-principle.md _communication/ 2>/dev/null
mv _experiences/2024-11-20-sbi.md _communication/ 2>/dev/null
mv _experiences/2024-11-20-speaking.md _communication/ 2>/dev/null
mv _experiences/2024-11-21-johari.md _communication/ 2>/dev/null

# Cập nhật categories trong các file
echo "✏️ Cập nhật front matter..."

# Function để cập nhật category
update_category() {
    local dir=$1
    local category=$2
    
    for file in "$dir"/*.md; do
        if [ -f "$file" ]; then
            # Kiểm tra nếu file đã có categories
            if grep -q "^categories:" "$file"; then
                # Thay thế categories cũ
                sed -i '' "s/^categories:.*/categories: $category/" "$file"
            else
                # Thêm categories sau date
                sed -i '' "/^date:/a\\
categories: $category
" "$file"
            fi
        fi
    done
}

# Cập nhật từng collection
update_category "_development" "development"
update_category "_architecture" "architecture"
update_category "_leadership" "leadership"
update_category "_learning" "learning"
update_category "_communication" "communication"

# Liệt kê các file còn lại trong _posts và _experiences
echo ""
echo "📋 Các file còn lại trong _posts:"
ls -la _posts/ 2>/dev/null | grep "\.md$" || echo "  (trống)"

echo ""
echo "📋 Các file còn lại trong _experiences:"
ls -la _experiences/ 2>/dev/null | grep "\.md$" || echo "  (trống)"

echo ""
echo "✅ Hoàn thành! Cấu trúc mới:"
echo "  📁 _development: $(ls -1 _development/*.md 2>/dev/null | wc -l) files"
echo "  📁 _architecture: $(ls -1 _architecture/*.md 2>/dev/null | wc -l) files"
echo "  📁 _vue: $(ls -1 _vue/*.md 2>/dev/null | wc -l) files"
echo "  📁 _communication: $(ls -1 _communication/*.md 2>/dev/null | wc -l) files"
echo "  📁 _leadership: $(ls -1 _leadership/*.md 2>/dev/null | wc -l) files"
echo "  📁 _learning: $(ls -1 _learning/*.md 2>/dev/null | wc -l) files"
echo ""
echo "⚠️ Lưu ý: Hãy kiểm tra lại các file còn lại trong _posts và _experiences"
echo "   để quyết định xóa hoặc di chuyển. File search.md đã được giữ lại."
