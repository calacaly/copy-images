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