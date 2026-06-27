extends Control
## 모바일 터치 조작: 화면 왼쪽을 드래그하면 가상 조이스틱(이동), 오른쪽 "행동" 버튼은 상호작용.
## 조이스틱은 이동 액션을 강도(strength)와 함께 눌러, 키보드/패드와 같은 코드 경로로 동작한다.
## 데스크톱에서는 emulate_touch_from_mouse 설정 덕분에 마우스로도 테스트된다.

const RADIUS := 70.0

var _active := false
var _index := -1
var _origin := Vector2.ZERO
var _knob := Vector2.ZERO  # 중심으로부터의 오프셋

@onready var act_button: Button = $ActButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	mouse_filter = Control.MOUSE_FILTER_IGNORE  # GUI 클릭은 버튼으로 통과
	act_button.button_down.connect(func(): Input.action_press("interact"))
	act_button.button_up.connect(func(): Input.action_release("interact"))
	queue_redraw()

func _process(_delta: float) -> void:
	if get_tree().paused:
		_release_move()
		return
	_apply_move()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			# 새 터치는 화면 왼쪽이면 스틱을 (재)시작한다.
			# not _active 가드를 두지 않아, 이전 터치의 release 를 놓쳐도 새 터치로 복구된다.
			if not get_tree().paused and event.position.x < get_viewport_rect().size.x * 0.5:
				_active = true
				_index = event.index
				_origin = event.position
				_knob = Vector2.ZERO
				queue_redraw()
		elif _active and event.index == _index:
			# release 는 일시정지 중에도 반드시 처리해서 스틱이 고정되지 않게 한다.
			_end_stick()
	elif event is InputEventScreenDrag and _active and event.index == _index and not get_tree().paused:
		_knob = (event.position - _origin).limit_length(RADIUS)
		queue_redraw()

func _notification(what: int) -> void:
	# 창/앱 포커스를 잃으면(탭 전환 등) 스틱을 해제해 무한 이동을 막는다.
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		if _active:
			_end_stick()

func _end_stick() -> void:
	_active = false
	_index = -1
	_knob = Vector2.ZERO
	_release_move()
	queue_redraw()

func _apply_move() -> void:
	var d := _knob / RADIUS if _active else Vector2.ZERO
	_set_action("move_right", maxf(0.0, d.x))
	_set_action("move_left", maxf(0.0, -d.x))
	_set_action("move_down", maxf(0.0, d.y))
	_set_action("move_up", maxf(0.0, -d.y))

func _set_action(action: String, strength: float) -> void:
	if strength > 0.08:
		Input.action_press(action, strength)
	else:
		Input.action_release(action)

func _release_move() -> void:
	for a in ["move_left", "move_right", "move_up", "move_down"]:
		Input.action_release(a)

func _draw() -> void:
	if _active:
		draw_circle(_origin, RADIUS, Color(1, 1, 1, 0.15))
		draw_circle(_origin, RADIUS, Color(1, 1, 1, 0.45), false, 2.0)
		draw_circle(_origin + _knob, 26, Color(1, 1, 1, 0.4))
