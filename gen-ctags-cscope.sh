#!/bin/bash
set -e  # 遇到错误立即退出，避免生成不完整索引

# 脚本功能：一键生成 ctags 标签 + cscope 索引（处理软链接、去重、排除无用文件）
echo "========================================"
echo "开始生成 ctags + cscope 索引..."
echo "当前目录：$(pwd)"
echo "========================================"

# 步骤1：生成过滤后的文件列表（cscope.files）
# 功能：递归查找 .c/.h 文件 + 解析软链接真实路径 + 排除编译产物 + 去重
#!/bin/bash

# 脚本功能：生成cscope.files，解析软链接的真实文件路径并去重
echo "开始生成 cscope.files..."

# 查找所有 .c 和 .h 文件（包括软链接），解析真实路径并去重
if [ -f "cscope.files" ] && [ -s "cscope.files" ]; then
    echo "1. 复用已有 cscope.files（共 $(wc -l < cscope.files) 个文件）..."
else
    echo "1. 生成过滤后的文件列表（处理软链接/排除无用文件）..."
    find . \( -name "*.c" -o -name "*.h" \) -exec bash -c '
    file="{}"
    # 判断是否为软链接
    if [ -L "$file" ]; then
        # 解析软链接的真实绝对路径
        real_path=$(readlink -f "$file")
        echo "$real_path"
    else
        # 普通文件直接输出路径
        echo "$file"
    fi
' \; | sort -u > cscope.files

    echo "   生成完成：cscope.files 共 $(wc -l < cscope.files) 个文件"
fi

#echo "cscope.files 生成完成！共收录 $(wc -l < cscope.files) 个文件路径。"

# 步骤2：生成 ctags 标签文件（支持函数/变量/宏定义跳转）
echo "2. 生成 ctags 标签文件（tags）..."
ctags -R --exclude='*.o' --exclude='*.ko' --exclude='*.mod.c' .

# 步骤3：生成 cscope 索引数据库（支持交叉引用查询）
echo "3. 生成 cscope 索引数据库（cscope.out 等）..."
cscope -Rbq -i cscope.files

# 步骤4：输出结果统计
tags_count=$(wc -l < tags 2>/dev/null || echo 0)
files_count=$(wc -l < cscope.files 2>/dev/null || echo 0)
echo "========================================"
echo "索引生成完成！"
echo "----------------------------------------"
echo "生成的文件："
echo "  - cscope.files：过滤后的文件列表（共 $files_count 个文件）"
echo "  - tags：ctags 标签文件（共 $tags_count 个标签）"
echo "  - cscope.out：cscope 主索引文件"
echo "  - cscope.in.out + cscope.po.out：快速查询文件"
echo "----------------------------------------"
echo "使用说明："
echo "  1. CTags 跳转：光标在函数/变量上按 Ctrl+] 跳转到定义，Ctrl+t 回退到原位置"
echo "  2. CScope 交叉引用：按 Ctrl+\\ + g（定义）、c（调用）、s（符号）、t（字符串）等触发查询"
echo "  3. 分屏/窗口切换：Ctrl+w - 水平分屏，Ctrl+w \\ 垂直分屏；Ctrl+h/j/k/l 切换左右上下窗口"
echo "  4. 代码折叠：za 切换当前块折叠状态，zR 全部展开，zM 全部折叠"
echo "  5. 插件功能：F3 切换 NERDTree 目录树；\\ + g 触发全局高亮搜索（ag.vim）；airline 显示状态栏信息"
echo "========================================"
