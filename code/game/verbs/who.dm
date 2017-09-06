
/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/msg = "<b>Current Players:</b>\n"

	var/list/Lines = list()

	//for admins
	var/living = 0 //Currently alive and in the round (possibly unconscious, but not officially dead)
	var/dead = 0 //Have been in the round but are now deceased
	var/observers = 0 //Have never been in the round (thus observing)
	var/lobby = 0 //Are currently in the lobby
	var/living_antags = 0 //Are antagonists, and currently alive
	var/dead_antags = 0 //Are antagonists, and have finally met their match

	if(holder && (R_ADMIN & holder.rights || R_MOD & holder.rights))
		for(var/client/C in clients)
			var/entry = "\t[C.key]"
			if(C.holder && C.holder.fakekey)
				entry += " <i>(as [C.holder.fakekey])</i>"
			entry += " - Playing as [C.mob.real_name]"
			switch(C.mob.stat)
				if(UNCONSCIOUS)
					entry += " - <font color='darkgray'><b>Unconscious</b></font>"
				if(DEAD)
					if(isobserver(C.mob))
						var/mob/dead/observer/O = C.mob

						if(O.started_as_observer)
							entry += " - <span style='color:gray'>Observing</span>"
							observers++
						else
							entry += " - <b>DEAD</b>"
							dead++
					else if (isnewplayer(C.mob))
						entry += " - <span style='color:gray'><i>Lobby</i></span>"
						lobby++
					else
						entry += " - <b>DEAD</b>"
						dead++
				else
					living++

			var/age
			if(isnum(C.player_age))
				age = C.player_age
			else
				age = 0

			if(age <= 1)
				age = "<font color='#ff0000'><b>[age]</b></font>"
			else if(age < 10)
				age = "<font color='#ff8c00'><b>[age]</b></font>"

			entry += " - [age]"

			if(is_special_character(C.mob))
				entry += " - <b><font color='red'>Antagonist</font></b>"
				if (istype(src.mob, /mob/dead/observer))  ///obj/item/organ/brain //
					dead_antags++
				else
					living_antags++
			entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
			Lines += entry

	else
		for(var/client/C in clients)
			if(C.holder && C.holder.fakekey)
				Lines += C.holder.fakekey
			else
				Lines += C.key

	for(var/line in sortList(Lines))
		msg += "[line]\n"
	if(holder && (R_ADMIN & holder.rights || R_MOD & holder.rights))
		msg += "<b><span class='notice'>Total Living: [living]</span> | Total Dead: [dead] | <span style='color:gray'>Observing: [observers]</span> | <span style='color:gray'><i>In Lobby: [lobby]</i></span> | <span class='bad'>Living Antags: [living_antags]</span> | <span class='good'>Dead Antags: [dead_antags]</span></b>\n"
		msg += "<b>Total Players: [length(Lines)]</b>\n"
		to_chat(src, msg)
	else
		msg += "<b>Total Players: [length(Lines)]</b>"
		to_chat(src, msg)
		src << msg

/client/verb/staffwho()
	set category = "Admin"
	set name = "Staffwho"

	var/msg = ""
	var/modmsg = ""
	var/cciaamsg = ""
	var/devmsg = ""
	var/num_mods_online = 0
	var/num_admins_online = 0
	var/num_cciaa_online = 0
	var/num_devs_online = 0
	if(holder)
		for(var/client/C in admins)
			if(R_ADMIN & C.holder.rights || (!R_MOD & C.holder.rights))	//Used to determine who shows up in admin rows

				if(C.holder.fakekey && (!R_ADMIN & holder.rights && !R_MOD & holder.rights))		//Mentors can't see stealthmins
					continue

				msg += "\t[C] is a [C.holder.rank]"

				if(C.holder.fakekey)
					msg += " <i>(as [C.holder.fakekey])</i>"

				if(isobserver(C.mob))
					msg += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					msg += " - Lobby"
				else
					msg += " - Playing"

				if(C.is_afk())
					msg += " (AFK)"
				msg += "\n"

				num_admins_online++
			else if(R_MOD & C.holder.rights)				//Who shows up in mod/mentor rows.
				modmsg += "\t[C] is a [C.holder.rank]"

				if(isobserver(C.mob))
					modmsg += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					modmsg += " - Lobby"
				else
					modmsg += " - Playing"

				if(C.is_afk())
					modmsg += " (AFK)"
				modmsg += "\n"
				num_mods_online++

			else if (R_CCIAA & C.holder.rights)
				cciaamsg += "\t[C]"
				if (isobserver(C.mob))
					cciaamsg += " - Observing"
				else if (istype(C.mob, /mob/new_player))
					cciaamsg += " - Lobby"
				else
					cciaamsg += " - Playing"

				if (C.is_afk())
					cciaamsg += " (AFK)"
				cciaamsg += "\n"
				num_cciaa_online++

			else if(C.holder.rights & R_DEV)
				devmsg += "\t[C] is a [C.holder.rank]"
				if(isobserver(C.mob))
					devmsg += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					devmsg += " - Lobby"
				else
					devmsg += " - Playing"

				if(C.is_afk())
					devmsg += " (AFK)"
				devmsg += "\n"
				num_devs_online++

	else
		for(var/client/C in admins)
			if(R_ADMIN & C.holder.rights || (!R_MOD & C.holder.rights))
				if(!C.holder.fakekey)
					msg += "\t[C] is a [C.holder.rank]\n"
					num_admins_online++
			else if (R_MOD & C.holder.rights)
				modmsg += "\t[C] is a [C.holder.rank]\n"
				num_mods_online++
			else if(C.holder.rights & R_DEV)
				devmsg += "\t[C] is a [C.holder.rank]\n"
				num_devs_online++
			else if (R_CCIAA & C.holder.rights)
				cciaamsg += "\t[C] is a [C.holder.rank]\n"
				num_cciaa_online++

	if(discord_bot && discord_bot.active)
		src << "<span class='info'>Adminhelps are also sent to Discord. If no admins are available in game try anyway and an admin on Discord may see it and respond.</span>"
	msg = "<b>Current Admins ([num_admins_online]):</b>\n" + msg

	if(config.show_mods)
		msg += "\n<b> Current Moderators ([num_mods_online]):</b>\n" + modmsg

	if (config.show_auxiliary_roles)
		if (num_cciaa_online)
			msg += "\n<b> Current CCIA Agents ([num_cciaa_online]):</b>\n" + cciaamsg
		if(num_devs_online)
			msg += "\n<b> Current Developers ([num_devs_online]):</b>\n" + devmsg

	src << msg
