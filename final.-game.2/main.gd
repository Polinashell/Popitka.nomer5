extends Node2D

var coins: int = 0
var lives: int = 3
var game_over: bool = false   # флаг, что игра закончена

@onready var player := $Player
@onready var heart1 := $UI/Heart1
@onready var heart2 := $UI/Heart2
@onready var heart3 := $UI/Heart3
@onready var game_over_screen := $UI/GameOver   # узел с картинкой GAME OVER

var player_start_position: Vector2

func _ready() -> void:
	player_start_position = player.global_position
	game_over = false
	_update_hearts()
	if game_over_screen:
		game_over_screen.visible = false


func add_coin() -> void:
	coins += 1
	if player.has_node("ScoreLabel"):
		player.get_node("ScoreLabel").text = "Coins: %d" % coins


func lose_life() -> void:
	if lives <= 0:
		return

	lives -= 1
	_update_hearts()

	if lives <= 0:
		_show_game_over()
	else:
		_restart_player()


func _update_hearts() -> void:
	if heart1:
		heart1.visible = lives >= 1
	if heart2:
		heart2.visible = lives >= 2
	if heart3:
		heart3.visible = lives >= 3


func _show_game_over() -> void:
	game_over = true
	if game_over_screen:
		game_over_screen.visible = true
	else:
		print("GameOver node not found!")


func _restart_player() -> void:
	player.global_position = player_start_position
	if "velocity" in player:
		player.velocity = Vector2.ZERO


func _input(event: InputEvent) -> void:
	# Реагируем на пробел только когда игра закончена
	if not game_over:
		return

	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
