tool
extends "res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/BranchSections/BaseBranchSection.gd"

onready var TextLabel : Label = self.get_node("Label")

func _ready() -> void:
	TextLabel.text = str(branch_pos - 1)

func get_branch_name() -> String:
	return str(branch_pos - 1)

func set_text(new_text : String) -> void:
	TextLabel.text = str(branch_pos - 1)

func get_branch_bake() -> String:
	return str(branch_pos - 1)
