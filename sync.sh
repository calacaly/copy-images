# /bin/bash

for auths in $(yq '.auths[]' auths.yaml); do
    username=$(echo $auths | yq '.username')
    password=$(echo $auths | yq '.password')
    domain=$(echo $auths | yq '.domain')
    skopeo login --username $username --password $password $domain
done

for images in $(yq '.images[]' images.yaml); do
    source=$(echo $images | yq '.source')
    target=$(echo $images | yq '.target')
    skopeo sync --src docker --dest docker $source $target
done
