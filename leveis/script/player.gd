extends CharacterBody2D

class_name PlayerClass

const SPEED = 200.0
const JUMP_FORCE = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") 
var is_jumping := false
var just_hit_enemy := false
var game_over := false

var knockback_vector := Vector2.ZERO
var direction

var is_hurted = false

@onready var animation := $Anim as AnimatedSprite2D
@onready var remote_transform := $Remote as RemoteTransform2D
@onready var ray_right := $Ray_Right as RayCast2D
@onready var ray_left := $Ray_Left as RayCast2D
@onready var jump_sfx: AudioStreamPlayer = $Jump_sfx as AudioStreamPlayer
@onready var destroy_sfx = preload("res://Sounds/destroy_sfx.tscn")
@onready var audio_stream_player:= $AudioStreamPlayer as AudioStreamPlayer

signal player_has_died()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
		jump_sfx.play()
	elif is_on_floor():
		is_jumping = false
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = direction * SPEED
		animation.scale.x = direction
		if !is_jumping and is_on_floor() and !just_hit_enemy: #is_not jumping
			if !is_hurted:
				animation.play("run")
	elif is_jumping: #is_jumping == true
		animation.play("jump")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if !just_hit_enemy:
			if is_on_floor():
				if is_hurted:
					is_hurted = false
				
				animation.play("idie")
			else:
				if !is_hurted:
					animation.play("jump")
				
		if knockback_vector != Vector2.ZERO:
			velocity = knockback_vector
	
	move_and_slide()

	for platform in get_slide_collision_count():
		var collision = get_slide_collision(platform)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)

func _on_hurt_box_body_entered(body: Node2D) -> void:
	
	if ray_right.is_colliding():
		take_damage(Vector2(-200, -200))
	elif ray_left.is_colliding():
		take_damage(Vector2(200, -200))
		
		if Globals.player_life <0:
			queue_free()

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

func take_damage (knocback_force := Vector2.ZERO, duration := 0.25):
	if Globals.player_life > 0:
		Globals.player_life -= 1
	else:
		get_tree().paused = true
		emit_signal("player_has_died")
		queue_free()
	
	is_hurted = true
	
	velocity = knocback_force
	
	if knocback_force != Vector2.ZERO:
		knockback_vector = knocback_force
	
	var knockback_tween := get_tree().create_tween()
	knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO,duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	animation.modulate = Color(1, 0, 0, 1)
	knockback_tween.parallel().tween_property(animation, "modulate", Color(1, 1, 1, 1), duration)
	
	animation.play("hurt")
		
		
func _set_state():
	var state = "idie"
		
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"
	
	return state
	
		
func funcfunc():
	just_hit_enemy = true
	animation.play("jump")
	

func _on_anim_animation_finished() -> void:
	if animation.animation == "jump":
		just_hit_enemy = false
	

func _on_head_collider_body_entered(body: Node2D) -> void:
	if body.has_method("break_sprite"):
		body.hitpoints -= 1
		if body.hitpoints < 0:
			body.break_sprite()
			play_destroy_sfx()
		else:
			body.animation_player.play("hit")
			body.hit_block.play()
			body.create_coin()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.name == "WorldBoundary":
		get_tree().paused = true
		player_has_died.emit()
		queue_free()

func play_destroy_sfx():
	var sound_sfx = destroy_sfx.instantiate()
	get_parent().add_child(sound_sfx)
	sound_sfx.play()
	await  sound_sfx.finished
	sound_sfx.queue_free()
	
