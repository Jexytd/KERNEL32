function GetGithubFile(file, folder, username, repo, branch)
    local githubRaw = 'https://raw.githubusercontent.com/'
    local urlFile = githubRaw + username + '/' + repo + '/' + branch + '/'
    if (folder and type(folder) == 'string' and #folder >= 1) then
        urlFile = urlFile + folder + '/'
    end
    urlFile = urlFile + file

    print(urlFile)

    local state, response = pcall(function()
        return game:HttpGet(urlFile);
    end)

    if not state then
        return 'Failed acquire file string. There may be an error in the url, [' + urlFile + ']';
    end

    local files = loadstring(response);
    return files or 'File are unable converted to be function!'
end

local library = GetGithubFile('library.lua', nil, 'Jexytd', 'KERNEL32', 'main')
print(library)
if library then library() else print('Uhh') end