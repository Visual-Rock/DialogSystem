extends VBoxContainer

onready var AddButton   : Button        = self.get_node("HBoxContainer/Add")
onready var List        : VBoxContainer = self.get_node("Templates")
onready var FilesDialog : FileDialog    = self.get_node("FileDialog")

var Section : Resource = load("res://addons/DialogEditor/Buttons/TemplateSection.tscn")

func _ready():
	if FilesDialog:
		FilesDialog.connect("files_selected", self, "add_templates")
	if AddButton:
		AddButton.connect("pressed", self, "add_pressed")

func reset() -> void:
	pass

func add_pressed() -> void:
	FilesDialog.popup_centered(Vector2(500, 300))

func add_templates(paths : Array) -> void:
	if paths.size() != 0:
		for path in paths:
			add_template(path)

func add_template(path : String):
	if !path_already_selected(path):
		var section : HBoxContainer = Section.instance()
		section.get_node("LineEdit").text = path
		List.add_child(section)

func set_value(value : Array) -> void:
	if value.size() != 0:
		var section : HBoxContainer
		for template in value:
			section = Section.instance()
			section.get_node("LineEdit").text = template
			List.add_child(section)

func get_value() -> Array:
	var rtrn : Array = []
	if List.get_child_count() != 0:
		var path : String
		for template in List.get_children():
			path = template.get_node("LineEdit").text
			if path.is_rel_path() || path.is_abs_path():
				rtrn.append(path)
	return rtrn

func path_already_selected(path : String) -> bool:
	for template in List.get_children():
		if template.get_node("LineEdit").text == path:
			return true
			break
	return false




























