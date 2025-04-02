#!/bin/bash

# 解析 auths.yaml 并登录到每个 registry
for auth in $(yq e '.auths | to_entries[] | [.key, .value.username, .value.password]' auths.yaml -o=json | jq -c '.'); do
    domain=$(echo $auth | jq -r '.[0]')
    username=$(echo $auth | jq -r '.[1]')
    password=$(echo $auth | jq -r '.[2]')
    
    echo "Logging into $domain as $username"
    echo "$password" | skopeo login --username "$username" --password-stdin "$domain"
done

# 解析 images.yaml 并同步镜像
for image in $(yq e '.images | to_entries[] | [.key, .value.source, .value.target]' images.yaml -o=json | jq -c '.'); do
    name=$(echo $image | jq -r '.[0]')
    source=$(echo $image | jq -r '.[1]')
    target=$(echo $image | jq -r '.[2]')
    
    echo "Syncing image $name from $source to $target"
    skopeo sync --src docker --dest docker "$source" "$target"
done