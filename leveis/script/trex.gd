extends CharacterBody2D

const FIREBALL = preload("res://leveis/pefabs/fireball.tscn")

var move_spered := 50.0
var direction := 1
var health_points := 3
@onready var sprite: Sprite2D = $Sprite
@onready var anim: AnimationPlayer = $Anim
@onready var fireball_spawn_point: Marker2D = $Fireball_spawn_point
@onready var ground_detector: RayCast2D = $Ground_detector
@onready var player_detector: RayCast2D = $Player_detector
@onready var hurt_sprite: Sprite2D = $Sprite/Hurt_sprite

enum EnemyState {PATROL, ATTACK, HURT}
var  current_state = EnemyState.PATROL
@export var target : CharacterBody2D
	
func _physics_process(delta: float) -> void:
	match (current_state):
		EnemyState.PATROL : patrol_slide()
		EnemyState.ATTACK : attack_state()	
	
func patrol_slide():
	anim.play("running")
	
	if is_on_wall():
		flip_enemy()
		
	if not ground_detector.is_colliding():
		flip_enemy()

	velocity.x = move_spered * direction
	
	if player_detector.is_colliding():
		_change_state(EnemyState.ATTACK)
	
	move_and_slide() 
	
func attack_state():
	anim.play("shooting")
	if not player_detector.is_colliding():
		_change_state(EnemyState.PATROL)
	
func hurt_state():
	anim.play("Hurt")
	hurt_sprite.visible = true
	await  get_tree().create_timer(0.3).timeout
	hurt_sprite.visible = false
	_change_state(EnemyState.PATROL)
	if health_points > 0:
		health_points -= 1
	else:
		queue_free()
func _change_state(state):
	current_state = state

func flip_enemy():
	direction *= -1
	sprite.scale.x *= -1
	player_detector.scale.x *= -1
	fireball_spawn_point.position.x *= -1
		
func spawn_fireball():
	var new_fireball = FIREBALL.instantiate()
	if sign(fireball_spawn_point.position.x) == 1:
		new_fireball.set_direction(1)
	else:
		new_fireball.set_direction(-1)
		
	add_sibling(new_fireball)
	new_fireball.global_position = fireball_spawn_point.global_position
 


func _on_hitbox_body_entered(body: Node2D) -> void:
	_change_state(EnemyState.HURT)
	hurt_state()
