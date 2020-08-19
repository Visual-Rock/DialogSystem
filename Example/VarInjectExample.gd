extends Node2D

onready var btn : Button = get_node("CanvasLayer/CenterContainer/VBoxContainer/HBoxContainer/Button")

var dm : DialogManager

func _ready():
	dm = DialogManager.new()
	dm.load_dialogs("res://Example/Bakes/", "en", "en")
	dm.start("Example_004")
	dm.set_data("player_name", "player")
	update_ui(dm.get_dialogs_values(), dm.is_dialog_branched())

func update_ui(data : Dictionary, is_branched : bool):
	$CanvasLayer/CenterContainer/VBoxContainer/Panel/VBoxContainer/name.text = data["Names"]
	$CanvasLayer/CenterContainer/VBoxContainer/Panel/VBoxContainer/text.text = data["text"]

func _on_Button_pressed():
	if btn.text == "next":
		dm.next()
		update_ui(dm.get_dialogs_values(), dm.is_dialog_branched())
		if dm.is_dialog_branched() == true:
			btn.disabled = true
		if dm.get_next_dialog_id() == 99:
			btn.text = "Restart Dialog"
		return
	elif btn.text == "Restart Dialog":
		dm.restart_dialog()
		update_ui(dm.get_dialogs_values(), dm.is_dialog_branched())
		btn.text = "next"

func _on_player_name_text_changed(new_text):
	dm.set_data("player_name", $CanvasLayer/CenterContainer/VBoxContainer/HBoxContainer/player_name.text)
