tool
extends Control

onready var DialogMenu : MenuButton = self.get_node("HSplitContainer/MainWindow/Toolbar/DialogMenu")
enum DIALOGMENU {
	SAVE     = 0,
	SAVEALL  = 1,
	BAKE     = 2,
	BAKEOPEN = 3,
	BAKEALL  = 4,
	CLOSE    = 5,
	CLOSEALL = 6
}

onready var NodeMenu : MenuButton = self.get_node("HSplitContainer/MainWindow/Toolbar/NodeMenu")
enum NODEMENU {
	START = 0
	TEXT  = 1
}

onready var GraphContainer : TabContainer = self.get_node("HSplitContainer/MainWindow/TabContainer")
onready var DebugLabel     : Label        = self.get_node("HSplitContainer/MainWindow/debug")

var current_graph : GraphEdit
var empty_graph   : String    = "res://addons/DialogEditor/GraphEditor/Graph/GraphEdit.tscn"

var settings_save_path : String     = "res://addons/DialogEditor/settings.json"
var save_path          : String     = "res://addons/DialogEditor/Saves/"
var bake_path          : String     = "res://Dialogs"
var bake_language      : String     = "en"
var node_template      : String     = "res://addons/DialogEditor/Template.json"
var node_values        : Dictionary = {}

func _ready() -> void:
	update_settings()
	if DialogMenu:
		DialogMenu.get_popup().connect("id_pressed", self, "dialog_menu_id_pressed")
	if NodeMenu:
		NodeMenu.get_popup().connect("id_pressed", self, "node_menu_id_pressed")
	if GraphContainer:
		GraphContainer.connect("tab_changed", self, "change_aktiv_graph")
	for sibling in get_parent().get_children():
		if sibling.name == "Dialog Manager":
			sibling.connect("open_dialog_graph", self, "open_graph")
		if sibling.name == "Editor Settings":
			sibling.connect("update_settings", self, "update_settings")

func dialog_menu_id_pressed(id : int) -> void:
	match id:
		DIALOGMENU.SAVE:
			if current_graph:
				current_graph.save_graph()
		DIALOGMENU.SAVEALL:
			if GraphContainer.get_child_count() != 0:
				for graph in GraphContainer.get_children():
					graph.save_graph()
		DIALOGMENU.BAKE:
			if current_graph:
				var dir    : Directory  = Directory.new()
				var f      : File       = File.new()
				var result : Dictionary = current_graph.bake_graph()
				if !dir.dir_exists(str(bake_path, bake_language)):
					dir.make_dir_recursive(str(bake_path, bake_language))
				f.open(str(bake_path, bake_language, current_graph.dialog_name, ".json"), f.WRITE)
				f.store_string(to_json(result))
				f.close()
				print(result)
		DIALOGMENU.BAKEOPEN:
			pass
		DIALOGMENU.BAKEALL:
			pass
		DIALOGMENU.CLOSE:
			if current_graph:
				current_graph.save_graph()
				current_graph.queue_free()
		DIALOGMENU.CLOSEALL:
			if GraphContainer.get_child_count() != 0:
				for graph in GraphContainer.get_children():
					graph.save_graph()
					graph.queue_free()

func node_menu_id_pressed(id : int) -> void:
	if GraphContainer.get_child_count() != 0:
		GraphContainer.get_child(GraphContainer.current_tab).add_node(id)

func change_aktiv_graph(tab : int) -> void:
	if current_graph:
		current_graph.save_graph()
	GraphContainer.current_tab = tab
	current_graph = GraphContainer.get_children()[tab]

func open_graph(path : String) -> void:
	if !graph_opend(path.get_file().trim_suffix(".tscn")):
		var Graph : GraphEdit
		var f     : File      = File.new()
		if f.file_exists(path):
			Graph = load(path).instance()
		else:
			Graph = load(empty_graph).instance()
			if node_values.has("node_values"):
				Graph.node_values = node_values["node_values"]
			Graph.dialog_name = path.get_file().trim_suffix(".tscn")
		Graph.name = path.get_file().trim_suffix(".tscn")
		Graph.editor = self
		GraphContainer.add_child(Graph)

func graph_opend(graph_name : String) -> bool:
	for graph in GraphContainer.get_children():
		if graph.name == graph_name:
			return true
			break
	return false

func debug_message(msg : String) -> void:
	DebugLabel.text = msg

func update_settings() -> void:
	var f : File = File.new()
	if f.file_exists(settings_save_path):
		f.open(settings_save_path, f.READ)
		var data = parse_json(f.get_as_text())
		save_path     = data["SavePath"]
		bake_path     = data["BakePath"]
		bake_language = data["DefaultBakeLanguage"]
		node_template = data["DefaultNodeTemplate"]
		f.close()
	if f.file_exists(node_template):
		f.open(node_template, f.READ)
		node_values = parse_json(f.get_as_text())
		f.close()
