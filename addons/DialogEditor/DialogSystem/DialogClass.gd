tool
extends Resource
class_name Dialog

enum DIALOG {
	START    = 0,
	TEXT     = 1,
	BRANCHED = 2,
	
	END      = 99
}

var complette_dialog : Dictionary = {}
var current_dialog   : Dictionary = {}

var dialog           : Dictionary = {}
var values           : Array      = []

var valid_dialog     : bool       = true
var keep_complette   : bool       = true
var inited_dialog    : bool       = false

var data             : Dictionary = {}       # Used for Variable Injection or Branching Based on Value

# load Dialog
func load_from_file(file_path : String = "", _keep_complette : bool = true) -> int:
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
	if current_dialog["node_id"] != 99:
		if current_dialog["options"].has(next_name):
			current_dialog = current_dialog["options"][next_name]
		else:
			current_dialog = current_dialog["options"][get_options()[0]]
		if branched_dialog():
			match int(current_dialog["branch_type"]):
				0: # On Selection
					pass
				1: # Random
					var options : Array = get_options()
					options.shuffle()
					next(options[0])
					print(get_values(), options)
				2: # Based on value
					if data.has(str(current_dialog["branch_value_name"])):
						print(data[current_dialog["branch_value_name"]])
						next(str(data[current_dialog["branch_value_name"]]))
					else:
						print(current_dialog["branch_value_name"], " not found!")
						next(str(current_dialog["options"][get_options()[0]]))
	return OK

func back_to_start() -> int:
	current_dialog = dialog
	return OK

func start() -> int:
	
	
	
	
	return OK

func get_options(inverted : bool = false) -> Array:
	var opt : Array = current_dialog["options"].keys()
	if inverted == true:
		opt.invert()
	return opt

func get_values(dict : Dictionary = {}) -> Dictionary:
	var rtrn : Dictionary = dict
	if inited_dialog == true:
		if current_dialog.has("value"):
			for value in current_dialog["value"]:
				if get_value_type(value["name"]) == 0:
					rtrn[value["name"]] = get_name_value(value["name"])
				else:
					rtrn[value["name"]] = value["value"]
	else:
		print_debug("Init your dialog first!")
	return rtrn

func get_next_id(next_name : String = "0") -> int:
	if current_dialog.has("options"):
		if current_dialog["options"].has(next_name):
			return current_dialog["options"][next_name]["node_id"]
	return 99

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

func branched_dialog() -> bool:
	if current_dialog["node_id"] == DIALOG.BRANCHED:
		return true
	else:
		return false

func get_branch_type() -> int:
	if branched_dialog():
		return current_dialog["branch_type"]
	else:
		return -1








