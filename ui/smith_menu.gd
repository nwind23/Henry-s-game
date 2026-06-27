extends CanvasLayer
## 대장장이 메뉴 — 곡괭이 등급 강화(속성의 돌 + 돈).

@onready var level_label: Label = $Panel/Level
@onready var effect_label: Label = $Panel/Effect
@onready var cost_label: Label = $Panel/Cost
@onready var upgrade_btn: Button = $Panel/Upgrade
@onready var close_btn: Button = $Panel/Close

func _ready() -> void:
	add_to_group("smith_menu")
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	close_btn.pressed.connect(close)
	upgrade_btn.pressed.connect(_on_upgrade)

func open() -> void:
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
	level_label.text = "곡괭이 등급: Lv %d" % GameState.pickaxe_level
	effect_label.text = "한 번에 광물 %d개 채굴" % GameState.pickaxe_level
	var c := GameState.pickaxe_upgrade_cost()
	if c.is_empty():
		cost_label.text = "이미 최고 등급입니다!"
		upgrade_btn.disabled = true
		upgrade_btn.text = "강화 완료"
		return
	var parts: Array[String] = ["%dG" % int(c.money)]
	for it in c.items:
		parts.append("%s %d" % [GameState.item_name(it), int(c.items[it])])
	cost_label.text = "강화 비용: " + ", ".join(parts)
	upgrade_btn.text = "곡괭이 강화 (Lv %d)" % (GameState.pickaxe_level + 1)
	upgrade_btn.disabled = not GameState.can_upgrade_pickaxe()

func _on_upgrade() -> void:
	if GameState.upgrade_pickaxe():
		print("곡괭이 강화! Lv %d" % GameState.pickaxe_level)
	_rebuild()
