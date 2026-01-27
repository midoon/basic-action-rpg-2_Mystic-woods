class_name AttackState extends State

@export_range(1,20,0.5) var decelerate_speed: float = 5.0
@export var attack_duration := 0.3

@onready var walk: WalkState = $"../Walk"
@onready var idle: StateIdle = $"../Idle"
@onready var attack_box: Area2D = $"../../AttackBox"
 

var is_attacking: bool = false

func Enter() -> void:
	is_attacking = true
	play_attack_animation()
	start_attack()

func Physics(_delta: float) -> State:
	player.direction = get_input()
	player.velocity -= player.velocity * decelerate_speed * _delta
	player.move_and_slide()
	
	if !is_attacking:
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
	
func start_attack() -> void:
	attack_box.monitoring = true
	await get_tree().create_timer(attack_duration).timeout 
	attack_box.monitoring = false
	is_attacking = false
	



func _on_animated_sprite_2d_animation_finished() -> void:
	is_attacking = false
	

func _on_attack_box_area_entered(area: Area2D) -> void:
	if not is_attacking:
		return
		
	if area.is_in_group("enemy_hitbox"):
		var enemy = area.get_parent()
		if enemy and enemy.has_method("take_damage"):
			enemy.take_damage(player.attack_damage) 
	


func _on_attack_box_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy_hitbox"):
		print("Attack State Exit area")
	
