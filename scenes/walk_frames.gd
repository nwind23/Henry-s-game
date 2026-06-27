class_name WalkFrames
## 3프레임 × 4방향(아래/위/왼쪽/오른쪽) 걷기 시트로 SpriteFrames 를 만든다.

static func build(sheet: Texture2D, fps: float = 6.0) -> SpriteFrames:
	var cols := 3
	var rows := 4
	var cw := int(sheet.get_width() / cols)
	var ch := int(sheet.get_height() / rows)
	var names := ["down", "up", "left", "right"]
	var sf := SpriteFrames.new()
	if sf.has_animation("default"):
		sf.remove_animation("default")
	for r in rows:
		sf.add_animation(names[r])
		sf.set_animation_loop(names[r], true)
		sf.set_animation_speed(names[r], fps)
		for c in cols:
			var at := AtlasTexture.new()
			at.atlas = sheet
			at.region = Rect2(c * cw, r * ch, cw, ch)
			sf.add_frame(names[r], at)
	return sf

## 이동 벡터로 방향 애니메이션 이름을 고른다.
static func dir_anim(v: Vector2) -> String:
	if absf(v.x) > absf(v.y):
		return "right" if v.x > 0.0 else "left"
	return "down" if v.y > 0.0 else "up"
