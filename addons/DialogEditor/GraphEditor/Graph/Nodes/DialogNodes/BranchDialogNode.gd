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

export var branch_values   : Array  = []
export var branch_value    : String = ""
export var branch_amount   : int    = 1
export var branch_type     : int    = 0

var branch_options  : Array = []
var branch_sections : Array = [
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/BranchSections/SelectSection.tscn"),
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/BranchSections/RandomSection.tscn"),
	load("res://addons/DialogEditor/GraphEditor/Graph/Nodes/DialogNodes/BranchSections/ValueSection.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if BranchAmount:
		BranchAmount.value = branch_amount
		BranchAmount.connect("value_changed", self, "branch_amount_update")
	if BranchOption:
		BranchOption.selected = branch_type
		BranchOption.connect("item_selected", self, "branch_type_update")
	if branch_options.size() != 0:
		for branch in branch_options:
			if branch:
				branch.queue_free()
	if branch_type == BRANCHTYPES.VALUE:
		BranchValueName.text = branch_value
	if branch_values.size() != 0:
		var values         : Array         = branch_values
		var branch_section : HBoxContainer
		var i              : int
		#if branch_type != BRANCHTYPES.RANDOM:         
		values.invert()
		for branch in values:
			if branch:
				branch_section = branch_sections[branch_type].instance()
				i = values.find(branch)
				branch_options.append(branch_section)
				branch_section.branch_pos = i
				self.add_child_below_node(BranchSettings, branch_section)
				self.set_slot(i + 1, false, 0, Color(1,1,1,1), true, 0, Color(1,1,1,1), null, null)
				if branch_type != BRANCHTYPES.RANDOM:
					branch_section.set_text(branch)
				else:
					branch_section.branch_pos = (int(branch) * -1) + 1
					branch_section.set_text(branch, true)
	if branch_type == BRANCHTYPES.VALUE:
		BranchValueName.show()
	else:
		BranchValueName.hide()
	self.set_slot(0, true, 0, Color(1,1,1,1), false, 0, Color(1,1,1,1), null, null)

func branch_amount_update(new_branch_amount : int = branch_amount) -> void:
	branch_amount = new_branch_amount
	branch_type = BranchOption.selected
	branch_values = []
	
	if branch_options.size() != 0:
		for branch in branch_options:
			if branch:
				branch_values.append(branch.get_branch_name())
				branch.queue_free()
	branch_options = []
	self.clear_all_slots()
	
	branch_values.resize(new_branch_amount)
	branch_values.invert()
	var i : int = new_branch_amount
	var branch_section : HBoxContainer
	
	for value in branch_values.size():
		branch_section = branch_sections[branch_type].instance()
		branch_options.append(branch_section)
		i = value
		print(value)
		branch_section.branch_pos = branch_amount - i
		self.add_child_below_node(BranchSettings, branch_section)
		self.set_slot(i + 1, false, 0, Color(1,1,1,1), true, 0, Color(1,1,1,1), null, null)
		if branch_values[value] != null:
			branch_section.set_text(branch_values[value])
	self.set_slot(0, true, 0, Color(1,1,1,1), false, 0, Color(1,1,1,1), null, null)
	
	branch_options.invert()
	
	branch_values = []
	for branch in branch_options:
		if branch:
			branch_values.append(branch.get_branch_name())
	
	if branch_type == BRANCHTYPES.VALUE:
		BranchValueName.show()
	else:
		BranchValueName.hide()

func branch_type_update(_selected : int = branch_type) -> void:
	branch_type = _selected
	branch_amount_update()
	if _selected == BRANCHTYPES.RANDOM || _selected == BRANCHTYPES.VALUE:
		include_values = false
	else:
		include_values = true

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
			right_node = get_parent().get_right_connected_node(name, branch.branch_pos + 1)
			if right_node.has("to"):
				rtrn[branch.get_branch_bake()] = get_parent().get_node(str(right_node["to"])).get_dialog(skip_empty)
			else:
				rtrn[branch.get_branch_name()] = { "node_id": 99 }
	return rtrn

func save_node() -> void:
	.save_node()
	if branch_type == BRANCHTYPES.VALUE:
		branch_value = BranchValueName.text
	branch_values = []
	for branch in branch_options:
		if branch:
			branch_values.append(branch.get_branch_name())
	branch_values.invert()
