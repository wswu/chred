using DelimitedFiles

function loaddata()
    # data from https://raw.githubusercontent.com/cjkvi/cjkvi-ids/master/ids.txt
    data = readdlm("ids.txt", '\t', String, comments=true)
    chars = data[:, 2]
    decomp = map(data[:, 3]) do x
        x = replace(x, r"[⿱⿰⿳⿲⿸⿹⿺⿵⿶⿷⿴⿻]" => "")
        replace(x, r"\[.*\]" => "")
    end
    Dict(zip(chars, decomp))
end

decomp = loaddata()

decompose(str) = flatten(get(decomp, string(c), c) for c in str)

flatten(seq) = [x for a in seq for x in a]

function expand(decomp)
    changed = true
    while changed
        changed = false
        for (k, v) in decomp
            new_v = join(decompose(v))
            if v != new_v
                decomp[k] = new_v
                changed = true
            end
        end
    end
    decomp
end

decomp = expand(decomp)

function editdistance(a, b)
    table = zeros(Int, length(a) + 1, length(b) + 1)
    for i in 1:length(a) + 1
        table[i, 1] = i - 1
    end
    for j in 1:length(b) + 1
        table[1, j] = j - 1
    end
    for i in 2:length(a) + 1
        for j in 2:length(b) + 1
            table[i, j] = min(
                table[i - 1, j] + 1,
                table[i, j - 1] + 1,
                table[i - 1, j - 1] + (a[i - 1] == b[j - 1] ? 0 : 1))
        end
    end
    table[end][end]
end

jaccard(a, b) = length(a ∩ b) / length(a ∪ b)

"""
    distance(a, b; multiplier=0.5, normalize=false)

Computes the distance between the decomposed forms of two strings using the formula

> dist = editdistance(a,b) - editdistance(a,b) * jaccard(a,b) * multiplier

`multiplier` scales the influence of the Jaccard similarity on the distance.

`normalize` divides the distance by the length of the longer string.
"""
function distance(a, b; multiplier=0.5, normalize=false)
    da = decompose(a)
    db = decompose(b)
    ed = editdistance(da, db)
    dist = ed - ed * jaccard(da, db) * multiplier
    if normalize
        dist = dist / max(length(da), length(db))
    end
    dist
end