# debug kernel


# See https://elinux.org/Debugging_by_printing
# set kernel print level
➜  mmap   cat /proc/sys/kernel/printk
4       4       1       7
➜  mmap sudo sh -c "echo 8 > /proc/sys/kernel/printk"

# pr_debug needs manually add -DDEBUG arg when compile
# ref: https://www.kernel.org/doc/local/pr_debug.txt
