extends Node2D
## 광산 지역. 광맥 바위를 캐고, "더 내려가기"로 깊은 갱도를 타고 내려간다(전투 없음).
## 더 깊을수록 좋은 광물. 1000층 맨 아래에 도달하면 신념의 보석 + 광산 엔딩.

const ORE_ROCK := preload("res://scenes/ore_rock.tscn")
const STONE_TEX := preload("res://assets/art/tiles/stone.png")
const ROCK_COUNT := 6
const DESCEND_STEP := 50   # 깊은 갱도를 타고 한 번에 내려가는 층수
const GOAL_DEPTH := 1000   # 맨 아래(광산 엔딩)

@onready var _depth_label: Label = $DepthUI/DepthLabel
@onready var _ending: CanvasLayer = $MineEnding

var _rocks: Array[Node] = []

func _ready() -> void:
	randomize()
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
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

## descend_point 가 호출한다. 바닥(1000층)에선 같은 자리에서 다시 채굴(재생성)된다.
func descend() -> void:
	var first_bottom := GameState.mine_depth < GOAL_DEPTH
	GameState.mine_depth = min(GameState.mine_depth + DESCEND_STEP, GOAL_DEPTH)
	GameState.mark_dirty()
	_spawn_rocks()  # 바닥에서도 다시 광맥이 생겨 시리우스·이리듐을 계속 캘 수 있다
	_update_label()
	if GameState.mine_depth >= GOAL_DEPTH:
		GameState.toast("지하 %d층(맨 아래) — 광맥 재생성" % GameState.mine_depth)
		if first_bottom and not GameState.has_gem("faith"):
			_reach_bottom()
	else:
		GameState.toast("지하 %d층으로 내려간다" % GameState.mine_depth)

func _reach_bottom() -> void:
	GameState.collect_gem("faith")  # 신념의 보석
	GameState.mark_ending("mine")
	_update_label()
	_ending.visible = true
	get_tree().paused = true
	GameState.toast("광산 맨 아래 도달! 신념의 보석 획득")

func _close_ending() -> void:
	_ending.visible = false
	get_tree().paused = false

func _update_label() -> void:
	if GameState.mine_depth >= GOAL_DEPTH:
		_depth_label.text = "지하 %d층 (맨 아래)" % GameState.mine_depth
	else:
		_depth_label.text = "지하 %d층" % GameState.mine_depth

func _draw() -> void:
	# 어두운 동굴 느낌으로 돌 타일을 깔고 모듈레이트로 톤을 낮춘다
	draw_texture_rect(STONE_TEX, Rect2(0, 0, 640, 360), true, Color(0.42, 0.4, 0.46))
	draw_rect(Rect2(0, 0, 640, 360), Color(0.1, 0.09, 0.12, 1), false, 12.0)
