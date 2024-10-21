extends CanvasLayer

@onready var color_rect: ColorRect = $Color_rect


func  _ready() -> void:
	show_new_scene()

func  chance_scene(path, delay = 1.0):
	var scene_transition = get_tree().create_tween()
	scene_transition.tween_property(color_rect, "threshold", 1.0, 0.5).set_delay(delay)
	#path.sushi.play()
	await scene_transition.finished
	assert(get_tree().change_scene_to_file(path) == OK)
	#path.sushi.play()
	
func  show_new_scene():
	var show_transition = get_tree().create_tween()
	show_transition.tween_property(color_rect, "threshold", 0.0, 0.5).from(1.0)
	
	
