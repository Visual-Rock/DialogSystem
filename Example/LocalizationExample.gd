extends Node2D

onready var btn           : Button        = get_node("CanvasLayer/CenterContainer/VBoxContainer/HBoxContainer/Button")
onready var SelectButtons : VBoxContainer = get_node("CanvasLayer/CenterContainer/VBoxContainer/options")

var dm : DialogManager = DialogManager.new()

var lang : Array = ["en", "de"]

func _ready():
	update_ui(dm.get_dialog_values(), dm.is_dialog_branched())

func update_ui(data : Dictionary, is_branched : bool):
	$CanvasLayer/CenterContainer/VBoxContainer/Panel/VBoxContainer/name.text = data["Names"]
	$CanvasLayer/CenterContainer/VBoxContainer/Panel/VBoxContainer/text.text = data["text"]
	if is_branched == true:
		var options : Array = dm.get_dialog_options()
		var btn : Button
		for child in SelectButtons.get_children():
			child.queue_free()
		for option in options:
			btn = Button.new()
			btn.connect("pressed", self, "option_pressed")
			btn.text = option
			SelectButtons.add_child(btn)

func _on_Button_pressed():
	if btn.text == "next":
		dm.next()
		update_ui(dm.get_dialog_values(), dm.is_dialog_branched())
		if dm.is_dialog_branched() == true:
			btn.disabled = true
		if dm.get_next_dialog_id() == 99:
			btn.text = "Restart Dialog"
		return
	elif btn.text == "Restart Dialog":
		dm.restart_dialog()
		update_ui(dm.get_dialog_values(), dm.is_dialog_branched())
		btn.text = "next"

func option_pressed() -> void:
	for i in SelectButtons.get_children():
		if i.pressed == true:
			dm.next(i.text)
			btn.disabled = false
			update_ui(dm.get_dialog_values(), dm.is_dialog_branched())
			for child in SelectButtons.get_children():
				child.queue_free()
			break

func _on_OptionButton_item_selected(index):
	dm.change_language(lang[index])
	update_ui(dm.get_dialog_values(), dm.is_dialog_branched())
