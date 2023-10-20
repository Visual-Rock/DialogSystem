@tool
extends Control

var manager : InternalDialogManager = InternalDialogManager.new()

@onready
var overview : Control = self.get_node("TabContainer/Overview")
@onready
var grap_editor : Control = self.get_node("TabContainer/GraphEditor")

# Called when the node enters the scene tree for the first time.
func _ready():
	manager.load_templates( )
	manager.load_dialogs( )
	overview.graph_editor = grap_editor
	overview.manager = manager
	overview.populate_dialogs( )
