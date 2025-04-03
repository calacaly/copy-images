to_images() {
    # $1 target repository/user like registry.cn-shanghai.aliyuncs.com/calacaly
    # $2 --suffix then target image like registry.cn-shanghai.aliyuncs.com/calacaly/nginx
    while IFS= read -r image; do
        suffix=""
        if [ "$2" = "--suffix" ]; then
            # extract suffix
            suffix=$(basename "$image")
        fi
        echo "- source: $image" >> images.yaml
        echo "  target: $1/$suffix" >> images.yaml
    done
}

help() {
    echo "Usage: "
    echo "cat images.txt | grep -v "^#" | tools.sh to_images <target repository/user> [--suffix]"

}

case "$1" in
    to_images)
        to_images $2 $3 $4
        ;;
    *)
        help
        exit 1
        ;;
esac
