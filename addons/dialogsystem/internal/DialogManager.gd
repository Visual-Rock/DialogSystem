extends Resource
class_name InternalDialogManager

signal dialogs_changed

var loaded_dialogs : Array[ InternalDialog ]
var loaded_templates : Array[ Template ]
var save_path : String = "res://dialogs"
var templates_path : String = "res://addons/dialogsystem/templates/"

func load_templates() -> void:
	loaded_templates.clear()
	var dir : DirAccess = DirAccess.open( templates_path )
	if dir:
		dir.list_dir_begin( )
		var f : String = dir.get_next( )
		while f != "":
			if !dir.current_is_dir( ):
				load_template( templates_path + f )
			f = dir.get_next( )

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

func delete_dialog( dialog: InternalDialog ) -> void:
	DirAccess.remove_absolute(dialog.path)
	DirAccess.remove_absolute(dialog.get_scene_path())
	DirAccess.remove_absolute(dialog.get_bake_path())
	loaded_dialogs.erase(dialog)
	load_dialogs()

func delete_dialogs( dialogs: Array[ InternalDialog ] ) -> void:
	for dialog in dialogs:
		DirAccess.remove_absolute(dialog.path)
		DirAccess.remove_absolute(dialog.get_scene_path())
		DirAccess.remove_absolute(dialog.get_bake_path())
		loaded_dialogs.erase(dialog)
	load_dialogs()
