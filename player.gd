extends Area2D

@export var speed = 200
var screen_size

signal hit

func _on_body_entered(_body):
	hit.emit(_body)
	_body.kill_dropper()
	# Must be deferred as we can't change physics properties on a physics callback.
	#$CollisionShape2D.set_deferred("disabled", true)

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	
	$AnimatedSprite2D.rotate(0.5 * delta)
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
