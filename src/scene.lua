local Object = require("src.object")

local Scene = Object:new()

function Scene:add(object, ...)
    local o = object:new()
    o.sc = self
    o:init(...)
    table.insert(self.objects, o)
    return o
end

function Scene:remove(object)
    for i, o in ipairs(self.objects) do
        if o == object then
            table.remove(self.objects, i)
            return
        end
    end
end

function Scene:check_col(a, b)
    return a.x < b.x+b.w and
            b.x < a.x+a.w and
            a.y < b.y+b.h and
            b.y < a.y+a.h
end

function Scene:check_dist(a, b, d)
    return Dist(a, b) <= d
end

function Scene:col(a, tag)
    for _, b in ipairs(self.objects) do
        if b.tag == tag then
            if a ~= b and self:check_col(a, b) then
                return b
            end
        end
    end
    return nil
end

function Scene:dist(a, tag, d)
    for _, b in ipairs(self.objects) do
        if b.tag == tag then
            if a ~= b and self:check_dist(a, b, d) then
                return b
            end
        end
    end
    return nil
end

function Scene:move_x(a, x, tag)
    a.x = a.x+x
    local col = self:col(a, tag)
    if col ~= nil then
        if x > 0 then
            a.x = col.x-a.w
        else
            a.x = col.x+col.w
        end
    end
    return col
end

function Scene:move_y(a, y, tag)
    a.y = a.y+y
    local col = self:col(a, tag)
    if col ~= nil then
        if y > 0 then
            a.y = col.y-a.h
        else
            a.y = col.y+col.h
        end
    end
    return col
end

return Scene