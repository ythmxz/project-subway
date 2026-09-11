extends Node3D

@onready var stage := $Scenery

func _physics_process(delta: float) -> void:
	stage.position.z += 10 * delta
