extends EnemyBase

@onready var wall_detector: RayCast2D = $Wall_Detector
@onready var texture: Sprite2D = $Texture
@onready var audio_stream_player: AudioStreamPlayer

func  _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	movement(delta)
	flip_direction(wall_detector, texture) 


func _on_hurt_body_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var player = body as PlayerClass
		
		audio_stream_player.play()
			
		print("toca - enemy hitbox")
		player.funcfunc()
		
		body.velocity.y = body.jump_velocity

func _on_audio_stream_player_finished() -> void:
	get_parent().queue_free()
