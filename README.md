# chred

Edit distance by decomposing CJK characters into radicals.

Character decomposition data is from [cjkvi-ids](https://github.com/cjkvi/cjkvi-ids). Download [ids.txt](https://raw.githubusercontent.com/cjkvi/cjkvi-ids/master/ids.txt) and place it in the current directory.

Distance is calculated as 

```
editdistance(a, b) - editdistance(a, b) * jaccard(a, b) * multiplier
```

with a default multiplier of 0.5.

## Examples

```julia
include("chred.jl")

# some similarity
decompose("杏")  # ['木', '口']
decompose("呆")  # ['口', '木']
distance("杏", "呆")  # 1.0
distance("杏", "呆", multiplier=0.0)  # 2.0, which is equivalent to
editdistance(decompose("杏"), decompose("呆"))  # 2

# no similarity
decompose("钢")  # ['钅', '冂', '㐅']
decompose("琴")  # ['一', '十', '一', '一', '十', '一', '人', '丶', '㇇']
distance("钢", "琴")   # 9.0
distance("钢", "琴", normalize=true)  # 1.0
```

