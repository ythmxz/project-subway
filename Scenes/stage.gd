extends Node3D

@onready var stage := $Chunk1

const SCROLL_SPEED := 10.0
const BACK_INIT_SCROLL_SPEED := -15.0
const BACK_DECCEL := 60.0

enum State { Playing, Died }
var state := State.Playing

var scroll_speed := 0.0

var player: Node3D = null

func _ready() -> void:
	player = $"Player"
	player.died.connect(func():
		state = State.Died
		scroll_speed = BACK_INIT_SCROLL_SPEED
	)

func _physics_process(delta: float) -> void:
	if state == State.Playing:
		scroll_speed = SCROLL_SPEED
	elif state == State.Died:
		scroll_speed = move_toward(scroll_speed, 0.0, BACK_DECCEL * delta)

	stage.position.z += scroll_speed * delta
