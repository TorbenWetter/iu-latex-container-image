# A Docker Image for Writing Scientific Work at IU International University using TeX Live

This Docker image provides a complete LaTeX environment specifically configured for writing scientific documents at IU International University. It is designed to ensure a consistent and reliable writing environment across different platforms.

## Features

- Based on `buildpack-deps` image (`Ubuntu 22.04 Jammy`)
- Full TeX Live installation with commonly used packages
- Pre-configured with German locale (`de_DE.UTF-8`)
- Includes the [IU LaTeX Package](https://github.com/TorbenWetter/iu-latex-package) for scientific writing at IU International University
- LaTeX-specific packages pre-installed using `apt-get` and `tlmgr`

## Usage

This image can be used in multiple ways:

1. **Direct Docker Usage**: Pull and run the image directly using Docker
2. **Dev Containers**: Use with VS Code Dev Containers for an integrated development experience
3. **GitHub Codespaces**: Supports development in the cloud with GitHub Codespaces

For templates and examples using this container image, check out the [IU LaTeX Container Templates](https://github.com/TorbenWetter/iu-latex-container-templates) repository.

## Related Projects

- [IU LaTeX Package](https://github.com/TorbenWetter/iu-latex-package): The main LaTeX package for scientific writing at IU International University, providing document classes and templates for various types of scientific work.
- [IU LaTeX Container Templates](https://github.com/TorbenWetter/iu-latex-container-templates): Ready-to-use templates that utilize this Docker image through Dev Containers, making it easy to start writing your scientific documents.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
