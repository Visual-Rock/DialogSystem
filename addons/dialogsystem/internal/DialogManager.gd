extends Resource
class_name DialogManager

signal dialogs_changed

var loaded_dialogs : Array[ InternalDialog ]
var loaded_templates : Array[ Template ]
var save_path : String = "res://dialogs"

func load_templates() -> void:
	load_template("res://addons/dialogsystem/templates/BaseTemplate.json")
	load_template("res://addons/dialogsystem/templates/TestTemplate.json")

func load_template(path: String) -> void:
	var template = Template.new()
	template.load(path)
	loaded_templates.append(template)

func load_dialogs( ) -> void:
	for dialog in loaded_dialogs:
		dialog.save( )
	loaded_dialogs.clear( )
	load_directory( save_path )
	emit_signal( "dialogs_changed" )

func load_directory( path : String = save_path ) -> void:
	var file : FileAccess
	var dir : DirAccess = DirAccess.open( path )
	if dir:
		dir.list_dir_begin( )
		var f : String = dir.get_next( )
		while f != "":
			if !dir.current_is_dir( ):
				var dialog : InternalDialog = InternalDialog.new( )
				dialog.load_from_path( path + "/" + f )
				loaded_dialogs.append( dialog )
				print( path + "/" + f )
			f = dir.get_next( )
