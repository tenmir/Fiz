extends CharacterBody2D

@export var speed: float = 50.0
@export var attack_distance: float = 40.0  # Дистанция ближнего удара
@export var attack_interval: float = 1.5
@export var damage: int = 10
@export var max_health: int = 30

var current_health: int = max_health
var player: Node2D
var can_attack: bool = true

signal died

func _ready():
	player = get_node("/root/Level1/player")
	add_to_group("enemies")

func _process(delta):
	if current_health <= 0:
		return  # Не двигаться и не атаковать после смерти

	if player:
		var distance_to_player = global_position.distance_to(player.global_position)

		if distance_to_player <= attack_distance:
			if can_attack:
				attack_player()
				can_attack = false
				await get_tree().create_timer(attack_interval).timeout
				can_attack = true
		else:
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
			move_and_slide()

func attack_player():
	if player.has_method("take_damage"):
		player.take_damage(damage)

func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		die()

func die():
	print("Враг умирает")
	died.emit()
	queue_free()
