local Object = require("src.object")

local Enemy = Object:new()

local Particle = require("src.objects.particle")

local img = love.graphics.newImage("assets/imgs/enemy.png")
local base_speed = 3

function Enemy:init(x, y)
    self.w = img:getWidth()
    self.h = img:getHeight()

    self.x = x
    self.y = y

    self.mx = 0
    self.my = 0
    self.r = 0

    self.particle = {
        timer = 0,
        time = 7,
    }
    
    self.deg = math.random(-50, 50)
    self.speed = math.sin(self.deg)*base_speed

    self.tag = "enemy"
end

function Enemy:draw()
    local nx, ny = self.x+self.w/2, self.y+self.h/2
    love.graphics.draw(img, nx, ny, self.r, 1, 1, self.w/2, self.h/2)
end

function Enemy:update(dt)
    local ix = 0
    local iy = 0

    local angle = math.atan2(self.sc.player.y-self.y, self.sc.player.x-self.x)+math.rad(self.deg)
    ix = math.cos(angle)
    iy = math.sin(angle)

    self.mx = self.mx+(ix-self.mx)*0.1*dt
    self.r = self.r+(ix/3-self.r)*0.2*dt
    self.my = self.my+(iy-self.my)*0.1*dt

    if ix ~= 0 or iy ~= 0 then
        self.particle.timer = self.particle.timer+dt
        if self.particle.timer >= self.particle.time then
            self.particle.timer = 0
            self.sc:add(Particle, self.x+self.w/2, self.y+self.h/2, -math.random(1, 2)*ix, math.random(-2, -1), math.random(4, 6))
        end
    end
    
    self.sc:move_x(self, self.mx*base_speed*dt)
    self.sc:move_y(self, self.my*base_speed*dt)
end

return Enemy