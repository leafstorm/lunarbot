--- Commands plugin for Lunarbot.

local commands = plugin "commands"
commands.commands = {}

local commandpattern = "[,:]%s+(%a+)%s*(.*)"

function commands:setup ()
    self.commands = {}
end


function commands.callbacks:pluginsready (plugin)
    for name, plugin in pairs(self._plugins) do
        if plugin.commands then
            for name, f in pairs(plugin.commands) do
                self.commands[name] = f
            end
        end
    end
end


function commands.callbacks:onchat (sender, message)
    local command, args
    if ischannel(sender.channel) then
        command, args = message:match("^" .. self.nick .. commandpattern)
    else
        command, args = message:match("(%a+)%s*(.*)")
    end
    if command then
        if self.commands[command] then
            self.commands[command](self, sender, args)
        else
            sender:reply("I don't recognize that command.")
        end
    end
end


function commands.commands:say (sender, args)
    if #args == 0 then
        sender:say("...")
    else
        sender:say(args)
    end
end


return commands
