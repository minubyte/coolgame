local Object = require("src.object")

local LineParticle = Object:new()

function LineParticle:init(x, y, lx, ly, size, color)
    self.x = x
    self.y = y

    self.lx = lx
    self.ly = ly

    self.l = 0

    self.size = size
    self.color = color or rgb(255, 255, 255)
    
    self.tag = "particle"
end

function LineParticle:draw()
    love.graphics.setColor(self.color)
    love.graphics.setLineWidth(self.size)
    love.graphics.line(self.x, self.y, self.x+self.lx*self.l, self.y+self.ly*self.l)
    love.graphics.setColor(1, 1, 1)
end

function LineParticle:update(dt)
    self.l = self.l+(1-self.l)*0.3*dt
    self.size = self.size+(0-self.size)*0.2*dt
    if self.size < 0.5 then
        self.sc:remove(self)
    end
end

return LineParticle