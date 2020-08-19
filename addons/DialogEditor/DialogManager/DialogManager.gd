tool
extends Control

signal open_dialog_graph(graph_name)

enum DIALOGMENU {
	SELECTALL,
	DESELECTALL,
	NONE,
	BAKESELECTED,
	BAKEALL,
	SAVESELECTED,
	SAVEALL
}

enum SORTTYPES {
	NAME,
	ID,
	TAG
}

onready var Debug      : Label              = self.get_node("HSplitContainer/Dialog/debug")
onready var DialogMenu : MenuButton         = self.get_node("HSplitContainer/Dialog/HSplitContainer/VBoxContainer/ToolBar/DialogMenu")
onready var SortMenu   : OptionButton       = self.get_node("HSplitContainer/Dialog/HSplitContainer/VBoxContainer/ToolBar/SortMenu")
onready var FlipList   : CheckBox           = self.get_node("HSplitContainer/Dialog/HSplitContainer/VBoxContainer/ToolBar/FlipList")
onready var SearchList : LineEdit           = self.get_node("HSplitContainer/Dialog/HSplitContainer/VBoxContainer/ToolBar/SearchLine")
onready var SearchType : OptionButton       = self.get_node("HSplitContainer/Dialog/HSplitContainer/VBoxContainer/ToolBar/SearchOptionsMenu")
onready var SearchStop : Button             = self.get_node("HSplitContainer/Dialog/HSplitContainer/VBoxContainer/ToolBar/EndSearch")

onready var Adddialog  : Button             = self.get_node("HSplitContainer/Dialog/HSplitContainer/VBoxContainer/ToolBar/AddDialog")
onready var NewDialog  : ConfirmationDialog = self.get_node("NewDialog")
onready var DialogList : VBoxContainer      = self.get_node("HSplitContainer/Dialog/HSplitContainer/VBoxContainer/TextEdit/MarginContainer/Dialogs/List")
onready var Templates  : OptionButton       = self.get_node("NewDialog/VBoxContainer/Template")

onready var TagsTree   : Tree               = self.get_node("HSplitContainer/Dialog/HSplitContainer/Tag/MarginContainer/VBoxContainer/TagTree")
onready var AddTag     : Button             = self.get_node("HSplitContainer/Dialog/HSplitContainer/Tag/MarginContainer/VBoxContainer/HBoxContainer/AddTag")
onready var DeleteTag  : Button             = self.get_node("HSplitContainer/Dialog/HSplitContainer/Tag/MarginContainer/VBoxContainer/HBoxContainer/DeleteTag")
onready var ReloadTags : Button             = self.get_node("HSplitContainer/Dialog/HSplitContainer/Tag/MarginContainer/VBoxContainer/HBoxContainer/Reload")

var tags_root : TreeItem
var tags      : Array

var dialog : Resource = load("res://addons/DialogEditor/DialogManager/Dialog.tscn")

