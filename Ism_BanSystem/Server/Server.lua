ESX = nil

TriggerEvent(Config.LoadEsxString, function(obj) ESX = obj end)


local Datas = {}
Datas['BannedUsers'] = json.decode(LoadResourceFile(GetCurrentResourceName(), './Data.json')) 
print(' ^1| ^3Create ^2By ^4Nimaism#4092 ^1| ^0')



AddEventHandler('playerConnecting', function(name, setKickReason)
    local source = source
    local Steam = "NONE"
    local License = "NONE"
    local Live = "NONE"
    local Xbox = "NONE"
    local Discord = "NONE"
    local Ip = "NONE"
    local UnbanEndTime = false
    local SteamBannedEndTime = 'NONE'
    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1,string.len("steam:")) == "steam:" then
            Steam = v
        elseif string.sub(v, 1,string.len("license:")) == "license:" then
            License = v
        elseif string.sub(v, 1,string.len("live:")) == "live:" then
            Live = v
        elseif string.sub(v, 1,string.len("xbl:")) == "xbl:" then
            Xbox = v
        elseif string.sub(v,1,string.len("discord:")) == "discord:" then
            Discord = v
        elseif string.sub(v, 1,string.len("ip:")) == "ip:" then
            Ip = v
        end
    end
    if Steam == nil or License == nil or Steam == "" or License == "" or Steam == "NONE" or License == "NONE" then
        setKickReason("\n NImaism_BanSystem \n ---------------- \n There Is A Problem Retrieving Your Fivem Information \n Please Restart FiveM. \n  ---------------- ")
        CancelEvent()
        return
    end
    if GetNumPlayerTokens(source) == 0 or GetNumPlayerTokens(source) == nil or GetNumPlayerTokens(source) < 0 or GetNumPlayerTokens(source) == "null" or GetNumPlayerTokens(source) == "**Invalid**" or not GetNumPlayerTokens(source) then
        setKickReason("\n NImaism_BanSystem \n ---------------- \n There Is A Problem Retrieving Your Fivem Information \n Please Restart FiveM. \n  ---------------- ")
        CancelEvent()
        return
    end
    Datas['BannedUsers'] = Datas['BannedUsers'] or {}
    for UserSteam, Values in pairs(Datas['BannedUsers']) do
        for t, TokenId in pairs(Values.Token) do
            for Hd = 0, GetNumPlayerTokens(source) - 1 do
                if GetPlayerToken(source, Hd) == TokenId or Values.License == tostring(License) or Values.Live == tostring(Live) or Values.Xbox == tostring(Xbox) or Values.Discord == tostring(Discord) or Values.Ip == tostring(Ip) or UserSteam == tostring(Steam) then
                    if os.time() < tonumber(Values.Expire) then
                        if UserSteam ~= tostring(Steam) then
                            setKickReason('NImaism_BanSystem : \n ---------------- \n Dont Change Steam Acc  \n  ----------------')
                        end
                        setKickReason("NImaism_BanSystem : \n ---------------- \n Ban ID : "..Values.Id.. "\n Reason : "..Values.Reason.."\n Expiration : "..math.floor(((tonumber(Values.Expire) - os.time())/86400)).." Days \n Steam Hex :"..Steam.."\n Harward Id : "..TokenId.." \n  ----------------")
                        CancelEvent()
                        break
                    else
                        SteamBannedEndTime = UserSteam
                        UnbanEndTime = true
                        break
                    end
                end
            end
        end
    end
    if UnbanEndTime then 
        Unban(SteamBannedEndTime, 'Expire Time Is Up')
    end    
end)

RegisterServerEvent("NImaism_BanSystem:CBan")
AddEventHandler("NImaism_BanSystem:CBan", function(Hex)
    if Datas['BannedUsers'][Hex] then 
        return true 
    end 
    return false   
end)


RegisterCommand(Config.ReloadCmd, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.permission_level >= Config.PermNeed then
        ReloadBans()
        TriggerClientEvent('chatMessage', source, "[BanSystem]", {255, 0, 0}, " ^0Ban List Reloaded.")
    else
        if source ~= 0 then
            TriggerClientEvent('chatMessage', source, "[BanSystem]", {255, 0, 0}, " ^0You Do Not Have Access.")
        end
    end
end)


