# Profiling a Python Program

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
