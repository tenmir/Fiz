extends CharacterBody2D

@export var speed: float = 50.0
@export var attack_distance: float = 300.0
@export var attack_interval: float = 1.5
@export var arrow_scene: PackedScene = preload("res://scenes/enemy_arrow.tscn")
@export var max_health: int = 30
var current_health: int = max_health
var player: Node2D
var can_shoot: bool = true
signal died

func _ready():
	player = get_node("/root/Level1/player")
	add_to_group("enemies")

func _process(delta):
	if current_health <= 0:
		return  # Не двигаться и не стрелять после смерти

	if player:
		var distance_to_player = global_position.distance_to(player.global_position)

		if distance_to_player <= attack_distance:
			if can_shoot:
				shoot_arrow()
				can_shoot = false
				await get_tree().create_timer(attack_interval).timeout
				can_shoot = true
		else:
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
			move_and_slide()

func shoot_arrow():
	if not arrow_scene:
		return

	var arrow = arrow_scene.instantiate()
	get_tree().current_scene.add_child(arrow)
	arrow.global_position = global_position
	arrow.direction = (player.global_position - global_position).normalized()

func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		die()

func die():
	died.emit()
	queue_free()
