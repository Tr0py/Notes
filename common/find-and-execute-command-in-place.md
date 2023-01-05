# How to extract files in place using `find`

> Or: How to find files and execute command acoordingly

**Problem:**

I have many compressed files in different folders.  I want to extract them to *their own* folders.

For example, consider this case:  I want to extract all the `tar` files to their own folders.

```bash
$ tree . -P '*[me].tar'
.
└── parsec-2.1
    ├── config
    └── pkgs
        ├── apps
        │   ├── blackscholes
        │   │   ├── inputs
        │   │   │   ├── input_simlarge.tar
        │   │   │   └── input_simmedium.tar
        │   │   └── parsec
        │   ├── bodytrack
        │   │   ├── inputs
        │   │   │   ├── input_simlarge.tar
        │   │   │   └── input_simmedium.tar
        │   │   └── parsec
        │   ├── facesim
        │   │   ├── inputs
        │   │   │   ├── input_simlarge.tar
        │   │   │   └── input_simmedium.tar
        │   │   └── parsec
.....
```

**Solution: use `find` with `-exec`  to execute command**

```bash
find ./parsec-2.1 -name '*.tar' -execdir tar -xvf '{}' \;
```

Here, `-execdir <command> \;` will execute `command` at the directory that the file is found.

`'{}'` is the name of the file found by `find`.

 **Advanced: rename file's extension**

According to https://askubuntu.com/questions/35922/how-do-i-change-extension-of-multiple-files-recursively-from-the-command-line , you can also rename the file's extenstion:

Eg. rename "123.avi" to "123.mp4"

```bash
find /the/path -depth -name "*.avi" -exec sh -c 'mv "$1" "${1%.avi}.mp4"' _ {} \;
```

> In case anyone else is wondering what the underscore is doing in the first command, it's needed because with sh -c the first argument is assigned to $0 and any remaining arguments are assigned to the positional parameters. So the _ is a dummy argument, and '{}' is the first positional argument to sh -c

**Advanced: convert videos to another format**

The following command will convert all the `DAT` file to `mp4` using `ffmpeg`.

```bash
find . -name '*.DAT' -execdir sh -c 'ffmpeg -i "$1" "${1%.DAT}.mp4"' _ {} \;
```

Note: ffmpeg is by default multithreaded.
