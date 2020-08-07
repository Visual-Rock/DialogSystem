extends Resource
class_name Dialog

var complette_dialog : Dictionary = {}
var current_dialog   : Dictionary = {}

var dialog           : Dictionary = {}
var values           : Array      = []

var valid_dialog     : bool       = true
var keep_complette   : bool       = true

# load Dialog
func load_from_file(file_path : String = "", _keep_complette : bool = true) -> int:
	var f : File = File.new()
	if f.file_exists(file_path):
		if f.open(file_path, f.READ) == OK:
			complette_dialog = parse_json(f.get_as_text())
			keep_complette = _keep_complette
			f.close()
			if complette_dialog.has("dialog") && complette_dialog.has("values"):
				valid_dialog = true
				return OK
			else:
				valid_dialog = false
				return ERR_CANT_RESOLVE
		else:
			return ERR_CANT_OPEN
	else:
		return ERR_FILE_NOT_FOUND

func load_from_dict(dict : Dictionary, _keep_complette : bool = true) -> int:
	if dict.has("dialog") && dict.has("values"):
		valid_dialog = true
		keep_complette = _keep_complette
		return OK
	else:
		valid_dialog = false
		return ERR_CANT_RESOLVE

# init's the dialog
func init_dialog() -> int:
	if complette_dialog.has("dialog"):
		dialog = complette_dialog["dialog"]
	else:
		return ERR_CANT_RESOLVE
	if complette_dialog.has("values"):
		values = complette_dialog["values"]
	else:
		return ERR_CANT_RESOLVE
	if keep_complette == false:
		complette_dialog.clear()
	prints("complette_dialog:", complette_dialog)
	print("dialog:", dialog)
	print("values:", values)
	return OK

# get dialog
func get_current_dialog() -> Dictionary:
	return current_dialog

func get_next_dialog() -> Dictionary:
	return {}

func next() -> int:
	return OK

func back_to_start() -> int:
	return OK

func start() -> int:
	return OK
