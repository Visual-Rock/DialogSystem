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

var EditorVariables : Dictionary = {}

var EditorVarRoot : TreeItem

onready var VarTypeTab : Tabs         = self.get_node("HSplitContainer/PanelContainer/Variables/Variables/MarginContainer/VBoxContainer/VarTypeTab")
onready var EditorVars : Tree         = self.get_node("HSplitContainer/PanelContainer/Variables/Variables/MarginContainer/VBoxContainer/ScrollContainer/EditorVar/Tree")
onready var VarName    : LineEdit     = self.get_node("HSplitContainer/PanelContainer/Variables/VariablesSettings/MarginContainer/ScrollContainer/VBoxContainer/VarName/Name")
onready var VarType    : OptionButton = self.get_node("HSplitContainer/PanelContainer/Variables/VariablesSettings/MarginContainer/ScrollContainer/VBoxContainer/Vartype/Type")


var CurrentVarType : int

onready var AddNodeMenu : MenuButton = self.get_node("HSplitContainer/VBoxContainer/ToolBar/AddNodeMenu")

var Graph : GraphEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	#connects the id_pressed signal to add_node_menu_pressed
	AddNodeMenu.get_popup().connect("id_pressed", self, "add_node_menu_pressed")
	
	VarTypeTab.add_tab("Editor Var")
	VarTypeTab.add_tab("Node Var")
	
	EditorVarRoot = EditorVars.create_item()
	
	Graph = $HSplitContainer/VBoxContainer/GraphEdit

func add_node_menu_pressed(id):
	# calles the add_node function on the graph
	Graph.add_node(id)

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
			EditorVariables[str(id)] = { "name": "NewVar", "type": VARIABLES.NAME, "value": [] }
			open_var(EditorVariables[str(id)])

func open_var(VarToOpen : Dictionary) -> void:
	VarName.text = VarToOpen["name"]
	VarType.selected = VarToOpen["type"]

func get_new_id() -> int:
	return 1 
