--- Launcher for Lunarbot.
-- It reads a config file (config.lua by default) and then starts the bot.

require 'lunarbot'

local configfile = (...) or "config.lua"
print("Loading configuration from " .. configfile .. "...")
local configfn = assert(loadfile(configfile))
local config = {}
setfenv(configfn, config)

configfn()

local bot = Lunarbot:new(config)
bot:run()
