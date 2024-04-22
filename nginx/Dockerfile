FROM rocky-openstack

COPY nginx/openstack.conf /etc/nginx/conf.d/

# Service port
EXPOSE 8080

# Add scripts
COPY nginx/healthy.sh nginx/startup.sh ./openstack.env /
RUN chmod +x /healthy.sh /startup.sh
CMD ["/startup.sh"]
