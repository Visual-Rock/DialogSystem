tool
extends Control

var SettingsSavePath = "res://addons/DialogEditor/settings.json"

var settings : Dictionary = { "BakePath": "res://" }

func _ready():
	load_settings()

# Select Bake Path
onready var BakePathPopup : FileDialog = self.get_node("SelectBakePath")
onready var BakePathLine  : LineEdit   = self.get_node("MarginContainer/ScrollContainer/VBoxContainer/BakePath/Path/LineEdit")
onready var BakePathReset : Button     = self.get_node("MarginContainer/ScrollContainer/VBoxContainer/BakePath/Path/Reset")

func _on_Button_pressed():
	BakePathPopup.popup_centered()

func _on_LineEdit_text_changed(new_text):
	settings["BakePath"] = new_text
	if new_text != "res://":
		BakePathReset.show()
	else:
		BakePathReset.hide()
	save_settings()

func _on_SelectBakePath_dir_selected(dir):
	BakePathLine.text = dir
	settings["BakePath"] = dir
	if dir != "res://":
		BakePathReset.show()
	else:
		BakePathReset.hide()
	save_settings()

func _on_Reset_pressed():
	BakePathLine.text = "res://"
	settings["BakePath"] = "res://"
	BakePathReset.hide()
	save_settings()

func save_settings() -> void:
	var f : File = File.new()
	
	f.open(SettingsSavePath, f.WRITE)
	f.store_string(to_json(settings))

func load_settings() -> void:
	var f : File = File.new()
	if f.file_exists(SettingsSavePath):
		f.open(SettingsSavePath, f.READ)
		settings = parse_json(f.get_as_text())
		f.close()
		
		BakePathLine.text = settings["BakePath"]
		if settings["BakePath"] != "res://":
			BakePathReset.show()
		else:
			BakePathReset.hide()
