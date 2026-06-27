extends Node2D
## 닭. 집(시작 위치) 주변을 천천히 배회하고, 상호작용하면 달걀을 준다(쿨다운).

const WANDER_SPEED := 24.0
const EGG_COOLDOWN := 5.0  # 임시 — DECISIONS.md 참고

var _has_egg := true
var _cooldown := 0.0
var _home := Vector2.ZERO
var _target := Vector2.ZERO

func _ready() -> void:
	randomize()
	_home = position
	_pick_target()
	queue_redraw()

func _process(delta: float) -> void:
	# 배회
	position = position.move_toward(_target, WANDER_SPEED * delta)
	if position.distance_to(_target) < 2.0:
		_pick_target()
	# 달걀 재생성
	if not _has_egg:
		_cooldown -= delta
		if _cooldown <= 0.0:
			_has_egg = true
			queue_redraw()

func _pick_target() -> void:
	var ang := randf() * TAU
	var dist := randf_range(8.0, 48.0)
	_target = _home + Vector2(cos(ang), sin(ang)) * dist

## 플레이어가 호출한다.
func interact() -> void:
	if _has_egg:
		_has_egg = false
		_cooldown = EGG_COOLDOWN
		GameState.add_item("egg", 1)
		queue_redraw()
		print("달걀을 얻었다! (보유 달걀: %d)" % GameState.get_count("egg"))
	else:
		print("닭이 아직 달걀을 낳지 않았다...")

func _draw() -> void:
	# 몸 (흰색)
	draw_circle(Vector2.ZERO, 9, Color.WHITE)
	# 벼슬
	draw_circle(Vector2(0, -9), 3, Color(0.9, 0.2, 0.2))
	# 부리
	draw_colored_polygon(PackedVector2Array([Vector2(8, -1), Vector2(13, 0), Vector2(8, 2)]), Color(1.0, 0.7, 0.1))
	# 눈
	draw_circle(Vector2(3, -3), 1.2, Color.BLACK)
	# 달걀이 준비되면 머리 위에 표시
	if _has_egg:
		draw_circle(Vector2(0, -17), 3.5, Color(1, 1, 0.85))
