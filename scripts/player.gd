extends CharacterBody2D

@export var speed: int = 400

var direction_left: String = "move_left"
var direction_right: String = "move_right"

func _physics_process(delta: float) -> void:
	# Movement controls
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed(direction_left):
		velocity.x -= speed * delta
		
	elif Input.is_action_pressed(direction_right):
		velocity.x += speed * delta
	
	move_and_collide(velocity)
