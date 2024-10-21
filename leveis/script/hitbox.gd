extends Area2D

@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var player = body as PlayerClass
		
		audio_stream_player.play()
		print("toca")
		player.funcfunc()
		
		body.velocity.y = body.JUMP_FORCE


func _on_audio_stream_player_finished() -> void:
	get_parent().queue_free()
