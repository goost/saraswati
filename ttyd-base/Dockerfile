FROM docker

RUN latest_ttyd=$(wget -qO- "https://api.github.com/repos/tsl0922/ttyd/releases/latest" | grep -E 'browser_download_url":\s".*?ttyd_linux.x86_64' | cut -f 2,3 -d ':' | cut -f 2 -d '"') \
  && wget -O /usr/bin/ttyd $latest_ttyd \
  && chmod +x /usr/bin/ttyd

ENTRYPOINT [ "/usr/bin/ttyd", "-p", "4242" ]