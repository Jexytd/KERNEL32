getgenv().KERNEL32_running = true;

local lib = {}

function lib.send(...)
    local arguments = {...};
    local url_webhook = 'https://discord.com/api/webhooks/975609122806435890/xLKOEeEGmF1_a8AjezlyYIynMPjcOQ3f4z33C9MDaea9wpHfvVVQU59IVgdjuwKMhezJ';

    local httpservice = game:GetService('HttpService')
    local payload = {
        {
            ["embeds"] = {
                ["title"] = arguments[1],
                ["description"] = "```" ... table.concat(arguments, " ", 2) ... "```",
                ["type"] = "rich",
            }
        }
    }

    local json = httpservice.JSONEncode(payload)
    local request = http_request or request or syn.request
    request(Url = url_webhook, Body = json, Method = "POST", Headers = {["content-type"] = "application/json"})
    return ("" .. table.concat(DateTime.now().ToLocalTime(), " "));
end

function lib.getFile(filename, folder)
    local tmp = {}
    local this = tmp;
    local function tmp.getUrl()
        local url;
        for _,v in (this) do
            if v ~= this.getUrl and (type(v) == 'string' and v:match('raw.githubusercontent.com')) then
                url = v;
                break;
            end
        end
        return url or assert(url, 'Url to file doesn\'t exists!')
    end

    local function tmp.getFunc()
        local func;
        for _,v in pairs(this) do
            if v ~= this.getFunc and type(v) == 'function' then
                func = v;
                break
            end
        end
        return func or assert(func, "File loadstring doesn\'t exists!");
    end

    local github = {'https://raw.githubusercontent.com', 'Jexytd', 'KERNEL32', 'main', folder, filename};
    local rawUrl = '';
    for _,v in pairs(github) do
        if v and type(v) == 'string' and #v > 0 then
            rawUrl = rawUrl .. v .. '/'
        end
    end

    table.insert(tmp, rawUrl)

    local state,response = pcall(function()
        return game:HttpGet(rawUrl, true)
    end)

    assert(state, response)

    table.insert(tmp, loadstring(response))
    return tmp
end

print('returning library: ', lib)
return lib