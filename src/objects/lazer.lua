local Object = require("src.object")

local Lazer = Object:new()

function Lazer:init(x, y, w, h)
    self.w = w
    self.h = h

    self.x = x
    self.y = y

    self.size = UNIT

    self.tag = "lazer"
end

function Lazer:draw()
    love.graphics.setColor(PALETTE.light)
    love.graphics.setLineWidth(self.size)
    love.graphics.line(self.x, self.y, self.x+self.w, self.y+self.h)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

function Lazer:update(dt)
    self.size = self.size+(0-self.size)*0.1*dt
    if self.size < 0.5 then
        self.sc:remove(self)
    end
end

return Lazer