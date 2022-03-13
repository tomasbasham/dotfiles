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

## License

This project is licensed under the [MIT License](LICENSE.md).
