tool
extends HBoxContainer

signal debug_text(msg)

onready var SelectedBox  : CheckBox   = self.get_node("Selected")
onready var NameLabel    : Label      = self.get_node("Name")
onready var RenameButton : Button     = self.get_node("EditName")
onready var TagMenu      : MenuButton = self.get_node("Tags")
onready var Description  : LineEdit   = self.get_node("Description")
onready var Save         : Button     = self.get_node("Save")
onready var Bake         : Button     = self.get_node("Bake")
onready var Delete       : Button     = self.get_node("Delete")

onready var DeleteDialog : ConfirmationDialog = self.get_node("DeleteDialog")
onready var RenameDialog : ConfirmationDialog = self.get_node("RenameDialog")
onready var RenameLine   : LineEdit           = RenameDialog.get_node("VBoxContainer/LineEdit")

var rename_dialog_size : Vector2 = Vector2(250, 125)
var delete_dialog_size : Vector2 = Vector2(250, 125)

var dialog_manager : Control = null

var selected    : bool   = false
var dialog_id   : int    = 0
var dialog_name : String = ""
var dialog_des  : String = ""

func _ready() -> void:
	# checks if SelectedBox is valid
	if SelectedBox:
		# connects the toggled signal of SelectedBox to set_selected
		SelectedBox.connect("toggled", self, "set_selected")
	# checks if RenameButton is valid
	if RenameButton:
		# connects the pressed signal of RenameButton to rename
		RenameButton.connect("pressed", self, "rename")
	# checks if RenameDialog is valid
	if RenameDialog:
		# connects the confirmed signal of RenameDialog to rename_name
		RenameDialog.connect("confirmed", self, "rename_name")
	# checks if Save is valid
	if Save:
		# connects the pressed signal of Save to save_dialog
		Save.connect("pressed", self, "save_dialog")
	# checks if Delete is valid
	if Delete:
		# connects the pressed signal of Delete to popup_delete_dialog
		Delete.connect("pressed", self, "popup_delete_dialog")
	# checks if DeleteDialog is valid
	if DeleteDialog:
		# connects the confirmed signal of DeleteDialog to delete
		DeleteDialog.connect("confirmed", self, "delete")
	# calles all setters to update UI
	set_des(dialog_des)
	set_name(dialog_name)
	set_id(dialog_id)

func dialog(data : Dictionary, manager : Control) -> void:
	# sets all the data
	dialog_name = data["name"]
	dialog_id   = data["id"]
	dialog_des  = data["description"]
	dialog_manager = manager

func set_selected(_selected : bool) -> void:
	selected = _selected
	SelectedBox.pressed = selected

func get_selected() -> bool:
	return selected

func set_name(_name : String = dialog_name) -> void:
	dialog_name = _name
	if NameLabel:
		NameLabel.text = _name
	save_dialog()

func get_name() -> String:
	return dialog_name

func set_id(new_id : int = dialog_id) -> void:
	dialog_id = new_id

func get_id() -> int:
	return dialog_id

func set_des(new_description : String = dialog_des) -> void:
	if Description:
		Description.text = new_description
		dialog_des = new_description

func get_des() -> String:
	if Description:
		dialog_des = Description.text
		return Description.text
	else:
		return dialog_des

func rename() -> void:
	# Popup in the center of the screen relative to its current canvas transform
	RenameDialog.popup_centered(rename_dialog_size)

func rename_name() -> void:
	# checks if dialog does not exists
	if !dialog_manager.dialog_exists(RenameLine.text):
		# sets the name
		set_name(RenameLine.text)
	else:
		# emit the debug text signal
		emit_signal("debug_text", "Dialog name already taken!")

func save_dialog() -> void:
	# creates data Dictionary
	var data = {
		"id":           get_id(),
		"name":         get_name(),
		"description":  get_des()
	}
	# crears a new instance of File
	var f : File = File.new()
	# opens the savefile (or creates it if it does not exist) in Write mode
	f.open(str(dialog_manager.get_save_path(), dialog_name, ".data"), f.WRITE)
	# stores the data
	f.store_var(data)
	# closes the file
	f.close()
	
	print("Saved ", dialog_name)

func popup_delete_dialog() -> void:
	# Popup in the center of the screen relative to its current canvas transform
	DeleteDialog.popup_centered()

func delete() -> void:
	# Creates new instance of Directory and gets savepath
	var dir      : Directory = Directory.new()
	var savepath : String    = dialog_manager.get_save_path()
	# checks if data file exists
	if dir.file_exists(str(savepath, dialog_name, ".data")):
		# removes the data file
		dir.remove(str(savepath, dialog_name, ".data"))
	# checks if dialog graph exist
	if dir.file_exists(str(savepath, dialog_name, ".tscn")):
		# removes the dialog graph
		dir.remove(str(savepath, dialog_name, ".tscn"))
	# queues it's self for deletion
	self.queue_free()
	print("Delete ", dialog_name)
