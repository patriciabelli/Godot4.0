extends Control

signal on_restart

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resstart_btn_pressed() -> void:
	on_restart.emit()


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
