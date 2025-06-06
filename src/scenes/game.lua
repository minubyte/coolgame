local Scene = require("src.scene")

local Game = Scene:new()

local Particle = require("src.objects.particle")
local Player = require("src.objects.player")
local Enemy = require("src.objects.enemy")
local Marker = require("src.objects.marker")

function Game:init()
    self.player = self:add(Player)
    -- self:add(Enemy, Res.w/2+UNIT, Res.h/2)

    math.randomseed(love.timer.getTime())
    self:summon_loop()

    self.camera_shake = {
        dur = 0,
        x = 0,
        y = 0,
    }
    self.camera = {
        x = 0,
        y = 0,
    }

    self.score = {
        value = 0,
        bounce = 0,
    }
end

function Game:draw_background()
    love.graphics.setBlendMode("lighten", "premultiplied")
    love.graphics.setColor(1, 1, 1, 0.02)
    local size = 30
    for x=0, Res.w/size do
        for y=0, Res.w/size do
            if (x+y)%2 == 0 then
                love.graphics.rectangle("fill", x*size, y*size, size, size)
            end
        end
    end
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(1, 1, 1)
end

function Game:draw()
    love.graphics.setBackgroundColor(PALETTE.dark)
    love.graphics.push()

    if self.camera_shake.dur > 0.1 then
        love.graphics.translate(self.camera_shake.x, self.camera_shake.y)
    end

    Res:apply()
    self:draw_background()
    for _, object in pairs(self.objects) do
        object:draw()
    end

    local s = tostring(self.score.value)
    love.graphics.print(s, Res.w/2, 50, 0, 1+self.score.bounce, 1-self.score.bounce, FONT:getWidth(s)/2, FONT:getHeight()/2)

    love.graphics.pop()
end

function Game:shake(dur)
    self.camera_shake.dur = dur
end

function Game:update(dt)
    self.score.bounce = self.score.bounce+(0-self.score.bounce)*0.07*dt

    if self.camera_shake.dur > 0.1 then
        self.camera_shake.x = math.random(-self.camera_shake.dur, self.camera_shake.dur)
        self.camera_shake.y = math.random(-self.camera_shake.dur, self.camera_shake.dur)
    end
    self.camera_shake.dur = self.camera_shake.dur+(0-self.camera_shake.dur)*0.2*dt
    
    for _, object in pairs(self.objects) do
        object:update(dt)
    end
end

function Game:summon(x, y)
    self:add(Enemy, x, y)
    self:shake(3)
    for _=0, 5 do
        self:add(Particle, x, y,  math.random(-5, 5), math.random(-5, 5), math.random(10, 20))
    end
end

function Game:summon_loop()
    local x, y = math.random(0, Res.w-UNIT), math.random(0, Res.h-UNIT)
    local marker = self:add(Marker, x, y)
    AddTimer(60, function ()
        self:summon(x, y)
        self:remove(marker)
    end)
    AddTimer(200, function ()
        self:summon_loop()
    end)
end

function Game:inc_score(v)
    self.score.value = self.score.value+v
    self.score.bounce = 0.5
end

return Game