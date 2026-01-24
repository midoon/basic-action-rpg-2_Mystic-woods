class_name Player extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine

@export var SPEED = 100.0

var direction = Vector2.ZERO
var last_direction = Vector2.DOWN

func _ready() -> void:
	state_machine.Initializer(self)
