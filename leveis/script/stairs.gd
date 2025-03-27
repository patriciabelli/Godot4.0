extends Node2D

func _ready() -> void:
	Globals.boss_defeated.connect(show_stairs)
	
func  show_stairs():
	for block in get_children():
		block.get_node("Anim").play("grow")
	
