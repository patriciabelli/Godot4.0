extends EnemyBase

@onready var wall_detector: RayCast2D = $Wall_Detector
@onready var texture: Sprite2D = $Texture
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func  _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	movement(delta)
	flip_direction(wall_detector, texture) 


func _on_hurt_body_body_entered(body: Node2D) -> void:
	print("toca - enemy hitbox")
	
	if body.name == "Player":
		var player = body as PlayerClass
			
		player.funcfunc()
		
		body.velocity.y = body.jump_velocity

func _on_audio_stream_player_finished() -> void:
	Globals.score += 100
	queue_free()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var player = body as PlayerClass
		player.knock_back(Vector2(0, -250))
		
		print('HITBOX do Enemy')
		audio_stream_player.play()
