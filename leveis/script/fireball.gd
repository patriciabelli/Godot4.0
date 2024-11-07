extends CharacterBody2D

var move_speed := 50.0	
var direction := 1


func _process(delta: float) -> void:
	position.x += move_speed * direction * delta

func set_direction(dir):
	direction = dir
	if dir < 0:
		$Anim.flip_h = true
	else:
		$Anim.flip_h = false
