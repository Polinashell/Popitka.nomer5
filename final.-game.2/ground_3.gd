extends AnimatableBody2D

@export var amplitude: float = 150.0
@export var speed: float = 2.5
@export var fragile_chance: float = 0.5
@export var disappear_delay: float = 0.6

var base_position: Vector2
var time_passed := 0.0
var is_fragile := false
var disappear_timer := -1.0

func _ready() -> void:
	base_position = global_position

	randomize()
	is_fragile = randf() < fragile_chance

	if is_fragile and has_node("Sprite2D"):
		$Sprite2D.modulate = Color(1, 0.8, 0.8, 0.9)

func _physics_process(delta: float) -> void:
	time_passed += delta
	var offset := sin(time_passed * speed) * amplitude
	global_position.x = base_position.x + offset

	if disappear_timer >= 0:
		disappear_timer -= delta
		if disappear_timer <= 0:
			if has_node("CollisionShape2D"):
				$CollisionShape2D.disabled = true
			hide()

func _on_Detector_body_entered(body: Node2D) -> void:
	if not is_fragile:
		return
	if body.name != "Player":
		return
	if disappear_timer < 0:
		disappear_timer = disappear_delay
