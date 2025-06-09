local Object = require("src.object")

local Player = Object:new()

local Particle = require("src.objects.particle")
local LineParticle = require("src.objects.line_particle")

local img = love.graphics.newImage("assets/imgs/player.png")
local speed = 3
local dash_speed = 15

function Player:init()
    self.w = img:getWidth()
    self.h = img:getHeight()

    self.x = Res.w/2
    self.y = Res.h/2

    self.mx = 0
    self.my = 0
    self.r = 0

    self.particle = {
        timer = 0,
        time = 7,
    }

    self.dash = {
        active = false,
        timer = 0,
        time = 6,
        x = 1,
        y = 0,
    }
    
    self.hurt = false

    self.tag = "player"
end

function Player:draw()
    if self.hurt then
        love.graphics.setColor(1, 1, 1, 0.7)
    end
    local nx, ny = self.x+self.w/2, self.y+self.h/2
    love.graphics.draw(img, nx, ny, self.r, 1, 1, self.w/2, self.h/2)
    love.graphics.setColor(1, 1, 1)
end

function Player:update(dt)
    self:col()
    if self.dash.active then
        self.sc:move_x(self, self.dash.x*dash_speed*dt)
        self.sc:move_y(self, self.dash.y*dash_speed*dt)
        self.dash.timer = self.dash.timer+dt
        if self.dash.timer >= self.dash.time then
            self.dash.timer = 0
            self.dash.active = false
        end
    else
        local ix = 0
        local iy = 0
        if Input.left.down then
            ix = ix-1
        end
        if Input.right.down then
            ix = ix+1
        end
        if Input.up.down then
            iy = iy-1
        end
        if Input.down.down then
            iy = iy+1
        end

        self.mx = self.mx+(ix-self.mx)*0.5*dt
        self.r = self.r+(ix/3-self.r)*0.2*dt
        self.my = self.my+(iy-self.my)*0.5*dt
        
        if ix ~= 0 or iy ~= 0 then
            self.dash.x = ix
            self.dash.y = iy
            self.particle.timer = self.particle.timer+dt
            if self.particle.timer >= self.particle.time then
                self.particle.timer = 0
                self.sc:add(Particle, self.x+self.w/2, self.y+self.h/2, -math.random(1, 2)*ix, math.random(-2, -1), math.random(4, 6))
            end
        end

        self.sc:move_x(self, self.mx*speed*dt)
        self.sc:move_y(self, self.my*speed*dt)
        
        if Input.dash.pressed then
            self.sc:inc_score(-10)
            self.dash.active = true
            self.sc:shake(5)
            if self.dash.x^2+self.dash.y^2 > 1 then
                self.dash.x = self.dash.x/math.sqrt(2)
                self.dash.y = self.dash.y/math.sqrt(2)
            end
            local r = dash_speed*self.dash.time
            local dx, dy = self.dash.x*r, self.dash.y*r
            self.sc:add(LineParticle, self.x+self.w/2, self.y+self.h/2, dx, dy, 40, PALETTE.acc)
            for _=0, 3 do
                self.sc:add(Particle, self.x+self.w/2, self.y+self.h/2, self.dash.x*math.random(1, 4), self.dash.y*math.random(1, 4), math.random(5, 20))
            end
        end
    end
end

function Player:dist_line(a, b)
    local ax = a.x+a.w/2
    local ay = a.y+a.h/2
    local bx = b.x+b.w/2
    local by = b.y+b.h/2
    
    local dx = ax - bx
    local dy = ay - by

    local perp_x = -self.dash.y
    local perp_y = self.dash.x

    local dot = dx * perp_x + dy * perp_y

    return math.abs(dot)
end

function Player:col()
    local w = self.w*0.7
    if self.dash.active then
        w = self.w*1.2
    end
    local col = self.sc:dist(self, "enemy", w)
    if col ~= nil then
        if self.dash.active or not self.hurt then
            self.sc:remove(col)
            self.sc:shake(15)
            if self.dash.active then
                local d = self:dist_line(self, col)
                self.sc:inc_score(100-math.floor(d))
            end
            for _=0, 3 do
                self.sc:add(Particle, self.x+self.w/2, self.y+self.h/2, math.random(-5, 5), math.random(-5, 5), math.random(10, 30), PALETTE.acc)
            end
        end
        if not self.dash.active then
            self.hurt = true
            AddTimer(90, function ()
                self.hurt = false
            end)
        end
    end
end

return Player