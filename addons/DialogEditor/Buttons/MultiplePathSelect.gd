extends VBoxContainer

onready var AddButton : Button        = self.get_node("HBoxContainer/Add")
onready var List      : VBoxContainer = self.get_node("Templates")

func _ready():
	pass

func reset() -> void:
	pass

func add_templates(paths : Array) -> void:
	if paths.size() != 0:
		for path in paths:
			add_template(path)

func add_template(path : String):
	pass

func get_value() -> Array:
	var rtrn : Array = []
	if List.get_child_count() != 0:
		for template in List.get_children():
			rtrn.append(template.get_value())
	return rtrn
