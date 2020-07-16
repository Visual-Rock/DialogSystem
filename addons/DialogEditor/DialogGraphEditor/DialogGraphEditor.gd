tool
extends Control

onready var AddNodeMenu : MenuButton = self.get_node("VBoxContainer/ToolBar/AddNodeMenu")

var Graph : GraphEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	#connects the id_pressed signal to add_node_menu_pressed
	AddNodeMenu.get_popup().connect("id_pressed", self, "add_node_menu_pressed")
	Graph = $VBoxContainer/GraphEdit

func add_node_menu_pressed(id):
	# calles the add_node function on the graph
	Graph.add_node(id)
