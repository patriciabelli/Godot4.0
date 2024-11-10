extends CharacterBody2D

const SPEED = 5000.0
var direction = -1
@onready var wall_detector: RayCast2D = $Wall_detector
@onready var sprite_2d: Sprite2D = $Sprite2D


func _physics_process(delta: float) -> void:
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
	
	if direction == 1:
		velocity.x = SPEED * delta
		sprite_2d.flip_h = true
	else:
		velocity.x = -SPEED * delta
		sprite_2d.flip_h = false
		
	move_and_slide()
