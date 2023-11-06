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
source ${THIS_REPO}/profile
```
