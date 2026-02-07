extends Node

@export var y_border_perc: float = 0.025

enum states { PLAYING, PAUSED }
var current_state

var player_score: int = 0
var enemy_score: int = 0


func _ready() -> void:
	# Init positions
	var screen_size = DisplayServer.window_get_size()
	var y_border = screen_size.y * y_border_perc
	
	var center_x = screen_size.x / 2
	
	$Player.position.x = center_x
	$Player.position.y = screen_size.y - y_border

	$Enemy.position.x = center_x
	$Enemy.position.y = y_border

	$Ball.position.x = center_x
	$Ball.position.y = screen_size.y / 2

func reset_ball(direction_y: int):
	var screen_size = DisplayServer.window_get_size()
	$Ball.position = screen_size / 2
	$Ball.launch(direction_y)

func _on_timer_timeout() -> void:
	$Ball.launch()

func _on_player_border_body_entered(_body: Node2D) -> void:
	enemy_score += 1
	print("Enemy scored! ", enemy_score)
	reset_ball(-1)

func _on_enemy_border_body_entered(_body: Node2D) -> void:
	player_score += 1
	print("Player scored! ", player_score)
	reset_ball(1)
