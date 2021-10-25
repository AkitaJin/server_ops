# Docker运维手册



示例中的容器名称为**postgres**

进入容器

```shell
sudo docker exec -it postgres bash
```

复制

```shell
sudo docker cp /home/zhny/tmp/localtime postgres:/etc/localtime
```

显示运行中的docker容器

```shell
sudo docker ps
```

查看日志

```shell
sudo docker logs -f --tail 100 postgres
```

查看镜像的元数据

```SH
sudo docker inspect
```

重启

```shell
sudo docker restart postgres
```

