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

# 循环处理每个主机
for host in "${HOSTS[@]}"; do
  echo "----------------------------------------"
  echo "处理主机: $host"
  
  # 执行更新、升级并重启
  echo "正在更新 $host 并准备重启..."
  ssh "$host" "
    echo '更新包索引...' &&
    sudo apt update -y &&
    echo '升级系统包...' &&
    sudo apt upgrade -y &&
    echo '清理不需要的包...' &&
    sudo apt autoremove -y &&
    sudo apt autoclean &&
    echo '准备重启 $host...' &&
    sudo reboot
  "
  
  # 检查SSH命令是否成功执行
  if [ $? -eq 0 ]; then
    echo "$host 已启动更新流程并将重启"
  else
    echo "$host 操作失败失败"
  fi
  
  # 等待主机开始重启（可根据需要调整时间）
  echo "等待等待 $host 重启..."
  sleep 10
done

echo "----------------------------------------"
echo "所有主机处理命令已发送完毕"
echo "注意：主机重启需要时间，请稍后检查各主机状态"
