extends Resource
class_name InternalDialog

signal prep_for_bake(dialog: InternalDialog)

var path : String = ""

var id : int = -1
var name : String = ""
var tags : Array = [ ]
var description : String = ""
var template : Template

var scene : Control

func load_from_path( _path : String ) -> void:
	path = _path
	var file : FileAccess = FileAccess.open(path, FileAccess.READ)
	id = file.get_var( )
	name = file.get_var( )
	tags = file.get_var( )
	description = file.get_var( )
	
	template = Template.new()
	template.load_to_dialog(self, file)
	
	var s = ResourceLoader.load(get_scene_path())
	scene = s.instantiate()

func init( _id : int, _name : String, _path : String, _template: Template ) -> void:
	id = _id
	name = _name
	path = _path + "/" + name + ".data"
	template = _template
	scene = load("res://addons/dialogsystem/graph_editor/graph/graph_edit.tscn").instantiate()
	scene.save_graph( )
	var s : PackedScene = PackedScene.new()
	s.pack(scene)
	ResourceSaver.save(s, get_scene_path())

func save( ) -> void:
	print("Hello")
	var file : FileAccess = FileAccess.open(path, FileAccess.WRITE)
	file.store_var( id )
	file.store_var( name )
	file.store_var( tags )
	file.store_var( description )
	
	template.save_to_file( file )
	
	if scene.loaded:
		scene.save_graph( )
		var s : PackedScene = PackedScene.new()
		s.pack(scene)
		ResourceSaver.save(s, get_scene_path())

func get_scene_path() -> String:
	var p = path.get_base_dir()
	return  p + "/Scenes/" + name + ".tscn"

func get_bake_path() -> String:
	var p = path.get_base_dir()
	return  p + "/Bakes/" + name + ".json"

func bake( ) -> void:
	if !scene.loaded:
		emit_signal("prep_for_bake", self)
	
	if scene.StartNode != null:
		var out : Dictionary = {}
		var nodes : Array[Dictionary] = []
		var id : int = 0
		
		var nodes_map = {}
		
		for node in scene.get_children():
			if node is GraphNode:
				nodes.append(node.get_bake_data(id))
				nodes_map[node.name] = id
				id += 1
		
		for connection in scene.connections:
			var node = nodes[nodes_map[connection["from_node"]]]
			var to = nodes_map[connection["to_node"]]
			if node["type"] == 2:
				node["branches"][connection["from_port"]]["next"] = to
			elif node["type"] == 3:
				pass # End
			else:
				node["next"] = to
		
		out["nodes"] = nodes
		out["start"] = 0
		var file = FileAccess.open(get_bake_path(), FileAccess.WRITE)
		file.store_string( JSON.stringify(out) )
	
	pass
