extends Node2D
## 밭 한 칸. 상호작용으로 씨앗 심기(돈 소비) → 시간이 지나 자람 → 익으면 수확.

const SEED_COST := 10      # 씨앗 값(임시) — DECISIONS.md
const CROP := "tomato"
const GROW_TIME := 12.0    # 다 자라는 데 걸리는 초(임시)

const DRY_TEX := preload("res://assets/art/tiles/field_brown.png")
const WET_TEX := preload("res://assets/art/tiles/field_watered.png")

enum State { EMPTY, GROWING, RIPE }

var _state: State = State.EMPTY
var _timer := 0.0

func _ready() -> void:
	queue_redraw()

func _process(delta: float) -> void:
	if _state == State.GROWING:
		_timer -= delta
		queue_redraw()  # 자라는 모습 갱신
		if _timer <= 0.0:
			_state = State.RIPE
			queue_redraw()

## 플레이어가 호출한다.
func interact() -> void:
	match _state:
		State.EMPTY:
			if GameState.money < SEED_COST:
				print("씨앗 살 돈이 부족하다 (%dG 필요)" % SEED_COST)
				return
			GameState.add_money(-SEED_COST)
			_state = State.GROWING
			_timer = GROW_TIME
			queue_redraw()
			print("%s 씨앗을 심었다 (-%dG)" % [GameState.item_name(CROP), SEED_COST])
		State.GROWING:
			print("자라는 중... (%d초 남음)" % ceili(_timer))
		State.RIPE:
			GameState.add_item(CROP, 1)
			_state = State.EMPTY
			queue_redraw()
			print("%s 수확! (보유: %d개)" % [GameState.item_name(CROP), GameState.get_count(CROP)])

func _draw() -> void:
	# 밭(흙) — 비어있으면 마른 흙, 심으면 물 준 밭
	var tex := DRY_TEX if _state == State.EMPTY else WET_TEX
	draw_texture_rect(tex, Rect2(-16, -14, 32, 28), false)
	match _state:
		State.GROWING:
			var grown := 1.0 - clampf(_timer / GROW_TIME, 0.0, 1.0)
			var h := 3.0 + grown * 12.0
			draw_line(Vector2(0, 4), Vector2(0, 4 - h), Color(0.2, 0.6, 0.2), 2.0)
			if grown > 0.33:
				draw_circle(Vector2(-3, 4 - h * 0.6), 2.5, Color(0.25, 0.7, 0.25))
				draw_circle(Vector2(3, 4 - h * 0.6), 2.5, Color(0.25, 0.7, 0.25))
		State.RIPE:
			draw_line(Vector2(0, 4), Vector2(0, -10), Color(0.2, 0.6, 0.2), 2.0)
			draw_circle(Vector2(-4, 0), 3, Color(0.25, 0.7, 0.25))
			draw_circle(Vector2(4, 0), 3, Color(0.25, 0.7, 0.25))
			draw_circle(Vector2(0, -10), 5, Color(0.9, 0.2, 0.2))  # 익은 토마토
