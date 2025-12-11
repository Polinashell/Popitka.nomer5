extends Area2D

const ROTATION_SPEED := 6.0   # скорость вращения монеты

func _process(delta: float) -> void:
	# крутим только спрайт монеты
	if has_node("Sprite2D"):
		$Sprite2D.rotation += ROTATION_SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# бросаем кубик 1–6
		var roll := randi() % 6 + 1
		print("Dice roll:", roll)

		# передаём эффект игроку, если он умеет его обрабатывать
		if body.has_method("apply_dice_effect"):
			body.apply_dice_effect(roll)

		# увеличиваем счёт в Main
		get_parent().add_coin()

		# удаляем монету
		queue_free()
