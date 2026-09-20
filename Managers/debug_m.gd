class_name DebugM
extends Node

@onready var labels := Utils.get_at_root(self, ^"UI/DebugLabels")
var entries: Array[Entry] = []

class Entry:
	var name: StringName
	var label: Label

	func set_text(val: String) -> void:
		label.text = "{0}: {1}".format([name, val])

	func on_exit() -> void:
		label.queue_free()

func alloc(name_: StringName, dep: Node) -> Entry:
	if labels == null:
		push_error("Could not find debug UI")
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
