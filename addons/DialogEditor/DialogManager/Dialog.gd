tool
extends HBoxContainer

signal debug_text(msg)
signal open_graph(_name)

onready var SelectedBox  : CheckBox   = self.get_node("Selected")
onready var IdLabel      : Label      = self.get_node("ID")
onready var NameLabel    : Label      = self.get_node("Name")
onready var Rename : Button     = self.get_node("EditName")
onready var TagMenu      : MenuButton = self.get_node("Tags")
onready var Description  : LineEdit   = self.get_node("Description")
onready var Save         : Button     = self.get_node("Save")
onready var Open         : Button     = self.get_node("Open")
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
var tags        : Array  = []

func _ready() -> void:
	# checks if SelectedBox is valid
	if SelectedBox:
		# connects the toggled signal of SelectedBox to set_selected
		SelectedBox.connect("toggled", self, "set_selected")
	# checks if Rename is valid
	if Rename:
		# connects the pressed signal of Rename to rename
		Rename.connect("pressed", self, "rename")
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
	# checks Open is valid
	if Open:
		# connects the pressed signal of Open to open
		Open.connect("pressed", self, "open")
	if TagMenu:
		TagMenu.get_popup().connect("id_pressed", self, "on_tag_pressed")
	# calles all setters to update UI
	set_des(dialog_des)
	set_name(dialog_name)
	set_id(dialog_id)
	update_tags(tags, true)
	# Adds Icons to Buttons
	Rename.icon = load("res://addons/DialogEditor/icons/Edit.svg")
	Save.icon   = load("res://addons/DialogEditor/icons/Save.svg")
	Open.icon   = load("res://addons/DialogEditor/icons/Play.svg")
	Bake.icon   = load("res://addons/DialogEditor/icons/Bake.svg")
	Delete.icon = load("res://addons/DialogEditor/icons/Remove.svg")

func dialog(data : Dictionary, manager : Control) -> void:
	# sets all the data
	dialog_name = data["name"]
	dialog_id   = data["id"]
	dialog_des  = data["description"]
	if data.has("tags"):
		tags    = data["tags"]
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
	IdLabel.text = str(new_id)
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
	var current_tags : Array = []
	for item in TagMenu.get_popup().get_item_count():
		if TagMenu.get_popup().is_item_checked(item):
			current_tags.append(tags[item])
	# creates data Dictionary
	var data = {
		"id":           get_id(),
		"name":         get_name(),
		"description":  get_des(),
		"tags":         current_tags
	}
	# crears a new instance of File
	var f : File = File.new()
	# opens the savefile (or creates it if it does not exist) in Write mode
	if f.open(str(dialog_manager.get_save_path(), dialog_name, ".data"), f.WRITE) == OK:
		# stores the data
		f.store_var(data)
		# closes the file
		f.close()

func popup_delete_dialog() -> void:
	# Popup in the center of the screen relative to its current canvas transform
	DeleteDialog.popup_centered()

func open():
	emit_signal("open_graph", dialog_name, -1, false)

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

func update_tags(new_tags : Array = tags, all_check : bool = false) -> void:
	var current_tags : Array = get_tags()
	tags = new_tags
	TagMenu.get_popup().clear()
	for tag in new_tags.size():
		TagMenu.get_popup().add_item(new_tags[tag])
		TagMenu.get_popup().set_item_as_checkable(tag, true)
		if new_tags[tag] in current_tags || all_check == true:
			TagMenu.get_popup().set_item_checked(tag, true)
	save_dialog()

func get_tags() -> Array:
	var rtrn : Array = []
	for item in TagMenu.get_popup().get_item_count():
		if TagMenu.get_popup().is_item_checked(item):
			rtrn.append(tags[item])
	return rtrn

func on_tag_pressed(tag_id : int) -> void:
	TagMenu.get_popup().set_item_checked(tag_id, !TagMenu.get_popup().is_item_checked(tag_id))











