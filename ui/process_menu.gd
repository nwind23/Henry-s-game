extends CanvasLayer
## 가공 메뉴. 가공대(processor)가 open(proc)로 연다. 레시피를 골라 가공을 시작한다.

@onready var status_label: Label = $Panel/Status
@onready var rows: VBoxContainer = $Panel/Rows
@onready var close_button: Button = $Panel/Close

var _proc: Node = null

func _ready() -> void:
	add_to_group("process_menu")
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	close_button.pressed.connect(close)

func open(proc: Node) -> void:
	_proc = proc
	visible = true
	get_tree().paused = true
	_rebuild()

func close() -> void:
	visible = false
	get_tree().paused = false

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		close()
		get_viewport().set_input_as_handled()

func _rebuild() -> void:
	if _proc.is_busy():
		status_label.text = "가공 중... (%d초 남음)" % _proc.remaining()
	else:
		status_label.text = "무엇을 만들까?"
	for child in rows.get_children():
		child.queue_free()
	for recipe in _proc.RECIPES:
		rows.add_child(_make_row(recipe))

func _make_row(recipe: Dictionary) -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)

	# 입력 → 출력 설명
	var parts: Array[String] = []
	for item in recipe.inputs:
		parts.append("%s %d" % [GameState.item_name(item), int(recipe.inputs[item])])
	var desc := Label.new()
	desc.text = "%s → %s (%d초)" % [", ".join(parts), GameState.item_name(recipe.output), int(recipe.time)]
	desc.custom_minimum_size = Vector2(230, 0)
	row.add_child(desc)

	var btn := Button.new()
	btn.text = "가공"
	btn.disabled = _proc.is_busy() or not _proc.can_make(recipe)
	btn.pressed.connect(_on_make.bind(recipe))
	row.add_child(btn)
	return row

func _on_make(recipe: Dictionary) -> void:
	_proc.start_recipe(recipe)
	_rebuild()
