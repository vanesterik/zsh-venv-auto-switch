# zsh-venv-auto-switch plugin

Automatically switch Python virtual environments in zsh.

Inspired by a shell script from [@raoulg](https://github.com/raoulg), who showed it to me in an early morning discussion on the topics of neural networks, hyperparameter tuning, and scientific research. Thank you for sharing the script, your guidance and support. All have been invaluable in my learning experience.

## Installation

Plug this with [Zap](https://www.zapzsh.com/) in your `.zshrc` configuration:

```zsh
plug "vanesterik/zsh-venv-auto-switch"
```

After installation, the plugin will automatically activate a project's Python virtual environment when you `cd` into a directory containing a `.venv` subdirectory, or into any directory below it. It will also deactivate the virtual environment when you leave the project.

## Usage

1. Create a Python virtual environment named `.venv` in your project directory:

```bash
python -m venv .venv
```

2. Navigate to your project directory, or any directory inside it:

```bash
cd /path/to/your/project
```

3. The plugin will automatically activate the virtual environment, and you can start working with it.

4. When you navigate away from the project directory, the plugin will automatically deactivate the virtual environment.

The plugin also:

- activates the virtual environment when a new shell starts inside a project, for example in a new terminal tab,
- switches to the other project's virtual environment when you `cd` directly from one project into another,
- uses the nearest `.venv` when projects are nested,
- leaves a virtual environment active if it can't deactivate it, such as one activated in a parent shell: a subshell inherits its `VIRTUAL_ENV` variable but not its `deactivate` function.

## Development

Run the tests with:

```zsh
zsh test.zsh
```

They also run on GitHub Actions for every push to `main` and every pull request, on Linux and macOS.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

