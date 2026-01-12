FROM ${IMAGE:-debian:13}

RUN apt-get update
RUN apt-get install --yes --no-install-recommends build-essential cmake doxygen ruby libimage-exiftool-perl libjpeg62-turbo-dev liblcms2-dev libtiff-dev libpng-dev pkgconf
RUN gem install fpm -v 1.17.0
ADD ./src /src
ENV SOURCE_DATE_EPOCH=${SOURCE_DATE_EPOCH:-0}
RUN mkdir /src/build
WORKDIR /src/build
