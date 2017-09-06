
//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
var/list/adminhelp_ignored_words = list("unknown","the","a","an","of","monkey","alien","as")

/client/verb/adminhelp(msg as text)
	set category = "Admin"
	set name = "Adminhelp"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "<span class='warning'>Speech is currently admin-disabled.</span>"
		return

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		src << "<font color='red'>Error: Admin-PM: You cannot send adminhelps (Muted).</font>"
		return

	adminhelped = 2 //Determines if they get the message to reply by clicking the name.

	/*A wee bit of an update here: we're using the following table for adminhelped values:
	3 - Adminhelp has not been claimed and was sent to discord as well.
	2 - Adminhelp has not been claimed by anyone.
	1 - Adminhelp has been claimed, initial message has not been sent.
	0 - Adminhelp has been claimed, initial message has been sent.
	*/

	if(src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	//clean the input msg
	if(!msg)
		return
	msg = sanitize(msg)
	if(!msg)
		return
	msg = "<span class='notice'><b><font color=red>Request for Help: </font>[get_options_bar(mob, 3, 1, 1)]:</b> [msg]</span>"

	var/admin_number_present = 0
	var/admin_number_afk = 0

	for(var/client/X in admins)
		if((R_ADMIN|R_MOD) & X.holder.rights)
			admin_number_present++
			if(X.is_afk())
				admin_number_afk++
			if(X.prefs.toggles & SOUND_ADMINHELP)
				X << 'sound/effects/adminhelp.ogg'

			X << msg

	//show it to the person adminhelping too
	src << "<font color='blue'>PM to-<b>Staff </b>: [msg]</font>"

	var/admin_number_active = admin_number_present - admin_number_afk
	log_admin("HELP: [key_name(src)]: [msg] - heard by [admin_number_present] non-AFK admins.",admin_key=key_name(src))
	if(admin_number_active <= 0)
		discord_bot.send_to_admins("@here Request for Help from [key_name(src)]: [rhtml_decode(msg)] - !![admin_number_afk ? "All admins AFK ([admin_number_afk])" : "No admins online"]!!")
		adminhelped = 3
	feedback_add_details("admin_verb","AH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return
