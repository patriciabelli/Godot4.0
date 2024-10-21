extends EnemyBase

@onready var wall_detector: RayCast2D = $Wall_Detector
@onready var texture: Sprite2D = $Texture
@onready var audio_stream_player: AudioStreamPlayer

func  _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	movement(delta)
	flip_direction(wall_detector, texture) 
 
