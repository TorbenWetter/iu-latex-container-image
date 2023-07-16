# A Docker Image for Writing Scientific Work at IU International University using TeX Live

This image is based on a `buildpack-deps` image ([Ubuntu 22.10 Kinetic](https://hub.docker.com/layers/library/buildpack-deps/kinetic-curl/images/sha256-4f07626230eb88038d29415ea16d352ce8bae03f6e7bf2279a03e173f2f7032d)) and contains a basic TeX Live installation.

LaTeX-specific packages are pre-installed using `apt-get` and `tlmgr`, and the locale is set to `de_DE.UTF-8`.

The IU Thesis LaTeX package is installed from [GitHub](https://github.com/TorbenWetter/iu-latex-package/releases).
