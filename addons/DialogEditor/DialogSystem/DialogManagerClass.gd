extends Resource
class_name DialogManager
# Class used for high-level Dialog interactions

var dialogs : Dictionary = {}

var dialog_path       : String = ""
var default_language  : String = "en"
var selected_language : String = "en"

var options_taken : Array = []

var dialog      : Dialog
var dialog_name : String

var changed_language : bool = false

func load_dialogs(path : String = "res://", _default_language : String = "en", _selected_language : String = "en") -> int:
	default_language = _default_language
	selected_language = _selected_language
	dialog_path = path
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

func start(_dialog_name : String) -> int:
	changed_language = false
	var f : File = File.new()
	if dialogs.has(_dialog_name):
		if f.file_exists(str(dialog_path, selected_language, "/", dialogs[_dialog_name])):
			dialog_name = _dialog_name
			dialog = Dialog.new()
			return dialog.load_from_file(str(dialog_path, selected_language, "/", dialogs[_dialog_name]))
		else:
			if f.file_exists(str(dialog_path, default_language, "/", dialogs[_dialog_name])):
				dialog_name = _dialog_name
				dialog = Dialog.new()
				return dialog.load_from_file(str(dialog_path, default_language, "/", dialogs[_dialog_name]))
			else:
				return ERR_FILE_NOT_FOUND
	else:
		return ERR_FILE_NOT_FOUND

func change_language(_new_selected_language : String = default_language, _progress_dialog_to_current : bool = false) -> void:
	if selected_language != _new_selected_language:
		selected_language = _new_selected_language
		changed_language = true
		if _progress_dialog_to_current:
			start(dialog_name)
			for opt in options_taken:
				dialog.next(dialog.get_options(false)[opt])

# functions to ineract with dialog
func next(_next : String = "0") -> void:
	if dialog:
		dialog.next(_next)
		options_taken.append(clamp(dialog.get_options().find(_next), 0, 9223372036854775807))

func restart_dialog() -> void:
	if dialog:
		options_taken = []
		if changed_language:
			start(dialog_name)
		else:
			dialog.back_to_start()

func get_current_dialog() -> Dictionary:
	if dialog:
		return dialog.get_current_dialog()
	else:
		return {}

func get_dialogs_values() -> Dictionary:
	if dialog:
		return dialog.get_values()
	else:
		return {}

func get_dialogs_dialog_values() -> Dictionary:
	if dialog:
		return dialog.get_dialogs_values()
	return {}

func get_dialog_options() -> Array:
	if dialog:
		return dialog.get_options()
	return []

func get_next_dialog_id() -> int:
	if dialog:
		return dialog.get_next_id()
	return -1

func is_dialog_branched() -> bool:
	if dialog:
		return dialog.is_branched_dialog()
	return true

func injekt_data(data : Dictionary) -> void:
	if dialog:
		for key in data.keys():
			dialog.data[key] = data[key]

func injekt_variable(text : String = "", data : Dictionary = {}) -> String:
	if dialog:
		for key in data.keys():
			dialog.data[key] = data[key]
		return dialog.injekt_variable(text)
	return ""

func set_data(value_name : String, new_value) -> void:
	if dialog:
		dialog.data[value_name] = new_value
