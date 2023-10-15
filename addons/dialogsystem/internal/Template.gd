extends Resource
class_name Template

var template_name : String = ""
var node_values : Array[ Dictionary ] = []
var branch_values : Array[ Dictionary ] = []

func load( path : String ) -> void:
	var template : Dictionary = JSON.parse_string(FileAccess.get_file_as_string(path))
	template_name = template["template_name"]
	for nv in template["node_values"]:
		node_values.append( nv )
	for bv in template["branch_values"]:
		branch_values.append( bv )

func save_to_file( file: FileAccess ) -> void:
	file.store_var(template_name)
	file.store_var(node_values)
	file.store_var(branch_values)

func load_to_dialog( dialog: InternalDialog, file: FileAccess ) -> void:
	template_name = file.get_var( )
	for nv in file.get_var( ):
		node_values.append( nv )
	for bv in file.get_var( ):
		branch_values.append( bv )
