extends CharacterBody2D
class_name  EnemyBase

const SPEED = 30.0
const JUMP_VELOCITY = -400.0

var anim

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction := Vector2.LEFT
var can_spawn = false
var spawn_instance : PackedScene = null
var spawn_instance_position

func flip_direction(wall_detector: RayCast2D, texture: Node2D):
	if wall_detector.is_colliding():
		if (direction == Vector2.LEFT):
			direction = Vector2.RIGHT
			texture.flip_h = true
		else:
			direction = Vector2.LEFT
			texture.flip_h = false
			
		wall_detector.target_position *= -1

func  _apply_gravity(delta):
	
	if not is_on_floor():
		velocity += get_gravity() * delta

func movement(delta):
	
	velocity.x = direction.x * SPEED
	
	move_and_slide()
	
func kill_ground_enemy(anim_name: StringName) -> void:
	if anim.anim_name == "Hurt":
		kill_and_score()
	
func kill_air_enemy() -> void:
		kill_and_score()
		
func kill_and_score() -> void:
		Globals.score += 100
		if can_spawn:
				spawn_new_enemy()
				queue_free()
 
func spawn_new_enemy():
	var instance_scene = spawn_instance.instantiate()
	get_parent().call_deferred("add_child", instance_scene)
	instance_scene.global_position = spawn_instance_position.global_position
	
