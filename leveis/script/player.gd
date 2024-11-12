extends CharacterBody2D

class_name PlayerClass

const SPEED = 200.0
const AIR_FRICTION := 0.5

const COIN_SCENE :=  preload("res://leveis/pefabs/coin_rigid.tscn")
 
var is_jumping := false
var just_hit_enemy := false
var game_over := false 

var knockback_vector := Vector2.ZERO
var knockback_power := 20
var direction
var is_hurted = false
var knockback_tween: Tween

#handle jump and gravity
@export var jump_height := 64
@export var max_time_to_peak := 0.5

var jump_velocity
var gravity
var fall_gravity


@onready var animation := $Anim as AnimatedSprite2D
@onready var remote_transform := $Remote as RemoteTransform2D
@onready var ray_right := $Ray_Right as RayCast2D
@onready var ray_left := $Ray_Left as RayCast2D
@onready var jump_sfx: AudioStreamPlayer = $Jump_sfx as AudioStreamPlayer
@onready var destroy_sfx = preload("res://Sounds/destroy_sfx.tscn")
@onready var audio_stream_player:= $AudioStreamPlayer as AudioStreamPlayer
@onready var collision: CollisionShape2D = $Collision

signal player_has_died()

func _ready() -> void:
	jump_velocity = (jump_height * 2) / max_time_to_peak
	gravity = (jump_height * 2) / (max_time_to_peak * max_time_to_peak)
	fall_gravity = gravity * 2

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		#velocity.y += gravity * delta
		velocity.x = 0

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -jump_velocity
		is_jumping = true
		jump_sfx.play()
	elif is_on_floor():
		is_jumping = false
		
	if velocity.y > 0 or not Input.is_action_pressed("ui_accept"):
		velocity.y += fall_gravity * delta
	else:
		velocity.y += gravity * delta
		
	direction = Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = lerp(velocity.x,direction * SPEED, AIR_FRICTION)
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
	#var knocback = Vector2((global_position.x - body.global_position.x) * knockback_power, -100)
	#print(knocback)
	#take_damage(knocback)
	
	if ray_right.is_colliding():
		take_damage(Vector2(-200, -200))
	elif ray_left.is_colliding():
		take_damage(Vector2(200, -200))
		
		if Globals.player_life <0:
			queue_free()

	if body.is_in_group("fireball"):
		body.queue_free()
		
func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

func take_damage (knocback_force := Vector2.ZERO, duration := 0.25):
	if Globals.player_life > 0:
		Globals.player_life -= 1
	else:
		emit_signal("player_has_died")
		self.queue_free()
		Globals.on_restart.emit()
	
	is_hurted = true
	
	velocity = knocback_force
	
	if knocback_force != Vector2.ZERO:
		knockback_vector = knocback_force
	
	knockback_tween = create_tween()
	knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO,duration)
	animation.modulate = Color(1, 0, 0, 1)
	knockback_tween.parallel().tween_property(animation, "modulate", Color(1, 1, 1, 1), duration)
	
	animation.play("hurt")
		
	lose_coins()
	
func _set_state():
	var state = "idie"
		
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"
	
	return state
	
		
func funcfunc():
	just_hit_enemy = true
	take_damage(Vector2(200, -250))
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
	if Globals.player_life > 0:
		Globals.player_life -= 1
		visible = false
		set_physics_process(false)
		
		await  get_tree().create_timer(1.0).timeout
		Globals.respawn_player()
		visible = true
		set_physics_process(true)
	else:
		visible = false
		await  get_tree().create_timer(0.5).timeout
		player_has_died.emit()
	#if area.name == "WorldBoundary":
		#player_has_died.emit()
		#queue_free()

func play_destroy_sfx():
	var sound_sfx = destroy_sfx.instantiate()
	get_parent().add_child(sound_sfx)
	sound_sfx.play()
	await  sound_sfx.finished
	sound_sfx.queue_free()
	
func lose_coins():
	var lost_coins :int = min(Globals.coins, 5)
	collision.set_deferred("disabled", true)
	Globals.coins -= lost_coins
	for i in lost_coins:
		var coin = COIN_SCENE.instantiate()
		#get_parent().add_child(coin)
		get_parent().call_deferred("add_child", coin)
		coin.global_position = global_position
		coin.apply_central_impulse(Vector2(randi_range(-100, 100), -250))
	await get_tree().create_timer(0.3).timeout
	collision.set_deferred("disabled", false)
	
