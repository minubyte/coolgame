local Scene = require("src.scene")

local Game = Scene:new()

local Particle = require("src.objects.particle")
local Player = require("src.objects.player")
local Enemy = require("src.objects.enemy")
local Lazer = require("src.objects.lazer")
local Marker = require("src.objects.marker")
local LazerMarker = require("src.objects.lazer_marker")

function Game:init()
    math.randomseed(love.timer.getTime())
    self.player = self:add(Player)

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

    self.upgrade = {
        phase = false,
        count = 1,
    }

    self:enemy_loop()
    
    -- 아직은 안씀
    -- self:lazer_loop()
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

    if self.upgrade.phase then
        love.graphics.print("asdfasdfasdf", 100, 100)
    end

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

    if DEBUG and Input.debug.down then
        self:start_upgrade()
    end

    if not self.upgrade.phase and self.score.value >= 450*self.upgrade.count^2 then
        self:start_upgrade()
    end
end

function Game:summon_enemy(x, y)
    self:add(Enemy, x, y)
    self:shake(3)
    for _=0, 5 do
        self:add(Particle, x, y,  math.random(-5, 5), math.random(-5, 5), math.random(10, 20))
    end
end

function Game:summon_lazer(x, y, w, h)
    self:add(Lazer, x, y, w, h)
    self:shake(6)
end

function Game:enemy_loop()
    if self.upgrade.phase then
        return
    end
    local x, y = math.random(0, Res.w-UNIT), math.random(0, Res.h-UNIT)
    local marker = self:add(Marker, x, y)
    AddTimer(40, function ()
        self:summon_enemy(x, y)
        self:remove(marker)
    end)
    AddTimer(160, function ()
        self:enemy_loop()
    end)
end

function Game:lazer_loop()
    if self.upgrade.phase then
        return
    end
    local xy = {math.random(0, Res.w-UNIT), math.random(0, Res.h-UNIT)}
    local hw = {Res.h, Res.w}
    local zero = math.random(1, 2)
    xy[zero] = 0
    hw[zero] = 0
    local x, y = xy[1], xy[2]
    local h, w = hw[1], hw[2]
    local marker = self:add(LazerMarker, x, y, w, h)
    AddTimer(60, function ()
        self:summon_lazer(x, y, w, h)
        self:remove(marker)
    end)
    AddTimer(150, function ()
        self:lazer_loop()
    end)
end

function Game:inc_score(v)
    self.score.value = self.score.value+v
    self.score.bounce = 0.5
    if self.score.value < 0 then
        self.score.value = 0
    end
end

local remove_list = {"enemy", "marker", "lazer", "lazer_marker"}

function Game:start_upgrade()
    self.upgrade.count = self.upgrade.count + 1
    self.upgrade.phase = true
    self:shake(10)
    for i, o in ipairs(self.objects) do
        if In(o.tag, remove_list) then
            table.remove(self.objects, i)
            for _=0, 2 do
                self:add(Particle, o.x+o.w/2, o.y+o.h/2, math.random(-5, 5), math.random(-5, 5), math.random(5, 20))
            end
        end
    end
end

return Game