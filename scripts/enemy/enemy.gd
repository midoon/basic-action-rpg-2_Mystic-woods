extends CharacterBody2D

var SPEED: int = 40
var PLAYER_CHASE: bool = false
var PLAYER: Node2D = null
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if PLAYER_CHASE:
		position += (PLAYER.position - position) / SPEED
		animation.play("walk")
		if (PLAYER.position.x - position.x) < 0:
			animation.flip_h = true
		else :
			animation.flip_h = false
	
	else:
		animation.play("idle")
			

func _on_detection_area_body_entered(body: Node2D) -> void:
	PLAYER = body
	PLAYER_CHASE = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	PLAYER = null
	PLAYER_CHASE = false
