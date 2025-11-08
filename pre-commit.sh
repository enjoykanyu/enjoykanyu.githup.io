#!/bin/bash

# Git pre-commit hook
# 在每次提交前自动更新博客文件信息

echo "正在运行pre-commit钩子，更新博客文件信息..."

# 检查是否有博客文件被修改
if git diff --cached --name-only | grep -q "^blog/.*\.md$"; then
    echo "检测到博客文件修改，正在更新文件信息..."
    
    # 运行更新脚本
    ./update-blog-info.sh
    
    # 添加更新后的files-info.json到暂存区
    git add blog/files-info.json
    
    echo "博客文件信息已更新并添加到暂存区"
fi

# 继续提交过程
exit 0