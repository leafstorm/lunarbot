--- Printing plugin for Lunarbot.
-- Prints messages and notices received by Lunarbot.

local printer = plugin "printer"

function printer.callbacks:onchat (sender, message)
    printf("[%s] %s: %s", sender.channel, sender.nick, message)
end


function printer.callbacks:onnotice (sender, message)
    printf("[%s] %s: %s", sender.channel, sender.nick or "*SERVER*", message)
end

return printer
