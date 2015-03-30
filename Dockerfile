FROM gliderlabs/alpine:3.1
MAINTAINER kgorskowski@codemonauts.com
RUN apk-install \
      python  \
      py-pip \
      build-base \
      curl
RUN pip install awscli
ADD sync.sh /
CMD ["/bin/sh","sync.sh"]