RegisterCommand(Config.BanCmd, function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local target = tonumber(args[1])
    if xPlayer.permission_level >= Config.PermNeed then
        if args[1] then
            if tonumber(args[2]) then
                if tostring(args[3]) then
                    if tonumber(args[1]) then
                        if GetPlayerName(target) then
                            BanUser(tonumber(target), tonumber(args[2]), table.concat(args, " ",3) )
                        else
                            TriggerClientEvent('chatMessage', source, "[BanSystem]", {255, 0, 0}, " ^0Player Is Not Online.")
                        end
                    else
                        if string.find(args[1], "steam:") ~= nil then
                            OffBanUser(args[1], tonumber(args[2]), table.concat(args, " ",3))
                        else
                            TriggerClientEvent('chatMessage', source, "[BanSystem]", {255, 0, 0}, " ^0Incorrect Steam Hex.")
                        end
                    end
                else
                    TriggerClientEvent('chatMessage', source, "[BanSystem]", {255, 0, 0}, " ^0Please Enter Ban Reason.")
                end
            else
                TriggerClientEvent('chatMessage', source, "[BanSystem]", {255, 0, 0}, " ^0Plaease Enter Ban Duration.")
            end
        else
            TriggerClientEvent('chatMessage', source, "[BanSystem]", {255, 0, 0}, " ^0Please Enter Server ID Or Steam Hex.")
        end
    else
        if source ~= 0 then
            TriggerClientEvent('chatMessage', source, "[BanSystem]", {255, 0, 0}, " ^0You Do Not Have Access.")
        end
    end
end)


RegisterCommand(Config.UnBanCmd, function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.permission_level >= Config.PermNeed then
        if tostring(args[1]) then
            if args[2] then 
                Datas['BannedUsers'] = Datas['BannedUsers'] or {}
                if Datas['BannedUsers'][args[1]] then 
                    Unban(args[1],  args[2])
                    TriggerClientEvent('chatMessage', source, "[BanSystem]", {255, 0, 0}, " ^0Successful To Unban "..args[1])
                else
                    TriggerClientEvent('chatMessage', source, "[BanSystem]", {255, 0, 0}, " ^0Player Is Not Banned")
                end    
            else    
                TriggerClientEvent('chatMessage', source, "[BanSystem]", {255, 0, 0}, " ^0The Entered Reason Is Incorrect.")
            end    
        else
            TriggerClientEvent('chatMessage', source, "[BanSystem]", {255, 0, 0}, " ^0The Entered Steam Is Incorrect.")
        end
    else
        if source ~= 0 then
            TriggerClientEvent('chatMessage', source, "[BanSystem]", {255, 0, 0}, " ^0You Do Not Have Access.")
        end
    end
end)


function BanUser(Target, Day, Reason)
    local Time
    local Day = tonumber(Day)
    local Name = GetPlayerName(Target)
    local Id = GID(6)
    if Day == 0 then
        Time = 99999
    else
        Time = Day
    end
    local Hex = "None"
    local LC = "None"
    local LV = "None"
    local XB = "None"
    local DS = "None"
    local Ip = "None"
    for k, v in ipairs(GetPlayerIdentifiers(Target)) do
        if string.sub(v, 1,string.len("steam:")) == "steam:" then
            Hex  = v
        elseif string.sub(v, 1,string.len("license:")) == "license:" then
            LC  = v
        elseif string.sub(v, 1,string.len("live:")) == "live:" then
            LV  = v
        elseif string.sub(v, 1,string.len("xbl:")) == "xbl:" then
            XB = v
        elseif string.sub(v,1,string.len("discord:")) == "discord:" then
            DS = v
        elseif string.sub(v, 1,string.len("ip:")) == "ip:" then
            Ip = v
        end
    end 
    Datas['BannedUsers'] = Datas['BannedUsers'] or {}
    Datas['BannedUsers'][Hex] = Datas['BannedUsers'][Hex] or {}
    Datas['BannedUsers'][Hex]['IsBan'] = true
    Datas['BannedUsers'][Hex]['License'] = LC
    Datas['BannedUsers'][Hex]['Id'] = Id
    Datas['BannedUsers'][Hex]['Discord'] = DS
    Datas['BannedUsers'][Hex]['Xbox'] = XB
    Datas['BannedUsers'][Hex]['Ip'] = Ip
    Datas['BannedUsers'][Hex]['Live'] = LV
    Datas['BannedUsers'][Hex]['Reason'] = Reason
    Datas['BannedUsers'][Hex]['Expire'] = os.time() + (Time * 86400)
    Datas['BannedUsers'][Hex]['Token'] = {}
    for i = 0, GetNumPlayerTokens(Target) - 1 do        
        table.insert(Datas['BannedUsers'][Hex]['Token'], GetPlayerToken(Target, i))
    end
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 1.1vw; margin: 1.0vw; background-color: rgba(250, 215, 170, 0.7);border-radius:12px;">^0<i class="" size: 7x></i> {0}^0<br>{1}</br></div>',
        args = { 'BanSystem', '^1' .. Name .. ' ^0Banned \n Reason: ^1' ..Reason.." ^0Time: ^1"..Time.." ^0 Days."}
    })
    DropPlayer(Target, '\n NImaism_BanSystem \n Reason : '..Reason..'\n Expiration : '..Time..' Days !')
    ReloadBans()
    local fields = {
        {
            name = 'Name :',
            value = Name,
            inline = false
        },
        {
            name = 'Time :',
            value = Time..' Days',
            inline = false
        },
        {
            name = 'Reason',
            value = Reason,
            inline = false
        },
        {
            name = 'Steam Hex',
            value = Hex,
            inline = false
        },
        {
            name = 'Ban Id',
            value = Id,
            inline = false
        },
    }    
    SendLog(fields)
