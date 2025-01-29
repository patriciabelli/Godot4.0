extends EnemyBase

@onready var wall_detector: RayCast2D = $Wall_detector
@onready var anim_cherry: AnimatedSprite2D = $Anim
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	anim = anim_cherry

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	movement(delta)
	flip_direction(wall_detector, anim)
	

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var player = body as PlayerClass
		player.knock_back(Vector2(0, -150))
		Globals.score += 200
		audio_stream_player.play()
		queue_free()
		
