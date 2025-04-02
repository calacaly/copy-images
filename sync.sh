#!/bin/bash
set -e  # 确保脚本遇到错误时立即退出

# 解析 auths.yaml 并登录到每个 registry
for auth_entry in $(yq e '.auths[]' auths.yaml -o=json); do
    domain=$(echo "$auth_entry" | jq -r '.domain')
    username_secret=$(echo "$auth_entry" | jq -r '.username_secret')
    password_secret=$(echo "$auth_entry" | jq -r '.password_secret')

    username=${!username_secret}
    password=${!password_secret}

    if [[ -z "$username" || -z "$password" ]]; then
        echo "Error: Could not find credentials for domain $domain"
        exit 1
    fi

    echo "Logging into $domain as $username"
    echo "$password" | skopeo login --username "$username" --password-stdin "$domain"
done

# 解析 images.yaml 并同步镜像
for image_entry in $(yq e '.images[]' images.yaml -o=json); do
    source=$(echo "$image_entry" | jq -r '.source')
    target=$(echo "$image_entry" | jq -r '.target')

    echo "Syncing image from $source to $target"
    skopeo sync --src docker --dest docker "$source" "$target"
done