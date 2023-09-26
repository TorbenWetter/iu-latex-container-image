ARG BASE_IMAGE=ghcr.io/torbenwetter/iu-latex-container-image-base
FROM $BASE_IMAGE:latest

# Switch to the "vscode" user for installing the LaTeX packages.
USER vscode

# Update the TeX Live package manager, install and update additional packages.
RUN tlmgr update --self --all \
  && tlmgr install babel-german biblatex biblatex-apa booktabs caption csquotes etoolbox fontspec hyphen-german latexindent latexmk minted newfloat parskip ragged2e setspace sidecap titlesec \
  && tlmgr update --all

# Install the IU LaTeX package.
RUN mkdir -p $TEXMFHOME/tex/latex/iuthesis \
  && wget -qO $TEXMFHOME/tex/latex/iuthesis/iuthesis.sty https://github.com/TorbenWetter/iu-latex-package/releases/download/v0.0.2/iuthesis.sty

# Update the ls-R databases with the locations of the newly installed files.
RUN texhash $TEXMFHOME \
  && texhash $TEXMFLOCAL \
  && texhash $TEXDIR/texmf-dist

# Verify the binaries work and have the right permissions.
RUN tlmgr version \
  && latexmk -version \
  && texhash --version
