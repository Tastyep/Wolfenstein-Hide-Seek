Modname = "^t#^7Hide^q&^7Seek"
     
    --global vars
	et.CS_PLAYERS = 689
	local	Alive = 0
	local	oldTime = 0
	local	mapstart_time = 0
	local	mapTime = 0
	local	gibList = {}
	local	pass = 0
	local	gib = true
	
	local restrict = {2, 3, 4, 9, 8}

 --[[weapons = {
            nil,            --// 1
            false,  --WP_LUGER,                             // 2
            false,  --WP_MP40,                              // 3
            false,  --WP_GRENADE_LAUNCHER,          // 4
            false,  --WP_PANZERFAUST,                       // 5
            false,  --WP_FLAMETHROWER,              // 6
            true,           --WP_COLT,                              // 7    // equivalent american weapon to german luger
            false,  --WP_THOMPSON,                  // 8    // equivalent american weapon to german mp40
            false,  --WP_GRENADE_PINEAPPLE, /       // 9
            false,  --WP_STEN,                              // 10   // silenced sten sub-machinegun
            true,           --WP_MEDIC_SYRINGE,             // 11   // JPW NERVE -- broken out from CLASS_SPECIAL per Id request
            true,           --WP_AMMO,                              // 12   // JPW NERVE likewise
            false,  --WP_ARTY,                              // 13
            false,  --WP_SILENCER,                  // 14   // used to be sp5
            false,  --WP_DYNAMITE,                  // 15
            nil,            --// 16
            nil,            --// 17
            nil,            --// 18
            true,           --WP_MEDKIT,                    // 19
            false,  --WP_BINOCULARS,                        // 20
            nil,            --// 21
            nil,            --// 22
            false,  --WP_KAR98,                             // 23   // WolfXP weapons
            false,  --WP_CARBINE,                   // 24
            false,  --WP_GARAND,                    // 25
            false,  --WP_LANDMINE,                  // 26
            false,  --WP_SATCHEL,                   // 27
            false,  --WP_SATCHEL_DET,                       // 28
            nil,            --// 29
            false,  --WP_SMOKE_BOMB,                        // 30
            false,  --WP_MOBILE_MG42,                       // 31
            false,  --WP_K43,                               // 32
            false,  --WP_FG42,                              // 33
            nil,            --// 34
            false,  --WP_MORTAR,                    // 35
            nil,            --// 36
            false,  --WP_AKIMBO_COLT,                       // 37
            false,  --WP_AKIMBO_LUGER,              // 38
            nil,            --// 39
            nil,            --// 40
            false,  --WP_SILENCED_COLT,             // 41
            false,  --WP_GARAND_SCOPE,              // 42
            false,  --WP_K43_SCOPE,                 // 43
            false,  --WP_FG42SCOPE,                 // 44
            false,  --WP_MORTAR_SET,                        // 45
            false,  --WP_MEDIC_ADRENALINE,          // 46
            false,  --WP_AKIMBO_SILENCEDCOLT,       // 47
            false   --WP_AKIMBO_SILENCEDLUGER,      // 48
}
--]]

function	findElem(elem, list)
	for idx, value in ipairs(list) do
		if (elem == value) then
			return idx
		end
	end
	return -1
end

function	getElapsedTime(time1, time2)
	return math.abs(time1 - time2)
end

function	add_to_gib(id)
	table.insert(gibList, id)
end

function	remove_from_gib(id)
	local	idx = findElem(id, gibList)

	if (idx == -1) then return -1 end
	table.remove(gibList, idx)
	return 0
end

function	force_ammos(levelTime, maxclients)
	for j = 0, maxclients do
		for k = 1, table.getn(restrict) do
			et.gentity_set(j, "ps.ammoclip", restrict[k], 0)
			et.gentity_set(j, "ps.ammo", restrict[k], 0)
		end
		et.gentity_set(j, "ps.ammo", 7, 150)
		et.gentity_set(j, "ps.powerups", 12, levelTime + 10000)
	end
end

 function 	et_ClientBegin(clientNum)
	et.trap_SendServerCommand(clientNum, "cp \"^t#^7LsD's ^7Hide^q&^7Seek\n" )
	et.trap_SendServerCommand(clientNum, "cpm \"^q!^7help to show your commands\"" )
 end 

 function	unlink_adlernest_hns(i)
		if et.gentity_get(i, "model") == "*80" or et.gentity_get(i, "model") == "*81" or et.gentity_get(i, "model") == "*82"
		or et.gentity_get(i, "model") == "*83" or et.gentity_get(i, "model") == "*84" or et.gentity_get(i, "model") == "*85" then
			et.trap_UnlinkEntity(i)
		end
		et.trap_UnlinkEntity(302) 
		et.trap_UnlinkEntity(303) 
		et.trap_UnlinkEntity(304)
		et.trap_UnlinkEntity(305)
		et.trap_UnlinkEntity(306) 
		et.trap_UnlinkEntity(307)
 end
 
