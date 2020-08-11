tool
extends "res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/BranchSections/BaseBranchSection.gd"

onready var TextLabel : Label = self.get_node("Label")

func _ready() -> void:
	TextLabel.text = str(branch_pos)
	print("pos: ", branch_pos)

func get_branch_name() -> String:
	return str(branch_pos)

func set_text(new_text : String, init : bool = false) -> void:
	print("text: ", new_text)
	if init == true:
		TextLabel.text = str(branch_pos)
	else:
		TextLabel.text = str(branch_pos)

func get_branch_bake() -> String:
	return str(branch_pos)