end

function OffBanUser(Hex, Day, Reason)
    local Time
    local Day = tonumber(day)
    local Id = GID(6)
    if Day == 0 then
        Time = 99999
    else
        Time = Day
    end
    Datas['BannedUsers'] = Datas['BannedUsers'] or {}
    Datas['BannedUsers'][Hex] = Datas['BannedUsers'][Hex] or {}
    Datas['BannedUsers'][Hex]['IsBan'] = true
    Datas['BannedUsers'][Hex]['Id'] = Id
    Datas['BannedUsers'][Hex]['Reason'] = Reason
    Datas['BannedUsers'][Hex]['Expire'] = os.time() + (Time * 86400)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 131, 0, 0.4); border-radius: 3px;"><i class="fas fa-exclamation-triangle"></i> [Punishment]<br>  {1}</div>',
        args = { name, '^1' .. Hex .. ' ^0Banned, Reason: ^1' ..Reason.." ^0Duration: ^1"..Time.." ^0 Days."}
    })
    ReloadBans()
    local fields = {
        {
            name = 'Steam Hex',
            value = Hex,
            inline = false
        },
        {
            name = 'Time :',
            value = Time,
            inline = false
        },
        {
            name = 'Reason',
            value = Reason,
            inline = false
        },
        {
            name = 'Ban Id',
            value = Id,
            inline = false
        },    
    }        
    SendLog(fields)

end

function Unban(Hex, Reason)
    Datas['BannedUsers'] = Datas['BannedUsers'] or {}
    Datas['BannedUsers'][Hex] = nil
    ReloadBans()
    local fields = {
        {
            name = 'Steam Hex',
            value = Hex,
            inline = false
        },
        {
            name = 'Reason',
            value = Reason,
            inline = false
        }, 
    }            
    SendLog(fields)


    
end

function ReloadBans()
    SaveResourceFile(GetCurrentResourceName(), 'Data.json', json.encode(Datas['BannedUsers']))
    Datas['BannedUsers'] = {}
    Datas['BannedUsers'] = json.decode(LoadResourceFile(GetCurrentResourceName(), 'Data.json'))
    print('[NImaism-BanSystem] Banned Users Updated')
end

function GID(l)
	local res = ""
	for i = 1, l do
		res = res .. string.char(math.random(97, 122))
	end
	return(res) 
end

function SendLog(Field)
    local embeds = {
    {   
            title = '✨ Ban System',
            description = '',
            color = 3666853,
            footer = {
                text = 'NImaism Ban System | '..os.date("%x %X  %p"),
            },
            fields = Field,
            thumbnail = {
                url = 'https://cdn.discordapp.com/attachments/887425896565334046/927863995216592926/JKKGBKJB.gif',
            },
        },
    }
  
    PerformHttpRequest(Config.Url, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embeds}), { ['Content-Type'] = 'application/json' })
  end