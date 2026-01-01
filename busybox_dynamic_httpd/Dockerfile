ARG BUSYBOX_VERSION=1.37.0

ARG BUSYBOX_IMAGE=busybox:${BUSYBOX_VERSION}-uclibc

FROM ${BUSYBOX_IMAGE}

# Create web root
WORKDIR /www

# Copy script
COPY index.sh /index.sh

# Make it executable
RUN chmod +x /index.sh

# Expose port (documentation only, Compose will map it)
EXPOSE 3000

# Generate index.html, then start httpd
CMD sh -c "/index.sh && exec busybox httpd -f -v -p 3000"
