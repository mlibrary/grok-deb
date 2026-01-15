## Build a new version
* update submodule to current revision of upstream repo
* tag release: ${UPSTREAM_VER}-${INTEGER} (reset the appended int to 1 when upgrading to a new upstream release)
  * example: `git tag -s 0.0.1-1 -m 0.0.1-1` - (tag _must_ be annotated, and _should_ be signed)
  * use a non-integer suffix for test releases: `git tag -s 0.0.1-r001 -m 0.0.1-r001`
  * test releases may be on non-main branch
* `git push --tags`
* GitHub Actions will build packages for all target platforms

To test locally:
```
git clone --recursive https://github.com/mlibrary/grok-deb && cd grok-deb

podman build -t mlibrary/grok-deb .
podman run --rm -it -v $(pwd):/src localhost/mlibrary/grok-deb:latest bash

./build.sh
```
