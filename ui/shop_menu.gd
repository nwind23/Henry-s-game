extends CanvasLayer
## 상점 창. 판매 탭(보유 품목 팔기) + 구매 탭(제작 재료 사기).

const BUY_PRICES := {
	"coal": 25,
	"copper": 40,
	"iron": 80,
}

@onready var money_label: Label = $Panel/Money
@onready var rows: VBoxContainer = $Panel/Rows
@onready var sell_tab: Button = $Panel/Tabs/SellTab
@onready var buy_tab: Button = $Panel/Tabs/BuyTab
@onready var close_button: Button = $Panel/Close

var _mode := "sell"

func _ready() -> void:
	add_to_group("shop_menu")
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	close_button.pressed.connect(close)
	sell_tab.pressed.connect(func(): _mode = "sell"; _rebuild())
	buy_tab.pressed.connect(func(): _mode = "buy"; _rebuild())

func open() -> void:
	visible = true
	get_tree().paused = true
	_mode = "sell"
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
	sell_tab.disabled = _mode == "sell"
	buy_tab.disabled = _mode == "buy"
	for child in rows.get_children():
		child.queue_free()
	if _mode == "sell":
		var any := false
		for item in GameState.SELL_PRICES:
			if GameState.get_count(item) > 0:
				rows.add_child(_sell_row(item))
				any = true
		if not any:
			var empty := Label.new()
			empty.text = "팔 물건이 없습니다."
			rows.add_child(empty)
	else:
		for item in BUY_PRICES:
			rows.add_child(_buy_row(item))

func _sell_row(item: String) -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	row.add_child(_label(GameState.item_name(item), 80))
	row.add_child(_label("%d개" % GameState.get_count(item), 48, HORIZONTAL_ALIGNMENT_RIGHT))
	row.add_child(_label("개당 %dG" % int(GameState.SELL_PRICES[item]), 80, HORIZONTAL_ALIGNMENT_RIGHT))
	var b := Button.new()
	b.text = "판매"
	b.pressed.connect(_on_sell.bind(item))
	row.add_child(b)
	return row

func _buy_row(item: String) -> Control:
	var price := int(BUY_PRICES[item])
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	row.add_child(_label(GameState.item_name(item), 90))
	row.add_child(_label("개당 %dG" % price, 90, HORIZONTAL_ALIGNMENT_RIGHT))
	var b := Button.new()
	b.text = "구매"
	b.disabled = GameState.money < price
	b.pressed.connect(_on_buy.bind(item))
	row.add_child(b)
	return row

func _label(t: String, w: int, align := HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var l := Label.new()
	l.text = t
	l.custom_minimum_size = Vector2(w, 0)
	l.horizontal_alignment = align
	return l

func _on_sell(item: String) -> void:
	var earned := GameState.sell_all(item)
	if earned > 0:
		print("%s 판매 → +%dG" % [GameState.item_name(item), earned])
	_rebuild()

func _on_buy(item: String) -> void:
	var price := int(BUY_PRICES[item])
	if GameState.money >= price:
		GameState.add_money(-price)
		GameState.add_item(item, 1)
		print("%s 구매 (-%dG)" % [GameState.item_name(item), price])
	_rebuild()
