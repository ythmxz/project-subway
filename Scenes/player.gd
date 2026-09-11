extends CharacterBody3D

func _physics_process(delta: float) -> void:
	velocity.y -= 100 * delta
	move_and_slide()
