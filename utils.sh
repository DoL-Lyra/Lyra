#!/bin/bash

# 描述: 增强版 cp 命令，支持智能覆盖逻辑（保留目标文件名大小写）
# --------------------------
# 示例用法:
# smart_cp "./src/file.txt" "./dest/"
# smart_cp "./src/file.txt" "./dest/NewFile.txt"
# --------------------------
function smart_cp() {
  local src=$1
  local dst=$2

  # --------------------------
  # 1. 参数校验阶段
  # --------------------------
  # 检查源文件是否存在且为普通文件
  if [[ ! -f "$src" ]]; then
    echo "错误：源文件 '$src' 不存在或不是普通文件" >&2
    return 1
  fi

  # --------------------------
  # 2. 路径解析阶段
  # --------------------------
  local src_basename=${src##*/} # 使用参数扩展获取文件名，避免调用 basename
  local target_path=""

  if [[ -d "$dst" ]]; then
    # 目标为目录：自动拼接目标路径
    dst=${dst%/} # 移除结尾的 / (如果有)
    target_path="$dst/$src_basename"
  else
    # 目标为文件路径：分离目录和文件名
    local target_dir=${dst%/*} # 使用参数扩展获取目录名
    target_path=$dst

    # 创建目标目录（如果不存在）
    if [[ ! -d "$target_dir" ]]; then
      mkdir -p "$target_dir" || return 1
    fi
  fi

  # --------------------------
  # 3. 文件名匹配阶段 (性能优化关键)
  # --------------------------
  local target_dir=${target_path%/*}
  local expected_name=${target_path##*/}
  local expected_name_lc=${expected_name,,} # Bash 4.0+ 小写转换，替代 tr
  local existing_file=""

  # 使用 find 命令避免通配符展开问题（支持超多文件）
  while IFS= read -r -d $'\0' file; do
    # 跳过目录和非文件项
    [[ ! -f "$file" ]] && continue

    local filename=${file##*/}
    local filename_lc=${filename,,}

    if [[ "$filename_lc" == "$expected_name_lc" ]]; then
      existing_file=$file
      break # 找到第一个匹配项即停止
    fi
  done < <(find "$target_dir" -maxdepth 1 -type f -print0 2>/dev/null)

  # --------------------------
  # 4. 文件操作阶段
  # --------------------------
  if [[ -n "$existing_file" ]]; then
    # 情况1: 存在不区分大小写的同名文件
    if [[ "$existing_file" != "$target_path" ]]; then
      # 如果大小写不同，保留目标文件名大小写
      # echo "覆盖并保留文件名大小写: $existing_file"
      cp -vf "$src" "$existing_file"
    else
      # 完全同名直接覆盖
      # echo "直接覆盖: $target_path"
      cp -vf "$src" "$target_path"
    fi
  else
    # 情况2: 无冲突文件，直接复制
    # echo "创建新文件: $target_path"
    cp -vf "$src" "$target_path"
  fi

  return $?
}
