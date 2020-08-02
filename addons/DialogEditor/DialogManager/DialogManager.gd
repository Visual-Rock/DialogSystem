extends Control

enum DIALOGMENU {
	SELECTALL,
	DESELECTALL,
	NONE,
	BAKESELECTED,
	BAKEALL,
	SAVESELECTED,
	SAVEALL
}

onready var Debug      : Label              = self.get_node("HSplitContainer/Dialog/debug")
onready var DialogMenu : MenuButton         = self.get_node("HSplitContainer/Dialog/ToolBar/MenuButton")

onready var Adddialog  : Button             = self.get_node("HSplitContainer/Dialog/ToolBar/AddDialog")
onready var NewDialog  : ConfirmationDialog = self.get_node("NewDialog")
onready var DialogList : VBoxContainer      = self.get_node("HSplitContainer/Dialog/HSplitContainer/TextEdit/MarginContainer/Dialogs/List")

var dialog : Resource = load("res://addons/DialogEditor/DialogManager/Dialog.tscn")

var save_path : String = "res://addons/DialogEditor/Saves/"

var new_dialog_size : Vector2 = Vector2(200, 70)

func _ready() -> void:
	# checks if Adddialog is valid
	if Adddialog:
		# connects the pressed signal of Adddialog to create new dialog
		Adddialog.connect("pressed", self, "create_new_dialog")
	# checks if Newdialog is valid
	if NewDialog:
		# connects the confirmed signal of NewDialog to new dialog
		NewDialog.connect("confirmed", self, "new_dialog")
	# checks if DialogMenu is valid
	if DialogMenu:
		# connects the id pressed signal of DialogMenu to on Dialog item pressed
		DialogMenu.get_popup().connect("id_pressed", self, "_on_Dialog_item_pressed")
	# creates a new instance of Directory
	var dir : Directory = Directory.new()
	# checks if all directorys of the savepath exist 
	if !dir.dir_exists(get_save_path()):
		# creates all the missing directorys
		dir.make_dir_recursive(get_save_path())
	# loads all dialogs
	load_dialogs()

# returns the save path
func get_save_path() -> String:
	# returns the savepath
	return save_path

# checks if dialog exists
func dialog_exists(dialog_name : String = "name") -> bool:
	# Creats new File from File class
	var f : File = File.new()
	# checks if file exists 
	if f.file_exists(str(get_save_path(), dialog_name, ".data")):
		# returns true because file already exists
		return true
	else:
		# returns false because file does not exists
		return false

func create_new_dialog() -> void:
	# pops the NewDialog in the center with a size  new dialog size 
	NewDialog.popup_centered(new_dialog_size)

func new_dialog() -> void:
	# checks if the dialog does not already exist
	if !dialog_exists(NewDialog.get_node("LineEdit").text):
		# resets the debug message 
		debug_msg()
		# creates an instance of dialog
		var d = dialog.instance()
		# sets the dialog manager to self
		d.dialog_manager = self
		# sets the dialogs name to the entered text
		d.dialog_name   = NewDialog.get_node("LineEdit").text
		# connects the debug_text signal of the dialog to debug msg
		d.connect("debug_text", self, "debug_msg")
		# adds the dialog as a child of DialogList
		DialogList.add_child(d)
		# sets the text of LineEdit to an empty String
		NewDialog.get_node("LineEdit").text = ""
	else:
		# calles debug msg to display that the dialog already exists
		debug_msg("Dialog Already exists! please enter a new name")
		# opens the window again
		create_new_dialog()

func debug_msg(msg : String = "") -> void:
	# sets the text of the debug label to the msg
	Debug.text = msg

func load_dialogs() -> void:
	# checks if DialogList has children
	if DialogList.get_child_count() != 0:
		# goes thrue all children of DialogList
		for c in DialogList.get_children():
			# Saves the dialog
			c.save_dialog()
			# queues the dialog for deleting  
			c.queue_free()
	# creats nnew instances of File and Directory
	var f   : File      = File.new()
	var dir : Directory = Directory.new()
	# opens the savepath directory and continues if
	# directory got open without Errors
	if dir.open(get_save_path()) == OK:
		# Initializes the stream used to list all files and directories using the get_next() function
		dir.list_dir_begin()
		# gets the first file/directory
		var file_name : String        = dir.get_next()
		# variable for the dialogs data
		var data      : Dictionary
		# variable for the dialog
		var d         : HBoxContainer
		while file_name != "":
			# checks whether the current item processed with the last get_next() call is a directory
			if !dir.current_is_dir():
				# checks if the file name ends with .data to filter only the data files out
				if file_name.ends_with(".data"):
					# opens the dialogs data file
					f.open(str(save_path, file_name), f.READ)
					# gets data from data file
					data = f.get_var()
					# creats an instance of dialog
					d = dialog.instance()
					# calles dialog on the dialog to setup data of the dialog
					d.dialog(data, self)
					# connects the debug_text signal of the dialog to debug msg
					d.connect("debug_text", self, "debug_msg")
					# adds d as a child of DialogList
					DialogList.add_child(d)
			# gets the next element (file or directory) in the current directory
			file_name = dir.get_next()
		# Closes the current stream opened with list_dir_begin()
		dir.list_dir_end()

func _on_Dialog_item_pressed(id : int) -> void:
	# matches the pressed id with the DIALOGMENU enum
	match id:
		DIALOGMENU.SELECTALL:
			# selects all dialogs
			set_selected_all_dialogs(true)
		DIALOGMENU.DESELECTALL:
			# deselets all dialogs
			set_selected_all_dialogs(false)
		DIALOGMENU.BAKESELECTED:
			# bakes all selected dialogs
			pass
		DIALOGMENU.BAKEALL:
			# bakes all dialogs
			pass
		DIALOGMENU.SAVESELECTED:
			# Saves all selected Dialogs
			save_selected_dialogs()
		DIALOGMENU.SAVEALL:
			# Saves all dialogs
			save_all_dialogs()

func save_all_dialogs() -> void:
	# goes thrue all the childrens of the DialogList
	for dialog in DialogList.get_children():
		# Saves the current dialog
		dialog.save_dialog()

func save_selected_dialogs() -> void:
	# goes thrue all the childrens of the DialogList
	for dialog in DialogList.get_children():
		# checks if the dialog is selected
		if dialog.get_selected() == true:
			# Saves the current dialog
			dialog.save_dialog()

func set_selected_all_dialogs(selected : bool = true):
	# goes thrue all the childrens of the DialogList
	for dialog in DialogList.get_children():
		# sets selected
		dialog.set_selected(selected)










