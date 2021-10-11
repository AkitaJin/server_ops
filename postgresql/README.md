# 配置

| 参数            | 内容          |
| --------------- | ------------- |
| 版本            | 12            |
| 用户1           | postgres      |
| 用户1密码       | zhny_qre      |
| 测试用户        | jin           |
| 测试用户密码    | 123123        |
| pgAdmin用户     | zhny@aiit.com |
| pgAdmin用户密码 | 123123        |



# 安装步骤

1. 更新服务器和组件

```bash
sudo apt update
sudo apt -y install vim bash-completion wget
sudo apt -y upgrade
sudo reboot
```

2. 安装postgresql

```bash
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt -y install postgresql-12 postgresql-client-12
```

3. 启动postgresql

```bash
#mkdir /var/run/postgresql
sudo chown zhny -R /var/run/postgresql
whereis postgresql
#cd /usr/lib/postgresql/12/bin
/usr/lib/postgresql/12/bin/initdb -D /var/postgresql/data
/usr/lib/postgresql/12/bin/pg_ctl -D /var/postgresql/data -l /var/postgresql/log start
```

4. 检查

```bash
postgres@zhny:/etc/postgresql$ systemctl status postgresql.service
● postgresql.service - PostgreSQL RDBMS
   Loaded: loaded (/lib/systemd/system/postgresql.service; enabled; vendor preset: enabled)
   Active: active (exited) since Mon 2021-10-11 14:22:33 CST; 4min 54s ago
  Process: 16455 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
 Main PID: 16455 (code=exited, status=0/SUCCESS)
postgres@zhny:/etc/postgresql$ systemctl status postgresql@12-main.service
● postgresql@12-main.service - PostgreSQL Cluster 12-main
   Loaded: loaded (/lib/systemd/system/postgresql@.service; indirect; vendor preset: enabled)
   Active: active (running) since Mon 2021-10-11 14:22:33 CST; 4min 57s ago
  Process: 16408 ExecStop=/usr/bin/pg_ctlcluster --skip-systemctl-redirect -m fast 12-main stop (code=exited, status=0/SUCCESS)
  Process: 16412 ExecStart=/usr/bin/pg_ctlcluster --skip-systemctl-redirect 12-main start (code=exited, status=0/SUCCESS)
 Main PID: 16417 (postgres)
    Tasks: 20 (limit: 4915)
   CGroup: /system.slice/system-postgresql.slice/postgresql@12-main.service
           ├─16417 /usr/lib/postgresql/12/bin/postgres -D /var/lib/postgresql/12/main -c config_file=/etc/postgresql/12/main/postgresql.conf
           ├─16419 postgres: 12/main: checkpointer
           ├─16420 postgres: 12/main: background writer
           ├─16421 postgres: 12/main: walwriter
           ├─16422 postgres: 12/main: autovacuum launcher
           ├─16423 postgres: 12/main: stats collector
           ├─16424 postgres: 12/main: logical replication launcher
           ├─16467 postgres: 12/main: postgres postgres 192.168.51.93(55072) idle
           ├─16468 postgres: 12/main: postgres postgres 192.168.51.93(55074) idle
           ├─16469 postgres: 12/main: postgres postgres 192.168.51.93(55076) idle
           ├─16470 postgres: 12/main: postgres postgres 192.168.51.93(55078) idle
           ├─16471 postgres: 12/main: postgres postgres 192.168.51.93(55080) idle
           ├─16472 postgres: 12/main: postgres postgres 192.168.51.93(55082) idle
           ├─16473 postgres: 12/main: postgres postgres 192.168.51.93(55084) idle
           ├─16474 postgres: 12/main: postgres postgres 192.168.51.93(55086) idle
           ├─16475 postgres: 12/main: postgres postgres 192.168.51.93(55088) idle
           ├─16476 postgres: 12/main: postgres postgres 192.168.51.93(55090) idle
           ├─19004 postgres: 12/main: jin testdb 10.250.250.2(61778) idle
           ├─19012 postgres: 12/main: jin testdb 10.250.250.2(61780) idle
           └─19309 postgres: 12/main: postgres postgres 10.250.250.2(63106) idle
postgres@zhny:/etc/postgresql$ systemctl is-enabled postgresql
enabled
```

