extends Node
var player_count := 0
var selected_shirts : Array[int] = [0, 0]

enum {
	SHIRT = 1, 
	EYES, 
	HAIR,
	SHOES,
}

var player_skins : Dictionary[int, Dictionary] = {
	1: {},
	2: {},
	3: {},
	4: {},
}
