extends CharacterBody3D

var min_lane := -1
var max_lane := 1
var cur_lane := 0

@onready var x_center := position.x
@onready var sm: StateMachine = $StateMachine

@onready var lower_front_area: Area3D = $LowerFrontArea
@onready var upper_front_area: Area3D = $UpperFrontArea

@onready var debug_m: DebugM = Utils.get_at_root(self, ^"DebugM")
var l_collide_up: DebugM.Entry = null
var l_collide_lo: DebugM.Entry = null

func _ready() -> void:
	after_ready.call_deferred()

func after_ready() -> void:
	l_collide_up = debug_m.alloc("CollideUpper", self)
	l_collide_lo = debug_m.alloc("CollideLower", self)

	# pior código que eu escrevi faz um tempo...
	var sensors := [lower_front_area, upper_front_area]
	var labels := [l_collide_lo, l_collide_up]
	var callbacks := [on_lower_front_collision, on_upper_front_collision]
	for i in range(0, len(sensors)):
		var s = sensors[i]
		var l = labels[i]
		var c = callbacks[i]

		s.body_entered.connect(func(body: Node3D) -> void:
			if body == self:
				return
			l.set_text("%s" % body)
			c.call(body)
		)

		s.body_exited.connect(func(body: Node3D) -> void:
			if body == self:
				return
			l.set_text("")
		)

func _physics_process(delta: float) -> void:
	velocity.y -= 65 * delta
	move_and_slide()
	
	var dest := x_center + cur_lane * 3.5
	velocity.x = (dest - position.x) * 0.5 / delta
	velocity.z = (0 - position.z) * 0.8 / delta

	if Input.is_action_just_pressed("ui_right"):
		cur_lane += 1
	if Input.is_action_just_pressed("ui_left"):
		cur_lane -= 1
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = 20
		sm.transition(^"Jump")
	if Input.is_action_just_pressed("ui_down") and velocity.y >= 0:
		velocity.y = minf(velocity.y, -30)
		sm.transition(^"SlideDown" if is_on_floor() else ^"DashDown")

	cur_lane = clampi(cur_lane, min_lane, max_lane)

func on_lower_front_collision(body: Node3D) -> void:
	pass

func on_upper_front_collision(body: Node3D) -> void:
	pass
