ARG BASE_IMAGE=ghcr.io/torbenwetter/iu-latex-container-image-base
FROM $BASE_IMAGE:latest

# Add metadata labels.
LABEL org.opencontainers.image.title="IU LaTeX Container Image"
LABEL org.opencontainers.image.description="LaTeX environment for writing scientific documents at IU International University"
LABEL org.opencontainers.image.source="https://github.com/TorbenWetter/iu-latex-container-image"
LABEL org.opencontainers.image.licenses="MIT"

# Switch to the "vscode" user for installing the LaTeX packages.
USER vscode

# Version of the IU LaTeX package to install.
ARG IU_LATEX_VERSION=0.0.4

# Update TeX Live and install required packages.
# The packages are grouped by their primary purpose:
# - Language support: babel-german, hyphen-german
# - Bibliography: biblatex, biblatex-apa
# - Typography and layout: booktabs, caption, csquotes, fancyvrb, fontspec, ragged2e, setspace, titlesec
# - Code and technical: etoolbox, latexindent, latexmk, lineno, minted, newfloat, parskip, sidecap, upquote
RUN tlmgr option repository https://mirror.ctan.org/systems/texlive/tlnet \
  && tlmgr update --self --all \
  && tlmgr install \
    babel-german \
    biblatex \
    biblatex-apa \
    booktabs \
    caption \
    csquotes \
    etoolbox \
    fancyvrb \
    fontspec \
    hyphen-german \
    latexindent \
    latexmk \
    lineno \
    minted \
    newfloat \
    parskip \
    ragged2e \
    setspace \
    sidecap \
    titlesec \
    upquote \
  && tlmgr update --all \
  # Install the IU LaTeX package.
  && mkdir -p $TEXMFHOME/tex/latex/iuthesis \
  && wget -qO $TEXMFHOME/tex/latex/iuthesis/iuthesis.sty https://github.com/TorbenWetter/iu-latex-package/releases/download/v${IU_LATEX_VERSION}/iuthesis.sty \
  # Update the ls-R databases.
  && texhash $TEXMFHOME \
  && texhash $TEXMFLOCAL \
  && texhash $TEXDIR/texmf-dist \
  # Verify installations.
  && tlmgr version \
  && latexmk -version \
  && texhash --version
