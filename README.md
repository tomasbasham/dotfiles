# dotfiles ![test](https://github.com/tomasbasham/dotfiles/workflows/test/badge.svg)

This is a collection of configurations and scripts I use for customising Linux,
macOS, and Windows based systems.

## Prerequisites

You will need the following things properly installed on your computer.

* [chezmoi](https://www.chezmoi.io/)
* [git](https://git-scm.com/)

## Installation

From within the terminal application run:

```bash
chezmoi init https://github.com/tomasbasham/dotfiles
```

Alternatively install chezmoi and these dotfiles on a new, empty machine with
a single command:

```bash
sh -c "$(curl -fsLS chezmoi.io/get)" -- init --apply tomasbasham
```

### Additional customisation

A few of the configurations in this repository allow for extension by including
a file with a name following `*.after` in the same directory as the respective
configuration file. For example to extend the content of `.profile` you may
create a `.profile.after` with your customisations. A list of extendable
configuration files is as follows:

| File         | Extension          | Purpose                                  |
|--------------|--------------------|------------------------------------------|
| `.bashrc`    | `.bashrc.after`    | Runs on interactive shell sessions       |
| `.gitconfig` | `.gitconfig.after` | Git configurations                       |
| `.profile`   | `.profile.after`   | Non shell specific environment variables |
| `.vimrc`     | `.vimrc.after`     | Vim configurations                       |
| `.zshrc`     | `.zshrc.after`     | Runs on interactive shell sessions       |

## License

This project is licensed under the [MIT License](LICENSE.md).
