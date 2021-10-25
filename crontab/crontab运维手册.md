# Crontab的维护手册

## 注意

不要单独使用crontab！不要单独使用crontab！不要单独使用crontab！

```bash
$ crontab   #不用使用！
```

使用时必须附上参数

```bash
$ crontab -e
$ crontab -l
```

## 常用指令

### 查看运行日志

```bash
$ tail -f /var/log/cron.log
```



### 查看操作记录日志

进入 **/var/spool/cron** 目录，输入 history 命令回车查看。



### 服务重启

```bash
$ systemctl restart cron #Ubuntu：cron///Centos: crond
$ systemctl restart rsyslog
```





## 参数调整

### 开启日志

```bash
sudo vim /etc/rsyslog.d/50-default.conf

#将cron前面的注释符#去掉

#cron.*    /var/log/cron.log    →    cron.*    /var/log/cron.log
```







