extends CharacterBody2D

var move_spered := 50.0
var direction := 1
var health_points := 3
@onready var sprite: Sprite2D = $Sprite
@onready var anim: AnimationPlayer = $Anim
@onready var fireball_spawn_point: Marker2D = $Fireball_spawn_point
@onready var ground_detector: RayCast2D = $Ground_detector
@onready var player_detector: RayCast2D = $Player_detector


func _ready() -> void:
	pass 
	
func _physics_process(delta: float) -> void:
	
	if is_on_wall():
		flip_enemy()
		
	if not ground_detector.is_colliding():
		flip_enemy()
		
	velocity.x = move_spered * direction
	
	move_and_slide()

func flip_enemy():
	direction *= -1
	sprite.scale.x *= -1
	player_detector.scale.x *= -1
		
