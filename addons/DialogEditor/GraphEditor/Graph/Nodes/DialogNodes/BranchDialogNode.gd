tool
extends "res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/BaseDialogNode.gd"

enum BRANCHTYPES {
	SELECT,
	RANDOM,
	VALUE
}

onready var BranchOption    : OptionButton  = self.get_node("VBoxContainer/BranchOptions")
onready var BranchAmount    : SpinBox       = self.get_node("VBoxContainer/HBoxContainer/SpinBox")
onready var BranchSettings  : VBoxContainer = self.get_node("VBoxContainer")
onready var BranchValueName : LineEdit      = self.get_node("VBoxContainer/ValueName")

export var branch_values   : Dictionary = {}
export var branch_amount   : int        = 1
export var branch_type     : int        = 0

var branch_options  : Array = []
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

func branch_amount_update(new_branch_amount : int = branch_amount) -> void:
	branch_amount = new_branch_amount
	branch_type = BranchOption.selected
	if branch_options.size() != 0:
		for branch in branch_options:
			if branch:
				branch.queue_free()
	for i in self.get_child_count():
		self.set_slot(i, false, 0, Color(1,1,1,1), false, 0, Color(1,1,1,1), null, null)
	self.set_slot(0, true, 0, Color(1,1,1,1), false, 0, Color(1,1,1,1), null, null)
	var i : int = new_branch_amount
	while i != 0:
		var branch_section : HBoxContainer = branch_sections[branch_type].instance()
		branch_options.append(branch_section)
		branch_section.branch_pos = i
		branch_section.name       = str(i)
		self.set_slot(i, false, 0, Color(1,1,1,1), true, 0, Color(1,1,1,1), null, null)
		self.add_child_below_node(BranchSettings, branch_section)
		i -= 1
	if branch_type == BRANCHTYPES.VALUE:
		BranchValueName.show()
	else:
		BranchValueName.hide()

func branch_type_update(_selected : int = branch_type) -> void:
	branch_type = _selected
	branch_amount_update()

func get_dialog(skip_empty : bool = true) -> Dictionary:
	var rtrn : Dictionary = .get_dialog(skip_empty)
	rtrn["branch_type"] = branch_type
	if branch_type == BRANCHTYPES.VALUE:
		rtrn["branch_value_name"] = BranchValueName.text
	return rtrn

func get_options(skip_empty : bool) -> Dictionary:
	var rtrn : Dictionary = {}
	var right_node : Dictionary
	for branch in branch_options:
		if branch:
			right_node = get_parent().get_right_connected_node(name, branch.branch_pos)
			if right_node.has("to"):
				rtrn[branch.get_branch_name()] = get_parent().get_node(str(right_node["to"])).get_dialog(skip_empty)
			else:
				rtrn[branch.get_branch_name()] = { "node_id": 99 }
	return rtrn
