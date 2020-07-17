tool
extends Control

enum VARTYPES {
	EDITOR,
	NODE
}

enum VARIABLES {
	NAME,
	STRING,
	MULTILINESTRING,
	INTEGER,
	FLOAT,
	BOOL,
	TEXTURE,
	SOUND
}

var SavePath : String = "res://addons/DialogEditor/"
var VarFileName : String = "variable.save"

var EditorVariables  : Dictionary = {}
var SelectedVariable : int        

var EditorVarRoot : TreeItem

onready var EditorVars  : Tree          = self.get_node("HSplitContainer/Variables/Variables/Editor/ScrollContainer/EditorVar/Tree")
onready var VarName     : LineEdit      = self.get_node("HSplitContainer/Variables/VariablesSettings/Inspektor/ScrollContainer/VBoxContainer/VarName/Name")
onready var VarType     : OptionButton  = self.get_node("HSplitContainer/Variables/VariablesSettings/Inspektor/ScrollContainer/VBoxContainer/Vartype/Type")
onready var Name        : VBoxContainer = self.get_node("HSplitContainer/Variables/VariablesSettings/Inspektor/ScrollContainer/VBoxContainer/Name")
onready var Names       : VBoxContainer = self.get_node("HSplitContainer/Variables/VariablesSettings/Inspektor/ScrollContainer/VBoxContainer/Name/MarginContainer/Names")
onready var string      : HBoxContainer = self.get_node("HSplitContainer/Variables/VariablesSettings/Inspektor/ScrollContainer/VBoxContainer/String")
onready var stringLE    : LineEdit      = self.get_node("HSplitContainer/Variables/VariablesSettings/Inspektor/ScrollContainer/VBoxContainer/String/LineEdit")
onready var multistring : VBoxContainer = self.get_node("HSplitContainer/Variables/VariablesSettings/Inspektor/ScrollContainer/VBoxContainer/MultiLineString")
onready var msTextEdit  : TextEdit      = self.get_node("HSplitContainer/Variables/VariablesSettings/Inspektor/ScrollContainer/VBoxContainer/MultiLineString/TextEdit")

var CurrentVarType : int

onready var AddNodeMenu : MenuButton = self.get_node("HSplitContainer/VBoxContainer/ToolBar/AddNodeMenu")

var Graph : GraphEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	#connects the id_pressed signal to add_node_menu_pressed
	AddNodeMenu.get_popup().connect("id_pressed", self, "add_node_menu_pressed")
	
	EditorVarRoot = EditorVars.create_item()
	EditorVars
	
	var f = File.new()
	if f.file_exists(str(SavePath, VarFileName)):
		f.open(str(SavePath, VarFileName), f.READ)
		EditorVariables = f.get_var()
		f.close()
		if EditorVariables != {}:
			for Var in EditorVariables:
				var item : TreeItem = EditorVars.create_item(EditorVarRoot)
				item.set_text(0, EditorVariables[Var]["name"])
				item.set_metadata(0, EditorVariables[Var]["id"])
	
	Graph = $HSplitContainer/VBoxContainer/GraphEdit

func add_node_menu_pressed(id):
	# calles the add_node function on the graph
	Graph.add_node(id, "dialog")

# Variables stuff

func _on_VarTypeTab_tab_changed(tab):
	CurrentVarType = tab

func _on_AddVar_pressed():
	match CurrentVarType:
		VARTYPES.EDITOR:
			var id = get_new_id()
			var item : TreeItem = EditorVars.create_item(EditorVarRoot)
			item.set_text(0, "NewVar")
			item.set_metadata(0, id)
			EditorVariables[str(id)] = { "name": "NewVar", "type": VARIABLES.NAME, "id": id, "value": [] }
			open_var(id)

func open_var(VarToOpen : int) -> void:
	
	if SelectedVariable != VarToOpen:
		save_var()
	
	var nv = EditorVariables[str(VarToOpen)]
	SelectedVariable = VarToOpen
	VarName.text = nv["name"]
	VarType.selected = nv["type"]
	
	Name.hide()
	for c in Names.get_children():
		c.queue_free()
	string.hide()
	multistring.hide()
	
	match nv["type"]:
		VARIABLES.NAME:
			for n in nv["value"]:
				var le : LineEdit = LineEdit.new()
				le.placeholder_text = "Name"
				le.text = n
				Names.add_child(le)
			Name.show()
		VARIABLES.STRING:
			string.show()
		VARIABLES.MULTILINESTRING:
			multistring.show()
			msTextEdit.text = nv["value"][0]

func save_var(VarToSave : int = SelectedVariable) -> void:
	
	var values = []
	
	match VarType.selected:
		VARIABLES.NAME:
			for c in Names.get_children():
				values.append(c.text)
		VARIABLES.STRING:
			values.append("")
		VARIABLES.MULTILINESTRING:
			values.append(msTextEdit.text)
	
	EditorVariables[str(VarToSave)] = { "name": VarName.text, "type": VarType.selected, "id": VarToSave, "value": values }
	
	var f = File.new()
	f.open(str(SavePath, VarFileName), f.WRITE)
	f.store_var(EditorVariables)
	f.close()


func get_new_id(start : int = 0) -> int:
	
	var rtrn : int = start + EditorVariables.size() + 1
	
	if EditorVariables.has(str(rtrn)) || rtrn == 0:
		rtrn = get_new_id(rtrn)
	
	return rtrn 

func _on_Tree_cell_selected() -> void:
	open_var(EditorVars.get_selected().get_metadata(0))

func _on_AddName_pressed():
	var le : LineEdit = LineEdit.new()
	le.placeholder_text = "Name"
	Names.add_child(le)

func _on_AddGraphNode_pressed():
	Graph.add_node(EditorVariables[str(SelectedVariable)]["type"], "value", EditorVariables[str(SelectedVariable)], self)

func _on_Type_item_selected(index):
	save_var()
