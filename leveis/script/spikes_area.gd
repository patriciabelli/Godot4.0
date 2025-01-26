extends Area2D

@onready var collision: CollisionShape2D = $Collision as CollisionShape2D
@onready var spikes: Sprite2D = $Spikes as Sprite2D

func _ready() -> void:
	collision.shape.size = spikes.get_rect().size


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" && body.has_method("take_damage"):
		var player = body as PlayerClass
		
		player.take_damage()
		player.knock_back(Vector2(0, -250))