var save_path          : String = "res://addons/DialogEditor/Saves/"
var settings_save_path : String = "res://addons/DialogEditor/settings.json"
var tags_save_path     : String = "res://addons/DialogEditor/tags.save"
var templates          : Array  = []

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
	# checks if SortMenu is valid
	if SortMenu:
		# connects the item_selected signal of DialogMenu to change_sort_type
		SortMenu.connect("item_selected", self, "change_sort_type")
	# checks if FlipList is valid
	if FlipList:
		# connects the toggled signal of DialogMenu to change_sort_flip
		FlipList.connect("toggled", self, "change_sort_flip")
	if SearchList:
		SearchList.connect("text_changed", self, "update_search")
	if SearchType:
		SearchType.connect("item_selected", self, "update_search_type")
	if SearchStop:
		SearchStop.connect("pressed", self, "stop_search")
	if AddTag:
		AddTag.connect("pressed", self, "add_tag")
	if DeleteTag:
		DeleteTag.connect("pressed", self, "delete_tag")
	if ReloadTags:
		ReloadTags.connect("pressed", self, "reload_tags")
	if TagsTree:
		tags_root = TagsTree.create_item()
	for sibling in get_parent().get_children():
		if sibling.name == "Editor Settings":
			sibling.connect("update_settings", self, "update_settings")
	# creates a new instance of Directory
	var dir : Directory = Directory.new()
	# checks if all directorys of the savepath exist 
	if !dir.dir_exists(get_save_path()):
		# creates all the missing directorys
		dir.make_dir_recursive(get_save_path())
	# loads settings
	update_settings()
	# loads all dialogs
	load_dialogs()
	# sorts all dialogs
	sort_dialogs()
	# loads tags
	var f : File = File.new()
	if f.file_exists(tags_save_path):
		if f.open(tags_save_path, f.READ) == OK:
			tags = f.get_var()
			f.close()
			if tags.size() != 0:
				var tagitem : TreeItem
				for tag in tags:
					tagitem = TagsTree.create_item(tags_root)
					tagitem.set_text(0, tag)
					tagitem.set_editable(0, true)
			reload_tags()

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
	NewDialog.get_node("VBoxContainer/HBoxContainer/SpinBox").value = get_next_empty_dialog_id()
	# pops the NewDialog in the center with a size  new dialog size 
	NewDialog.popup_centered(new_dialog_size)

func new_dialog() -> void:
	# checks if dialog id and name already exists
	var id_exists      : bool = has_dialog_id(NewDialog.get_node("VBoxContainer/HBoxContainer/SpinBox").value)
	var name_exists    : bool = dialog_exists(NewDialog.get_node("VBoxContainer/LineEdit").text)
	var valid_filename : bool = str(NewDialog.get_node("VBoxContainer/LineEdit").text).is_valid_filename()
	# checks if the dialog name and id does not exist
	if (!name_exists && !id_exists) && valid_filename:
		# resets the debug message 
		debug_msg()
		# creates an instance of dialog
		var d = dialog.instance()
		# sets the dialog manager to self
		d.dialog_manager = self
		# sets the dialogs name and id
		d.dialog_name   = NewDialog.get_node("VBoxContainer/LineEdit").text
		d.dialog_id     = NewDialog.get_node("VBoxContainer/HBoxContainer/SpinBox").value
		# connects the debug_text and open graph signal of the dialog
		d.connect("debug_text", self, "debug_msg")
		d.connect("open_graph", self, "open_graph")
		# adds the dialog as a child of DialogList
		DialogList.add_child(d)
		open_graph(NewDialog.get_node("VBoxContainer/LineEdit").text, Templates.selected, false)
		# sets the text of LineEdit to an empty String
		NewDialog.get_node("VBoxContainer/LineEdit").text = ""
	else:
		# checks if dialog id exists
		if id_exists == true:
			# calles debug msg to display that the dialog id already exists
			debug_msg("Dialog ID Already exists! please enter a new ID")
		# checks if dialog name exists
		elif name_exists == true:
			# calles debug msg to display that the dialog already exists
			debug_msg("Dialog Already exists! please enter a new name")
		# checks if filename is valid
		elif valid_filename == true:
			# calles debug msg to display that filename has invalid Characters
			debug_msg("Dialog Name has forbidden Characters!")
		# opens the window again
		create_new_dialog()

func get_next_empty_dialog_id() -> int:
	var new_id : int = 0
	if DialogList.get_child_count() != 0:
		for dialog in DialogList.get_children():
			if dialog.dialog_id == new_id:
				new_id += 1
			else:
				break
	return new_id

func has_dialog_id(_id : int) -> bool:
	# checks if DialogList has children
	if DialogList.get_child_count() != 0:
		# loops through all children of the DialogList
		for dialog in DialogList.get_children():
			# checks if the current dialogs id is equal to _id
			if dialog.get_id() == _id:
				# returns true because id equals _id
				return true
				# breaks out of the loop
				break
	# returns false because no matching id was found
	return false

func debug_msg(msg : String = "") -> void:
	# sets the text of the debug label to the msg
	Debug.text = msg

