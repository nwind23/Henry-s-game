extends CanvasLayer
## 간단한 대화창. NPC나 인트로가 show_dialogue(이름, 대사)로 띄운다.

@onready var name_label: Label = $Panel/Name
@onready var text_label: Label = $Panel/Text
@onready var close_btn: Button = $Panel/Close

func _ready() -> void:
	add_to_group("dialogue")
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	close_btn.pressed.connect(close)

func show_dialogue(who: String, line: String) -> void:
	name_label.text = who
	text_label.text = line
	visible = true
	get_tree().paused = true

func close() -> void:
	visible = false
	get_tree().paused = false

func _unhandled_input(event: InputEvent) -> void:
	if visible and (event.is_action_pressed("ui_cancel") or event.is_action_pressed("interact")):
		close()
		get_viewport().set_input_as_handled()
