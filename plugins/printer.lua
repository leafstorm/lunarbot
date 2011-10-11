--- Printing plugin for Lunarbot.
-- Prints messages and notices received by Lunarbot.

local printer = plugin "printer"

function printer.callbacks:onchat (sender, message)
    printf("[%s] %s: %s", sender.channel, sender.nick, message)
end


function printer.callbacks:onnotice (sender, message)
    printf("[%s] %s: %s", sender.channel, sender.nick or "*SERVER*", message)
end


function printer.callbacks:onjoin (user, channel)
    printf("- %s joined %s.", user.nick, channel)
end


function printer.callbacks:onpart (user, channel)
    printf("- %s left %s.", user.nick, channel)
end


function printer.callbacks:ontopic (channel, topic)
    printf('- Topic for %s is "%s".', channel, topic)
end

return printer
