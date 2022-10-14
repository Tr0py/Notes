
My favorate debug printer.

```
#define PMEM_DBG
#ifdef PMEM_DBG
#define PDBG(fmt, ...)  pr_alert("[%s]\t" fmt, __func__, ##__VA_ARGS__)
#else
#define PDBG(...)
#endif
```
