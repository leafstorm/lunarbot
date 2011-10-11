--- The Hail plugin displays configurable messages when entering chatrooms.
-- Use "^" as the message, and it will not hail that particular room.

local hail = plugin "hail"

function hail.callbacks:onjoin (user, channel)
    if user.nick == self.nick and self.options.hailmessages then
        local message = self.options.hailmessages[channel] or
                        self.options.hailmessages["*"]
        if message and message ~= "^" then
            self:send(channel, message)
        end
    end
end


return hail
