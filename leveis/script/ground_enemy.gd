extends EnemyBase

@onready var wall_detector: RayCast2D = $Wall_Detector
@onready var texture: Sprite2D = $Texture
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func  _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	movement(delta)
	flip_direction(wall_detector, texture) 


func _on_hurt_body_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var player = body as PlayerClass
			
		print("toca - enemy hitbox")
		player.funcfunc()
		
		body.velocity.y = body.jump_velocity

func _on_audio_stream_player_finished() -> void:
	queue_free()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var player = body as PlayerClass
		
		print('HITBOX do Enemy')
		audio_stream_player.play()
