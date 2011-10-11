--- Utilities used by Lunarbot.
-- Yes, I know these are all globals. I'll fix it eventually.

function printf (mesg, ...)
    print(string.format(mesg, ...))
end


function new (cls, ...)
    local instance = setmetatable({}, cls)
    if cls.__init then
        instance:__init(...)
    end
    return instance
end


function class ()
    local cls = {}
    cls.__index = cls
    cls.new = new
    return cls
end


function ischannel (channel)
    return channel:match("^[#&+!]")
end


Scheduler = class()

function Scheduler:__init ()
    self.events = {}
end


function Scheduler:check ()
    local idx = 1
    local events = self.events
    while idx <= #events do
        local event = events[idx]
        local keep = event()
        if keep then
            idx = idx + 1
        else
            table.remove(events, idx)
        end
    end
end


function Scheduler:add (event)
    self.events[#self.events + 1] = event
end


function Scheduler:after (delay, event)
    local firetime = os.time() + delay
    self:add(function ()
        if os.time() > firetime then
            event()
            return false
        else
            return true
        end
    end)
end