function	et_InitGame(levelTime, randomSeed, rep_time)
	local	gamestate = tonumber(et.trap_Cvar_Get("gamestate"))
	local	mapname = string.lower(et.trap_Cvar_Get("mapname"))
	
	if (pass == 0) then
		for i = 64, 1021 do
			if (et.gentity_get(i, "classname") == "misc_mg42") then
				et.trap_UnlinkEntity(i)
			end
			if (mapname == "adlernest") then
				if (et.gentity_get(i, "origin") == "733 -2971 -120") then
					et.trap_UnlinkEntity(i)
				end
			elseif (mapname == "adlernest_hns") then
				unlink_adlernest_hns(i)
			end
		end
		pass = 1
	end
	if (gamestate == 0) then
		local	timelimit = et.trap_Cvar_Get("timelimit")
		
		mapstart_time = (levelTime - 1000) / 1000
		if (timelimit == nil or timelimit == "0" or timelimit == "100000") then
			et.trap_Cvar_Set("timelimit", "10")
		end
	end
	et.trap_SendServerCommand( -1, "cpm  \""..Modname.."config ^q[^7Loaded^q]\n\"")
    et.RegisterModname("^t#2 config")
    et.trap_SendServerCommand(-1, "chat \"^t#^7LsD's Hide^q&^7Seek, Good Luck^q&^7Have fun. Our Webiste: ^4-^7LsDfunwar.fr^t-\"" )
end

function	give_spawn_shield(client_team, axisSpawnInvul, alliedSpawnInvul)
	if (client_team == 1) then
		if (axisSpawnInvul == 0) then 
			et.gentity_set(clientNum, "ps.powerups", 1, spawnInvul + et_leveltime)
		else
			et.gentity_set(clientNum, "ps.powerups", 1, axisSpawnInvul + et_leveltime)
		end
	end
	if (client_team == 2) then
		if (alliedSpawnInvul == 0) then 
			et.gentity_set(clientNum, "ps.powerups", 1, spawnInvul + et_leveltime )
		else
			et.gentity_set(clientNum, "ps.powerups", 1, alliedSpawnInvul + et_leveltime )
		end
	end
end

function	et_ClientSpawn(clientNum, revived)
	local	gamestate = tonumber(et.trap_Cvar_Get("gamestate"))
	et.gentity_set(clientNum, "health", 130)   -- 130 =maxhp 

	if (revived == 0) then
		local spawnInvul = 3
		local axisSpawnInvul = 29000
		local alliedSpawnInvul = 29000
		local client_team = tonumber(et.gentity_get(clientNum, "sess.sessionTeam"))
		local cvar_axisInvul = et.trap_Cvar_Get( "g_axisSpawnInvul" )
		local cvar_alliedInvul = et.trap_Cvar_Get( "g_alliedSpawnInvul" )
		local cvar_spawnInvul = et.trap_Cvar_Get( "g_spawnInvul" )
		if (cvar_spawnInvul ~= "") then
			spawnInvul = tonumber(cvar_spawnInvul)
		end
		if et_leveltime then
			give_spawn_shield(client_team, axisSpawnInvul, alliedSpawnInvul)
		end
	end
	if (revived == 1 and gamestate == 0) then -- revived and playing
		remove_from_gib(clientNum)
		nameR = string.gsub(et.gentity_get(clientNum, "pers.netname"), "%^$", "^^ ")
		et.trap_SendServerCommand(-1, "cpm \""..nameR.." ^7got revived\"" )
	end
end

function	allied_slot(maxclients)
	local	b = {}

	for i = 0, maxclients do
		if (tonumber(et.gentity_get(i, "sess.sessionTeam")) == 2) then -- Allie
			table.insert(b, i)
		end
	end
	return b
end

function	make_gib_invincible()
	for i = 1, table.getn(gibList) do
		if (tonumber(et.gentity_get(gibList[i], "health")) > 0) then
			remove_from_gib(gibList[i])
		else
			et.gentity_set(gibList[i], "health", -1)
		end
	end
end

function	set_allie_hp(allie_id)
	for _, i in ipairs(allie_id) do
		et.gentity_set(i, "health", 1000)
	end
end

function 	round(number, precision)
	return math.floor(number*math.pow(10,precision)+0.5) / math.pow(10,precision)
end

--[[
	Gamestate value
	0: in game
	1: countdown
	2: warmup
	3: end of the map
--]]

