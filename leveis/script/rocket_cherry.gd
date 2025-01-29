extends EnemyBase

@onready var spawn_enemy: Marker2D = $"../Spawn_enemy"
func _ready() ->  void:
	spawn_instance = preload("res://actors/cherry.tscn")
	spawn_instance_position = spawn_enemy
	can_spawn = true

	if anim != null:
		anim.animation_finished.connect(kill_air_enemy)

	if can_spawn:
		spawn_new_enemy()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var player = body as PlayerClass
		player.knock_back(Vector2(0, -250))
		Globals.score += 100
		queue_free()
