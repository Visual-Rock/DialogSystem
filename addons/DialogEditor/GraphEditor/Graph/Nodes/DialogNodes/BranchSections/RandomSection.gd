extends "res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/BranchSections/BaseBranchSection.gd"

func get_branch_name() -> String:
	return str(branch_pos)
