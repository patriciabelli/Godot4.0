extends CanvasLayer

@onready var pause: TouchScreenButton = $Pause

func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		visible = true
		get_tree().paused = true


func _on_pause_pressed() -> void:
	print("click click")
	get_tree().paused = true