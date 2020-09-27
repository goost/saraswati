FROM nestybox/alpine-docker

COPY entrypoint.sh /usr/bin
COPY docker-compose.module.yml /docker-compose.yml
#RUN apk add py-pip python-dev libffi-dev openssl-dev gcc libc-dev make \\
#  && wget "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
RUN wget https://github.com/docker/compose/releases/download/1.27.4/run.sh -O /usr/bin/docker-compose \
  && chmod +x /usr/bin/docker-compose \
  && chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "sh" ]