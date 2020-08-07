extends Node2D

var d : Dialog = Dialog.new()

func _on_Button_pressed():
	if d.inited_dialog == false:
		print(d.load_from_file("res://Example/Bakes/en/Example_001.json"))
		set_ui(d.get_values())
		$DialogLayer/Control/VBoxContainer/HBoxContainer/Button.text = "next"
	else:
		if d.get_next_id() == 99:
			set_ui({"Names": "Sys", "text": "End of Dialog this is not part of the dialog!"} )
			$DialogLayer/Control/VBoxContainer/HBoxContainer/Button2.show()
		else:
			d.next()
			set_ui(d.get_values())

func set_ui(data : Dictionary) -> void:
	$DialogLayer/Control/VBoxContainer/name.text = data["Names"]
	$DialogLayer/Control/VBoxContainer/text.text = data["text"]


func _on_Button2_pressed():
	d.back_to_start()
	set_ui(d.get_values())
	$DialogLayer/Control/VBoxContainer/HBoxContainer/Button2.hide()
