extends Node2D
## 보석 제단. 정해진 공물(아이템)을 바치면 그 지역의 전설의 보석을 준다(1회).
## 예: 숲 — 산딸기 10개 → 숲의 보석.

@export var gem_id: String = "forest"
@export var cost_item: String = "berry"
@export var cost_amount: int = 10

@onready var _label: Label = $Label

func _ready() -> void:
	_update_label()
	GameState.gems_changed.connect(_update_label)
	queue_redraw()

func _update_label() -> void:
	if GameState.has_gem(gem_id):
		_label.text = "%s 획득함" % _gem_name()
	else:
		_label.text = "%s %d개 바치기" % [GameState.item_name(cost_item), cost_amount]

func _gem_name() -> String:
	for g in GameState.GEMS:
		if g.id == gem_id:
			return g.name
	return "보석"

func interact() -> void:
	if GameState.has_gem(gem_id):
		print("%s은(는) 이미 가지고 있다." % _gem_name())
		return
	if GameState.get_count(cost_item) < cost_amount:
		print("%s이(가) %d개 필요하다. (지금 %d개)" % [GameState.item_name(cost_item), cost_amount, GameState.get_count(cost_item)])
		return
	GameState.add_item(cost_item, -cost_amount)
	GameState.collect_gem(gem_id)
	queue_redraw()
	print("✨ %s을(를) 얻었다!" % _gem_name())

func _draw() -> void:
	# 제단 받침
	draw_rect(Rect2(-16, 2, 32, 14), Color(0.4, 0.4, 0.46))
	draw_rect(Rect2(-12, -4, 24, 8), Color(0.5, 0.5, 0.56))
	# 보석(획득 전엔 빈 받침/반투명, 획득 후엔 색 보석)
	var got := GameState.has_gem(gem_id)
	var col := Color(0.2, 0.7, 0.3) if got else Color(0.6, 0.6, 0.6, 0.4)
	draw_colored_polygon(PackedVector2Array([
		Vector2(0, -22), Vector2(8, -10), Vector2(0, -2), Vector2(-8, -10)
	]), col)
