# Python Tip: Use `loguru` for logging

**TL;DR:** Just use `loguru` instead of `logging`.  Save you life.

| ![](python-simple-logging_images/2023-10-19-16-35-44-image.png) | ![](python-simple-logging_images/2023-10-19-16-35-48-image.png) |
| --------------------------------------------------------------- | --------------------------------------------------------------- |
| Figure 1. `logging` default format                              | Figure 2. `loguru` default format                               |

**Problem.**  Doing proper logging is important in pyhton scripts, yet the library `logging` has the ugliest possible defaut formatting. (see Figure 1) Configuring `logging` to have a pretty format takes lines of code.

**Solution.** `loguru` has a default config.  (see Figure 2)

**One-liner:**

```python3
from loguru import logger as logging
```

**Example:**

```python3
logging.debug('xxxx')
logging.info('xxxx')
logging.success('xxxx')
logging.warning('xxxx')
logging.error('xxxx')
```
