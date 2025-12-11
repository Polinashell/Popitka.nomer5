extends CharacterBody2D

const BASE_SPEED := 350.0
const BASE_JUMP_VELOCITY := -950.0
const BASE_GRAVITY := 900.0

const EFFECT_DURATION := 3.0   # сколько секунд действует эффект

@export var death_offset: float = 600.0   # насколько ниже камеры можно упасть, прежде чем умереть
@onready var camera: Camera2D = get_parent().get_node("Camera2D")

var speed := BASE_SPEED
var jump_velocity := BASE_JUMP_VELOCITY
var gravity := BASE_GRAVITY

var effect_timer := 0.0
var invert_controls := false

func _ready() -> void:
	randomize()

func _physics_process(delta: float) -> void:
	# гравитация
	if not is_on_floor():
		velocity.y += gravity * delta

	# отсчёт времени эффекта
	if effect_timer > 0.0:
		effect_timer -= delta
		if effect_timer <= 0.0:
			_reset_effects()

	# горизонтальное движение
	var direction := Input.get_axis("ui_left", "ui_right")

	# инверсия управления, если эффект активен
	if invert_controls:
		direction *= -1

	velocity.x = direction * speed

	# разворот спрайта
	if direction < 0:
		$Sprite2D.flip_h = true
	elif direction > 0:
		$Sprite2D.flip_h = false

	# прыжок
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	move_and_slide()

	# смерть, если игрок упал слишком низко относительно камеры (doodle-jump style)
	if camera and global_position.y > camera.global_position.y + death_offset:
		var parent = get_parent()
		if parent and parent.has_method("lose_life"):
			parent.lose_life()
		else:
			get_tree().reload_current_scene()  # запасной вариант, если нет логики жизней

func _reset_effects() -> void:
	speed = BASE_SPEED
	jump_velocity = BASE_JUMP_VELOCITY
	gravity = BASE_GRAVITY
	invert_controls = false
	effect_timer = 0.0

# вызывается монеткой, когда она "кидает кубик"
func apply_dice_effect(roll: int) -> void:
	_reset_effects()
	effect_timer = EFFECT_DURATION

	match roll:
		1:
			# 1 – супер-скорость
			speed = BASE_SPEED * 1.8
		2:
			# 2 – супер-прыжок
			jump_velocity = BASE_JUMP_VELOCITY * 1.5
		3:
			# 3 – замедление
			speed = BASE_SPEED * 0.6
		4:
			# 4 – инверсия управления
			invert_controls = true
		5:
			# 5 – супер-скорость + супер-прыжок
			speed = BASE_SPEED * 1.5
			jump_velocity = BASE_JUMP_VELOCITY * 1.3
		6:
			# 6 – ничего не происходит
			_reset_effects()
