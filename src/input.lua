Input = {}

local function new(name, keys)
    return {
        name = name,
        keys = keys,
        pressed = false,
        down = false,
    }
end

Input.left = new("left", {"a", "left"})
Input.right = new("right", {"d", "right"})
Input.up = new("up", {"w", "up"})
Input.down = new("down", {"s", "down"})
Input.dash = new("dash", {"lshift", "rshift", "space"})

function UpdateInputs()
    for _, action in pairs(Input) do
        local down = false
        for _, key in pairs(action.keys) do
            down = down or love.keyboard.isDown(key)
        end
        action.pressed = down and not action.down
        action.down = down
    end
end