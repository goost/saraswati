FROM nestybox/alpine-docker

COPY entrypoint.sh /usr/bin
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "sh" ]