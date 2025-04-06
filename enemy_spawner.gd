extends Node2D

var enemy_scene: PackedScene = preload("res://enemy.tscn")
@export var spawn_interval: float = 3.0

var screen_size: Vector2

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	spawn_loop()

func spawn_loop() -> void:
	await get_tree().process_frame
	while true:
		spawn_enemy()
		await get_tree().create_timer(spawn_interval).timeout

func spawn_enemy():
	var enemy = enemy_scene.instantiate()

	# Размеры врага (если нужны точные границы — можно использовать get_rect())
	var enemy_size = Vector2(32, 32)  # замените на реальные размеры

	# Случайная позиция ВНУТРИ экрана с учетом размера врага
	var x = randf_range(enemy_size.x / 2, screen_size.x - enemy_size.x / 2)
	var y = randf_range(enemy_size.y / 2, screen_size.y - enemy_size.y / 2)
	enemy.global_position = Vector2(x, y)

	add_child(enemy)
