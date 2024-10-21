extends Area2D

var coins := 1
@onready var coin_sfx: AudioStreamPlayer = $Coin_sfx as AudioStreamPlayer
 
func _on_body_entered(body: Node2D) -> void:
	$Anim.play("collect")
	coin_sfx.play()
	await $Collision.call_deferred("queue_free")
	print('tukituki ', coins)
	Globals.coins += coins

func _on_anim_animation_finished() -> void:
	if $Anim.animation == "collect":
		queue_free()
