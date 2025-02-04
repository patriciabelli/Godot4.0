extends CanvasLayer

@onready var menu: Control = $Menu
@onready var menu_pause: VBoxContainer = $Menu/Menu_pause
@onready var resume_btn: Button = $Menu/Menu_pause/Resume_btn
@onready var menu_game_over: VBoxContainer = $Menu/Menu_game_over
@onready var restart_btn: Button = $Menu/Menu_game_over/Restart_btn
@onready var moedas_label: Label = $Menu/Menu_game_over/HBoxContainer/Moedas_label
@onready var pause_play: TextureButton = $Pause_play

signal restart_pressed

func _ready() -> void:
	#Globals.player.player_has_died.connect(game_over)
	menu.visible = false
	pause_play.visible = true
	
func game_over():
	menu.visible = true
	menu_game_over.visible = true
	moedas_label.text = str(Globals.coins)
	restart_btn.grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		menu_pause.visible = true
		get_tree().paused = true
		resume_btn.grab_focus()

func _on_resume_btn_pressed() -> void:
	get_tree().paused = false
	menu.visible = false
	pause_play.visible = true


func _on_quit_tbn_pressed() -> void:
	get_tree().quit()


func _on_pause_play_pressed() -> void:
	pause_play.visible = true
	menu.visible = true
	get_tree().paused = true
	moedas_label.text = str(Globals.coins)

func _on_restart_btn_pressed() -> void:
	get_tree().paused = false
	menu.visible = false
	menu_game_over.visible = false
	pause_play.visible = true
	restart_pressed.emit()
	get_tree().reload_current_scene()
