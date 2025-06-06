local Object = require("src.object")

local Particle = Object:new()

function Particle:init(x, y, vx, vy, size, color)
    self.x = x
    self.y = y
    
    self.vx = vx
    self.vy = vy
    
    self.size = size
    self.color = color or PALETTE.light
    
    self.tag = "particle"
end

function Particle:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, self.size)
    love.graphics.setColor(1, 1, 1)
end

function Particle:update(dt)
    self.x = self.x+self.vx*dt
    self.y = self.y+self.vy*dt

    self.vx = self.vx+(0-self.vx)*0.1*dt
    self.vy = self.vy+(0-self.vy)*0.1*dt
    self.size = self.size+(0-self.size)*0.1*dt
    if self.size < 0.5 then
        self.sc:remove(self)
    end
end

return Particle