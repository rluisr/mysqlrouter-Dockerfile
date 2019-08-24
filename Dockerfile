FROM oraclelinux:7-slim

ARG MYSQL_SERVER_PACKAGE=mysql-community-server-minimal-8.0.17
ARG MYSQL_ROUTER_PACKAGE=mysql-router-community-8.0.17

RUN yum install -y https://repo.mysql.com/mysql-community-minimal-release-el7.rpm \
      https://repo.mysql.com/mysql-community-release-el7.rpm \
  && yum-config-manager --enable mysql80-server-minimal \
  && yum-config-manager --enable mysql-tools-community \
  && yum install -y \
      $MYSQL_SERVER_PACKAGE \
      $MYSQL_ROUTER_PACKAGE \
      libpwquality \
  && yum clean all

COPY run.sh /run.sh
HEALTHCHECK \
        CMD mysqladmin --port 6446 --protocol TCP ping 2>&1 | grep Access || exit 1
EXPOSE 6446 6447 64460 64470
ENTRYPOINT ["/run.sh"]
CMD ["mysqlrouter"]
