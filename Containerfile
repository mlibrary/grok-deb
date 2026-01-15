FROM debian:latest

RUN apt-get update
RUN apt-get install --yes --no-install-recommends git build-essential cmake doxygen ruby libimage-exiftool-perl libjpeg62-turbo-dev liblcms2-dev libtiff-dev libpng-dev pkgconf
RUN gem install fpm -v 1.17.0
WORKDIR /src
