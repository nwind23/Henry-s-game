extends CanvasLayer
## 상점 판매 창. 열리면 게임을 일시정지하고, 팔 수 있는 품목을 한국어로 보여준다.
## shop.gd 가 그룹 "shop_menu" 로 찾아 open() 을 호출한다.

@onready var money_label: Label = $Panel/Money
@onready var rows: VBoxContainer = $Panel/Rows
@onready var close_button: Button = $Panel/Close

func _ready() -> void:
	add_to_group("shop_menu")
	process_mode = Node.PROCESS_MODE_ALWAYS  # 일시정지 중에도 버튼 동작
	visible = false
	close_button.pressed.connect(close)

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
	money_label.text = "소지금: %dG" % GameState.money
	for child in rows.get_children():
		child.queue_free()
	for item in GameState.SELL_PRICES:
		rows.add_child(_make_row(item))

func _make_row(item: String) -> Control:
	var count := GameState.get_count(item)
	var price := int(GameState.SELL_PRICES[item])

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)

	var name_label := Label.new()
	name_label.text = GameState.item_name(item)
	name_label.custom_minimum_size = Vector2(70, 0)
	row.add_child(name_label)

	var count_label := Label.new()
	count_label.text = "%d개" % count
	count_label.custom_minimum_size = Vector2(48, 0)
	count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	row.add_child(count_label)

	var price_label := Label.new()
	price_label.text = "개당 %dG" % price
	price_label.custom_minimum_size = Vector2(80, 0)
	price_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	row.add_child(price_label)

	var sell_button := Button.new()
	sell_button.text = "판매"
	sell_button.disabled = count <= 0
	sell_button.pressed.connect(_on_sell.bind(item))
	row.add_child(sell_button)

	return row

func _on_sell(item: String) -> void:
	var earned := GameState.sell_all(item)
	if earned > 0:
		print("%s 판매 → +%dG" % [GameState.item_name(item), earned])
	_rebuild()
