tool
extends Control

var SettingsSavePath = "res://addons/DialogEditor/settings.json"
var DefaultBakePath  = "res://"
var DefaultSavePath  = "res://addons/DialogEditor/Saves/"

var settings : Dictionary = { "BakePath": "res://" , "SavePath": "res://addons/DialogEditor/Saves/"}

func _ready():
	load_settings()

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
	if settings["BakePath"] != DefaultBakePath:
		BakePathReset.show()
	else:
		BakePathReset.hide()
	SavePathLine.text = settings["SavePath"]
	if settings["SavePath"] != DefaultSavePath:
		SavePathReset.show()
	else:
		SavePathReset.hide()

# Select Bake Path
onready var BakePathPopup : FileDialog = self.get_node("SelectBakePath")
onready var BakePathLine  : LineEdit   = self.get_node("MarginContainer/ScrollContainer/VBoxContainer/BakePath/Path/LineEdit")
onready var BakePathReset : Button     = self.get_node("MarginContainer/ScrollContainer/VBoxContainer/BakePath/Path/Reset")

func _on_Button_pressed():
	BakePathPopup.popup_centered()

func _on_LineEdit_text_changed(new_text):
	settings["BakePath"] = new_text
	if new_text != DefaultBakePath:
		BakePathReset.show()
	else:
		BakePathReset.hide()
	save_settings()

func _on_SelectBakePath_dir_selected(dir):
	BakePathLine.text = dir
	settings["BakePath"] = dir
	if dir != DefaultBakePath:
		BakePathReset.show()
	else:
		BakePathReset.hide()
	save_settings()

func _on_Reset_pressed():
	BakePathLine.text = DefaultBakePath
	settings["BakePath"] = DefaultBakePath
	BakePathReset.hide()
	save_settings()

# Select Graph Save Path
onready var SavePathPopup : FileDialog = self.get_node("SelectSavePath")
onready var SavePathLine  : LineEdit   = self.get_node("MarginContainer/ScrollContainer/VBoxContainer/SavePath/Path/LineEdit")
onready var SavePathReset : Button     = self.get_node("MarginContainer/ScrollContainer/VBoxContainer/SavePath/Path/Reset")

func _on_Button_SavePath_pressed():
	SavePathPopup.popup_centered()

func _on_LineEdit_SavePath_text_changed(new_text):
	settings["SavePath"] = new_text
	if new_text != DefaultSavePath:
		SavePathReset.show()
	else:
		SavePathReset.hide()
	save_settings()

func _on_SelectSavePath_dir_selected(dir):
	SavePathLine.text = dir
	settings["SavePath"] = dir
	if dir != DefaultSavePath:
		SavePathReset.show()
	else:
		SavePathReset.hide()
	save_settings()

func _on_Reset_SavePath_pressed():
	BakePathLine.text = DefaultSavePath
	settings["BakePath"] = DefaultSavePath
	SavePathReset.hide()
	save_settings()
