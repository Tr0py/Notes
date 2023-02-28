
### Drop Page Cache in Linux

To drop cache in linux, you can use the `/proc/sys/vm/drop_caches`, which controls how the kernel drops cached items. You can write different values to this file to clear different types of cache:

```
sync; echo 1 | sudo tee /proc/sys/vm/drop_caches # clear page cache only
sync; echo 2 | sudo tee /proc/sys/vm/drop_caches # clear dentries and inodes only
sync; echo 3 | sudo tee /proc/sys/vm/drop_caches # clear page cache, plus dentries and inodes.
```

The sync command before writing to the file ensures that all pending disk writes are flushed before dropping the cache.

`echo xx | sudo tee` enpowers `tee` to write to the privileged file using sudo.
This is a variation from `sudo sh -c "echo xxx > xxx"`.
