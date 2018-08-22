include("chred.jl")

@show decompose("杏")
@show decompose("呆")
@show distance("杏", "呆")
@show distance("杏", "呆", multiplier=0.0)
@show editdistance(decompose("杏"), decompose("呆"))

@show decompose("钢")
@show decompose("琴")
@show distance("钢", "琴")
@show distance("钢", "琴", normalize=true)