4. 修改pg账号密码

切换用户

```bash
sudo su - postgres
```

修改随机密码

```bash
psql -c "alter user postgres with password 'StrongAdminP@ssw0rd'"
```

5. 修改pg远程访问设置


      1. 修改文件**postgresql.conf**
    
               1. #listen_addresses='localhost' 改为 listen_addresses='*'
      2. 修改文件**pg_hba.conf**
    
               1. 文档末尾加上：host	all 	all	0.0.0.0	md5

6. 重启服务

```bash
zhny@zhny:/etc/postgresql/12/main$ systemctl restart postgresql
[....] Restarting postgresql (via systemctl): postgresql.service==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
Authentication is required to restart 'postgresql.service'.
Authenticating as: zhny
Password:
==== AUTHENTICATION COMPLETE ===
. ok
```

7. 检查和测试

```bash
postgres=# \conninfo
You are connected to database "postgres" as user "postgres" via socket in "/var/run/postgresql" at port "5432".
postgres=# CREATE DATABASE testdb;
CREATE DATABASE
postgres=# CREATE USER mytestuser WITH ENCRYPTED PASSWORD 'MyStr0ngP@SS';
CREATE ROLE
postgres=# CREATE USER jin WITH ENCRYPTED PASSWORD '123123';
CREATE ROLE
postgres=# GRANT ALL PRIVILEGES ON DATABASE testdb to jin;
GRANT
```

8. 测试数据库

```sql
postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf-8 | en_US.utf-8 |
 template0 | postgres | UTF8     | en_US.utf-8 | en_US.utf-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf-8 | en_US.utf-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 testdb    | postgres | UTF8     | en_US.utf-8 | en_US.utf-8 | =Tc/postgres         +
           |          |          |             |             | postgres=CTc/postgres+
           |          |          |             |             | jin=CTc/postgres
(4 rows)

postgres=# \c testdb
You are now connected to database "testdb" as user "postgres".

```

9. 远程登录测试

![image-20211011142957528](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20211011142957528.png)

## 问题1

5432端口被占用

```bash
zhny@zhny:/usr/lib/postgresql/12/bin$ ./pg_ctl -D /var/postgresql/data start
waiting for server to start....2021-10-11 09:58:04.528 CST [18458] LOG:  starting PostgreSQL 12.8 (Ubuntu 12.8-1.pgdg18.04+1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0, 64-bit

2021-10-11 09:58:04.529 CST [18458] LOG:  could not bind IPv4 address "127.0.0.1": Address already in use

2021-10-11 09:58:04.529 CST [18458] HINT:  Is another postmaster already running on port 5432? If not, wait a few seconds and retry.

2021-10-11 09:58:04.529 CST [18458] WARNING:  could not create listen socket for "localhost"

2021-10-11 09:58:04.529 CST [18458] FATAL:  could not create any TCP/IP sockets

2021-10-11 09:58:04.529 CST [18458] LOG:  database system is shut down
```

解决：

```bash
zhny@zhny:/usr/lib/postgresql/12/bin$ sudo lsof -i:5432
[sudo] password for zhny:
COMMAND    PID     USER   FD   TYPE   DEVICE SIZE/OFF NODE NAME
postgres 23264 postgres    7u  IPv4 11701395      0t0  TCP localhost:postgresql (LISTEN)
zhny@zhny:/usr/lib/postgresql/12/bin$ kill -9 23264
-bash: kill: (23264) - Operation not permitted
zhny@zhny:/usr/lib/postgresql/12/bin$ sudo kill -9 23264
```

# 常用操作

## 切换到服务器的pg用户

```bash
sudo su - postgres
```

## 删除所有相关组件

```none
sudo apt-get --purge remove postgresql\*
sudo rm -r /etc/postgresql
sudo rm -r /etc/postgresql-common
sudo rm -r /var/lib/postgresql
```

##  查询相关进程

```bash
ps -ef | grep postgres
```

## 服务

### 启动

```bash
/usr/lib/postgresql/12/bin/pg_ctl -D /var/postgresql/data -l /var/postgresql/log start
```

### 重启

```bash
service postgresql restart
```

https://computingforgeeks.com/install-postgresql-12-on-ubuntu/

