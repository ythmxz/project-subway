extends State

@onready var placeholder_model_crouch := $"../../PlaceholderModelCrouch"
@onready var placeholder_model := $"../../PlaceholderModel"
@onready var lower_front_area: Area3D = $"../../LowerFrontArea"
@onready var upper_front_area: Area3D = $"../../UpperFrontArea"
@onready var sm: StateMachine = $".."
@onready var player := $"../.."

func enter() -> void:
	placeholder_model.visible = false
	placeholder_model_crouch.visible = true
	lower_front_area.monitoring = true
	upper_front_area.monitoring = false

func process(_delta: float) -> void:
	pass

func leave() -> void:
	pass
