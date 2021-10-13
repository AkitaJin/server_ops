#DirectoryName=$(date +%Y%m%d) 
#/usr/lib/postgresql/12/bin/pg_dump -p 5432 -U postgres -d postgres > /home/zhny/backups/db_${DirectoryName}.sql

/usr/lib/postgresql/12/bin/pg_dump -p 5432 -U postgres -d postgres > /home/zhny/backups/db_bak.sql
