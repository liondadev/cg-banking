-- CGBanking -> A banking addon for a CivilGamers Developer Application
-- Written by @liondadev
CGBanking = CGBanking or {}
CGBanking.Config = CGBanking.Config or {}
CGBanking.BaseDir = "cgbanking/"

-- Some general settings for the addon, not to be changed by normies
CGBanking.PrefixColor = Color(255, 75, 75)
CGBanking.PrintTextColor = Color(255, 255, 255)
CGBanking.PrefixText = "[CGBanking] "

-- CGBanking.Print(msg: string) is a utility function for printing to the console
function CGBanking.Print(msg)
    MsgC(CGBanking.PrefixColor, CGBanking.PrefixText, CGBanking.PrintTextColor, msg .. "\n")
end

-- CGBanking.LoadShared(fileName: string) will include a file shared
function CGBanking.LoadShared(fileName)
    local f = CGBanking.BaseDir .. fileName

    if SERVER then
        AddCSLuaFile(f)
        include(f)
    else
        include(f)
    end
end

-- CGBanking.LoadServer(fileName: string) will include a file serverside
function CGBanking.LoadServer(fileName)
    local f = CGBanking.BaseDir .. fileName

    if SERVER then
        include(f)
    end
end

-- CGBanking.LoadClient(fileName: string) will include a file clientside
function CGBanking.LoadClient(fileName)
    local f = CGBanking.BaseDir .. fileName

    if SERVER then
        AddCSLuaFile(f)
    else
        include(f)
    end
end

-- Load Things
CGBanking.LoadShared("config.lua")
CGBanking.LoadServer("mysql.lua")
CGBanking.LoadServer("core/sv_init.lua")
CGBanking.LoadClient("core/cl_menu.lua")
