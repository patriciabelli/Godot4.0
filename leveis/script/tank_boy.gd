extends CharacterBody2D

const BOMB := preload("res://leveis/pefabs/bomb.tscn")
const MISSILE := preload("res://leveis/pefabs/missile.tscn")
const SPEED = 5000.0
var direction = -1
@onready var wall_detector: RayCast2D = $Wall_detector
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var missile_point: Marker2D = %Missile_point
@onready var bomb_point: Marker2D = %Bomb_point

@onready var anim_tree: AnimationTree = $Anim_Tree
@onready var state_machine = anim_tree["parameters/playback"]

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

func throw_bomb():
	var bomb_instance = BOMB.instantiate()
	add_sibling(bomb_instance)
	bomb_instance.global_position = bomb_point.global_position
	bomb_instance.apply_impulse(Vector2(randi_range(direction * 30, direction * 200 ), randi_range(-200, -400)))
	
func launch_missile():
	var missile_instance = MISSILE.instantiate()
	add_sibling(missile_instance)
	missile_instance.global_position = missile_point.global_position
	missile_instance.set_direction(direction)
	
func _on_bomb_coodown_timeout() -> void:
	throw_bomb()

func _on_missile_coodown_timeout() -> void:
	launch_missile()
