extends State

@onready var sm: StateMachine = $".."
@onready var player := $"../.."

var timer: float

func enter() -> void:
	timer = 0.5
	player.set_crouch(true)

func process(delta: float) -> void:
	timer = maxf(0.0, timer - delta)
	if timer <= 0.0 and not Input.is_action_pressed("ui_down") and player.upper_front_area.get_overlapping_bodies().size() == 0:
		sm.transition(^"Walk")

func leave() -> void:
	pass
