# 博客系统使用指南

这个博客系统支持从Git提交历史中获取文件时间，并自动展示在时间线上。

## 功能特点

1. 自动从`blog`目录读取Markdown文件
2. 从Git提交历史中获取文件的实际提交时间
3. 按时间顺序展示文章列表
4. 支持Markdown渲染
5. 响应式设计，适配移动设备

## 文件结构

```
├── index.html              # 主页面
├── blog/                   # 博客文章目录
│   ├── docker.md          # 示例文章
│   └── files-info.json    # 文件信息（包含Git提交时间）
├── generate-blog-info.sh   # 生成文件信息脚本
├── update-blog-info.sh     # 更新文件信息脚本
└── pre-commit.sh          # Git钩子脚本
```

## 如何添加新文章

1. 在`blog`目录中创建新的Markdown文件（.md扩展名）
2. 文件第一行应该是文章标题（使用# 标题格式）
3. 运行`./update-blog-info.sh`更新文件信息
4. 提交更改到Git仓库

## 自动化更新

### 方法1：手动更新
```bash
./update-blog-info.sh
git add blog/files-info.json
git commit -m "更新博客文件信息"
```

### 方法2：使用Git钩子（推荐）
1. 将`pre-commit.sh`复制到`.git/hooks/`目录：
```bash
cp pre-commit.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

2. 现在，每次提交前，系统会自动检查是否有博客文件被修改，如果有，会自动更新`files-info.json`

## 文件信息格式

`blog/files-info.json`文件包含每个博客文章的Git提交时间：

```json
[
  {
    "name": "docker.md",
    "createdTime": "2025-11-08T13:14:29+08:00",
    "modifiedTime": "2025-11-08T13:14:29+08:00"
  }
]
```

## 注意事项

1. 确保所有博客文件都是有效的Markdown格式
2. 文章标题应该使用一级标题（# 标题）
3. 如果没有Git提交历史，系统将使用文件修改时间
4. 在GitHub Pages上部署时，确保`files-info.json`文件是最新的

## 故障排除

如果文章时间不正确：
1. 运行`./update-blog-info.sh`手动更新文件信息
2. 检查Git仓库是否有提交历史
3. 确认`blog/files-info.json`文件存在且格式正确