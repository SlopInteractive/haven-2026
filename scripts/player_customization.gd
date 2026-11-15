extends Control

@onready var player := $"Player"
var indexes := {
	Globals.SHIRT: 0,
	Globals.EYES: 0, 
	Globals.HAIR: 0,
	Globals.SHOES: 0,
}
const min_indexes := {
	Globals.SHIRT : 1, 
	Globals.EYES : 1,
	Globals.HAIR : 1,
	Globals.SHOES : 1,
}
const max_indexes := { #exclusive
	Globals.SHIRT : 7,
	Globals.EYES: 7,
	Globals.HAIR: 7,
	Globals.SHOES: 7,
}

func _ready() -> void:
	change(Globals.SHIRT, 1)
	change(Globals.EYES, 1)
	change(Globals.HAIR, 1)
	change(Globals.SHOES, 1)


func change(skin_part : int, value : int):
	if skin_part == Globals.SHIRT:
		var old_index : int = indexes[Globals.SHIRT]
		while Globals.selected_shirts.has(indexes[Globals.SHIRT]):
			indexes[skin_part] = wrap(indexes[skin_part] + value, min_indexes[skin_part], max_indexes[skin_part])
		Globals.selected_shirts.append(indexes[skin_part])
		if old_index != 0:
			Globals.selected_shirts.remove_at(Globals.selected_shirts.find(old_index))
	else :
		indexes[skin_part] = wrap(indexes[skin_part] + value, min_indexes[skin_part], max_indexes[skin_part])
	print(Globals.selected_shirts)
	match skin_part:
		Globals.SHIRT:
			player.change_shirt(indexes[skin_part])
		Globals.EYES:
			player.change_eyes(indexes[skin_part])
		Globals.HAIR:
			player.change_hair(indexes[skin_part])
		Globals.SHOES:
			player.change_shoes(indexes[skin_part])

func next_shirt():
	change(Globals.SHIRT, 1)

func prev_shirt():
	change(Globals.SHIRT, -1)
	

func next_eyes(): 
	change(Globals.EYES, 1)

func prev_eyes(): 
	change(Globals.EYES, -1)

func next_hair(): 
	change(Globals.HAIR, 1)

func prev_hair(): 
	change(Globals.HAIR, -1)
	
func next_shoes(): 
	change(Globals.SHOES, 1)

func prev_shoes(): 
	change(Globals.SHOES, -1)
