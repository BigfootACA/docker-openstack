FROM rocky-openstack

# Data volume
VOLUME [ "/var/lib/glance" ]

# Service port
EXPOSE 9292

# Add scripts
COPY config /config
COPY glance/healthy.sh glance/startup.sh glance/config.sh config/openstack.env config/openstack.pw.env ./admin-rc /
RUN chmod +x /healthy.sh /startup.sh /config.sh
RUN chmod 0600 /openstack.pw.env
RUN /config.sh
CMD ["/startup.sh"]
