extends CharacterBody2D

@export var speed: int = 400
@export var ball: Node2D

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO	
	velocity.x += position.direction_to(ball.position).x
	
	move_and_collide(velocity * speed * delta)
