extends Resource
class_name DialogManager
# Class used for high-level Dialog interactions

var dialogs : Dictionary = {}

var dialog_path       : String = ""
var default_language  : String = "en"
var selected_language : String = "en"



func load_dialogs(path : String = "res://") -> int:
	var dir : Directory = Directory.new()
	if dir.dir_exists(path) && dir.dir_exists(str(path, default_language, "/")):
		if dir.open(str(path, default_language, "/")) == OK:
			dir.list_dir_begin()
			var file_name : String = dir.get_next()
			while file_name != "":
				if !dir.current_is_dir():
					dialogs[file_name.trim_suffix(".json")] = file_name
				file_name = dir.get_next()
			return OK
		else:
			return ERR_CANT_OPEN
	else:
		return ERR_CANT_RESOLVE
