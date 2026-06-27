extends Node2D
## 광맥 바위. 상호작용하면 현재 깊이에 따른 광물을 1개 주고 사라진다(전투 없음).

func _ready() -> void:
	randomize()
	queue_redraw()

func interact() -> void:
	var ore := _roll_ore(GameState.mine_depth)
	var amount: int = max(1, GameState.pickaxe_level)  # 곡괭이 등급만큼
	GameState.add_item(ore, amount)
	print("%s %d개 채굴! (보유: %d개)" % [GameState.item_name(ore), amount, GameState.get_count(ore)])
	# 깊은 곳에서 속성의 돌이 드물게 나온다
	var d := GameState.mine_depth
	if d >= 600 and randf() < 0.12:
		GameState.add_item("ice_stone", 1)
		print("✨ 얼음의 돌 발견!")
	if d >= 850 and randf() < 0.10:
		GameState.add_item("dark_stone", 1)
		print("✨ 어둠의 돌 발견!")
	queue_free()

## 깊을수록 더 좋은 광물이 나올 수 있다.
func _roll_ore(depth: int) -> String:
	var pool := ["stone", "stone", "coal", "copper"]
	if depth >= 150:
		pool.append("iron")
	if depth >= 400:
		pool.append("gold")
	if depth >= 600:
		pool.append("magic_ore")
		pool.append("opal")
	if depth >= 850:
		pool.append("sirius")
	if depth >= 950:
		pool.append("iridium")
	return pool[randi() % pool.size()]

func _draw() -> void:
	# 바위
	draw_circle(Vector2.ZERO, 12, Color(0.36, 0.34, 0.4))
	draw_circle(Vector2(-3, -2), 9, Color(0.44, 0.42, 0.48))
	# 광물 반짝임
	draw_circle(Vector2(3, 2), 2.5, Color(0.8, 0.7, 0.4))
	draw_circle(Vector2(-4, 4), 2.0, Color(0.7, 0.8, 0.9))
