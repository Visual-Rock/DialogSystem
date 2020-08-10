tool
extends "res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/BranchSections/BaseBranchSection.gd"

onready var LE : LineEdit = self.get_node("LineEdit")

func _ready() -> void:
	LE.placeholder_text = str("Way ", branch_pos - 1)

func get_branch_name() -> String:
	if LE.text != "":
		return LE.text
	else:
		return str(branch_pos)
