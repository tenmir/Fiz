extends CharacterBody2D

# Настройки
@export var speed := 220.0  # Скорость движения
@export var acceleration := 15.0  # Плавность разгона
@export var friction := 10.0  # Плавность торможения

@export var attack_range: float = 100.0
@export var attack_interval: float = 1.0
@export var attack_damage: int = 100
@export var max_health: int = 100

var current_health: int = max_health

func _ready():
	start_auto_attack()
	add_to_group("player")

func start_auto_attack():
	while current_health > 0:
		attack_nearby_enemies()
		await get_tree().create_timer(attack_interval).timeout

func attack_nearby_enemies():
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if global_position.distance_to(enemy.global_position) <= attack_range:
			enemy.take_damage(attack_damage)

func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		die()

func die():
	queue_free()
	print("Player died!")


func _physics_process(delta):
	# 1. Получаем ввод с клавиатуры (-1..1 по осям X и Y)
	var input_vector := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# 2. Рассчитываем движение
	if input_vector != Vector2.ZERO:
		velocity = velocity.lerp(input_vector * speed, acceleration * delta)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction * delta)
	
	# 3. Применяем движение и обрабатываем коллизии
	move_and_slide()
