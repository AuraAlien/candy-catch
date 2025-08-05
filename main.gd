extends Node

@export var drop_scene: PackedScene
var score = 0
var time_remaining = 0


var dropTypes = []
var barks = []

class drop_type:
	func drop_type(points, dropScene):
		self.points = points
		self.dropScene = dropScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_remaining = $GameTimer.time_left
	$Player.hide()
	dropTypes.append(preload("res://dropScenes/daniel.tscn"))
	dropTypes.append(preload("res://dropScenes/falling_object.tscn")) # Skittles, just used as extension
	dropTypes.append(preload("res://dropScenes/angelina.tscn"))
	dropTypes.append(preload("res://dropScenes/drench.tscn"))
	dropTypes.append(preload("res://dropScenes/ellie.tscn"))
	dropTypes.append(preload("res://dropScenes/reeses.tscn"))
	dropTypes.append(preload("res://dropScenes/freddie.tscn"))
	
	barks.append(preload("res://barks/ThanksForTheCandyRachelsDeadFriend.mp3"))
	barks.append(preload("res://barks/ThatsWhereItsAt.mp3"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_remaining = $GameTimer.time_left
	$HUD.update_timer(int(time_remaining))


func _on_player_hit(_body) -> void:
	score += _body.points
	
	if _body.points > 0 and $BarkPlayer.playing == false:
		$BarkPlayer.stream = barks[randi_range(0, barks.size() - 1)]
		$BarkPlayer.play()
	$HUD.update_score(score)

func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("COLLECT THE CANDY
	AVOID HATE AND DEATH")
	$Player.start($StartPosition.position)
	$Player.show()
	$StartTimer.start()
	$GameTimer.start()
	
func game_over():
	$DropTimer.stop()
	$HUD.show_game_over()


func _on_drop_timer_timeout() -> void:
	randomize()
	var randDropType = dropTypes[randi_range(0, dropTypes.size() - 1)]
	
	var drop = randDropType.instantiate()
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