func load_dialogs() -> void:
	# checks if DialogList has children
	if DialogList.get_child_count() != 0:
		# goes through all children of DialogList
		for c in DialogList.get_children():
			# Saves the dialog
			c.save_dialog()
			# queues the dialog for deleting  
			c.queue_free()
	# creats new instances of File and Directory
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
					# closes file
					f.close()
					# creats an instance of dialog
					d = dialog.instance()
					# calles dialog on the dialog to setup data of the dialog
					d.dialog(data, self)
					# connects the debug_text and open graph signal of the dialog
					d.connect("debug_text", self, "debug_msg")
					d.connect("open_graph", self, "open_graph")
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
			for dialog in DialogList.get_children():
				if dialog.get_selected() == true:
					dialog.bake()
		DIALOGMENU.BAKEALL:
			# bakes all dialogs
			for dialog in DialogList.get_children():
				dialog.bake()
		DIALOGMENU.SAVESELECTED:
			# Saves all selected Dialogs
			save_selected_dialogs()
		DIALOGMENU.SAVEALL:
			# Saves all dialogs
			save_all_dialogs()

func save_all_dialogs() -> void:
	# goes through all the childrens of the DialogList
	for dialog in DialogList.get_children():
		# Saves the current dialog
		dialog.save_dialog()

func save_selected_dialogs() -> void:
	# goes through all the childrens of the DialogList
	for dialog in DialogList.get_children():
		# checks if the dialog is selected
		if dialog.get_selected() == true:
			# Saves the current dialog
			dialog.save_dialog()

func set_selected_all_dialogs(selected : bool = true):
	# goes through all the childrens of the DialogList
	for dialog in DialogList.get_children():
		if dialog.visible == true:
			# sets selected
			dialog.set_selected(selected)

# updates settings and templates displayed in the 
# Templates Option Button
func update_settings() -> void:
	# creats new File
	var f : File = File.new()
	# Checks if settings file exists
	if f.file_exists(settings_save_path):
		# opens the Settings File in Read mode
		f.open(settings_save_path, f.READ)
		# parses the JSON data into a data Variable
		var data = parse_json(f.get_as_text())
		# gets the Save path and adds a "/" at the end
		save_path = str(data["SavePath"], "/")
		# gets the Array of Templates
		templates = data["DefaultNodeTemplate"]
		# Closes the File
		f.close()
		# adds the Default Template at the Start of the Array
		templates.push_front("res://addons/DialogEditor/Templates/DefaultTemplate.json")
		# Clears the Options of the Templates Option Button
	Templates.clear()
	# creates a new File 
	var ff : File       = File.new()
	# variable to hold the data of the Templates
	var d  : Dictionary = {}
	# loops through all Templates
	for template in templates:
		# Checks if the current Template exists
		if ff.file_exists(template):
			# opens the Template in Read mode
			ff.open(template, ff.READ)
			# parses the Templates data into d
			d = parse_json(ff.get_as_text())
			# checks if the Template has a template name defined
			if d.has("template_name"):
				# adds the Templates name to the Templates Option Button
				Templates.add_item(d["template_name"])
			else:
				# adds the Templates filename to the Templates Option Button
				Templates.add_item(template.get_file().trim_suffix(".json"))
			# closes the current Template file
			ff.close()

func open_graph(_name : String, template_id : int, bake : bool) -> void:
	emit_signal("open_dialog_graph", str(get_save_path(), _name, ".tscn"), template_id, bake)

