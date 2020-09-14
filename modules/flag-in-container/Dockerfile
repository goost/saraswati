FROM nestybox/alpine-docker

COPY builder/Dockerfile /tmp
COPY builder/container-run.sh /usr/bin
COPY entrypoint.sh /usr/bin
RUN chmod +x /usr/bin/container-run.sh \
  && chmod +x /usr/bin/entrypoint.sh \
  && container-run.sh \
  && rm /usr/bin/container-run.sh \
  && rm /tmp/Dockerfile

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "sh" ]