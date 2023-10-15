extends Resource
class_name Dialog

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
	template.template_name = file.get_var( )
	for nv in file.get_var( ):
		template.node_values.append(nv) 
	
	var s = ResourceLoader.load(get_scene_path())
	scene = s.instantiate()

func init( _id : int, _name : String, _path : String, _template: Template ) -> void:
	id = _id
	name = _name
	path = _path + "/" + name + ".data"
	template = _template
	scene = load("res://addons/dialogsystem/graph_editor/graph/graph_edit.tscn").instantiate()

func save( ) -> void:
	var file : FileAccess = FileAccess.open(path, FileAccess.WRITE)
	file.store_var( id )
	file.store_var( name )
	file.store_var( tags )
	file.store_var( description )
	
	file.store_var(template.template_name)
	file.store_var(template.node_values)
	
	if scene.loaded:
		scene.save_graph( )
		var s : PackedScene = PackedScene.new()
		s.pack(scene)
		ResourceSaver.save(s, get_scene_path())

func get_scene_path() -> String:
	var p = path.get_base_dir()
	
	return  p + "/Scenes/" + name + ".tscn"
