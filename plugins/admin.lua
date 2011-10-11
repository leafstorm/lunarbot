--- Administrative plugin for Lunarbot.
-- This allows Lunarbot's owner to disconnect him.

local admin = plugin "admin"

admin.commands = {}

function admin.commands:disconnect (sender)
    if sender.nick == self.options.owner then
        self:disconnect "Goodbye, everyone."
    else
        sender:reply("Access denied.")
    end
end


function admin.commands:join (sender, channel)
    if sender.nick == self.options.owner then
        self:join(channel)
    else
        sender:reply("Access denied.")
    end
end


function admin.commands:part (sender, channel)
    if sender.nick == self.options.owner then
        self:part(channel)
    else
        sender:reply("Access denied.")
    end
end

return admin
