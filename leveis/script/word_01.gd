extends Node2D

@onready var player := $Player as CharacterBody2D
@onready var player_scene = preload("res://actors/player.tscn")
@onready var camera := $Camera as Camera2D
@onready var control: Control = $HUD/Control 
@onready var player_start_position: Marker2D = $Player_start_position
@onready var game_over: Control = $GameOver
@onready var hud: CanvasLayer = $HUD
@onready var transition: CanvasLayer = $Transition
@onready var controls: CanvasLayer = $Controls
@onready var pause_menu: CanvasLayer = $Pause_menu


const camera_y_limit = 318

func _ready() -> void:
	Globals.player_start_position = player_start_position
	Globals.player = player
	Globals.player.follow_camera(camera)
	Globals.player.player_has_died.connect(on_game_over)
	
	move_child(game_over, get_child_count())
	
	control.time_is_up.connect(on_game_over)
	
	Globals.coins = 0 
	Globals.score = 0
	Globals.player_life = 5
	Globals.respawn_player()
	
func _process(delta: float) -> void:
	if camera.position.y >= camera_y_limit:
		camera.position.y = camera_y_limit


	
	#await get_tree().create_timer(1.0).timeout
	#var player = player_scene.instantiate()
	#add_child(player)
	#control.reset_clock_timer()
	#Globals.player = player
	#Globals.player.follow_camera(camera)
	#Globals.player.player_has_died.connect(on_game_over)
	
func on_game_over():
	if (find_child('Player')):
		find_child('Player').queue_free()
	game_over.position = camera.position
	game_over.visible = true 
	hud.visible = false
	transition.visible = false
	controls.visible = false
	pause_menu.visible = false
	

func _on_game_over_on_restart() -> void:
	hud.visible = true
	transition.visible = true
	pause_menu.visible = true
	
