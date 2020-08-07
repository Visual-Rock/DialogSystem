extends Resource
class_name Dialog

var complette_dialog : Dictionary = {}
var valid_dialog     : bool       = true

# load Dialog
func load_from_file(file_path : String) -> int:
	var f : File = File.new()
	if file_path.is_valid_filename() && (file_path.is_abs_path() || file_path.is_rel_path()):
		if f.file_exists(file_path):
			if f.open(file_path, f.READ) == OK:
				complette_dialog = parse_json(f.get_as_text())
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
	else:
		return ERR_FILE_BAD_PATH

func load_from_dict(dict : Dictionary) -> int:
	if dict.has("dialog") && dict.has("values"):
		valid_dialog = true
		return OK
	else:
		valid_dialog = false
		return ERR_CANT_RESOLVE
