--- Commands plugin for Lunarbot.

local commands = plugin "commands"
commands.commands = {}

local commandpattern = "[,:]%s+(%a+)%s*(.*)"

function commands:setup ()
    self.commands = {}
end


function commands.callbacks:pluginadded (plugin)
    if plugin.commands then
        for name, f in pairs(plugin.commands) do
            self.commands[name] = f
        end
    end
end


function commands.callbacks:onchat (sender, message)
    local command, args = message:match("^" .. self.nick .. commandpattern)
    if command then
        if self.commands[command] then
            self.commands[command](self, sender, args)
        else
            sender:reply(string.format("%s: Not a command.", sender.nick))
        end
    end
end


function commands.commands:echo (sender, args)
    printf("Received echo command from %s", sender.nick)
    if #args == 0 then
        sender:reply("...")
    else
        sender:reply(args)
    end
end


return commands
