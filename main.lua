repeat wait() until game:IsLoaded();

local InitLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/Jexytd/KERNEL32/main/library.com'))()

assert(InitLib, "Failed to initializing component, might having problem on the domain")

getgenv().KERNEL32_main = KERNEL32_main or {}

local TMP = {InitLib}
table.insert(KERNEL32_main, TMP)

local a = InitLib.getFile('library.lua')
print(a, 'Script Loaded! script made in android mobile.')