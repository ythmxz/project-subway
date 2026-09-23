extends Node

var labels: Node = null
var entries: Array[Entry] = []

func _ready() -> void:
	get_tree().scene_changed.connect(on_scene_change)
	on_scene_change()

func on_scene_change() -> void:
	labels = Utils.get_in_scene(^"UI/DebugLabels")

class Entry:
	var name: StringName
	var label: Label

	func set_text(val: String) -> void:
		label.text = "{0}: {1}".format([name, val])

	func on_exit() -> void:
		label.queue_free()

func alloc_entry(name_: StringName, dep: Node) -> Entry:
	if labels == null:
		push_error("Debug UI reference missing")
		return null

	var l := Label.new()
	labels.add_child(l)

	var e := Entry.new()
	e.name = name_
	e.label = l
	e.set_text("")

	dep.tree_exiting.connect(e.on_exit)
	entries.append(e)
	return e
