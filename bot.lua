require 'lunarbot'

local bot = Lunarbot:new {
    host = "irc.freenode.net",
    nick = "lunarbot",
    realname = "Lunarbot (Testing)",
    owner = "leafstorm",
    punch = {loudbot = "always", leafstorm = "never"},
    plugins = {
        "plugins/printer.lua",
        "plugins/commands.lua",
        "plugins/admin.lua",
        "plugins/punching.lua"
    }
}

bot:later(function ()
    bot:join("#ncsulug")
    bot:send("#ncsulug", "Hello World!")
end)


bot:run()
