extends CharacterBody3D

var min_lane := -1
var max_lane := 1
var cur_lane := 0

@onready var x_center := position.x

func _physics_process(delta: float) -> void:
	velocity.y -= 65 * delta
	move_and_slide()
	
	var dest := x_center + cur_lane * 3.5
	position.x = lerp(position.x, dest, 0.5)
	
	if Input.is_action_just_pressed("ui_right"):
		cur_lane += 1
	if Input.is_action_just_pressed("ui_left"):
		cur_lane -= 1
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = 20
	if Input.is_action_just_pressed("ui_down") and velocity.y >= 0:
		velocity.y = minf(velocity.y, -30)
	cur_lane = clampi(cur_lane, min_lane, max_lane)
