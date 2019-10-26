[In this](https://github.com/Evizero/UnicodePlots.jl#histogram),
I get `UndefVarError: histogram not defined`.
 `Plots.histogram(...)`  works, but I feel like the way the readme has it is better.

For `boxplot(...)` I also get undefined error.
With Plots.boxplot(...)` I get `backend must not support the series type Val{:boxplot}, and there isn't a series recipe defined.` and the warning that StatsPlots needs to be added.

```
julia> versioninfo()
Julia Version 1.1.1
Commit 55e36cc308 (2019-05-16 04:10 UTC)
Platform Info:
  OS: Linux (x86_64-pc-linux-gnu)
  CPU: Intel(R) Core(TM) i5-6400 CPU @ 2.70GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-6.0.1 (ORCJIT, skylake)
julia> using UnicodePlots
```


| xx  | Scatterplot | Lineplot  | Staircase plot |  Barplot | Histogram |
| - | - | - | - | - | - |
| Reqires Prefix  | False  | False  | False  | False | False
| works correctly | Content Cell  | Content Cell  | Content Cell  |
| Requires StatsPlots | ------------- | ------------- | ------------- | ------------- |
Scatterplot

Lineplot

Staircase plot

Barplot

Histogram
The main thing though, I can get all of the readme functions to work, some with `Plots.` some without, but heatmap doesn't seem to work.
`ERROR: The backend must not support the series type Val{:heatmap}, and there isn't a series recipe defined.`
tldr; heatmap doesn't work for me, inconsistency in exported graph series types. density plot but not histogram
