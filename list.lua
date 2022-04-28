


local modules = {
    'buffer',
    'childprocess',
    'codec',
    'core',
    'dgram',
    'dns',
    'fs',
    'helpful',
    'hooks',
    'http-codec',
    'http-header',
    'http',
    'https',
    'json',
    'los',
    'net',
    'path',
    'pathjoin',
    'pretty-print',
    'process',
    'querystring',
    'readline',
    'repl',
    'require',
    'resource',
    'stream',
    'thread',
    'timer',
    'url',
    'ustring',
    'utils'
}

--===--

-- object stuff
local baseObject = require 'core'.Object
local instanceof = require 'core'.instanceof

local function inherits(class1, class2)
    local meta = class1 and rawget(class1, 'meta')
    if type(class1) ~= 'table' or not meta or not class2 then
        return false
    end
    if meta.__index == class2 then
        return true
    end

    while meta do
        if meta.super == class2 then
            return true
        elseif meta.super == nil then
            return false
        end
        meta = meta.super.meta
    end
    return false
end

--===--


local function getParams(f)
    assert(type(f) == 'function', "bad argument #1 to 'getParams' (function expected)")
    local params = {}
    local i = 1

    local info = debug.getinfo(f)

    for i = 1, info.nparams do
        local loc = assert(debug.getlocal(f, i))

        params[#params+1] = {
            name = loc
        }
    end
    if info.isvararg then
        params[#params+1] = {
            name = '...'
        }
    end
    return params
end

---@param t table
local function getFunctions(t, level)
    if not level then level = 1 end
    local out = {}
    for n,f in pairs(t) do
        print(n)
        if type(f) == 'function' then
            out[#out+1] = {
                name = n,
                params = getParams(f)
            }
        end
    end
    local mt = getmetatable(t)
    if mt and type(mt.__index) == 'table' then
        local inherited = getFunctions(mt.__index, level + 1)
        for _, item in ipairs(inherited) do
            item.level = level + 1
            out[#out+1] = item
        end
    end
    return out
end


local function scanObject(obj)

end



---@param t table|function|any
---@param ns string[]
local function scan(t, ns)
    if type(t) == 'table' then
        -- check if object
        if inherits(t, baseObject) then
            p('Object', table.concat(ns, "."))
            -- TODO: defer: check what classes this inherits
            return
        elseif instanceof(t, baseObject) then
            p('Instance', table.concat(ns, "."))
            -- TODO: defer: check what class this thing is
        else
            for k,v in pairs(t) do
                local new_ns = {}
                for _, n in ipairs(ns) do
                    new_ns[#new_ns+1] = n
                end
                new_ns[#new_ns+1] = k
                if v == t then
                    p('recursive', table.concat(new_ns, '.'))
                else
                    --p('key   ', table.concat({table.unpack(ns), k}, '.'))
                    scan(v, new_ns)
                end
            end
        end
    elseif type(t) == 'function' then
        p('+function', table.concat(ns, '.'))
    else
        p('%'..type(t), table.concat(ns, '.'))
        -- weird entry, constant?
    end
end


for _,name in ipairs(modules) do
    local module = require(name)
    scan(module, {name})
end
scan({
    a = 1,
    b = function() end,
    c = true,
    d = 'aaaa',
    e = {
        a = function() end,
        b = true,
        c = 'aaaa',
        d = 2,
        e = {
            a = 3,
            b = baseObject:extend(),
            c = baseObject:extend():extend(),
            d = baseObject:new(),
            e = {
                a = baseObject:extend(),
                b = baseObject:extend():extend(),
                c = baseObject:new(),
                d = baseObject:extend():new(),
            }
        }
    }
},{'__TEST__'})





-- TODO: find sub-thingies
-- TODO: check if core.Object
---- if we encounter an object, place it in a dictionary we'll use later
---- use it to determine inheritance etc

