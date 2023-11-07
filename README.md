# bash-profile

Bash profile with some useful aliases, functions, etc.

## Usage

When Bash is invoked as an interactive shell it first reads and
executes commands from the file /etc/profile, if that file exists.
After reading that file, it looks for ~/.bash_profile, ~/.bash_login,
and ~/.profile, in that order, and reads and executes commands
from the first one that exists and is readable.

Append your startup file with:

```bash
source .../profile
```

**(!)** Replace "..." with the local path where this repo is cloned.

### Bash On Windows

You can specify your terminal emulator type:

- [MinGW (Git Bash)](https://git-scm.com)

    ```bash
    source .../profile windows/mingw
    ```

- [MobaXterm](https://mobaxterm.mobatek.net)

    ```bash
    source .../profile windows/mobaxterm
    ```

- [Ubuntu on WSL](https://ubuntu.com/wsl)

    ```bash
    source .../profile wsl/ubuntu
    ```

Or, you can specify the path through which Windows computer drives are accessible:

```bash
DRIVES_PATH=/
source .../profile
```
