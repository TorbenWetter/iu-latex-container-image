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

# Install required Perl modules.
RUN cpanm File::HomeDir Pod::Usage YAML::Tiny

# Generate the German locale and set it as the default.
RUN locale-gen de_DE.UTF-8
ENV LANG de_DE.UTF-8
ENV LANGUAGE de_DE:de
ENV LC_ALL de_DE.UTF-8

### BIBER ###
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

# Clean up.
RUN rm -rf /biber

### TEXLIVE ###
WORKDIR /texlive

# Define environment variables for TeX Live.
ENV TEXDIR /usr/local/texlive
ENV TEXUSERDIR ~/.texlive
ENV TEXMFHOME /home/vscode/texmf
ENV TEXMFLOCAL $TEXDIR/texmf-local

# Install the latest version of TeX Live and add it to the path.
RUN wget -qO - https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | tar xz --strip-components=1 \
  && perl ./install-tl --no-interaction --scheme=basic --no-doc-install --no-src-install --texdir=$TEXDIR --texuserdir=$TEXUSERDIR --repository https://mirror.ctan.org/systems/texlive/tlnet
ENV PATH $TEXDIR/bin/aarch64-linux:$TEXDIR/bin/x86_64-linux:$PATH

# Clean up.
RUN rm -rf /texlive

### VSCODE USER ###
WORKDIR /home/vscode

# Create the "vscode" user.
RUN groupadd -g 1000 vscode && useradd -r -u 1000 -g vscode vscode

# Change the owner of the home directory to the "vscode" user.
RUN chown -R vscode:vscode /home/vscode

# Change the owner of the TeX Live installation to the "vscode" user.
RUN chown -R vscode:vscode $TEXDIR
