#!/bin/bash

# 自动更新博客文件信息脚本
# 在每次提交前运行此脚本，更新files-info.json文件

echo "正在更新博客文件信息..."

# 创建备份（如果文件存在）
if [ -f "blog/files-info.json" ]; then
    cp blog/files-info.json blog/files-info.json.bak
fi

# 创建博客文件信息JSON
echo "[" > blog/files-info.json

# 获取所有.md文件
first=true
for file in blog/*.md; do
  if [ -f "$file" ]; then
    # 获取文件名
    filename=$(basename "$file")
    
    # 获取Git提交时间（Unix时间戳）
    git_time=$(git log -1 --format="%ct" "$file" 2>/dev/null)
    
    # 如果没有Git时间，使用文件修改时间
    if [ -z "$git_time" ]; then
      git_time=$(stat -f "%m" "$file" 2>/dev/null)
    fi
    
    # 如果仍然没有时间，使用当前时间
    if [ -z "$git_time" ]; then
      git_time=$(date +%s)
    fi
    
    # 转换为ISO格式
    iso_time=$(date -r "$git_time" -Iseconds)
    
    # 添加逗号（除了第一个文件）
    if [ "$first" = false ]; then
      echo "," >> blog/files-info.json
    else
      first=false
    fi
    
    # 添加文件信息
    echo "  {" >> blog/files-info.json
    echo "    \"name\": \"$filename\"," >> blog/files-info.json
    echo "    \"createdTime\": \"$iso_time\"," >> blog/files-info.json
    echo "    \"modifiedTime\": \"$iso_time\"" >> blog/files-info.json
    echo "  }" >> blog/files-info.json
  fi
done

echo "]" >> blog/files-info.json

# 添加files-info.json到Git（如果需要）
# git add blog/files-info.json

echo "博客文件信息已更新到 blog/files-info.json"
echo "请记得将更新后的文件提交到Git仓库"