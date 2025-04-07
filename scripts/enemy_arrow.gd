extends Area2D  
@export var speed: float = 300.0
var direction: Vector2 = Vector2.ZERO

func _ready():
	$Timer.start()
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta):
	if direction != Vector2.ZERO:
		position += direction * speed * delta

func _on_Timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(10)  # Урон по игроку
		queue_free()
