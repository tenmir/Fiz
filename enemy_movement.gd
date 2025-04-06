extends CharacterBody2D

@export var speed: float = 100.0  # Скорость врага
var player: Node2D  # Ссылка на игрока

func _ready():
	# Находим игрока в сцене
	player = get_node("/root/Level1/player")  # Замените на правильный путь к вашему игроку

func _process(delta):
	# Если игрок найден, движемся в его сторону
	if player:
		move_towards_player(delta)

func move_towards_player(delta):
	# Используем глобальную позицию игрока для вычисления направления
	# Если у игрока есть смещения, используем его центральную позицию
	var target_position = player.global_position

	# Вычисляем направление к игроку
	var direction = (target_position - global_position).normalized()

	# Устанавливаем скорость врага по направлениям X и Y
	velocity = direction * speed  # Обновляем свойство velocity

	# Двигаем врага с использованием move_and_slide
	move_and_slide()  # Используем без аргументов
