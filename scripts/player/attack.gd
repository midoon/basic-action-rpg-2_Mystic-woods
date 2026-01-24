class_name AttackState extends State

@export_range(1,20,0.5) var decelerate_speed: float = 5.0

@onready var walk: WalkState = $"../Walk"
@onready var idle: StateIdle = $"../Idle"

var isAttacking: bool = false

func Enter() -> void:
	isAttacking = true
	play_attack_animation()

func Physics(_delta: float) -> State:
	player.direction = get_input()
	player.velocity -= player.velocity * decelerate_speed * _delta
	player.move_and_slide()
	
	if !isAttacking:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	
	return null

func get_input() -> Vector2:
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

func play_attack_animation():
	var dir = player.last_direction
	var sprite = player.animated_sprite_2d
	
	if abs(dir.x) > abs(dir.y):
		sprite.animation = "attack_side"
		sprite.flip_h = dir.x < 0
	elif dir.y > 0:
		sprite.animation = "attack_front"
	else:
		sprite.animation = "attack_back"
	
	sprite.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	isAttacking = false
	
