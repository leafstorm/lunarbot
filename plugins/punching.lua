--- A plugin for punching people.
-- It can punch people at will, and be configured to always punch people.

local punching = plugin "punching"
punching.commands = {}

function punching.callbacks:onchat (sender, message)
    if self.options.punch[sender.nick] == "always" then
        sender:action("punches " .. sender.nick .. ".")
    end
end


function punching.commands:punch (sender, args)
    if self.options.punch[args] == "never" then
        sender:reply("I am not allowed to punch " .. args .. ".")
    else
        sender:action("punches " .. args .. ".")
    end
end


return punching