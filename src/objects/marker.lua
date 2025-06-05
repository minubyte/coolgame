local Object = require("src.object")

local Marker = Object:new()

function Marker:init(x, y)
    self.w = UNIT
    self.h = UNIT

    self.x = x
    self.y = y
    self.size = 0

    self.tag = "marker"
end

function Marker:draw()
    love.graphics.setLineWidth(3)
    love.graphics.circle("line", self.x+self.w/2, self.y+self.h/2, self.size*10)
end

function Marker:update(dt)
    self.size = self.size+(1-self.size)*0.05*dt
end

return Marker
