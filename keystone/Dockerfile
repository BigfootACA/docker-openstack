FROM rocky-openstack

# Data volume
VOLUME [ "/var/lib/keystone" ]

RUN rm -f /etc/httpd/conf.d/*
COPY keystone/wsgi-keystone.conf /etc/httpd/conf.d/wsgi-keystone.conf

# Service port
EXPOSE 5000

# Add scripts
COPY keystone/healthy.sh keystone/startup.sh keystone/config.sh ./openstack.env ./openstack.pw.env /
RUN chmod +x /healthy.sh /startup.sh /config.sh
RUN chmod 0600 /openstack.pw.env
RUN /config.sh
CMD ["/startup.sh"]
