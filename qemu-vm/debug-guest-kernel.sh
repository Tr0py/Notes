# Methods to debug _guest kernel_

# 1. use printk()
# You have to set the proper printk() level.  If you want to use pr_debug(),
# you need to turn on CONFIG_DEBUG* for kernel config.
# See https://www.kernel.org/doc/local/pr_debug.txt

# Set kernel print level to enable kernel to print more info in dmesg
# ref: https://elinux.org/Debugging_by_printing
eg.
```
$ cat /proc/sys/kernel/printk
4       4       1       7
$ sudo sh -c "echo 8 > /proc/sys/kernel/printk"
```

# 2. Use GDB+QEMU
# See https://yulistic.gitlab.io/2018/12/debugging-linux-kernel-with-gdb-and-qemu/
# add -s to qemu to enable debug feature

# attach gdb to guest kernel
gdb ./vmlinux
# the default gdb port is localhost:1234
(gdb) target remote :1234

# Remenber to set scheduler lock to prevent thread switching during debugging!!!!
# See https://stackoverflow.com/questions/6721940/how-to-restrict-gdb-debugging-to-one-thread-at-a-time
set scheduler-locking step


# print a file's filename using `struct file*` or `vm fault`
p *file->f_path->dentry
p *vmf->vma->vm_file->f_path->dentry

