# zsh-venv-auto-switch plugin

Automatically switch Python virtual environments in zsh.

Inspired by a shell script from [raoulg](https://github.com/raoulg), which you showed in an early morning discussion on the topics of neural networks, hyperparameter tuning, and scientific research. Thank you for sharing the script,  your guidance and support. All have been invaluable in my learning experience.

## Installation

Plug this with [Zap](https://www.zapzsh.com/) in your `.zshrc` configuration:

```zsh
plug "vanesterik/zsh-venv-auto-switch"
```

After installation, the plugin will automatically activate the Python virtual environment when you `cd` into a directory containing a `venv` subdirectory. It will also deactivate the virtual environment when you leave the directory.

## Usage

1. Create a Python virtual environment in your project directory:

```bash
python -m venv venv
```

2. Navigate to your project directory:

```bash
cd /path/to/your/project
```

3. The plugin will automatically activate the virtual environment, and you can start working with it.

4. When you navigate away from the project directory, the plugin will automatically deactivate the virtual environment.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

