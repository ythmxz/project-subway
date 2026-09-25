extends CharacterBody3D

signal died()

var min_lane := -1
var max_lane := 1
var cur_lane := 0

@onready var x_center := position.x
@onready var sm: StateMachine = $StateMachine

@onready var lower_front_area: Area3D = $LowerFrontArea
@onready var upper_front_area: Area3D = $UpperFrontArea
@onready var placeholder_model: MeshInstance3D = $PlaceholderModel
@onready var placeholder_model_crouch: MeshInstance3D = $PlaceholderModelCrouch

var l_collide_up: Debug.Entry = null
var l_collide_lo: Debug.Entry = null
var l_cur_state: Debug.Entry = null

var is_dead := false
var is_crouching := false

func _ready() -> void:
	after_ready.call_deferred()

func after_ready() -> void:
	# (yohanan) pior código que eu escrevi faz um tempo...
	l_collide_up = Debug.alloc_entry("CollideUpper", self)
	l_collide_lo = Debug.alloc_entry("CollideLower", self)
	var sensors := [lower_front_area, upper_front_area]
	var labels := [l_collide_lo, l_collide_up]
	var callbacks := [on_lower_front_collision, on_upper_front_collision]
	for i in range(0, len(sensors)):
		var s = sensors[i]
		var l = labels[i]
		var c = callbacks[i]

		s.body_entered.connect(func(body: Node3D) -> void:
			l.set_text("%s" % body)
			c.call(body)
		)

		s.body_exited.connect(func(body: Node3D) -> void:
			l.set_text("")
		)

	l_cur_state = Debug.alloc_entry("Player state", self)
	sm.transitioned.connect(func(_old, new):
		l_cur_state.set_text(new.name)
	)

func _physics_process(delta: float) -> void:
	velocity.y -= 65 * delta
	move_and_slide()
	
	var x_dest := x_center + cur_lane * 3.5
	velocity.x = (x_dest - position.x) * 0.5 / delta
	velocity.z = (0 - position.z) * 0.8 / delta

	if not is_dead:
		handle_input()

	cur_lane = clampi(cur_lane, min_lane, max_lane)

	if Input.is_action_just_pressed("debug_restart"):
		get_tree().reload_current_scene()

func handle_input():
	if Input.is_action_just_pressed("ui_right"):
		cur_lane += 1
	if Input.is_action_just_pressed("ui_left"):
		cur_lane -= 1

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = 20
		sm.transition(^"Jump")

	if sm.get_state_name() == &"Jump" and Input.is_action_just_pressed("ui_down"):
		velocity.y = minf(velocity.y, -30)
		sm.transition(^"DashDown")

	if sm.get_state_name() == &"Walk" and Input.is_action_just_pressed("ui_down"):
		sm.transition(^"SlideDown")

func die() -> void:
	is_dead = true
	died.emit()

func set_crouch(crouch: bool) -> void:
	placeholder_model.visible = not crouch
	placeholder_model_crouch.visible = crouch
	is_crouching = crouch

func on_lower_front_collision(_body: Node3D) -> void:
	die()

func on_upper_front_collision(_body: Node3D) -> void:
	if not is_crouching:
		die()
