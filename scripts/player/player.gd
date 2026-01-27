class_name Player extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var attack_box: Area2D = $AttackBox

@export var SPEED = 100.0
@export var max_hp: int = 100
@export var attack_damage: int = 20

var current_hp: int
var direction = Vector2.ZERO
var last_direction = Vector2.DOWN
var spawn_position: Vector2
var is_dead:bool = false

func _ready() -> void:
	current_hp = max_hp
	spawn_position = global_position
	state_machine.Initializer(self)
	attack_box.monitoring = false

func take_damage(damage:int) -> void:
	if is_dead:
		return
	
	current_hp -= damage
	print("Player HP: ", current_hp)
	
	if current_hp <= 0:
		die()

func die() -> void:
	is_dead = true
	set_physics_process(false)
	state_machine.process_mode = Node.PROCESS_MODE_DISABLED
	
	await  get_tree().create_timer(2.0).timeout
	respawn()
	
func respawn() -> void:
	global_position = spawn_position
	current_hp = max_hp
	is_dead = false
	set_physics_process(true)
	state_machine.process_mode = Node.PROCESS_MODE_INHERIT
	print("Player Respawned!")
