tool
extends Resource
class_name Dialog

var complette_dialog : Dictionary = {}
var current_dialog   : Dictionary = {}

var dialog           : Dictionary = {}
var values           : Array      = []

var valid_dialog     : bool       = true
var keep_complette   : bool       = true
var inited_dialog    : bool       = false

# load Dialog
func load_from_file(file_path : String = "", _keep_complette : bool = true) -> int:
	print("load from file")
	var f : File = File.new()
	if f.file_exists(file_path):
		if f.open(file_path, f.READ) == OK:
			complette_dialog = parse_json(f.get_as_text())
			keep_complette = _keep_complette
			f.close()
			if complette_dialog.has("dialog") && complette_dialog.has("value"):
				valid_dialog = true
				init_dialog()
				return OK
			else:
				valid_dialog = false
				return ERR_CANT_RESOLVE
		else:
			return ERR_CANT_OPEN
	else:
		return ERR_FILE_NOT_FOUND

func load_from_dict(dict : Dictionary, _keep_complette : bool = true) -> int:
	print("load from dict")
	if dict.has("dialog") && dict.has("value"):
		valid_dialog = true
		keep_complette = _keep_complette
		init_dialog()
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
	if complette_dialog.has("value"):
		values = complette_dialog["value"]
	else:
		return ERR_CANT_RESOLVE
	if keep_complette == false:
		complette_dialog.clear()
	current_dialog = dialog
	print("init")
	inited_dialog = true
	return OK

# get dialog
func get_current_dialog() -> Dictionary:
	var rtrn : Dictionary = get_values()
	rtrn["node_id"] = current_dialog["node_id"]
	rtrn["options"] = get_options()
	return rtrn

func get_next_dialog() -> Dictionary:
	return {}

func next(next_name : String = "0") -> int:
	current_dialog = current_dialog["options"][next_name]
	return OK

func back_to_start() -> int:
	current_dialog = dialog
	return OK

func start() -> int:
	
	
	
	
	return OK

func get_options() -> Array:
	return current_dialog["options"].keys()

func get_values(dict : Dictionary = {}) -> Dictionary:
	var rtrn : Dictionary = dict
	if inited_dialog == true:
		for value in current_dialog["value"]:
			if get_value_type(value["name"]) == 0:
				rtrn[value["name"]] = get_name_value(value["name"])
			else:
				rtrn[value["name"]] = value["value"]
	else:
		print_debug("Init your dialog first!")
	return rtrn

func get_next_id(next_name : String = "0") -> int:
	return current_dialog["options"][next_name]["node_id"]

func get_name_value(value_name : String) -> String:
	for value in values:
		if value["name"] == value_name:
			return value["value"][get_selected(value_name)]
			break
	return ""

func get_selected(value_name : String) -> int:
	
	for value in current_dialog["value"]:
		if value["name"] == value_name:
			return value["value"]
			break
	return 0

func get_value_type(value_name : String) -> int:
	for value in values:
		if value["name"] == value_name:
			return value["type"]
	return 0












