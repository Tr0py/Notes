# Why is My Python So Slow?  --  Profiling a Python Program

Interested in why your program took so long to run?  See the time it spent in
detail by profiling.

## TL;DR

Use cProfile.

```
python -m cProfile <your_program>.py
```

## Advanced

Save it to a logfile and analyze it using `pstats`.

```
python -m cProfile [-o output_file] myscript.py
```

In python prompt, try this:
```
import pstats
from pstats import SortKey
p = pstats.Stats('restats')
p.strip_dirs().sort_stats(-1).print_stats()
p.sort_stats(SortKey.CUMULATIVE).print_stats(10)
p.sort_stats(SortKey.TIME).print_stats(10)
p.sort_stats(SortKey.CALLS).print_stats(10)
```
Find the metrics here:
https://docs.python.org/3/library/profile.html#pstats.Stats.sort_stats.

**Example**

```
>>> p.sort_stats(SortKey.CALLS).print_stats(30)
Thu Oct 27 01:54:41 2022    cp.log

         51753738 function calls (51728837 primitive calls) in 18.545 seconds

   Ordered by: call count
   List reduced from 5695 to 30 due to restriction <30>

   ncalls  tottime  percall  cumtime  percall filename:lineno(function)
 10050800    1.568    0.000    3.427    0.000 LSH.py:35(hash)
 10050800    1.859    0.000    1.859    0.000 {sklearn.utils.murmurhash.murmurhash3_32}
  5002589    0.155    0.000    0.155    0.000 {method 'add' of 'set' objects}
  5000074    0.329    0.000    0.330    0.000 {built-in method builtins.sum}
  5000000    5.558    0.000    5.887    0.000 LSH.py:65(__linear_comb)
  5000000    1.145    0.000    4.552    0.000 LSH.py:69(<listcomp>)
  5000000    1.341    0.000   11.780    0.000 LSH.py:68(__get_index)
  5000000    2.838    0.000   14.772    0.000 LSH.py:72(insert)
```
