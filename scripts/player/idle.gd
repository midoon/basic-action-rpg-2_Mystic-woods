class_name StateIdle extends State

@onready var walk: WalkState = $"../Walk"
@onready var attack: AttackState = $"../Attack"

func Enter() -> void:
	play_idle_animation()
	
func Physics(_delta: float) -> State:
	player.direction = get_input()
	player.velocity = Vector2.ZERO
	
	if player.direction != Vector2.ZERO:
		player.last_direction = player.direction
		return walk
	
	return null

func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null

func get_input() -> Vector2:
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"),
	)

func play_idle_animation() ->void:
	var dir = player.last_direction
	var sprite = player.animated_sprite_2d
	
	if abs(dir.x) > abs(dir.y):
		sprite.animation = "idle_side"
		sprite.flip_h = dir.x < 0
	elif dir.y > 0:
		sprite.animation = "idle_front"
	else:
		sprite.animation = "idle_front"
	
	sprite.play()
		
		
	
