extends Resource
class_name DialogManager

var dialogs : Array[Dialog]
var injection_data : Dictionary = {}

func load_dialogs(path: String) -> void:
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin( )
		var f : String = dir.get_next( )
		while f != "":
			if !dir.current_is_dir( ):
				var dialog = Dialog.new()
				dialog.load_from_json( path + f )
				dialogs.append(dialog)
			f = dir.get_next( )

func get_dialog(name: String) -> Dialog:
	for dialog in dialogs:
		if dialog.name == name:
			dialog.injection_data = injection_data
			return dialog
	return null
