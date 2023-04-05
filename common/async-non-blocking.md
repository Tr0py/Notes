# Asynchronous VS non-blocking; Synchronous VS blocking Difference 

TL;DR: **Synchronous/Asynchronous refers to how a task is executed, while blocking/Non-blocking refers to the amount of effort an operation puts into performing a task.**  

---

**Synchronous/Asynchronous refers to how a task is executed.** An operation is considered synchronous when it is executed in the foreground without spawning any background job; otherwise, it is considered asynchronous and executed in the background concurrently*.

**Blocking/Non-blocking refers to the amount of effort an operation puts into performing a task especially when the task may need multiple retries or waiting.** A blocking operation puts in its best effort to complete the task in the foreground, meaning that it keeps retrying to get the final result, while a non-blocking operation is allowed to return an intermediate result after attempting but failing to complete.

Based on the definition, we can draw the following conclusions:

1. **A blocking operation is synchronous.** This is because a blocking operation puts in its best effort to complete the task in the foreground, meaning that it does not spawn a background job. Examples of blocking operations include blocking send.
2. **An asynchronous operation is non-blocking.** This is because an asynchronous operation spawns a background job and does not perform everything in the foreground. Examples of asynchronous operations include CLFLUSHOPT.
3. **A non-blocking operation can be either synchronous or asynchronous.** Since a non-blocking operation does not put in its best effort in the foreground, it can either return the current result or spawn a background job to complete the task. Examples of non-blocking operations include non-blocking send (synchronous) and CLFLUSHOPT (asynchronous).
4. **A synchronous operation can also be either blocking or non-blocking.** This is because a synchronous operation does not spawn a background job. It can either put in its best effort to complete the task in the foreground (blocking) or try once and return the result (non-blocking). Examples of synchronous operations include non-blocking send (synchronous and non-blocking) and blocking send (synchronous and blocking).

Below is a table to facilitate the points.

|  | synchronous | asynchonous |
| --- | --- | --- |
| block | normal functions, like sum(), send(), printf() | Not exist |
| non-block | functions that tries to do something.  Eg. non-blocking send/recv(), try_lock()  | all asynchronous functions, may or may not have a call back function.  Eg. await in asyncio. |

Note: 

* its better to say async is utilizing *concurrency* but not necessarily *parallelism, as c*oncurrency refers to the ability of a system to perform multiple tasks or processes at the same time, and it may or may not be parallel (eg. multiplexing).
