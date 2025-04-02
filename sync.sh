#!/bin/bash
set -e  # 确保脚本遇到错误时立即退出
set -x

# 解析 auths.yaml 并登录到每个 registry
length=$(yq '.auths | length' auths.yaml)
for ((i = 0; i < length; i++)); do
    username_key=$(yq ".auths[$i].username" auths.yaml)
    password_key=$(yq ".auths[$i].password" auths.yaml)
    username=$(echo "${!username_key}" | base64 -d)
    password=$(echo "${!password_key}" | base64 -d)
    domain=$(yq ".auths[$i].domain" auths.yaml)
    if [[ -z "$username" || -z "$password" ]]; then
        echo "Error: Could not find credentials for domain $domain"
        exit 1
    fi

    echo "Logging into $domain as $username"
    #echo "$password" | skopeo login --username "$username" --password-stdin "$domain"
done


# 解析 images.yaml 并同步镜像`
length=$(yq '.auths | length' auths.yaml)
for ((i = 0; i < length; i++)); do
    source=$(yq ".images[$i].source" images.yaml)
    target=$(yq ".images[$i].target" images.yaml)
    echo "Syncing image from $source to $target"
    skopeo sync --src docker --dest docker "$source" "$target"
done