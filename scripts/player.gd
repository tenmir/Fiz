extends CharacterBody2D

# Настройки
@export var speed := 220.0  # Скорость движения
@export var acceleration := 15.0  # Плавность разгона
@export var friction := 10.0  # Плавность торможения

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
