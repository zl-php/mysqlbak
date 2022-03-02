# mysql备份脚本

使用方法
配置
修改 `backup.conf`，中的数据库连接配置和备份配置。

设置crontab 
```
crontab -e
```
增加以下命令将在每天凌晨1点执行一次
```
0 1 * * * /bin/bash /path/mysqlbak/mysqlbak.sh >> /path/mysqlbak/crontab.log
```
