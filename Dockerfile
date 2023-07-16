# Use the `kinetic` variant of the buildpack-deps image as the base image.
# It is based on Ubuntu and includes common tools and libraries such as Git, GCC, and OpenSSL, as well as programming languages like Ruby, Node.js, and Python.
ARG VARIANT="kinetic"
FROM buildpack-deps:${VARIANT}-curl

# Accept the Microsoft EULA for the fonts (Arial).
RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections

# Install additional OS packages and clean up.
RUN apt-get update \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get install -y --no-install-recommends build-essential cpanminus libbz2-dev libc6-dev libexpat1-dev libffi-dev libgdbm-dev liblzma-dev libncurses5-dev libncursesw5-dev libreadline-dev libsqlite3-dev libssl-dev libxml2 libxml2-dev libxslt1.1 libxslt1-dev llvm locales make python3-pygments tk-dev ttf-mscorefonts-installer zlib1g-dev \
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/*

# Generate the German locale and set it as the default.
RUN locale-gen de_DE.UTF-8
ENV LANG de_DE.UTF-8
ENV LANGUAGE de_DE:de
ENV LC_ALL de_DE.UTF-8

WORKDIR /biber

# Download the source code of the required Biber version and extract it.
RUN wget -qO - https://github.com/plk/biber/archive/v2.19/biber-2.19.tar.gz | tar xz --strip-components=1

# Install the Perl dependencies and add them to the library path.
RUN cpanm --installdeps .
ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH

# Build the required Biber binary.
RUN perl Build.PL \
  && ./Build \
  && ./Build install

WORKDIR /texlive

# Install required Perl modules for latexindent.
RUN cpanm File::HomeDir Pod::Usage YAML::Tiny

# Define environment variables for TeX Live.
ENV TEXDIR /usr/local/texlive
ENV TEXUSERDIR ~/.texlive
ENV TEXMFHOME /home/vscode/texmf
ENV TEXMFLOCAL $TEXDIR/texmf-local

# Install the latest version of TeX Live and add it to the path.
RUN wget -qO - https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | tar xz --strip-components=1 \
  && perl ./install-tl --no-interaction --scheme=basic --no-doc-install --no-src-install --texdir=$TEXDIR --texuserdir=$TEXUSERDIR
ENV PATH $TEXDIR/bin/aarch64-linux:$TEXDIR/bin/x86_64-linux:$PATH

# Create the "vscode" user.
RUN groupadd -g 1000 vscode && useradd -r -u 1000 -g vscode vscode

# Change the owner of the TeX Live installation to the "vscode" user.
RUN chown -R vscode:vscode $TEXDIR

# Create home directory for "vscode" user and give ownership.
RUN mkdir -p /home/vscode && chown vscode:vscode /home/vscode

# Switch to the "vscode" user for installing the LaTeX packages.
USER vscode

# Update the TeX Live package manager, install and update additional packages.
RUN tlmgr update --self --all \
  && tlmgr install babel-german biblatex biblatex-apa booktabs caption csquotes etoolbox fontspec hyphen-german latexindent latexmk minted newfloat parskip ragged2e setspace sidecap titlesec \
  && tlmgr update --all

# Install the IU LaTeX package.
RUN mkdir -p $TEXMFHOME/tex/latex/iuthesis \
  && wget -qO $TEXMFHOME/tex/latex/iuthesis/iuthesis.sty https://github.com/TorbenWetter/iu-latex-package/releases/download/v0.0.1/iuthesis.sty

# Update the ls-R databases with the locations of the newly installed files.
RUN texhash $TEXMFHOME \
  && texhash $TEXMFLOCAL \
  && texhash $TEXDIR/texmf-dist

# Verify the binaries work and have the right permissions.
RUN tlmgr version \
  && latexmk -version \
  && texhash --version