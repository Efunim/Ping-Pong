extends Node

@export var y_border_perc: float = 0.025

enum states { PLAYING, PAUSED }
var current_state

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

func reset_ball():
	var screen_size = DisplayServer.window_get_size()
	$Ball.position = screen_size / 2
	$Ball.launch()


func _on_timer_timeout() -> void:
	$Ball.launch()
