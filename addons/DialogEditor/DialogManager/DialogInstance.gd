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

func get_id() -> int:
	return DialogID










