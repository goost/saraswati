FROM docker

# TODO (glost) Latest compose tag
RUN latest_ttyd=$(wget -qO- "https://api.github.com/repos/tsl0922/ttyd/releases/latest" | grep -E 'browser_download_url":\s".*?ttyd_linux.x86_64' | cut -f 2,3 -d ':' | cut -f 2 -d '"') \
  && wget -O /usr/bin/ttyd $latest_ttyd \
  && chmod +x /usr/bin/ttyd \
  && apk -U add py-pip python-dev libffi-dev openssl-dev gcc libc-dev make \
  && wget "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose \
  #&& wget -O /usr/bin/docker-compose "https://github.com/docker/compose/releases/download/1.27.4/run.sh" \
  && chmod +x /usr/bin/docker-compose

ENTRYPOINT [ "/usr/bin/ttyd", "-p", "4242" ]