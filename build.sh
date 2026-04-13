#!/bin/sh

set -e

SOURCE_DATE_EPOCH=$(git show --no-patch --format=%ct)
export SOURCE_DATE_EPOCH

if [ -f /etc/os-release ]; then
  . /etc/os-release
  case "$VERSION_CODENAME" in
  bookworm)
    LIBPNG=libpng16-16
    ;;
  trixie)
    LIBPNG=libpng16-16t64
    ;;
  *)
    echo "Don't know how to build package for '$ID $VERSION_CODENAME'" >&2
    exit 1
  esac
else
  echo "Can't find /etc/os-release?! I give up." >&2
  exit 1
fi

PACKAGE_VERSION=$(git describe --exact-match 2>/dev/null || git log -1 --pretty=0.0.0-git+%h --abbrev-commit)

rm -rf grok/build
mkdir -p grok/build && cd grok/build

cmake \
  -DCMAKE_BUILD_TYPE=Release  \
  -DGRK_BUILD_DOC=ON          \
  -DGRK_BUILD_JPEG=OFF        \
  -DGRK_BUILD_LCMS2=OFF       \
  -DGRK_BUILD_LIBPNG=OFF      \
  -DGRK_BUILD_LIBTIFF=OFF     \
  -DCMAKE_INSTALL_PREFIX=/usr \
  ..
make -j8
make DESTDIR=. install

fpm -s dir -t deb \
  --name grokj2k \
  --version "${PACKAGE_VERSION}+${ID%ian}${VERSION_ID}" \
  --conflicts grokj2k-tools \
  --conflicts libgrokj2k1 \
  --depends libjpeg62-turbo \
  --depends liblcms2-2 \
  --depends $LIBPERL \
  --depends $LIBPNG \
  --depends libtiff6 \
  --deb-dist "$VERSION_CODENAME" \
  --deb-generate-changes \
  --url https://github.com/GrokImageCompression/grok \
  --description "Grok JPEG 2000 library" \
  --maintainer "University of Michigan Library IT <lit-noreply@umich.edu>" \
  usr/bin=/usr usr/include=/usr usr/lib=/usr usr/share/man=/usr/share
