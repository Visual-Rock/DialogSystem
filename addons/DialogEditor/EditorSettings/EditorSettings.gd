tool
extends Control

signal update_settings()

onready var SaveSettings  : Button        = self.get_node("MarginContainer/ScrollContainer/VBoxContainer/Title/SaveSettings")
onready var ResetSettings : Button        = self.get_node("MarginContainer/ScrollContainer/VBoxContainer/Title/ResetSettings")

onready var SettingsList : VBoxContainer = self.get_node("MarginContainer/ScrollContainer/VBoxContainer/MarginContainer/VBoxContainer")
onready var Savepath     : HBoxContainer = self.get_node("MarginContainer/ScrollContainer/VBoxContainer/MarginContainer/VBoxContainer/SavePath/PathSelect")
onready var Bakepath     : HBoxContainer = self.get_node("MarginContainer/ScrollContainer/VBoxContainer/MarginContainer/VBoxContainer/BakePath/PathSelect")
onready var SkipNodes    : HBoxContainer = self.get_node("MarginContainer/ScrollContainer/VBoxContainer/MarginContainer/VBoxContainer/SkipEmptyNodes/CheckBox")
onready var BakeLanguage : HBoxContainer = self.get_node("MarginContainer/ScrollContainer/VBoxContainer/MarginContainer/VBoxContainer/DefaultLanguage/LanguageSelect")
onready var NodeTemplates: VBoxContainer = self.get_node("MarginContainer/ScrollContainer/VBoxContainer/MarginContainer/VBoxContainer/Templates/MultiplePathSelect")

var default_settings : Dictionary = {
	"SavePath": "res://addons/DialogEditor/Saves",
	"BakePath": "res://Dialogs",
	"SkipEmptyNodes": true,
	"DefaultBakeLanguage": "en",
	"DefaultNodeTemplate": "res://DialogEditor/Template.json"
}

var settings_save_path = "res://addons/DialogEditor/settings.json"

var settings : Dictionary = default_settings

func _ready() -> void:
	var f : File = File.new()
	if f.file_exists(settings_save_path):
		f.open(settings_save_path, f.READ)
		settings = JSON.parse(f.get_as_text()).result
		f.close()
		for child in SettingsList.get_children():
			child.get_child(1).reset()
		Savepath.set_value(settings["SavePath"])
		Bakepath.set_value(settings["BakePath"])
		SkipNodes.set_value(settings["SkipEmptyNodes"])
		BakeLanguage.set_value(BakeLanguage.languages.find(settings["DefaultBakeLanguage"]))
		NodeTemplates.set_value(settings["NodeTemplates"])
	if SaveSettings:
		SaveSettings.connect("pressed", self, "save_settings")
	if ResetSettings:
		ResetSettings.connect("pressed", self, "reset_settings")

# Saves the Editor Settings in a JSON file
func save_settings() -> void:
	
	update_settings()
	var f : File = File.new()
	f.open(settings_save_path, f.WRITE)
	f.store_string(to_json(settings))
	f.close()

func update_settings() -> void:
	if Savepath.get_value().is_rel_path() || Savepath.get_value().is_abs_path():
		settings["SavePath"] = Savepath.get_value()
	if Bakepath.get_value().is_rel_path() || Savepath.get_value().is_abs_path():
		settings["BakePath"] = Bakepath.get_value()
	settings["SkipEmptyNodes"] = SkipNodes.get_value()
	settings["DefaultBakeLanguage"] = BakeLanguage.get_value()
	settings["NodeTemplates"] = NodeTemplates.get_value()
	emit_signal("update_settings")

func reset_settings() -> void:
	for child in SettingsList.get_children():
		child.get_child(1).reset()
