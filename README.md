This should produce a working deb for trixie. Working on moving this to a github action...

```
git clone --recursive https://github.com/mlibrary/grok-deb && cd grok-deb
export SOURCE_DATE_EPOCH=$(git show --no-patch --format=%ct)

podman build -t mlibrary/grok-deb .; podman run --rm -it localhost/mlibrary/grok-deb:latest bash

cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DGRK_BUILD_DOC=ON         \
  -DGRK_BUILD_JPEG=OFF       \
  -DGRK_BUILD_LCMS2=OFF      \
  -DGRK_BUILD_LIBPNG=OFF     \
  -DGRK_BUILD_LIBTIFF=OFF    \
  -DCMAKE_INSTALL_PREFIX=/usr ..
make -j8
make DESTDIR=. install

fpm -s dir -t deb \
  --name grokj2k \
  --version 20.0.4-0 \
  --conflicts grokj2k-tools \
  --conflicts libgrokj2k1 \
  --depends libimage-exiftool-perl \
  --depends libjpeg62-turbo \
  --depends liblcms2-2 \
  --depends libperl5.40 \
  --depends libpng16-16t64 \
  --depends libtiff6 \
  --deb-dist trixie \
  --url https://github.com/GrokImageCompression/grok \
  --description "Grok JPEG 2000 library" \
  --maintainer "University of Michigan Library IT <lit-noreply@umich.edu>" \
  usr/bin=/usr usr/include=/usr usr/lib=/usr usr/share/man=/usr/share
```
