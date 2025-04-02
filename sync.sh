#!/bin/bash
set -e  # 确保脚本遇到错误时立即退出

# 解析 auths.yaml 并登录到每个 registry
while IFS= read -r line; do
    domain=$(echo "$line" | yq e '.domain' -)
    username=$(echo "$line" | yq e '.username' -)
    password=$(echo "$line" | yq e '.password' -)

    echo "Logging into $domain as $username"
    echo "$password" | skopeo login --username "$username" --password-stdin "$domain"
done < <(yq e '.auths[]' auths.yaml)

# 解析 images.yaml 并同步镜像
while IFS= read -r line; do
    source=$(echo "$line" | yq e '.source' -)
    target=$(echo "$line" | yq e '.target' -)

    echo "Syncing image from $source to $target"
    skopeo sync --src docker --dest docker "$source" "$target"
done < <(yq e '.images[]' images.yaml)