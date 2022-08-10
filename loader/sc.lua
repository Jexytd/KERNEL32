repeat wait() until game:IsLoaded()

local CLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/STX"))()
local Console = CLib:Window({
    Title = "KERNEL32 - Output",
    Position = UDim2.new(0.5, 0, 0.5, 0),
    DragSpeed = 12
})

getgenv().CPrompt = function(type,text)
    local types = {
        "default",
        "success",
        "fail",
        "warning",
        "nofitication"
    }
    assert(type, '[' .. table.concat(types, ' ') .. ']')
    assert(text, 'Please provide a text to being prompt.')
    CLib:Prompt({
        Title = text,
        TypesWeHave = {
            "default",
            "success",
            "fail",
            "warning",
            "nofitication"
        },
        Type = type
    })
end

function JEncode(t) return game:GetService('HttpService'):JSONEncode(t); end
function JDecode(s) return game:GetService('HttpService'):JSONDecode(game:HttpGet(s)); end

local LIST = JDecode('https://raw.githubusercontent.com/Jexytd/KERNEL32/main/loader/list.json')
local _VERSION = LIST['version']

function _getGame(PID)
    local SCRIPT = LIST['script']
    local Result;
    for _,v in pairs(SCRIPT) do
        local EQ = (table.concat(v['PlaceId'], ' ')):find(PID)
        if EQ then
            Result = v;
        end
    end
    return Result
end

update = false;

--/ Check Version /--
CPrompt('nofitication', 'Checking hub version...')
coroutine.wrap(function()
    local FPATH = './KERNEL32'
    local FILE = './KERNEL32/version.ot'
    if (not isfolder(FPATH)) then
        pcall(makefolder, FPATH)
    end

    local oldVersion = false;
    if (isfile(FILE)) then
        oldVersion = true;
    end

    if (oldVersion) then
        CPrompt('warning', 'Old version detected! trying to update to new version...')
        update = true;
        local VERSION = readfile(FILE)
        local DATA = JDecode(VERSION)
        if (DATA['version'] ~= _VERSION) then
            pcall(delfile, FILE)
        end
    end

    if (not isfile(FILE)) then
        CPrompt('success', 'Hub now on up-to-date version')
        local format = {
            ['version'] = _VERSION
        }
        local encoded = JEncode(format)
        pcall(writefile, FILE, encoded)
    end
end)

--/ Hub updated /--
coroutine.wrap(function()
    if (update) then
        local FILE = './KERNEL32/scriptVersion.ot'
        local GAME = _getGame(game.PlaceId)
        local NAME = GAME['GameName']

        local FILE_TEXT = readfile(FILE)
        local DATA_FILE = JDecode(FILE_TEXT)

        local function getVersion(n)
            local ver;
            for _,v in pairs(DATA_FILE) do
                if v['GameName'] == n then
                    ver = v['version']
                end
            end
            return ver;
        end

        if (isfile(FILE)) then
            CPrompt('warning', NAME .. ' old version detected! trying to update to new version...')
            local OLD_VERSION = getVersion(NAME)
            if OLD_VERSION ~= GAME['scriptVer'] then
                pcall(delfile, FILE)
            end
        end

        if (not isfile(FILE)) then
            local format = (function()
                local newTable = {}
                for _,v in pairs(LIST['script']) do
                    local FORMAT = {
                        ['GameName'] = NAME;
                        ['scriptVer'] = v['scriptVer']
                    }
                    table.insert(newTable, FORMAT)
                end
                return newTable;
            end)()
            local encoded = JEncode(format)
            pcall(writefile, FILE, encoded)
            CPrompt('success', NAME .. ', now on up-to-date version')
        end
    end
end)

--/ Create Player Settings /--
coroutine.wrap(function()
    local FILE = './KERNEL32/settings.ot'

    if (isfile(FILE)) then
        CPrompt('nofitication', 'Updating player settings...')
        local oldFILE = readfile(FILE)
        local DATA = JDecode(oldFILE);
        local player = DATA['player']
        
        local noId = true
        for _,v in pairs(player) do
            if v['userid'] == game:GetService('Players').LocalPlayer.UserId then
                noId = false;
            end
        end

        if noId then
            local format = {
                ["userid"] = game:GetService('Players').LocalPlayer.UserId,
                ["data"] = {}
            }
            table.insert(DATA['player'], format)
            CPrompt('nofitication', 'Adding new player/id to settings')

            local encoded = JEncode(DATA)
            pcall(writefile, FILE, encoded)
            CPrompt('success', 'Player settings updated!')
        end
    end

    if (not isfile(FILE)) then
        CPrompt('nofitication', 'Creating player settings...')
        local format = {
            ['player'] = {
                {
                    ["userid"] = game:GetService('Players').LocalPlayer.UserId,
                    ["data"] = {}
                }
            }
        }
        local encoded = JEncode(format)
        pcall(writefile, FILE, encoded)
        CPrompt('success', 'Player settings created!')
    end
end)

CPrompt('success', 'Running script...')