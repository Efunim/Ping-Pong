extends CharacterBody2D

@export var min_speed: int = 400
@export var max_speed: float = 400

var collision_normal = Vector2.RIGHT

var speed: float

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * speed * delta, false, 0.1)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
			
		var reflection = collision.get_remainder().bounce(collision.get_normal())
		move_and_collide(reflection)
		
		if speed < max_speed:
			speed += 10

func launch(direction_y: int = -1): # Shows which playe's side it is, -1 means player
	# Randomise ball angle between around 215 and 330 deg
	# We need to change angle only on X axis, so I used Vector2.RIGHT
	speed = min_speed
	
	velocity = Vector2.RIGHT.rotated(randf_range(3.5, 5.5))
	velocity.y *= direction_y
