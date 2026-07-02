extends Node2D
## 낚시터. 상호작용하면 잠시 뒤 물고기를 낚는다.

const FISH := ["minnow", "minnow", "minnow", "carp", "carp", "bigfish"]  # 가중치

var _busy := false
var _t := 0.0

func _ready() -> void:
	queue_redraw()

func _process(delta: float) -> void:
	if _busy:
		_t -= delta
		if _t <= 0.0:
			_busy = false
			var f: String = FISH[randi() % FISH.size()]
			GameState.add_item(f, 1)
			GameState.toast("%s 낚음! (보유: %d개)" % [GameState.item_name(f), GameState.get_count(f)])
			queue_redraw()

func interact() -> void:
	if _busy:
		GameState.toast("낚는 중...")
		return
	_busy = true
	_t = randf_range(2.0, 4.0)
	queue_redraw()
	GameState.toast("낚시 시작...")

func _draw() -> void:
	# 나무 부두
	draw_rect(Rect2(-18, -5, 36, 12), Color(0.5, 0.36, 0.22))
	draw_rect(Rect2(-18, -5, 36, 12), Color(0.34, 0.24, 0.15), false, 2.0)
	# 낚싯대
	draw_line(Vector2(8, -4), Vector2(20, -22), Color(0.3, 0.2, 0.1), 2.0)
	draw_line(Vector2(20, -22), Vector2(22, 2), Color(0.8, 0.8, 0.8), 1.0)
	if _busy:
		draw_circle(Vector2(22, 2), 2.5, Color(1, 0.3, 0.3))  # 찌
