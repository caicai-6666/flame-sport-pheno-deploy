FROM mysql:8.4

ENV TZ=Asia/Shanghai

RUN set -eux; \
    { \
        echo '[mysqld]'; \
        echo 'character-set-server=utf8mb4'; \
        echo 'collation-server=utf8mb4_unicode_ci'; \
        echo 'default-time-zone=+08:00'; \
        echo ''; \
        echo '[client]'; \
        echo 'default-character-set=utf8mb4'; \
    } > /etc/mysql/conf.d/dev.cnf

# 数据卷首次为空时，MySQL 官方入口会按文件名顺序执行此目录的脚本。
COPY init/ /docker-entrypoint-initdb.d/

EXPOSE 3306

HEALTHCHECK --interval=10s --timeout=5s --start-period=20s --retries=10 \
  CMD mysqladmin ping -h 127.0.0.1 -uroot -p"$MYSQL_ROOT_PASSWORD" --silent || exit 1
