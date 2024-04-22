FROM rocky-openstack

# Edit configs
RUN rm -f /etc/httpd/conf.d/*
COPY horizon/settings.py /etc/openstack-dashboard/local_settings
COPY horizon/dashboard.conf /etc/httpd/conf.d/dashboard.conf
RUN ln -s zh_Hans /usr/share/openstack-dashboard/openstack_dashboard/locale/zh
RUN ln -s zh_Hans /usr/share/openstack-dashboard/openstack_dashboard/locale/zh_hans

# Service port
EXPOSE 8989

# Add scripts
COPY horizon/healthy.sh horizon/startup.sh config/openstack.env config/openstack.pw.env /
RUN chmod +x /healthy.sh /startup.sh
RUN chmod 0600 /openstack.pw.env
CMD ["/startup.sh"]
