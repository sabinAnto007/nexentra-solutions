# Nexentra Solutions — company website
#
# The site is static: one index.html plus a favicon, no build step and no
# dependencies. So there is nothing to compile — this is a single stage that
# copies the files into nginx.

FROM nginx:1.27-alpine

LABEL org.opencontainers.image.title="nexentra-site" \
      org.opencontainers.image.description="Nexentra Solutions company website" \
      org.opencontainers.image.source="https://github.com/sabinAnto007/nexentra-solutions" \
      org.opencontainers.image.licenses="UNLICENSED"

RUN rm -f /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/site.conf

COPY index.html          /usr/share/nginx/html/index.html
COPY logistics-erp.html  /usr/share/nginx/html/logistics-erp.html
COPY favicon.svg         /usr/share/nginx/html/favicon.svg
COPY og-image.png        /usr/share/nginx/html/og-image.png

# port 8080 so the container can run as a non-root user; binding 80 would
# need root, and the stock nginx image already ships an unprivileged `nginx`
# user with write access to the cache and pid paths it needs
RUN chown -R nginx:nginx /usr/share/nginx/html /var/cache/nginx \
 && touch /var/run/nginx.pid && chown nginx:nginx /var/run/nginx.pid
USER nginx

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/healthz || exit 1

CMD ["nginx", "-g", "daemon off;"]
