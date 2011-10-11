--- Lunarbot
-- Lunarbot is a bot written in Lua. It is powered by LuaIRC.
-- Like most bots, it uses plugins.

require 'lunarbot.utils'
local ircmodule = require 'irc'
local sleep = require 'socket'.sleep

function plugin (name)
    return {name = name, callbacks = {}}
end


Sender = class()

function Sender:__init (bot, channel, user)
    self.bot = bot
    self.channel = channel
    self.nick = user.nick
end


function Sender:reply (mesg)
    if self.channel:match("^[#&+!]") then
        self.bot:send(self.channel, mesg)
    else
        self.bot:send(self.nick, mesg)
    end
end


function Sender:action (mesg)
    if self.channel:match("^[#&+!]") then
        self.bot:action(self.channel, mesg)
    else
        self.bot:action(self.nick, mesg)
    end
end


function Sender:message (mesg)
    self.bot:send(self.nick, mesg)
end


Lunarbot = class()

function Lunarbot:__init (options)
    self.options = options
    self.state = {}
    self._plugins = {}
    self._callbacks = {}
    self._disconnect = nil
    self._scheduler = Scheduler:new()
    
    for _, plugin in ipairs(options.plugins or {}) do
        if type(plugin) == "string" then
            plugin = assert(loadfile(plugin))()
        end
        self:addplugin(plugin)
    end
end


function Lunarbot:disconnect (mesg)
    self._disconnect = mesg
end


function Lunarbot:addcallback (event, callback)
    if not self._callbacks[event] then
        self._callbacks[event] = {}
    end
    self._callbacks[event][#self._callbacks[event] + 1] = callback
end


function Lunarbot:runcallbacks (event, ...)
    local callbacks = self._callbacks[event] or {}
    for idx = 1, #callbacks do
        local stop = callbacks[idx](self, ...)
        if stop then
            return
        end
    end
end


function Lunarbot:addplugin (plugin)
    if self._plugins[plugin.name] then
        return
    end
    print("Loading plugin " .. plugin.name .. "...")
    self._plugins[plugin.name] = plugin
    if plugin.setup then
        plugin.setup(self)
    end
    if plugin.callbacks then
        for event, callback in pairs(plugin.callbacks) do
            self:addcallback(event, callback)
        end
    end
    self:runcallbacks("pluginadded", plugin)
end


function Lunarbot:later (event)
    self._scheduler:add(event)
end


function Lunarbot:after (delay, event)
    self._scheduler:after(delay, event)
end


function Lunarbot:send (target, message)
    self.irc:sendChat(target, message)
end


function Lunarbot:action (target, message)
    self.irc:sendChat(target, string.format("\001ACTION %s \001", message))
end


function Lunarbot:notice (target, message)
    self.irc:sendNotice(target, message)
end


function Lunarbot:join (channel)
    self.irc:join(channel)
end


function Lunarbot:part (channel)
    self.irc:part(channel)
end


function Lunarbot:onchat (user, channel, message)
    local sender = Sender:new(self, channel, user)
    self:runcallbacks("onchat", sender, message)
end


function Lunarbot:onnotice (user, channel, message)
    local sender = Sender:new(self, channel, user)
    self:runcallbacks("onnotice", sender, message)
end


function Lunarbot:_addhooks (irc)
    local function hook (hookname, method)
        irc:hook(hookname, method, function (...)
            return self[method](self, ...)
        end)
    end
    hook("OnChat", "onchat")
    hook("OnNotice", "onnotice")
end


function Lunarbot:run ()
    -- connection setup
    self.nick = self.options.nick or "lunarbot"
    local irc = ircmodule.new {
        nick = self.nick,
        username = self.options.username or self.nick,
        realname = self.options.realname or "Lunarbot",
    }
    self:_addhooks(irc)
    self.irc = irc
    
    irc:connect(self.options.host)
    printf("Connected to %s", self.options.host)
    
    local step = self.options.sleepstep or 0.1
    repeat
        irc:think()
        self._scheduler:check()
        sleep(step)
    until self._disconnect
    irc:disconnect(self._disconnect)
end
