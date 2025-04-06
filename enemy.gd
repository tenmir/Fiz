extends CharacterBody2D

var speed := 100.0
var health := 30
var player_node: Node2D  # Будем хранить ссылку на игрока

func _ready():
	# Ищем игрока в дереве сцены при создании врага
	player_node = get_tree().get_first_node_in_group("player")
	if not player_node:
		push_error("Player not found! Make sure player has 'player' group")

func _physics_process(delta):
	if not player_node:
		return  # Если игрок не найден, ничего не делаем
		
	var direction = (player_node.position - position).normalized()
	velocity = direction * speed
	move_and_slide()
