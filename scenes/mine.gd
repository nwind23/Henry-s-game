extends Node2D
## 광산 지역. 광맥 바위를 캐고, "더 내려가기"로 깊은 층으로(전투 없음).
## 더 깊을수록 좋은 광물. 깊이는 GameState.mine_depth 에 유지된다.

const ORE_ROCK := preload("res://scenes/ore_rock.tscn")
const ROCK_COUNT := 6

@onready var _depth_label: Label = $DepthUI/DepthLabel

var _rocks: Array[Node] = []

func _ready() -> void:
	randomize()
	_spawn_rocks()
	_update_label()
	queue_redraw()

func _spawn_rocks() -> void:
	for r in _rocks:
		if is_instance_valid(r):
			r.queue_free()
	_rocks.clear()
	for i in ROCK_COUNT:
		var rock := ORE_ROCK.instantiate()
		rock.position = Vector2(randf_range(110, 600), randf_range(110, 320))
		add_child(rock)
		_rocks.append(rock)

## descend_point 가 호출한다.
func descend() -> void:
	GameState.mine_depth += 1
	_spawn_rocks()
	_update_label()
	print("지하 %d층으로 내려간다" % GameState.mine_depth)

func _update_label() -> void:
	_depth_label.text = "지하 %d층" % GameState.mine_depth

func _draw() -> void:
	# 어두운 동굴 바닥
	draw_rect(Rect2(0, 0, 640, 360), Color(0.16, 0.14, 0.18))
	# 벽 테두리
	draw_rect(Rect2(0, 0, 640, 360), Color(0.1, 0.09, 0.12), false, 12.0)
