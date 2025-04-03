# copy-images

原理：白嫖github workflows的外网服务器运行脚本来搬运镜像到其他仓库（如从docker.io等国内无法访问的镜像仓库搬运到阿里云等个人免费仓库），推送到其他仓库时需要的账号密码可安全配置（依赖github的secrets）。

# 使用方法

fork为自己的仓库

## 设置仓库secrets

settings > Security > Secrets and variables > Actions > Secrets > Repository secrets > New repository secrets

可以是aliyun的镜像仓库登录名和密码，名称要和auths.yaml和.github/workflows/actions.yaml中Copy steps的env要匹配。

## 修改workflows

在auths.yaml中配置在项目中的repository和secrets名称，并同理修改.github/workflows/actions.yaml中Copy steps的env

## 更新镜像要搬运的镜像

更新images.yaml（或者参考推荐使用方式来生成images.yaml）中需要搬运的镜像，然后提交，如果修改了任何copy.sh，images.yaml，auths.yaml，actions.yaml，txt文件，提交的时候都会触发workflows执行。

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

# 推荐使用方式

项目中如果存在txt文件，推送到github的时候，copy.sh会遍历所有的txt文件，添加镜像到images.yaml。

需要配置@replace=xxx（只识别第一条），那么示例中docker.io/library/nginx:latest会替换为registry.cn-shanghai.aliyuncs.com/calacaly/nginx:latest

```textile
# images.txt
# @replace=registry.cn-shanghai.aliyuncs.com/calacaly
docker.io/library/nginx:latest
nginx:alpine
```
# 其他
## 获取helm镜像列表
示例
```bash
helm template rabbitmq ./rabbitmq | grep "image: " | awk -F 'image: ' '{print $2}' | awk '!seen[$0]++'
```
