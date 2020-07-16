tool
extends Control

onready var AddNodeMenu : MenuButton = self.get_node("VBoxContainer/ToolBar/AddNodeMenu")

var Graph : GraphEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	AddNodeMenu.get_popup().connect("id_pressed", self, "add_node_menu_pressed")
	Graph = $VBoxContainer/GraphEdit

func add_node_menu_pressed(id):
	Graph.add_node(id)
