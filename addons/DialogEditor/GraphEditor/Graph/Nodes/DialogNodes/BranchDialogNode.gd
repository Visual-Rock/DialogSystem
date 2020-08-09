tool
extends "res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/BaseDialogNode.gd"

enum BRANCHTYPES {
	SELECT,
	RANDOM,
	VALUE
}

onready var BranchOption   : OptionButton  = self.get_node("VBoxContainer/BranchOptions")
onready var BranchAmount   : SpinBox       = self.get_node("VBoxContainer/HBoxContainer/SpinBox")
onready var BranchSettings : VBoxContainer = self.get_node("VBoxContainer")

export var branch_options  : Array = []
export var branch_amount   : int   = 1
export var branch_type     : int   = 0
var branch_sections : Array = [
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/BranchSections/SelectSection.tscn"),
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/BranchSections/RandomSection.tscn"),
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/BranchSections/ValueSection.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if BranchAmount:
		BranchAmount.connect("value_changed", self, "branch_amount_update")
	if BranchOption:
		BranchOption.connect("item_selected", self, "branch_type_update")
	if branch_options != []:
		for section in branch_options:
			self.add_child_below_node(BranchSettings, section)

func branch_amount_update(new_branch_amount : int = branch_amount) -> void:
	branch_type = BranchOption.selected
	if branch_options.size() != 0:
		for branch in branch_options:
			if branch:
				branch.queue_free()
	var i : int = new_branch_amount
	while i != 0:
		var branch_section : HBoxContainer = branch_sections[branch_type].instance()
		branch_options.append(branch_section)
		self.add_child_below_node(BranchSettings, branch_section)
		i -= 1

func branch_type_update(_selected : int = branch_type) -> void:
	branch_type = _selected
	branch_amount_update()

func save_node() -> void:
	.save_node()
	for section in branch_options:
		section.owner = self
		section.save()