function	getVar(varName)
	local	value = et.trap_Cvar_Get(varName)
	
	if (varName == "nextmap" and value ~= nil) then
		value = string.sub(value, 5)
	end
	return value
end

function	timeEvents(b_team, maxclients)
	if (mapTime == 2) then
		et.trap_SendServerCommand(-1, "cpm \"^7Both teams are ^qINVINCIBLE ^7and Allies are ^qBLIND ^7for ^q30 ^7seconds\"" )
	end
	if (mapTime < 30) then
		local rest = round(30 - mapTime, 0)

		for i = 1, table.getn(b_team) do
			et.trap_SendServerCommand(b_team[i] , "cp \"^2"..rest.."\"") -- b_team[i]
		end
	elseif (mapTime == 30) then
		et.G_globalSound("sound/chat/axis/14a.wav")         
		et.trap_SendServerCommand(-1, "cpm \"^7You are ^qNOT invincible^7 anymore, Run for your life !\"")
		for i = 1, table.getn(b_team) do
			et.trap_SendServerCommand(b_team[i], "cp \"^7Kill them all ^p!\"")
		end
	end
	if (gib == true and mapTime == (3 * 60))then
		et.trap_SendServerCommand( -1, "cp \"^7Gib Enabled ^q! ^7No more chances ^q!\"" )
	end
	if (mapTime == (9 * 60 + 30)) then -- last 30 sec
		if (Alive > 1) then
			et.trap_SendServerCommand( -1, "cp \"^q30 ^7seconds remaining and ^q".. Alive .." ^7axis Alive ^p!\"" )
		elseif (Alive == 1) then
			print_last_alive(maxclients)
		end
	elseif (mapTime == (10 * 60)) then -- print end message
		et.G_globalSound("sound/chat/axis/586a.wav")
		et.trap_SendServerCommand( -1, "cp \"^7Axis ^qWON ^7the game !\"" )	
	elseif (mapTime) == (10 * 60 + 5) then -- force end
		et.trap_SendConsoleCommand(et.EXEC_APPEND, "ref shuffleteamsxp")
	end
end

function	et_RunFrame(levelTime)
	local	maxclients = tonumber((et.trap_Cvar_Get("sv_maxClients")) - 1)
	local	b_team = allied_slot(maxclients)
	local	tmp

	mapTime = (levelTime / 1000) - mapstart_time
	force_ammos(levelTime, maxclients)
	set_allie_hp(b_team)
	make_gib_invincible()
	if (getElapsedTime(oldTime, levelTime) > 1000) then	-- check every second
		local	gamestate = tonumber(et.trap_Cvar_Get("gamestate"))

		mapTime = math.floor(mapTime)
		oldTime = levelTime
		if (gamestate == 0) then
			tmp = Inlive(maxclients)
			if (Alive == 2 and tmp == 1) then
				last(maxclients)
			end
			Alive = tmp
			timeEvents(b_team, maxclients)
		end
	end
end

function	et_Obituary(victim, killer, meansofdeath)		
	local	vic = string.gsub(et.gentity_get(victim, "pers.netname"), "%^$", "^^ ")
	local	kil = nil
	local	teamK = nil
	if (killer ~= nil) then
		kil = string.gsub(et.gentity_get(killer, "pers.netname"), "%^$", "^^ ")
		teamK = tonumber(et.gentity_get(killer, "sess.sessionTeam"))
	end
	local	teamV = tonumber(et.gentity_get(victim, "sess.sessionTeam"))
	local	soundindex = et.G_SoundIndex("sound/player/gib.wav" )
	local	soundindex2 = et.G_SoundIndex("sound/player/gasp.wav" )
	local	numA = alliec()
	
	-- 2 Allied		
	-- 1 Axis
	if (gib == false or (gib == true and mapTime > 30 and mapTime < 180)) then
		add_to_gib(victim)
	end
	if (teamK == 2 and teamV == 1) then
		if (gib == true and mapTime < (3 * 60) and Alive > 1) then
			et.trap_SendServerCommand(-1, "bp \"^7Gib is ^qDISABLED ^7until 7\n \"" )
		end
	end
	return 0
end

-- checking functions

function checkmuted(client)
	return et.gentity_get(client, "sess.muted", 1)
end

