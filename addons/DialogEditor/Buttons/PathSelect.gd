tool
extends HBoxContainer

onready var Reset        : Button     = self.get_node("Reset")
onready var PathLine     : LineEdit   = self.get_node("Path")
onready var SelectFolder : Button     = self.get_node("SelectFolder")
onready var SelectDialog : FileDialog = self.get_node("FileDialog")

export var default_path : String = ""           # Default Path to reset to
export var path_name    : String = ""           # name of path
export var current_path : String = default_path # the currently selected path

var selecte_dialog_size : Vector2 = Vector2(500, 250)

func _ready():
	# calles set path with the current path as path
	set_value(current_path)
	
	# checks if Reset is set
	if Reset:
		# connects the pressed signal to reset
		Reset.connect("pressed", self, "reset")
	# checks if PathLine is set
	if PathLine:
		# connects the text_changed signal to set_path
		PathLine.connect("text_changed", self, "set_value")
		# setss placeholder text to path name
		PathLine.placeholder_text = path_name
	# checks if SelectDialog is valid
	if SelectDialog:
		# connects the dir selected signal to set_path
		SelectDialog.connect("dir_selected", self, "set_value")
	# checks if SelectFolder is valid
	if SelectFolder:
		# connects the pressed signal to show_file_dialog
		SelectFolder.connect("pressed", self, "show_file_dialog")

# called when path shoud be reseted
func reset():
	# calles the set_path function with the default path as path
	set_value(default_path)

# sets te current path and hides buttons and does other
# things for rightly displaying everything
func set_value(path : String) -> void:
	# sets current path to path
	current_path = path
	# checks if the text of the PathLine is not the path
	# to see if the signal text_changed on the PathLine was called
	if PathLine.text != path:
		# sets the text of the PatLine to the path
		PathLine.text = path
	# checks if the current path is not the default path
	# for hideing and unhideing the reset button 
	if current_path != default_path:
		# Shows the Rese button
		Reset.show()
	else:
		# Hides the Reset button
		Reset.hide()

func get_value() -> String:
	return current_path

# shows the SelectDialog in the center with Selected Dialog Size as its size
func show_file_dialog() -> void:
	SelectDialog.popup_centered(selecte_dialog_size)
