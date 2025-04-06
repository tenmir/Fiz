extends Control

var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
@export var spawn_interval: float = 3.0
@export var max_enemies: int = 10  # Ограничение на общее количество врагов

var screen_size: Vector2
var enemies: Array = []  # Массив для отслеживания всех врагов

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	spawn_loop()

# Цикл для спавна врагов
func spawn_loop() -> void:
	# Создаем таймер для спавна врагов
	await get_tree().create_timer(spawn_interval).timeout
	while true:
		# Если врагов на сцене меньше максимального количества
		if enemies.size() < max_enemies:
			spawn_enemy()
		await get_tree().create_timer(spawn_interval).timeout  # Повторяем с интервалом

func spawn_enemy():
	# Спавн врага
	var enemy = enemy_scene.instantiate() 

	# Спавн за пределами экрана — выбираем случайную позицию вне видимой области
	var spawn_side = randi_range(0, 2)
	var x: float
	var y: float

	if spawn_side == 0:  # Спавн слева
		x = -randf_range(50, 200)
		y = randf_range(0, screen_size.y)
	elif spawn_side == 1:  # Спавн справа
		x = screen_size.x + randf_range(50, 200)
		y = randf_range(0, screen_size.y)
	elif spawn_side == 2:  # Спавн сверху
		x = randf_range(0, screen_size.x)
		y = -randf_range(50, 200)
	else:  # Спавн снизу
		x = randf_range(0, screen_size.x)
		y = screen_size.y + randf_range(50, 200)

	enemy.global_position = Vector2(x, y)
	add_child(enemy)

	# Добавляем врага в массив для отслеживания
	enemies.append(enemy)


func _on_enemy_exited(enemy):
	# Враги не удаляются из массива, так как они не должны умирать за экраном
	# Мы просто игнорируем их выход за пределы экрана
	# Однако можно оставить логику для очистки врагов, если они каким-то образом "покидают" сцену
	# или другие условия, если потребуется.
	# Например, можно использовать флаг для состояния или перемещать их обратно за пределы экрана.
	pass
