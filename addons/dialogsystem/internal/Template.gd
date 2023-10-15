extends Resource
class_name Template

var template_name : String = ""
var node_values : Array[ Dictionary ] = []

func load( path : String ) -> void:
	var template : Dictionary = JSON.parse_string(FileAccess.get_file_as_string(path))
	template_name = template["template_name"]
	for nv in template["node_values"]:
		node_values.append( nv )

func save_to_file( file: FileAccess ) -> void:
	file.store_var(template_name)
	file.store_var(node_values)

func load_to_dialog( dialog: Dialog, file: FileAccess ) -> void:
	template_name = file.get_var( )
	node_values = file.get_var( )
