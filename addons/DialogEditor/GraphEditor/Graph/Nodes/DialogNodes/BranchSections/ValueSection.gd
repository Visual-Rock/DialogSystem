extends "res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/BranchSections/BaseBranchSection.gd"

onready var LE : LineEdit = self.get_node("LineEdit")

func get_branch_name() -> String:
	if LE.text != "":
		return LE.text
	else:
		return str(branch_pos)
