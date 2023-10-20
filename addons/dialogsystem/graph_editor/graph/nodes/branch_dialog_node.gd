@tool
extends "res://addons/dialogsystem/graph_editor/graph/nodes/base_node.gd"

@export var branches : Array[ Array ] = [ ]
@export var branch_template : Array = [ ]
@export var selected_type : int = 0

@onready var BranchHeader : VBoxContainer = self.get_node("Branch")
@onready var BranchTypeMenu : OptionButton = self.get_node("Branch/OptionButton")
@onready var BranchNumberSpinBox : SpinBox = self.get_node("Branch/HBoxContainer/SpinBox")

var BranchSections : PackedScene = load("res://addons/dialogsystem/graph_editor/graph/nodes/node_value_container.tscn")

func _ready():
	super._ready()
	BranchTypeMenu.selected = selected_type
	self.remove_child(NodeValueContainer)
	if branches.is_empty( ):
		var b = BranchSections.instantiate( )
		b.name = "0"
		self.add_child(b)
		b.load_template(branch_template)
		
		set_slot_enabled_right( 1, true )
	else:
		BranchNumberSpinBox.set_value_no_signal(branches.size())
		var i : int = 0
		for branch in branches:
			var b = BranchSections.instantiate( )
			b.name = str(i)
			self.add_child(b)
			b.load_template(branch)
			set_slot_enabled_right( i + 1, true )
			i += 1
	add_child( NodeValueContainer )


func _on_spin_box_value_changed(value):
	self.remove_child(NodeValueContainer)
	var arr : Array[ Control ] = [ ]
	for i in range(0, get_child_count()):
		if i == 0:
			set_slot_type_left(i, false)
		else:
			set_slot_enabled_right( 1, false )
			arr.append( get_child( 1 ) )
			remove_child( get_child( 1 ) )
	
	if value <= arr.size():
		for i in range(0, value):
			add_child( arr[ i ] )
			set_slot_enabled_right( i + 1, true )
	else:
		for i in range(0, arr.size()):
			add_child( arr[ i ] )
			set_slot_enabled_right( i + 1, true )
		
		for i in range(arr.size(), value):
			var b = BranchSections.instantiate( )
			b.name = str(i)
			self.add_child(b)
			b.load_template(branch_template)
			set_slot_enabled_right( i + 1, true )
	
	add_child( NodeValueContainer )

func save() -> void:
	dialog_values = [ ]
	selected_type = BranchTypeMenu.selected
	branches.clear( )
	for c in NodeValueContainer.get_children( ):
		if c.has_method( "get_save_data" ):
			dialog_values.append( c.get_save_data( ) )
	for c in get_children():
		if c != NodeValueContainer && c != BranchHeader:
			var arr : Array[ Dictionary ] = []
			for bc in c.get_children():
				if bc.has_method( "get_save_data" ):
					arr.append( bc.get_save_data( ) )
			branches.append(arr)

func get_bake_data(id: int) -> Dictionary:
	var dict : Dictionary = super.get_bake_data( id )
	dict["branch_type"] = BranchTypeMenu.selected
	dict["branches"] = [ ]
	for c in get_children():
		if c != NodeValueContainer && c != BranchHeader:
			var arr : Array[ Dictionary ] = []
			for bc in c.get_children():
				if bc.has_method( "get_data" ):
					arr.append( bc.get_data( ) )
			dict["branches"].append({"values": arr})
	return dict
