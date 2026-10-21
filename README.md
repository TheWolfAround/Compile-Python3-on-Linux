# Compile-Python3-on-Linux

This script prepared for a YouTube video. Watch the video before using it to avoid unexpected errors.  

https://youtu.be/RdhmJNDADNc

## How to make Default Your Compilation

You need to create symbolic links somewhere that comes before `/usr/bin` in your `PATH`. On a default Debian setup, `/usr/local/bin` is first in your `PATH`.
Let's say you compiled python in this directory `~/.MY_PYTHON_3.13.15`, then you need to create symbolic links like below:

```
sudo ln -s ~/.MY_PYTHON_3.13.15/bin/python3.13 /usr/local/bin/python
sudo ln -s ~/.MY_PYTHON_3.13.15/bin/python3.13 /usr/local/bin/python3
sudo ln -s ~/.MY_PYTHON_3.13.15/bin/pip3.13 /usr/local/bin/pip
sudo ln -s ~/.MY_PYTHON_3.13.15/bin/pip3.13 /usr/local/bin/pip3
```

After creating the symbolic links above you can run your python as `python` and `python3`, same goes for pip as `pip` and `pip3`.
Verify: `python --version` → 3.13.15, `python3 --version` → 3.13.15, `pip --version` shows the ~/.MY_PYTHON_3.13.15 path.

Note: This doesn't repoint `/usr/bin/python3` — that is a symlink managed by Debian, pointing to the system Python (`/usr/bin/python3.13`, this is a version that is integrated your Debian). It is left untouched, so Debian's own packaging tools (apt, gnome-terminal, network-manager, etc.) won't break.

To undo, just remove the symlinks (your compiled Python in `~/.MY_PYTHON_3.13.15` is not affected):

```
sudo rm /usr/local/bin/python /usr/local/bin/python3 /usr/local/bin/pip /usr/local/bin/pip3
```

## If You Delete Your Compiled Python

Deleting `~/.MY_PYTHON_3.13.15` does **not** remove the symlinks in `/usr/local/bin`. A symlink is just a small file that stores a path — it is not tied to its target, so nothing cleans it up when the target disappears. The four links stay in place but become **dangling (broken) symlinks**: they still exist on your `PATH`, but running them fails with a confusing error like:

```
bash: /usr/local/bin/python3: No such file or directory
```

So if you remove the build, remove the links too:

```
sudo rm /usr/local/bin/python /usr/local/bin/python3 /usr/local/bin/pip /usr/local/bin/pip3
```

(`rm` on a symlink removes the link itself, never the target — safe.)

Then verify nothing is left dangling:

```
find /usr/local/bin -xtype l
```

Nothing else references the build: pip-installed scripts live inside `~/.MY_PYTHON_3.13.15/bin/` and are deleted together with the directory, so the four `/usr/local/bin` links are the only cleanup needed.
