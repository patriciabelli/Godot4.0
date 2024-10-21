extends Area2D

@onready var transition: CanvasLayer = $"../Transition"
#@onready var sushi: AudioStreamPlayer = $Sushi as AudioStreamPlayer
@export var next_level : String = ""


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and !next_level == "":
		Globals.is_checkpoint_active = false
		transition.chance_scene(next_level)
	else :
		print ("nenhuma cena carregada")
