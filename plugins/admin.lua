--- Administrative plugin for Lunarbot.
-- This allows Lunarbot's owner to disconnect him.

local admin = plugin "admin"

admin.commands = {}

function admin.commands:disconnect (sender, channel)
    if sender.nick == self.options.owner then
        self:disconnect "Goodbye, everyone."
    else
        sender:reply(string.format("%s: Access denied.", sender.nick))
    end
end

return admin
