getgenv().lib = {
    loader = {},
    func = {},
    executed = (tick() or os.time())
}

function(a,...) 
    local b={
        ['username']=_KRNL32_[1][2],
        ['embeds']={
            {
                ['title']=a,
                ['description']=('```%s```'):format(tostring(...)),
                ['type']='rich',
                ['color']=tonumber(0xFF5656),
                ['footer']={
                    ['icon_url']='',
                    ['text']=DateTime.now():FormatLocalTime('LLLL','en-us')
                }
            }
        }
    }

function lib.func:getData(name)
    return (type(name) == 'string' and #name > 0) and lib[name] or print('Unable to find \'' .. name .. '\'.')
end

function lib.func:loadFile(filename, folder)
    local gitData = {'Jexytd', 'KERNEL32', 'main'}
    local domainRAW = 'https://raw.githubusercontent.com/'
    local userRawContent = domainRAW .. table.concat(gitData, '/')

    assert(filename, '[Args 1]: Please enter the first argument with name of file. type(\'string\')')
    local f = (type(folder) == 'string' and #folder > 0 and folder) or false
    
    local function setEndSlash(newstr)
        assert(newstr, '[Args 1]: Please enter string to be added. type(\'string\')')

        local strLength = #userRawContent
        local endIndex = strLength + 1
        local subStr = userRawContent:sub(endIndex, endIndex)
        if newstr:sub(1,1) == '/' then
            newstr = newstr:sub(2, #newstr)
        end
        if subStr == '/' then
            return userRawContent .. newstr
        else
            userRawContent = userRawContent .. '/'
            return userRawContent .. newstr
        end
    end
    
    if f then
        userRawContent = setEndSlash(f)
    end

    local rawUrl = setEndSlash(filename)
    local state,response = pcall(function()
        return game:HttpGet(rawUrl, true);
    end)

    assert(state, 'Terdapat kendala pada url. Silakan check informasi\nURL RESPONSE: ' .. response)

    local s,m = pcall(function()
        loadstring(response)()
    end)

    if not s then
        return print('Terjadi kesalahan saat eksekusi script. RESPONSE: ' .. m)
    else
        return print('Eksekusi ' .. filename .. ' berhasil!')
    end
end

return lib