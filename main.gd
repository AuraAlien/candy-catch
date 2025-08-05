extends Node

@export var drop_scene: PackedScene
var score = 0
var time_remaining = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_remaining = $GameTimer.time_left


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_remaining = $GameTimer.time_left
	$HUD.update_timer(int(time_remaining))


func _on_player_hit(_body) -> void:
	score += _body.points
	$HUD.update_score(score)

func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("COLLECT THE CANDY
	AVOID HATE AND DEATH")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$GameTimer.start()
	
func game_over():
	$DropTimer.stop()
	$HUD.show_game_over()


func _on_drop_timer_timeout() -> void:
	var drop = drop_scene.instantiate()
	var drop_spawn_location = $DropPath/DropPathLocation
	drop_spawn_location.progress_ratio = randf()
	
	drop.position = drop_spawn_location.position
	
	var direction = drop_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	drop.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(100.0, 200.0), 0.0)
	drop.linear_velocity = velocity.rotated(direction)
	
	add_child(drop)


func _on_start_time_timeout() -> void:
	$DropTimer.start()


func _on_game_timer_timeout() -> void:
	game_over()
