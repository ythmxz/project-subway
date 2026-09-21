extends Node

func get_in_scene(p: NodePath = ^".") -> Node:
	return get_tree().current_scene.get_node(p)
