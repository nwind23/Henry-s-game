extends Node2D
## 마을 씬의 바닥(잔디)을 그린다. 자식 노드(플레이어/닭/상점)는 그 위에 그려진다.

const INTRO_TEXT := "토캣몬은 먼 곳에서 이 마을에 온 신비한 친구예요.\n동물을 키우고 작물을 기르고 광산을 파며,\n7개의 전설의 보석을 모으는 모험을 시작합니다!\n(5년 뒤엔 원래 집으로 돌아간대요.)"

const GRASS_TEX := preload("res://assets/art/tiles/grass.png")
const PATH_TEX := preload("res://assets/art/tiles/dirt_path.png")

func _ready() -> void:
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	queue_redraw()
	if not GameState.seen_intro:
		GameState.seen_intro = true
		GameState.mark_dirty()
		_show_intro.call_deferred()

func _show_intro() -> void:
	var d := get_tree().get_first_node_in_group("dialogue")
	if d:
		d.call("show_dialogue", "토캣몬 이야기", INTRO_TEXT)

func _draw() -> void:
	# 잔디 바닥 (뷰포트 전체)
	draw_texture_rect(GRASS_TEX, Rect2(0, 0, 640, 360), true)
	# 상점 앞 흙길
	draw_texture_rect(PATH_TEX, Rect2(408, 150, 64, 200), true)
