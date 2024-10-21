extends EnemyBase

@onready var wall_detector: RayCast2D = $Wall_detector
@onready var anim_cherry: AnimatedSprite2D = $Anim

func _ready() -> void:
	anim = anim_cherry

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	movement(delta)
	flip_direction(wall_detector, anim)
	
