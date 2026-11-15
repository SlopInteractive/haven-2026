extends Control

@onready var player := $"Player"
var indexes := {
	SHIRT: 0,
	EYES: 0, 
	HAIR: 0,
	SHOES: 0,
}
const min_indexes := {
	SHIRT : 1, 
	EYES : 1,
	HAIR : 1,
	SHOES : 1,
}
const max_indexes := { #exclusive
	SHIRT : 7,
	EYES: 7,
	HAIR: 7,
	SHOES: 7,
}

func _ready() -> void:
	change(SHIRT, 1)
	change(EYES, 1)
	change(HAIR, 1)
	change(SHOES, 1)
enum {
	SHIRT = 1, 
	EYES, 
	HAIR,
	SHOES,
}

func change(skin_part : int, value : int):
	if skin_part == SHIRT:
		var old_index : int = indexes[SHIRT]
		while Globals.selected_shirts.has(indexes[SHIRT]):
			indexes[skin_part] = wrap(indexes[skin_part] + value, min_indexes[skin_part], max_indexes[skin_part])
		Globals.selected_shirts.append(indexes[skin_part])
		if old_index != 0:
			Globals.selected_shirts.remove_at(Globals.selected_shirts.find(old_index))
	else :
		indexes[skin_part] = wrap(indexes[skin_part] + value, min_indexes[skin_part], max_indexes[skin_part])
	print(Globals.selected_shirts)
	match skin_part:
		SHIRT:
			player.change_shirt(indexes[skin_part])
		EYES:
			player.change_eyes(indexes[skin_part])
		HAIR:
			player.change_hair(indexes[skin_part])
		SHOES:
			player.change_shoes(indexes[skin_part])

func next_shirt():
	change(SHIRT, 1)

func prev_shirt():
	change(SHIRT, -1)
	

func next_eyes(): 
	change(EYES, 1)

func prev_eyes(): 
	change(EYES, -1)

func next_hair(): 
	change(HAIR, 1)

func prev_hair(): 
	change(HAIR, -1)
	
func next_shoes(): 
	change(SHOES, 1)

func prev_shoes(): 
	change(SHOES, -1)
