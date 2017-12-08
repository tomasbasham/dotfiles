# dotfiles

This is a collection of dotfiles and scripts I use for customising macOS and
Debian based system and setting up the software development tools I use daily.
They should be cloned to your home directory into the path `~/dotfiles`. The
included setup script creates symlinks from your home directory to the files
which are located in `~/dotfiles`.

The setup script is smart enough to back up your existing dotfiles into a
`~/dotfiles_old` directory if you already have any dotfiles of the same name
present.

Additionally many of the configurations in this repository allow for extension
by including a `*.after` next to its respective dotfile. For example to extend
the content of `.profile` you may create a `.profile.after` with your
customisations.

## Prerequisites

You will need the following things properly installed on your computer.

* [Bash](https://www.gnu.org/software/bash/)
* [curl](https://curl.haxx.se/)

both of which are installed on most Unix operating systems.

## Installation

From within the terminal application run:
```bash
curl -s https://dotfiles.tomasbasham.dev | bash
```

This downloads and immediately runs a short [bash
script](https://raw.githubusercontent.com/tomasbasham/dotfiles/master/scripts/setup)
that will fetch and extract the latest dotfiles archive from github into a
temporary location and installs everything into `~/dotfiles`.

### Additional Components

In addition some common development tools can be installed through the
installation script. These must be given as a comma separated list.

```bash
curl -s https://dotfiles.tomasbasham.dev | bash -s -- --additional-components=COMPONENTS
```
Available components are:

- aws
- docker (with docker-compose)
- gcloud
- golang
- helm
- kustomize
- sops
- terraform
