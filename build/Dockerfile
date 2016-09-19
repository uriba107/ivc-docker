######################
### BMS IVC server ###
######################
FROM multiarch/alpine:x86-edge
MAINTAINER uri_ba <uri@uriba.org>

LABEL Description="BMS 4.33U1 IVC server" Vendor="Benchmark Sims" Version="4.33.1"

ENV APP_NAME ivc
ENV APP_ROOT /opt
ENV APP_PATH ${APP_ROOT}/${APP_NAME}
## not so maintained image upgrade everything
RUN apk upgrade --no-cache
## Dumb-init
RUN apk add --no-cache -t build-deps gcc curl musl-dev \
 && curl -L https://github.com/Yelp/dumb-init/archive/master.tar.gz | tar -C /tmp -xzf - \
 && gcc -std=gnu99 -s -Wall -Werror -O3 -o /usr/sbin/dumb-init /tmp/dumb-init-master/dumb-init.c \
 && apk del build-deps

## install wine
RUN echo "http://dl-3.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && apk add --no-cache freetype libpng wine

EXPOSE 9987 9988 9989

# configure wine
RUN /usr/bin/wineboot --init

#Move bineries over
WORKDIR /opt
ADD wrapper/launcher.sh /opt


ENTRYPOINT ["/usr/sbin/dumb-init", "--"]
CMD [ "/opt/launcher.sh" ]
