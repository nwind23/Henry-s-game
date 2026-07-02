extends Node2D
## 지역 바닥. 타일 텍스처가 있으면 반복해 깔고, 없으면 단색.
## water_style: 0=없음, 1=바다(물결+왼쪽 모래사장), 2=강(가로 물줄기 밴드)

@export var ground_color: Color = Color(0.3, 0.5, 0.3)
@export var accent_color: Color = Color(0.28, 0.46, 0.28)
@export var ground_texture: Texture2D
@export var water_style: int = 0

const RIVER_BAND := Rect2(0, 120, 640, 160)  # 강물 영역(낚시터가 이 안에 있음)

func _ready() -> void:
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	queue_redraw()

func _draw() -> void:
	if ground_texture:
		draw_texture_rect(ground_texture, Rect2(0, 0, 640, 360), true)
	else:
		draw_rect(Rect2(0, 0, 640, 360), ground_color)
	match water_style:
		1: _draw_sea()
		2: _draw_river()
	draw_rect(Rect2(0, 0, 640, 360), accent_color, false, 10.0)

## 바다: 왼쪽 입장 지점에 모래사장 + 잔물결 하이라이트
func _draw_sea() -> void:
	# 모래사장(입장 지점)
	draw_rect(Rect2(0, 0, 84, 360), Color(0.87, 0.78, 0.55))
	draw_rect(Rect2(80, 0, 8, 360), Color(0.93, 0.88, 0.7))   # 물가 거품 라인
	# 잔물결(고정 패턴 — 매 프레임 동일)
	var wave := ground_color.lightened(0.28)
	for i in 42:
		var x := float((i * 97 + 130) % 520 + 100)
		var y := float((i * 53 + 40) % 330 + 14)
		draw_rect(Rect2(x, y, 10, 2), wave)
		draw_rect(Rect2(x + 3, y + 3, 5, 2), wave * Color(1, 1, 1, 0.6))

## 강: 잔디 바닥 위에 가로 물줄기 밴드(낚시터 위치와 일치)
func _draw_river() -> void:
	var deep := Color(0.22, 0.45, 0.62)
	var edge := Color(0.5, 0.72, 0.82)
	draw_rect(RIVER_BAND, deep)
	# 강가 라인
	draw_rect(Rect2(RIVER_BAND.position.x, RIVER_BAND.position.y, RIVER_BAND.size.x, 4), edge)
	draw_rect(Rect2(RIVER_BAND.position.x, RIVER_BAND.end.y - 4, RIVER_BAND.size.x, 4), edge)
	# 잔물결(고정 패턴)
	var wave := deep.lightened(0.25)
	for i in 26:
		var x := float((i * 113 + 30) % 600 + 20)
		var y := RIVER_BAND.position.y + 16 + float((i * 47) % int(RIVER_BAND.size.y - 32))
		draw_rect(Rect2(x, y, 12, 2), wave)
