extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var v_box_container: VBoxContainer = $VBoxContainer



func _on_resstart_btn_pressed() -> void:
	Globals.on_restart.emit()
	color_rect.visible = false
	v_box_container.visible = false

func _on_quit_btn_pressed() -> void:
	get_tree().quit()