function	et_ClientCommand(client, command)
	local	argc = et.trap_Argc()
	local	i = 0
	local	arg = {}
	
	while (i < argc) do
		arg[i + 1] = et.trap_Argv(i)
		i = i + 1
	end
	
	local	command = string.lower(command)
    local	gamestate = tonumber(et.trap_Cvar_Get( "gamestate"))
	local	teamc = tonumber(et.gentity_get(client, "sess.sessionTeam"))
	
	if (gamestate == 0) then
		if (command == "kill") then
			et.trap_SendServerCommand( client, "cp \"^7Self kill is ^1Disabled ^7during the game^z.\n\"" )
			return 1
        elseif (command == "forcetapout") then
			et.trap_SendServerCommand( client, "cp \"^7As self killing, ^qForcetapout ^7is ^qDisabled ^7during the game^p.\n\"" )
			return 1
		end
	end
	-- private message
	if (command == "m" or command == "pm" or command == "msg" or command == "mp") then
		if (checkmuted(client) == 1) then
			et.trap_SendServerCommand( client, "cp \"^7You are ^qMuted^7 and not allowed to send private messages^p.\n\"" )
			return 1
		end
	end	
	-- SAVE & LOAD
	if (command == "save" or command == "load") then 
		if (gamestate == 0) then
			et.trap_SendServerCommand(client, "cp \"^7This command is ^qDisabled ^7during the game^z.\n\"" )
			return 1
		end
	end
	-- callvote
	if (command == "callvote") then
		if (checkmuted(client) == 1) then -- client is muted
			et.trap_SendServerCommand( client, "cp \"^7You are ^qMuted^7 and not allowed to vote^p.\n\"" )
            return 1
		elseif (gamestate == 0 and mapTime > (7 * 60)) then -- 7min
			et.trap_SendServerCommand(client, "cp \"^7This command is ^qdisabled ^7because the map end in less than ^q3 ^7min\n\"" )
			return 1
		end
	end
	if (command == "team") then
		if (gamestate == 1 and teamc ~= 3) then
			et.trap_SendServerCommand(client, "cp \"^7You ^qcan't switch ^7during the Countdown\n\"" )
			return 1
		elseif (gamestate == 0) then
			if (teamc == 3) then
				et.trap_SendServerCommand(client, "cp \"^7Spectators can't join a team if the match has already started\n\"")
				return 1
			end
		end
	end
	return 0
end

function	totalp()
	local	maxclients = tonumber((et.trap_Cvar_Get("sv_maxClients")) - 1)
	local	numA = 0
	local	numB = 0
	local	numS = 0
	
	for i = 0, maxclients, 1 do
		clientteam = tonumber(et.gentity_get(i, "sess.sessionTeam"))
		if (clientteam == 1) then -- Axis
			numA = numA + 1
		elseif (clientteam == 2) then -- Allies
			numB = numB + 1
		end
	end
	return numA, numB
end

function	alliec()
	local	numAllies = 0
	local	maxclients = tonumber((et.trap_Cvar_Get("sv_maxClients")) - 1)

	for i = 0, maxclients, 1 do
		clientteam = tonumber(et.gentity_get(i, "sess.sessionTeam"))
		if (clientteam == 2) then -- Allies
			numAllies = numAllies + 1
		end
	end
	return numAllies
end

function	Inlive(maxclients)
	local	countAlive = 0

	for i = 0, maxclients do
		if (tonumber(et.gentity_get(i, "sess.sessionTeam")) == 1) then -- if axis
			if (tonumber(et.gentity_get(i, "health")) > 0) then -- if alive2
				countAlive = countAlive + 1
			end
		end
	end
	return countAlive
end	

function	last(maxclients)
	for i = 0, maxclients do
		local hp = tonumber(et.gentity_get(i, "health"))
		if (hp > 0) then
			local teamA = tonumber(et.gentity_get(i, "sess.sessionTeam"))
			if (teamA == 1) then -- Axis
				local nameA = string.gsub(et.gentity_get(i, "pers.netname"), "%^$", "^^ ")
				et.trap_SendServerCommand(-1, "cp \"^7"..nameA.." ^7is the ^qLAST ^7Axis Alive with ^2"..hp.." ^7hp\n\"" )
			end
		end
	end		
end

function	print_last_alive(maxclients)
	for i = 0, maxclients do
		local	hp = tonumber(et.gentity_get(i, "health"))
		if (hp > 0) then
			if (tonumber(et.gentity_get(i, "sess.sessionTeam")) == 1) then -- Axis
				local nameA = string.gsub(et.gentity_get(i, "pers.netname"), "%^$", "^^ ")
				et.trap_SendServerCommand(-1, "cp \"^q30 ^7seconds remaining and "..nameA.."^7 is still running with ^q"..hp.." ^7hp ^p!\"")
			end
		end
	end
end

function	et_ClientDisconnect(clientNum)
	local	idx = findElem(clientNum, gibList)
	
	if (idx ~= -1) then
		table.remove(gibList, idx)
	end			
end

function et_ClientConnect(clientNum, firstTime, isBot)
	local	idx = findElem(clientNum, gibList)
	
	if (idx ~= -1) then
		table.remove(gibList, idx)
	end			
end