# A Docker Image for Writing Scientific Work using TeX Live

This image is based on [Ubuntu 22.10 Kinetic](https://hub.docker.com/layers/library/buildpack-deps/kinetic-curl/images/sha256-8f2e95201750f27ae11350dbd1be2b91478bda92d5f4e1387fffaeb83dabb687) and contains a basic TeX Live installation.

Packages are installed using `apt-get` and `tlmgr`, and the locale is set to `de_DE.UTF-8`.
