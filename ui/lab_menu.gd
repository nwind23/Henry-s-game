extends CanvasLayer
## 연구소 메뉴. 7개의 전설의 보석 진척을 보여주고, 다 모으면 레인보우 보석 →
## 미래 장치 가동(무지개 엔딩)으로 이어진다.

@onready var progress_label: Label = $Panel/Progress
@onready var rows: VBoxContainer = $Panel/Rows
@onready var action_btn: Button = $Panel/Action
@onready var close_btn: Button = $Panel/Close
@onready var ending: Control = $Ending
@onready var ending_rainbow: HBoxContainer = $Ending/Box/Rainbow
@onready var ending_close: Button = $Ending/Box/Close

func _ready() -> void:
	add_to_group("lab_menu")
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	ending.visible = false
	close_btn.pressed.connect(close)
	action_btn.pressed.connect(_on_action)
	ending_close.pressed.connect(_close_ending)
	# 엔딩 화면 상단 무지개 띠(7색)
	for g in GameState.GEMS:
		var r := ColorRect.new()
		r.custom_minimum_size = Vector2(40, 16)
		r.color = g.color
		ending_rainbow.add_child(r)

func open() -> void:
	visible = true
	get_tree().paused = true
	_rebuild()

func close() -> void:
	visible = false
	if not ending.visible:
		get_tree().paused = false

func _unhandled_input(event: InputEvent) -> void:
	if visible and not ending.visible and event.is_action_pressed("ui_cancel"):
		close()
		get_viewport().set_input_as_handled()

func _rebuild() -> void:
	progress_label.text = "전설의 보석: %d / %d" % [GameState.gem_count(), GameState.GEMS.size()]
	for c in rows.get_children():
		c.queue_free()
	for g in GameState.GEMS:
		rows.add_child(_gem_row(g))
	if not GameState.has_all_gems():
		action_btn.text = "보석을 모두 모으세요"
		action_btn.disabled = true
	elif not GameState.has_rainbow:
		action_btn.text = "레인보우 보석 만들기"
		action_btn.disabled = false
	else:
		action_btn.text = "미래 장치 가동 (무지개 엔딩)"
		action_btn.disabled = false

func _gem_row(g: Dictionary) -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	var got := GameState.has_gem(g.id)

	var sw := ColorRect.new()
	sw.custom_minimum_size = Vector2(18, 18)
	sw.color = g.color if got else Color(0.32, 0.32, 0.32)
	row.add_child(sw)

	var name_l := Label.new()
	name_l.text = "%s (%s)" % [g.name, g.where]
	name_l.custom_minimum_size = Vector2(240, 0)
	row.add_child(name_l)

	var st := Label.new()
	st.text = "획득" if got else "미획득"
	row.add_child(st)
	return row

func _on_action() -> void:
	if GameState.has_all_gems() and not GameState.has_rainbow:
		GameState.make_rainbow()
		print("레인보우 보석 완성!")
		_rebuild()
	elif GameState.has_rainbow:
		ending.visible = true

func _close_ending() -> void:
	ending.visible = false
	get_tree().paused = false
	close()
