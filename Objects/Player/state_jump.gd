extends State

@onready var sm: StateMachine = $".."
@onready var player := $"../.."

func enter() -> void:
	player.set_crouch(false)

func process(_delta: float) -> void:
	pass

func leave() -> void:
	pass
