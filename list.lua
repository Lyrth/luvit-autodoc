


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


local function getParams(f)
    assert(type(f) == 'function', "bad argument #1 to 'getParams' (function expected)")
    local params = {}

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

    return out
end

for _,module in ipairs(modules) do

end

p(getFunctions(require'buffer'.Buffer))



-- TODO: find sub-thingies
-- TODO: check if core.Object
---- if we encounter an object, place it in a dictionary we'll use later
---- use it to determine inheritance etc


