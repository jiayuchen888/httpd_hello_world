FROM registry.access.redhat.com/ubi8/ubi:8.5-239.1651231664

LABEL name="httpd-24" \
      io.openshift.expose-services="8080:http,8443:https" \
      io.openshift.tags="httpd24-jtest"

ENV DOCROOT=/var/www/html

EXPOSE 8080
EXPOSE 8443

RUN yum install -y httpd && \
    yum -y clean all && \
    echo "Hello from SRE1" > ${DOCROOT}/index.html  

RUN sed -i "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf && \
    sed -i "s/#ServerName www.example.com:80/ServerName 0.0.0.0:8080/g" /etc/httpd/conf/httpd.conf && \
    chgrp -R 0 /var/run/httpd /var/log/httpd && \
    chmod -R g=u /var/run/httpd /var/log/httpd

USER 1001

CMD ["/usr/sbin/httpd","-D","FOREGROUND"]
