function GetGithubFile(file, folder)
    local dataGithub = ['Jexytd', 'KERNEL32', 'main']
    local githubRaw = 'https://raw.githubusercontent.com/' .. dataGithub[1] .. '/' .. dataGithub[2] .. '/' .. dataGithub[3] .. '/';

    if folder and type(folder) == 'string' and #folder >= 1 then
        githubRaw = githubRaw .. folder .. '/'
    end

    githubRaw = githubRaw .. file

    local state, response = pcall(function()
        return game:HttpGet(githubRaw);
    end)

    if not state then
        return 'Failed acquire string of file. There may be an error in the url, [' + githubRaw + ']';
    end

    local files = loadstring(response);
    return files or 'File are unable converted to be function!'
end

local library = GetGithubFile('library.lua')
print(library)
if library then library() else print('Uhh') end