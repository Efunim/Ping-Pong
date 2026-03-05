extends Node

@export var y_border_perc: float = 0.025
@export var score_to_win: int = 7

@onready var launch_timer: Timer = $ResetBallTimeout
@onready var pause_timer: Timer = $PauseTimeout
@onready var overlay: Label = $OverlayText/Label

enum states { NOT_STARTED, ON_HOLD, PLAYING, PAUSED}
var current_state

var player_score: int = 0
var enemy_score: int = 0

var direction_y: int = -1

# Technicaly work with states

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
	
	current_state = states.NOT_STARTED
	overlay.text = "PRESS ANY BUTTON TO START"
	get_tree().paused = true


func start_game() -> void:
	hide_overlay()
	$Ball.launch(direction_y)
	current_state = states.PLAYING
	get_tree().paused = false
	print("START GAME")


func _unhandled_key_input(_event: InputEvent) -> void:
	print(current_state)
	
	match current_state:
		states.NOT_STARTED:
			start_game()
			
		states.PAUSED:
			if _event.is_action_pressed("ui_pause"):
				resume_game()
		
		states.ON_HOLD:
			pass
		
		_:
			if _event.is_action_pressed("ui_pause"):
				pause_game()


func pause_game() -> void:
	print("pause")
	current_state = states.PAUSED
	get_tree().paused = true
	show_overlay("PAUSED")

func resume_game() -> void:
	current_state = states.PLAYING
	get_tree().paused = false
	hide_overlay()

func _on_pause_timeout_timeout() -> void:
	current_state = states.PLAYING
	get_tree().paused = false

# Gameplay utils

func _on_player_border_body_entered(_body: Node2D) -> void:
	enemy_score += 1
	on_body_score(-1, "Enemy")


func _on_enemy_border_body_entered(_body: Node2D) -> void:
	player_score += 1
	on_body_score(1, "Player")

# direction should be either 1 (for direction to bottom) or -1 (upwards)
func on_body_score(new_direction: int, entity: String) -> void:
	show_overlay("%s scored!" % entity)
	$ShowOverlayTimeout.start()
	current_state = states.ON_HOLD
	
	direction_y = new_direction
	reset_ball()


func reset_ball():
	var screen_size = DisplayServer.window_get_size()
	$Ball.position = screen_size / 2
	$Ball.velocity = Vector2.ZERO
	launch_timer.start()


func _on_reset_ball_timeout_timeout() -> void:
	$Ball.launch(direction_y)
	current_state = states.PLAYING


# Methods for overlay text

func show_overlay(text: String) -> void:
	overlay.text = text
	overlay.visible = true


func hide_overlay() -> void:
	overlay.visible = false


func _on_show_overlay_timeout_timeout() -> void:
	hide_overlay()
