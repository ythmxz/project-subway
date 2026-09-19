class_name Utils

static func get_at_root(ref: Node, p: NodePath = ^".") -> Node:
	return ref.get_tree().current_scene.get_node(p)
