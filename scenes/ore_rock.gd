extends Node2D
## 광맥 바위. 상호작용하면 현재 깊이에 따른 광물을 1개 주고 사라진다(전투 없음).

func _ready() -> void:
	randomize()
	queue_redraw()

func interact() -> void:
	var ore := _roll_ore(GameState.mine_depth)
	GameState.add_item(ore, 1)
	print("%s 채굴! (보유: %d개)" % [GameState.item_name(ore), GameState.get_count(ore)])
	queue_free()

## 깊을수록 더 좋은 광물이 나올 수 있다.
func _roll_ore(depth: int) -> String:
	var pool := ["stone", "stone", "coal", "copper"]
	if depth >= 3:
		pool.append("iron")
	if depth >= 5:
		pool.append("gold")
	return pool[randi() % pool.size()]

func _draw() -> void:
	# 바위
	draw_circle(Vector2.ZERO, 12, Color(0.36, 0.34, 0.4))
	draw_circle(Vector2(-3, -2), 9, Color(0.44, 0.42, 0.48))
	# 광물 반짝임
	draw_circle(Vector2(3, 2), 2.5, Color(0.8, 0.7, 0.4))
	draw_circle(Vector2(-4, 4), 2.0, Color(0.7, 0.8, 0.9))
