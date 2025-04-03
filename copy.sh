#!/bin/bash
set -e  # 确保脚本遇到错误时立即退出

# 解析 auths.yaml 并登录到每个 registry
length=$(yq '. | length' auths.yaml)
for ((i = 0; i < length; i++)); do
    username_key=$(yq ".[$i].username" auths.yaml)
    password_key=$(yq ".[$i].password" auths.yaml)
    username=${!username_key}
    password=${!password_key}
    repository=$(yq ".[$i].repository" auths.yaml)
    if [[ -z "$username" || -z "$password" ]]; then
        echo "Error: Could not find credentials for repository $repository"
        exit 1
    fi

    echo "Logging into $repository as $username"
    echo "$password" | skopeo login --username "$username" --password-stdin "$repository"
done

# 遍历当前目录下的所有 .txt 文件, 执行tools.sh
find . -type f -name "*.txt" | while IFS= read -r file; do
    replace=$(cat "$file" | grep "^#" | grep -m 1 "@replace=" | awk -F '@replace=' '{print $2}')
    if [ -z "$repository" ]; then
        echo "Error: Could not find replace in $file"
        continue
    fi
    cat "$file" | grep -v "^#" | bash tools.sh to_images $replace --suffix
done
cat images.yaml


# 解析 images.yaml 并复制镜像`
length=$(yq '. | length' images.yaml)
for ((i = 0; i < length; i++)); do
    source=$(yq ".[$i].source" images.yaml)
    target=$(yq ".[$i].target" images.yaml)
    echo "Copy image from $source to $target"
    skopeo copy docker://$source docker://$target
done