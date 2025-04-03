# sync-images

利用github workflows来搬运镜像（如从docker.io等国内无法访问的镜像仓库搬运到阿里云的个人免费仓库）

# 使用方法

fork为自己的仓库

## 设置仓库secrets

settings > Security > Secrets and variables > Actions > Secrets > Repository secrets > New repository secrets

可以是aliyun的镜像仓库登录名和密码，名称要和auths.yaml和.github/workflows/actions.yaml中Sync steps的env要匹配。

## 修改workflows

在auths.yaml中配置在项目中的repository和secrets名称，并同理修改.github/workflows/actions.yaml中Sync steps的env

## 更新镜像要搬运的镜像

更新images.yaml中需要搬运的镜像，然后提交到自己的镜像仓库。



# 使用工具脚本生成images.yaml

```bash
# 使用示例 其中registry.cn-shanghai.aliyuncs.com/calacaly可以改为你要搬运的目标仓库地址

cat images.txt | grep -v "#" | bash tools.sh to_images registry.cn-shanghai.aliyuncs.com/calacaly --suffix
```

images.txt就是纯粹的原始镜像列表，可以存在#注释

```textile
# images.txt
docker.io/library/nginx:latest
nginx:alpine
```

## 推荐使用方式

但在项目中如果存在txt文件，推送到github的时候，sync.sh会遍历所有的txt文件，来添加镜像到images.yaml。配置了@replace=xxx（只识别第一条），示例中docker.io/library/nginx:latest会替换为registry.cn-shanghai.aliyuncs.com/calacaly/nginx:latest

```textile
# images.txt
# @replace=registry.cn-shanghai.aliyuncs.com/calacaly
docker.io/library/nginx:latest
nginx:alpin
```