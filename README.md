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
source ~/bash-profile/profile
```

Replace "~/bash-profile" with the location where you have cloned this repo.

### Bash On Windows

Windows computer drives are accessible through a path which location varies depending on the terminal emulator.  
Use any of the defined profiles bellow, or specify custom location from environment variable DRIVES_PATH:

| TERMINAL EMULATOR                          | DRIVES_PATH | BASH_PROFILE      | C:        |
|--------------------------------------------|-------------|-------------------|-----------|
| [MinGw (Git Bash)](https://git-scm.com)    | /           | windows/mingw     | /c        |
| [MobaXterm](https://mobaxterm.mobatek.net) | /drives     | windows/mobaxterm | /drives/c |
| [Ubuntu on WSL](https://ubuntu.com/wsl)    | /mnt        | wsl/ubuntu        | /mnt/c    |
| Linux (native)                             |             | default           |           |

In case you don't intent to deal with paths to Windows programs, then use the default profile and skip this section.

**Examples:**

```bash
source ~/.bash-profile/profile windows/mingw
```

```bash
BASH_PROFILE=windows/mingw
source ~/.bash-profile/profile
```

```bash
DRIVES_PATH=/
source ~/bash-profile/profile
```

The following helper functions are available on Windows:

- `winpath()` - converts *nix path to Windows path

    ```bash
    winpath ~       # -> C:/Users/vdoshev
    winpath /c/foo  # -> C:/foo
    ```

- `nixpath()` - converts Windows path to *nix path

    ```bash
    nixpath ~       # -> /c/Users/vdoshev
    nixpath C:/foo  # -> /c/foo
    ```
