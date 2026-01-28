extends CharacterBody2D

var SPEED: int = 40
var PLAYER_CHASE: bool = false
var PLAYER: Node2D = null
var is_dead := false

@export var max_hp:int = 100
@export var attack_daamge: int = 25
@export var attack_cooldown: float = 1.5

var current_hp:int
var can_attack: bool = true
var player_in_hitbox: bool = false

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: Area2D = $HitBox
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var colission_detection_area: CollisionShape2D = $detectionArea/colissionDetectionArea


func _ready():
	current_hp = max_hp
	hit_box.add_to_group("enemy_hitbox")

func _physics_process(_delta: float) -> void:
	if is_dead:
		return
		
	if PLAYER_CHASE and PLAYER:
		var distance = position.distance_to(PLAYER.position)
		if distance < 30:
			animation.play("idle")
			
			if player_in_hitbox:
				attack_player()
		else:
			position += (PLAYER.position - position) / SPEED
			animation.play("walk")
			if (PLAYER.position.x - position.x) < 0:
				animation.flip_h = true
			else:
				animation.flip_h = false
	else:
		animation.play("idle")

func attack_player() -> void:
	if can_attack and PLAYER and PLAYER.has_method("take_damage"):
		PLAYER.take_damage(attack_daamge)
		can_attack = false
		
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true

func take_damage(damage: int) -> void:
	if is_dead:
		return
	
	current_hp -= damage
	print("Enemy HP: ", current_hp)
	
	animation.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	animation.modulate = Color.WHITE
	
	if current_hp <= 0:
		die()

func die():
	is_dead = true
	PLAYER_CHASE = false
	
	set_physics_process(false)
	collision_shape_2d.set_deferred("disabled", true)
	colission_detection_area.set_deferred("disabled", true)
	hit_box.monitoring = false
	
	animation.play("dead")
	
	await animation.animation_finished
	queue_free()
	

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		PLAYER = body
		PLAYER_CHASE = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is Player:
		PLAYER = null
		PLAYER_CHASE = false


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_attack") or area.owner is Player:
		player_in_hitbox = true


func _on_hit_box_area_exited(area: Area2D) -> void:
	if area.is_in_group("player_attack") or area.owner is Player:
		player_in_hitbox = false
