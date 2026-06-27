extends CanvasLayer
## 가공 메뉴. 가공대(processor)가 open(proc)로 연다. 레시피를 골라 가공을 시작한다.

@onready var title_label: Label = $Panel/Title
@onready var status_label: Label = $Panel/Status
@onready var rows: VBoxContainer = $Panel/Scroll/Rows
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
	title_label.text = _proc.display_name()
	if _proc.is_busy():
		status_label.text = "가공 중... (%d초 남음)" % _proc.remaining()
	else:
		status_label.text = "무엇을 만들까?"
	for child in rows.get_children():
		child.queue_free()
	for recipe in _proc.recipes:
		rows.add_child(_make_row(recipe))

func _make_row(recipe: Dictionary) -> Control:
	# 레시피 한 줄: [좌] 결과물 이름 + 재료 목록(보유/필요 색상) / [우] 가공 버튼
	var frame := PanelContainer.new()
	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", 10)
	frame.add_child(hb)

	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 1)
	hb.add_child(col)

	# 결과물 이름 (한 개 만들어짐)
	var name_lbl := Label.new()
	name_lbl.text = GameState.item_name(recipe.output)
	col.add_child(name_lbl)

	# 재료: "재료 보유/필요" — 충분하면 초록, 부족하면 빨강 / 줄바꿈 허용
	var mats := RichTextLabel.new()
	mats.bbcode_enabled = true
	mats.fit_content = true
	mats.scroll_active = false
	mats.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	mats.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var parts: Array[String] = []
	for item in recipe.inputs:
		var need := int(recipe.inputs[item])
		var have := GameState.get_count(item)
		var c := "5fd17a" if have >= need else "ff6b6b"
		parts.append("[color=#%s]%s %d/%d[/color]" % [c, GameState.item_name(item), have, need])
	mats.text = "[color=#b0b0b0]%s · %d초[/color]" % [" · ".join(parts), int(recipe.time)]
	col.add_child(mats)

	# 가공 버튼
	var btn := Button.new()
	btn.text = "가공"
	btn.custom_minimum_size = Vector2(76, 0)
	btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	btn.disabled = _proc.is_busy() or not _proc.can_make(recipe)
	btn.pressed.connect(_on_make.bind(recipe))
	hb.add_child(btn)
	return frame

func _on_make(recipe: Dictionary) -> void:
	_proc.start_recipe(recipe)
	_rebuild()
