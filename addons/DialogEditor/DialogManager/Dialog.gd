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
	
	SelectedBox.connect("toggled", self, "set_selected")
	RenameButton.connect("pressed", self, "rename")
	RenameDialog.connect("confirmed", self, "rename_name")
	Save.connect("pressed", self, "save_dialog")
	Delete.connect("pressed", self, "popup_delete_dialog")
	DeleteDialog.connect("confirmed", self, "delete")
	
	set_des(dialog_des)
	set_name(dialog_name)
	set_id(dialog_id)

func dialog(data : Dictionary, manager : Control) -> void:
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
	RenameDialog.popup_centered(rename_dialog_size)

func rename_name() -> void:
	if !dialog_manager.dialog_exists(RenameLine.text):
		set_name(RenameLine.text)
	else:
		emit_signal("debug_text", "Dialog name already taken!")

func save_dialog() -> void:
	var data = {
		"id":           get_id(),
		"name":         get_name(),
		"description":  get_des()
	}
	
	var f : File = File.new()
	f.open(str(dialog_manager.get_save_path(), dialog_name, ".data"), f.WRITE)
	f.store_var(data)
	f.close()
	
	print("Saved ", dialog_name)

func popup_delete_dialog() -> void:
	DeleteDialog.popup_centered()

func delete() -> void:
	var dir      : Directory = Directory.new()
	var savepath : String    = dialog_manager.get_save_path()
	if dir.file_exists(str(savepath, dialog_name, ".data")):
		dir.remove(str(savepath, dialog_name, ".data"))
	if dir.file_exists(str(savepath, dialog_name, ".tscn")):
		dir.remove(str(savepath, dialog_name, ".tscn"))
	self.queue_free()
	print("Delete ", dialog_name)
