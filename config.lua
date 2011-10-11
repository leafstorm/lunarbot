-- connection settings
host = "irc.freenode.net"
nick = "lunarbot"
realname = "Lunarbot (testing)"

-- plugins
plugins = {
    "plugins/printer.lua",
    "plugins/commands.lua",
    "plugins/autojoin.lua",
    "plugins/admin.lua",
    "plugins/punching.lua",
    "plugins/hail.lua"
}

-- plugin options
autojoin = {"##bottest"}
owner = "leafstorm"
punch = {loudbot = "always", leafstorm = "never"}
hailmessages = {
    ["##bottest"] = "Hello, world!"
}