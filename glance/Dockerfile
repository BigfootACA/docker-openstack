FROM rocky-openstack

# Data volume
VOLUME [ "/var/lib/glance" ]

# Service port
EXPOSE 9292

# Add scripts
COPY glance/healthy.sh glance/startup.sh glance/config.sh ./openstack.env ./openstack.pw.env ./admin-rc /
RUN chmod +x /healthy.sh /startup.sh /config.sh
RUN chmod 0600 /openstack.pw.env
RUN /config.sh
CMD ["/startup.sh"]
