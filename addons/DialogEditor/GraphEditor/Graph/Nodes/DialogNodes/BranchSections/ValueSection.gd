tool
extends "res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/BranchSections/BaseBranchSection.gd"

onready var LE : LineEdit = self.get_node("LineEdit")

func _ready() -> void:
	LE.placeholder_text = str("Value ", branch_pos - 1)

func get_branch_name() -> String:
	return LE.text

func set_text(new_text : String) -> void:
	LE.text = new_text

func get_branch_bake() -> String:
	if LE.text != "":
		return LE.text
	else:
		return str(branch_pos)
