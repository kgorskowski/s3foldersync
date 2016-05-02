FROM alpine
MAINTAINER kgorskowski@codemonauts.com
RUN apk add --update \
      python  \
      py-pip \
      build-base \
      curl
RUN pip install awscli
ADD sync.sh /
RUN rm -rf /var/cache/apk/* && rm -rf /var/lib/lists/*
CMD ["/bin/sh","sync.sh"]
