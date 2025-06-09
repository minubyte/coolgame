local Object = require("src.object")

local LazerMarker = Object:new()

function LazerMarker:init(x, y, w, h)
    self.w = w
    self.h = h

    self.x = x
    self.y = y

    self.size = 0

    self.tag = "lazer_marker"
end

function LazerMarker:draw()
    love.graphics.setColor(1, 1, 1, 0.7)
    love.graphics.setLineWidth(self.size)
    love.graphics.line(self.x, self.y, self.x+self.w, self.y+self.h)
    love.graphics.setColor(1, 1, 1)
end

function LazerMarker:update(dt)
    self.size = self.size+(UNIT/2-self.size)*0.1*dt
end

return LazerMarker
