function rgb(r, g, b)
    return {r/255, g/255, b/255}
end

function rgba(r, g, b, a)
    return {r/255, g/255, b/255, a}
end

function Sign(x)
    if x > 0 then
        return 1
    elseif x < 0 then
        return -1
    end
    return 0
end

function Dist(a, b)
    local ax = a.x+a.w/2
    local ay = a.y+a.h/2
    local bx = b.x+b.w/2
    local by = b.y+b.h/2
    return math.sqrt((ax-bx)^2+(ay-by)^2)
end

function In(item, table)
    for _, v in ipairs(table) do
        if item == v then
            return true
        end
    end
    return false
end