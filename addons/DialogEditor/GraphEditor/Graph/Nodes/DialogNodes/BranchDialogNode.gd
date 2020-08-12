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
		var i              : int           = 0
		var j              : int
		values.invert()
		for branch in values:
			branch_section = branch_sections[branch_type].instance()
			j = branch_amount - i
			branch_options.append(branch_section)
			branch_section.branch_pos = j
			self.add_child_below_node(BranchSettings, branch_section)
			self.set_slot(j + 1, false, 0, Color(1,1,1,1), true, 0, Color(1,1,1,1), null, null)
			if branch_type != BRANCHTYPES.RANDOM:
				branch_section.set_text(str(branch))
			else:
				branch_section.branch_pos = int(branch)
				branch_section.set_text(branch, true)
			i += 1
	else:
		if branch_amount != 0:
			branch_amount_update(branch_amount)
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
	var options : Array = self.get_children()
	options.resize(branch_amount + 1)
	for branch in branch_amount:
		right_node = get_parent().get_right_connected_node(name, branch)
		if right_node.has("to"):
			rtrn[options[branch + 1].get_branch_bake()] = get_parent().get_node(str(right_node["to"])).get_dialog(skip_empty)
		else:
			rtrn[options[branch + 1].get_branch_bake()] = { "node_id": 99 }
	return rtrn

func save_node() -> void:
	.save_node()
	if branch_type == BRANCHTYPES.VALUE:
		branch_value = BranchValueName.text
	branch_values = []
	for branch in branch_options:
		if branch:
			branch_values.append(branch.get_branch_name())
	if branch_type == BRANCHTYPES.RANDOM:
		branch_values.sort_custom(SortRandomValues, "sort_ascending")
	else:
		branch_values.invert()

class SortRandomValues: # for Saving
	static func sort_ascending(a, b) -> bool:
		# checks if dialog a's id is smaller then b's id
		if int(a) < int(b):
			# returns true because dialog a's id is smaller then b's id
			return true
		# returns true because dialog a's id is not smaller then b's id
		return false

func get_paste_data() -> Dictionary:
	var opt = []
	for branch in branch_options:
		if branch:
			opt.append(branch.get_branch_name())
	var rtrn : Dictionary = .get_paste_data()
	rtrn["branch_type"] = branch_type
	rtrn["options"]     = opt
	return rtrn
