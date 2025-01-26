extends RigidBody2D

const EXPLOSION = preload("res://leveis/pefabs/explosion.tscn")
@onready var collision: CollisionShape2D = $Collision

func _on_body_entered(body: Node) -> void:
	visible = false
	var explosion_instance = EXPLOSION.instantiate()
	get_parent().add_child(explosion_instance)
	
	if(body.name == "Player"):
		var player = body as PlayerClass
		
		player.take_damage()
		player.knock_back(Vector2(-200, -200))
		
	explosion_instance.global_position = global_position
	collision.set_deferred("disabled", true)
	await  explosion_instance.animation_finished
	queue_free()
