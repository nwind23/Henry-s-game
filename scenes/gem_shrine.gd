extends Node2D
## 보석 제단. 정해진 공물(아이템)을 바치면 그 지역의 전설의 보석을 준다(1회).
## 예: 숲 — 산딸기 10개 → 숲의 보석.

@export var gem_id: String = "forest"
@export var cost_item: String = "berry"
@export var cost_amount: int = 50

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
		GameState.toast("%s은(는) 이미 가지고 있다." % _gem_name())
		return
	if GameState.get_count(cost_item) < cost_amount:
		GameState.toast("%s이(가) %d개 필요하다. (지금 %d개)" % [GameState.item_name(cost_item), cost_amount, GameState.get_count(cost_item)])
		return
	GameState.add_item(cost_item, -cost_amount)
	GameState.collect_gem(gem_id)
	queue_redraw()
	GameState.toast("✨ %s을(를) 얻었다!" % _gem_name())

func _gem_color() -> Color:
	for g in GameState.GEMS:
		if g.id == gem_id:
			return g.color
	return Color(0.6, 0.6, 0.6)

func _draw() -> void:
	# 돌 제단(계단식 받침 + 명암)
	draw_rect(Rect2(-18, 8, 36, 8), Color(0.36, 0.36, 0.42))
	draw_rect(Rect2(-14, 0, 28, 9), Color(0.46, 0.46, 0.52))
	draw_rect(Rect2(-10, -6, 20, 7), Color(0.55, 0.55, 0.61))
	draw_rect(Rect2(-18, 8, 36, 8), Color(0.22, 0.22, 0.27), false, 1.5)
	# 기둥 문양
	draw_line(Vector2(-8, -2), Vector2(-8, 5), Color(0.32, 0.32, 0.38), 1.5)
	draw_line(Vector2(8, -2), Vector2(8, 5), Color(0.32, 0.32, 0.38), 1.5)
	# 보석: 그 지역 보석의 고유색. 획득 전엔 흐릿하게, 획득 후엔 빛나게.
	var got := GameState.has_gem(gem_id)
	var base := _gem_color()
	var col := base if got else Color(base.r, base.g, base.b, 0.35)
	if got:
		draw_circle(Vector2(0, -14), 11, Color(base.r, base.g, base.b, 0.22))  # 은은한 빛
	draw_colored_polygon(PackedVector2Array([
		Vector2(0, -24), Vector2(8, -12), Vector2(0, -4), Vector2(-8, -12)
	]), col)
	draw_line(Vector2(-8, -12), Vector2(8, -12), col.lightened(0.35), 1.0)
	if got:
		draw_circle(Vector2(-2, -17), 1.6, Color(1, 1, 1, 0.85))  # 하이라이트
