#!/bin/bash

# 定义目标主机列表
HOSTS=(
  "master0"
  "master1"
  "master2"
  "worker0"
  "worker1"
  "worker2"
  "longhorn0"
  "longhorn1"
  "longhorn2"
)

# 定义本地DEB文件路径
LOCAL_DEB="./check-mk-agent_2.4.0p8-1_all.deb"

# 定义远程临时文件路径
REMOTE_TEMP="/tmp/check-mk-agent_2.4.0p8-1_all.deb"

# 循环处理每个主机
for host in "${HOSTS[@]}"; do
  echo "----------------------------------------"
  echo "处理主机: $host"
  
  # 1. 复制DEB文件到远程主机
  echo "正在复制安装包到 $host..."
  scp "$LOCAL_DEB" "$host:$REMOTE_TEMP"
  
  # 检查SCP是否成功
  if [ $? -ne 0 ]; then
    echo "复制到 $host 失败，跳过该主机"
    continue
  fi
  
  # 2. SSH到远程主机并安装
  echo "正在在 $host 上安装Checkmk代理..."
  ssh "$host" "sudo apt install -y $REMOTE_TEMP && rm -f $REMOTE_TEMP"
  
  # 检查安装是否成功
  if [ $? -eq 0 ]; then
    echo "$host 安装成功"
  else
    echo "$host 安装失败"
  fi
done

echo "----------------------------------------"
echo "所有主机处理完毕"