extends Node2D
## 광산 지역. 광맥 바위를 캐고, "더 내려가기"로 깊은 갱도를 타고 내려간다(전투 없음).
## 더 깊을수록 좋은 광물. 1000층 맨 아래에 도달하면 신념의 보석 + 광산 엔딩.

const ORE_ROCK := preload("res://scenes/ore_rock.tscn")
const ROCK_COUNT := 6
const DESCEND_STEP := 50   # 깊은 갱도를 타고 한 번에 내려가는 층수
const GOAL_DEPTH := 1000   # 맨 아래(광산 엔딩)

@onready var _depth_label: Label = $DepthUI/DepthLabel
@onready var _ending: CanvasLayer = $MineEnding

var _rocks: Array[Node] = []

func _ready() -> void:
	randomize()
	_spawn_rocks()
	_update_label()
	_ending.visible = false
	_ending.process_mode = Node.PROCESS_MODE_ALWAYS  # 일시정지 중에도 닫기 동작
	$MineEnding/Box/Close.pressed.connect(_close_ending)
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
	if GameState.mine_depth >= GOAL_DEPTH:
		_reach_bottom()
		return
	GameState.mine_depth = min(GameState.mine_depth + DESCEND_STEP, GOAL_DEPTH)
	_spawn_rocks()
	_update_label()
	print("지하 %d층으로 내려간다" % GameState.mine_depth)
	if GameState.mine_depth >= GOAL_DEPTH:
		_reach_bottom()

func _reach_bottom() -> void:
	GameState.collect_gem("faith")  # 신념의 보석
	_update_label()
	_ending.visible = true
	get_tree().paused = true
	print("광산 맨 아래 도달! 신념의 보석 획득")

func _close_ending() -> void:
	_ending.visible = false
	get_tree().paused = false

func _update_label() -> void:
	if GameState.mine_depth >= GOAL_DEPTH:
		_depth_label.text = "지하 %d층 (맨 아래)" % GameState.mine_depth
	else:
		_depth_label.text = "지하 %d층" % GameState.mine_depth

func _draw() -> void:
	draw_rect(Rect2(0, 0, 640, 360), Color(0.16, 0.14, 0.18))
	draw_rect(Rect2(0, 0, 640, 360), Color(0.1, 0.09, 0.12), false, 12.0)
