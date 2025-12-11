extends Area2D

# Насколько ниже камеры висит зона смерти
@export var vertical_offset: float = 400.0  

@onready var camera: Camera2D = get_parent().get_node("Camera2D")

func _physics_process(_delta: float) -> void:
	if camera == null:
		return
	# KillZone движется вместе с камерой
	global_position.y = camera.global_position.y + vertical_offset

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var parent = get_parent()
		if parent and parent.has_method("lose_life"):
			parent.lose_life()
		else:
			get_tree().reload_current_scene()
