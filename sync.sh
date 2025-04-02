#!/bin/bash

# 解析 auths.yaml 并登录到每个 registry
for auth in $(yq e '.auths[] | {domain: .domain, username: .username, password: .password}' auths.yaml -o=json); do
    domain=$(echo $auth | jq -r '.domain')
    username=$(echo $auth | jq -r '.username')
    password=$(echo $auth | jq -r '.password')

    echo "Logging into $domain as $username"
    echo "$password" | skopeo login --username "$username" --password-stdin "$domain"
done

# 解析 images.yaml 并同步镜像
for image in $(yq e '.images[] | {source: .source, target: .target}' images.yaml -o=json); do
    source=$(echo $image | jq -r '.source')
    target=$(echo $image | jq -r '.target')

    echo "Syncing image from $source to $target"
    skopeo sync --src docker --dest docker "$source" "$target"
done