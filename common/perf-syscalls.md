# Use perf to profile syscall counts

```
~/perf stat -e 'syscalls:sys_enter_*'  <command-to-execute> 2 > perf-log
cat ./perf-log| grep "syscalls" | awk '$1!=0' |  sort -n -k 1 -r
```

Example:

```
$ ~/perf stat -e 'syscalls:sys_enter_*'  make run_bench 2 > perf-log
$ cat ./perf-log| grep "syscalls" | awk '$1!=0' |  sort -n -k 1 -r

               879      syscalls:sys_enter_close
               673      syscalls:sys_enter_fcntl
               637      syscalls:sys_enter_openat
               558      syscalls:sys_enter_read
               442      syscalls:sys_enter_newfstat
               399      syscalls:sys_enter_mmap
               331      syscalls:sys_enter_newfstatat
               302      syscalls:sys_enter_getdents64
               249      syscalls:sys_enter_mprotect
               207      syscalls:sys_enter_newlstat
               129      syscalls:sys_enter_write
               119      syscalls:sys_enter_brk
               116      syscalls:sys_enter_pread64
               100      syscalls:sys_enter_newstat
                76      syscalls:sys_enter_rt_sigaction
                48      syscalls:sys_enter_futex
                41      syscalls:sys_enter_munmap
                41      syscalls:sys_enter_fchdir
                38      syscalls:sys_enter_lseek
                38      syscalls:sys_enter_access
```
