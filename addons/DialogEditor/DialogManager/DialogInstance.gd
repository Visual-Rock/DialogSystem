tool
extends Control

var manager : Control

var DialogName : String
var DialogID   : int

func _on_create(_name : String, _id : int, _manager):
	
	DialogName = _name
	DialogID = _id
	
	manager = _manager
	save_dialog()
	update_display()

func _on_load(_data : Dictionary, _manager : Control):
	
	DialogName = _data["name"]
	DialogID = _data["id"]
	
	manager = _manager
	update_display()

func save_dialog():
	
	var f = File.new()
	
	var data : Dictionary = {
		"id": DialogID,
		"name": DialogName
	}
	
	f.open(str(manager.get_save_path(), DialogName, ".data"), f.WRITE)
	f.store_var(data)
	f.close()

func update_display() -> void:
	
	$HBoxContainer/Name.text = DialogName
	$HBoxContainer/Id.text   = str(DialogID)

func _on_Save_pressed():
	save_dialog()

func _on_Delete_pressed():
	$DeleteDialog.popup_centered()

func _on_DeleteDialog_confirmed():
	delete_dialog()

func delete_dialog() -> void:
	var dir : Directory = Directory.new()
	var savepath = manager.get_save_path()
	if dir.file_exists(str(savepath, DialogName, ".data")):
		dir.remove(str(savepath, DialogName, ".data"))
	if $DeleteDialog/CheckBox.pressed == true && dir.file_exists(str(savepath, DialogName, ".tscn")):
		dir.remove(str(savepath, DialogName, ".tscn"))
	self.queue_free()

func get_id() -> int:
	return DialogID

func _on_Open_pressed():
	manager.emit_signal("open_dialog", DialogName)
