extends Control

var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
var enemy_scene_ranged: PackedScene = preload("res://scenes/ranged_enemy.tscn")

@export var spawn_interval: float = 3.0
@export var max_enemies: int = 10  # Ограничение на общее количество врагов

var screen_size: Vector2
var enemies: Array = []  # Массив для отслеживания всех врагов

func _ready():
	randomize()
	screen_size = get_viewport().get_visible_rect().size
	spawn_loop()

# Цикл для спавна врагов
func spawn_loop() -> void:
	while true:
		await get_tree().create_timer(spawn_interval).timeout
		print("Проверка спавна: врагов ", enemies.size(), "/", max_enemies)
		if enemies.size() < max_enemies:
			print("Спавним врага")
			spawn_enemy()

func spawn_enemy():
	var enemy

	# Случайный выбор типа врага
	if randi_range(0, 1) == 0:
		enemy = enemy_scene.instantiate()
	else:
		enemy = enemy_scene_ranged.instantiate()

	print("Враг создан: ", enemy)

	# Случайная позиция
	var spawn_side = randi_range(0, 3)
	var x: float
	var y: float
	match spawn_side:
		0:
			x = -randf_range(50, 200)
			y = randf_range(0, screen_size.y)
		1:
			x = screen_size.x + randf_range(50, 200)
			y = randf_range(0, screen_size.y)
		2:
			x = randf_range(0, screen_size.x)
			y = -randf_range(50, 200)
		3:
			x = randf_range(0, screen_size.x)
			y = screen_size.y + randf_range(50, 200)

	enemy.global_position = Vector2(x, y)
	add_child(enemy)
	enemy.died.connect(_on_enemy_removed.bind(enemy))
	enemies.append(enemy)

func _on_enemy_removed(enemy):
	# Удаляем врага из массива, когда он умираетw
		enemies.erase(enemy)
		print("Враг удалён из массива:", enemy)
		enemy.queue_free()  # Удаляем врага с дерева
		
