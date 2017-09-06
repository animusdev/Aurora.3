// Mask
/datum/gear/mask
	display_name = "sterile mask"
	path = /obj/item/clothing/mask/surgical
	cost = 2
	sort_category = "Masks"

/datum/gear/scarf
	display_name = "blue face scarf"
	path = /obj/item/clothing/mask/bluefacescarf
	cost = 1
	sort_category = "Masks"

/datum/gear/scarf/New()
	..()
	var/scarfface = list()
	scarfface["blue"] = /obj/item/clothing/mask/bluefacescarf
	scarfface["red-white"] = /obj/item/clothing/mask/redwhitefacescarf
	scarfface["green"] = /obj/item/clothing/mask/greenfacescarf
	gear_tweaks += new/datum/gear_tweak/path(scarfface)

/datum/gear/longscarf
	display_name = "blue long scarf"
	path = /obj/item/clothing/mask/bluelongscarf
	cost = 1
	sort_category = "Masks"

/datum/gear/longscarf/New()
	..()
	var/longscarf = list()
	longscarf["blue"] = /obj/item/clothing/mask/bluelongscarf
	longscarf["red"] = /obj/item/clothing/mask/redlongscarf
	longscarf["green"] = /obj/item/clothing/mask/greenlongscarf
	gear_tweaks += new/datum/gear_tweak/path(longscarf)