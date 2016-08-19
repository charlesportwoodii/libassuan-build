# Libassuan build

[![TravisCI](https://img.shields.io/travis/charlesportwoodii/libassuan-build.svg?style=flat-square "TravisCI")](https://travis-ci.org/charlesportwoodii/libassuan-build)

This repository allows you to build and package libassuan

## Dependencies

```
apt-get install build-essential libgmp-dev libunbound-dev m4
```

# Building and Packaging
```
git clone https://github.com/charlesportwoodii/libassuan-build
cd libassuan-build

sudo make VERSION=<version>
# deb packages can be built with
# sudo make package VERSION=<version>
```
