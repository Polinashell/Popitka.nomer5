extends Camera2D

@export var vertical_offset: float = -150.0   # насколько выше игрока держать камеру
@export var follow_speed: float = 3.0         # плавность следования (меньше = медленнее)

@onready var player = get_parent().get_node("Player")

var highest_y: float

func _ready() -> void:
	if player:
		highest_y = player.global_position.y + vertical_offset
		global_position.y = highest_y
	else:
		highest_y = global_position.y

func _physics_process(delta: float) -> void:
	if player == null:
		return

	# куда камера ХОЧЕТ сместиться
	var target_y: float = player.global_position.y + vertical_offset

	# камера может двигаться вверх, но не вниз
	if target_y < highest_y:
		highest_y = target_y

	# ПЛАВНОЕ движение камеры (lerp)
	global_position.y = lerp(global_position.y, highest_y, follow_speed * delta)
