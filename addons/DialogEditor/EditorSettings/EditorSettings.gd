tool
extends Control

onready var Savepath : HBoxContainer = self.get_node("MarginContainer/ScrollContainer/VBoxContainer/MarginContainer/VBoxContainer/SavePath/PathSelect")
onready var Bakepath : HBoxContainer = self.get_node("MarginContainer/ScrollContainer/VBoxContainer/MarginContainer/VBoxContainer/BakePath/PathSelect")

var default_settings = {
	"SavePath": "res://addons/DialogEditor/Saves",
	"BakePath": "res://Dialogs",
	"SkipEmptyNodes": true,
	"DefaultBakeLanguage": "en"
}

var settings : Dictionary = default_settings

func _ready() -> void:
	var f : File = File.new()
	if f.file_exists("res://addons/DialogEditor/settings.json"):
		f.open("res://addons/DialogEditor/settings.json", f.READ)
		settings = JSON.parse(f.get_as_text()).result
		f.close()

# Saves the Editor Settings in a JSON file
func save_settings() -> void:
	
	update_settings()
	var f : File = File.new()
	f.open("res://addons/DialogEditor/settings.json", f.WRITE)
	f.store_string(to_json(settings))
	f.close()

func update_settings() -> void:
	pass
