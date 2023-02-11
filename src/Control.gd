extends Control


var source_dir : String
var end_dir : String
var user_path : String

var json_ok := false
var sourcekey_ok := false
var endkey_ok := false


func _ready():
	user_path = OS.get_environment("windir").to_lower().replace("windows","") + "/users/" + OS.get_environment("USERNAME") + "/APPDATA/Roaming/Godot/app_userdata/Rename from JSON/"
	source_dir = user_path + "to_rename/"
	end_dir = user_path + "renamed/"
	
	var dir = DirAccess.open(user_path)
	dir.make_dir("to_rename")
	dir.make_dir("renamed")
	
	
func _print(text : String, color = null) -> void:
	if color == null:
		$vbox/console.text += text + "\n"
	else:
		$vbox/console.text += "[color=#" + color + "]" + text + "[/color]" + "\n"


func _on_json_input_text_changed():
	json_ok = false
	if JSON.parse_string($vbox/json_input.text) != null:
		json_ok = true
	go_check()


func _on_source_line_text_changed(new_text):
	sourcekey_ok = false
	if new_text != "":
		sourcekey_ok = true
	go_check()
	

func _on_end_line_text_changed(new_text):
	endkey_ok = false
	if new_text != "":
		endkey_ok = true
	go_check()
	

func go_check() -> void:
	if json_ok and sourcekey_ok and endkey_ok:
		$vbox/hbox/Button.disabled = false
	else:
		$vbox/hbox/Button.disabled = true


func _on_Button_pressed():
	disable_ui()
	var errors_occurred := false
	$vbox/console.text = ""
	$vbox/ProgressBar.value = 0
	
	var source_key : String = $vbox/hbox/source_input/source_line.text
	var end_key : String = $vbox/hbox/end_input/end_line.text
	
	var index = {}
	for entry in JSON.parse_string($vbox/json_input.text):
		if source_key in entry and end_key in entry:
			index[str(entry[source_key])] = entry[end_key]
		else:
			if not source_key in entry:
				_print("given source key not found in " + str(entry),"ff8f00")
			if not end_key in entry:
				_print("given end key not found in " + str(entry),"ff8f00")
	
	var queue_size = 0
	var dir = DirAccess.open(source_dir)
	var array = dir.get_files()
	queue_size = array.size()
	
	if queue_size > 0:
		var step = float(100)/queue_size
		for file in array:
			var source_name = file.split(".")[0]
			var extension = "." + file.split(".")[1]
			if source_name in index:
				if index[source_name] != "":
					var end_name = index[source_name] + extension
					var copy = dir.copy(source_dir + file, end_dir + end_name)
					if copy != 0:
						_print(file + " error: invalid character in '" + end_name + "'\nPlease note that your OS file naming system doesn't support characters like: *, <, >, ?, |, :, double quotes and slashes","cf0000")
						errors_occurred = true
					else:
						_print(file + " renamed to " + end_name,"56ff00")
				else:
					_print(file + " end value is empty","cf0000")
					errors_occurred = true
			else:
				_print(file + " not found in given JSON","ff8f00")
				errors_occurred = true
			$vbox/ProgressBar.value += step
			await get_tree().process_frame
		
		if not errors_occurred:
			_print("JOB COMPLETED","56ff00")
		else:
			_print("JOB COMPLETED WITH ERRORS","ff8f00")
	else:
		_print("NOTHING TO RENAME","ff8f00")
	enable_ui()


func _on_Button2_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open(user_path)
	
	
func disable_ui() -> void:
	$vbox/hbox/Button.disabled = true
	$vbox/hbox/Button2.disabled = true
	$vbox/json_input.editable = false
	$vbox/hbox/source_input/source_line.editable = false
	$vbox/hbox/end_input/end_line.editable = false
	
	
func enable_ui() -> void:
	$vbox/hbox/Button.disabled = false
	$vbox/hbox/Button2.disabled = false
	$vbox/json_input.editable = true
	$vbox/hbox/source_input/source_line.editable = true
	$vbox/hbox/end_input/end_line.editable = true


func _on_LinkButton_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open("https://github.com/handre-dev/rename-from-json")
