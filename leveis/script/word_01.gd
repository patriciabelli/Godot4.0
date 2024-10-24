extends Node2D

@onready var player := $Player as CharacterBody2D
@onready var player_scene = preload("res://actors/player.tscn")
@onready var camera := $Camera as Camera2D
@onready var control: Control = $HUD/Control 
@export var pause_menu_scene: PackedScene
@onready var player_start_position: Marker2D = $Player_start_position

const camera_y_limit = 318
const camera_x_limit = -1000

func _ready() -> void:
	Globals.player_start_position = player_start_position
	Globals.player = player
	Globals.player.follow_camera(camera)
	Globals.coins = 0
	Globals.score = 0 
	Globals.player_life = 3
	
	
	var pause_menu = pause_menu_scene.instantiate()
	pause_menu.restart_pressed.connect(reload_game)
	add_child(pause_menu)
	
	control.time_is_up.connect(finished_time)
	
func _process(delta: float) -> void:
	if camera.position.y >= camera_y_limit:
		camera.position.y = camera_y_limit

func reload_game():
	await get_tree().create_timer(1.0).timeout
	var player = player_scene.instantiate()
	add_child(player)
	control.reset_clock_timer()
	Globals.player = player
	Globals.player.follow_camera(camera)
	Globals.player.player_has_died.connect(reload_game)
	Globals.coins = 0 
	Globals.score = 0
	Globals.player_life = 3
	Globals.respawn_player()
	
func finished_time():
	get_tree().reload_current_scene()
 
