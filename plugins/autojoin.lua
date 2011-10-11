--- Auto-joining plugin for Lunarbot.
-- This will cause Lunarbot to join channels on startup.

local autojoin = plugin "autojoin"

function autojoin:setup ()
    self:later(function ()
        if self.options.autojoin then
            for _, channel in ipairs(self.options.autojoin) do
                self:join(channel)
            end
        end
    end)
end


return autojoin