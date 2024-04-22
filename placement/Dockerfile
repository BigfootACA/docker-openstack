FROM rocky-openstack

RUN rm -f /etc/httpd/conf.d/*
COPY placement/placement-api.conf /etc/httpd/conf.d/

# Service port
EXPOSE 8778

# Add scripts
COPY placement/healthy.sh placement/startup.sh placement/config.sh ./openstack.env ./openstack.pw.env /
RUN chmod +x /healthy.sh /startup.sh /config.sh
RUN chmod 0600 /openstack.pw.env
RUN /config.sh
CMD ["/startup.sh"]
