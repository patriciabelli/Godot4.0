extends Node

#new signals
signal player_has_died
signal coins_updated
signal score_updated
signal Globals_updated
signal on_restart

#setters
var coins := 0
var score := 0
var player_life := 5
var player = null
var player_start_position = null
var current_checkpoint = null
var is_checkpoint_active := false
var bomb_instance = null

func  respawn_player():
	if is_checkpoint_active:
		player.position = current_checkpoint.global_position
 	#else:
		#player.global_position = player_start_position.global_position

func reload_game():
	get_parent().get_tree().reload_current_scene()
