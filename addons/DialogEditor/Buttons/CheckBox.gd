tool
extends HBoxContainer

onready var Reset    : Button   = self.get_node("Reset")
onready var checkBox : CheckBox = self.get_node("CheckBox")

export var default : bool = true
export var current : bool = default

func _ready():
	# calles set value with current as new value
	set_value(current)
	
	# checks if reset is valid
	if Reset:
		# connects the pressed signal to reset
		Reset.connect("pressed", self, "reset")
	# checks if check Box is valid 
	if checkBox:
		# connects the toggled signal to set value
		checkBox.connect("toggled", self, "set_value")

# called when it shoud be reseted
func reset() -> void:
	# calles set_value with default as new value
	set_value(default)

# sets the current value and updates the GUI
# to reflect changes
func set_value(new_value : bool) -> void:
	# sets current to new value
	current = new_value
	# sets the pressed to the new value
	checkBox.pressed = new_value
	# checks if the new value is not the default value
	# to hide or unhide the reset button
	if new_value != default:
		# Shows the Reset Button
		Reset.show()
	else:
		# Hides the Reset Button
		Reset.hide()

func get_value() -> bool:
	return current