# Sorting the Dialogs
func sort_dialogs(sort_type : int = SortMenu.selected, flipped : bool = !FlipList.pressed) -> void:
	# gets all children of DialogList
	var dialogs : Array = DialogList.get_children()
	# checks if DialogList has children
	if dialogs.size() != 0:
		# loops through all children of DialogList
		for child in dialogs:
			# removes the dialog (remove not delete) from DialogList
			DialogList.remove_child(child)
	# Matches the sort type
	match sort_type:
		SORTTYPES.ID:
			# checks if the search shud be flipped
			if flipped == true:
				# sorts the dialog by id ascending
				dialogs.sort_custom(SortDialogID, "sort_ascending")
			else:
				# sorts the dialog by id descending
				dialogs.sort_custom(SortDialogID, "sort_descending")
		SORTTYPES.NAME:
			if flipped == true:
				# sorts the dialog by name ascending
				dialogs.sort_custom(SortDialogName, "sort_ascending")
			else:
				# sorts the dialog by name descending
				dialogs.sort_custom(SortDialogName, "sort_descending")
	# loops through all dialogs
	for node in dialogs:
		# adds them as a child of DialogList in sorted order
		DialogList.add_child(node)

# Changes the Sort type and calls sort_dialogs
func change_sort_type(new_type : int) -> void:
	sort_dialogs()

# flips the dialog list
func change_sort_flip(new_flip : bool) -> void:
	sort_dialogs()

func update_search(search_for : String) -> void:
	if search_for != "":
		match SearchType.selected:
			SORTTYPES.NAME:
				for dialog in DialogList.get_children():
					if search_for in dialog.dialog_name:
						dialog.show()
					else:
						dialog.hide()
			SORTTYPES.ID:
				for dialog in DialogList.get_children():
					if search_for in str(dialog.dialog_id):
						dialog.show()
					else:
						dialog.hide()
			SORTTYPES.TAG:
				for dialog in DialogList.get_children():
					for tag in dialog.get_tags():
						if search_for in tag:
							dialog.show()
						else:
							dialog.hide()
	else:
		for dialog in DialogList.get_children():
			dialog.show()

func update_search_type(new_type : int) -> void:
	update_search(SearchList.text)

func stop_search() -> void:
	SearchList.text = ""
	update_search("")

func add_tag() -> void:
	var tag : TreeItem = TagsTree.create_item(tags_root)
	tag.set_text(0, "New Tag")
	tag.set_editable(0, true)
	tags.append(tag)
	save_tags()

func delete_tag() -> void:
	var selected : TreeItem = TagsTree.get_selected()
	if selected != null:
		selected.deselect(0)
		tags_root.remove_child(selected)
	save_tags()

func reload_tags() -> void:
	var new_tags : Array = get_tags()
	for dialog in DialogList.get_children():
		dialog.update_tags(new_tags)
	save_tags()

func get_tags() -> Array:
	var new_tags : Array = []
	var item : TreeItem  = tags_root.get_children()
	
	while item != null:
		new_tags.append(item.get_text(0))
		item = item.get_next()
	
	return new_tags

func save_tags() -> void:
	var tags : Array = get_tags()
	var f    : File  = File.new()
	if f.open(tags_save_path, f.WRITE) == OK:
		f.store_var(tags)
		f.close()

class SortDialogID:
	static func sort_ascending(a, b) -> bool:
		# checks if dialog a's id is smaller then b's id
		if a.get_id() < b.get_id():
			# returns true because dialog a's id is smaller then b's id
			return true
		# returns true because dialog a's id is not smaller then b's id
		return false
	
	static func sort_descending(a, b):
		# checks if dialog a's id is bigger then b's id
		if a.get_id() > b.get_id():
			# returns true because dialog a's id is bigger then b's id
			return true
		# returns true because dialog a's id is not bigger then b's id
		return false

class SortDialogName:
	static func sort_ascending(a, b) -> bool:
		# creats an array with the name of a and b
		var names : Array = [a.get_name(), b.get_name()]
		# sorts array 
		names.sort()
		# checks if the first name in the array is the name of a
		if names[0] == a.get_name():
			# returns true because the first name in the array is the name of a
			return true
		# returns false because the first name in the array is not the name of a
		return false
	
	static func sort_descending(a, b):
		# creats an array with the name of a and b
		var names : Array = [a.get_name(), b.get_name()]
		# sorts array 
		names.sort()
		# checks if the first name in the array is the name of b
		if names[0] == b.get_name():
			# returns true because the first name in the array is the name of b
			return true
		# returns false because the first name in the array is not the name of b
		return false
