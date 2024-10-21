extends Area2D

@onready var anim = $Anim
@onready var marker_2d: Marker2D = $Marker2D

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player" or Globals.is_checkpoint_active:
		return
	activate_checkpoint()
	
func activate_checkpoint():
	anim.play("raising")
	Globals.is_checkpoint_active = true

func _on_anim_animation_finished() -> void:
	Globals.current_checkpoint = marker_2d
	if anim.animation == "raising":
		anim.play("checked")
