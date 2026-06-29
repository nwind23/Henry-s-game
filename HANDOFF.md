# 현석이의 모험 — 인수인계 문서 (Claude → Claude)

> 다음 세션의 Claude가 이 프로젝트를 바로 이어받을 수 있도록 정리한 문서.
> 게임 기획/방향은 `DECISIONS.md`, 코드 구조는 아래 "파일 지도" 참고.

## 1. 프로젝트 한 줄 요약
- **현석이의 모험**: 2D 탑다운 생활/수집 시뮬레이션. 주인공 **토캣몬**.
- 엔진 **Godot 4.7** + **GDScript**. **전투 없음**. **한국어 UI**. Kairosoft풍 픽셀아트.
- **모바일 터치(가상 조이스틱) + 키보드/게임패드** 동시 지원.
- **웹(HTML5) 빌드 → Vercel** 정적 호스팅. 라이브: `henry-s-game.vercel.app`

## 2. 현재 상태 (게임 완주 가능)
- 지역 9곳: 마을 / 숲 / 목장 / 광산 / 화산 / 번개산 / 꽃의 들판 / 광활한 바다 / 강
- 시스템: 동물 사육(6종), 작물 재배, 가공대/제련소, 광산(층 내려가기), 낚시, 채집,
  상점(판매/구매), 대장간(곡괭이 강화 Lv1~5), 연구소, NPC 대화, 인트로
- **전설의 보석 7종 + 엔딩 3종(광산/무지개/진엔딩)** 전부 획득·도달 가능
- 세이브/로드(`user://save.json`, 2초 디바운스 자동저장)
- 난이도 1차 상향 완료(보석 공물 ↑, 채집 쿨다운 ↑, 강화비 ↑)
- 숨겨진 초기화 버튼(HUD 우상단 흐릿한 "R" + 확인창)
- **실제 픽셀아트 에셋 통합 완료**: 캐릭터/동물 4방향 걷기 스프라이트,
  건물 텍스처, 지역 타일 바닥, 밭/표지판/광산 입구

## 3. ★ 작업 규칙 (사용자 명시 요구 — 꼭 지킬 것)
1. **분할 배포 금지.** 변경은 **로컬에서 다 만들고 헤드리스로 검증한 뒤 한 번에 배포**한다.
   (Vercel 배포 한도 때문 — 슬라이스마다 배포하다 한도 소진된 적 있음)
2. **계획 먼저, 그다음 구현.** 큰 방향을 바꾸는 결정은 사용자에게 먼저 확인.
3. **[미정] 항목은 `DECISIONS.md`에 임시값과 함께 기록**한다.
4. **푸시하면 자동 머지까지** 진행 (사용자 승인됨). main 자동 배포.
5 커밋 메시지/PR/코드에 **모델 식별자(claude-opus-…)를 넣지 말 것** (채팅에서만).
6. 사용자는 한국어로 소통. 답변·커밋·UI 전부 한국어.

## 4. 배포 워크플로 (검증된 절차)
1. 로컬에서 변경 → `godot --headless --import` (파싱/컴파일 검증, 무오류 확인)
2. 씬 인스턴스화 스모크 테스트 + 필요시 `xvfb`로 렌더 스크린샷 확인 (방법은 §6)
3. `godot --headless --export-release "Web" public/index.html` 로 웹 빌드 재생성
4. `public/` 포함 전부 커밋 → 작업 브랜치에 푸시
5. **main에 rebase 후** PR 생성 → **squash 머지** (GitHub MCP 사용)
   - main이 squash 머지로 갈라지므로, 머지 전 `git rebase --onto origin/main <직전커밋> <브랜치>` 로
     새 커밋만 main 위에 얹는다 (이전 슬라이스 중복 적용 방지)
6. Vercel이 main push에 자동 배포 → Vercel MCP `list_deployments`로 production READY 확인

## 5. ★ 현재 미해결 블로커 — Vercel 배포 한도
- **#20(에셋 통합)까지는 production 배포 정상.**
- **#21(가공/제련 메뉴 개선)·#22(docs)** 는 main 머지됐으나 **Vercel이 배포를 아예 생성 안 함**
  (production은 물론 preview 배포도 0건) → **계정 일일 배포 한도 소진**으로 판단.
- **코드/빌드는 모두 정상이고 main 최신(`9186157`)에 반영됨. `public/` 빌드도 최신.**
- 한도가 풀리면(보통 24h 단위 리셋) **다음 push가 자동으로 최신본을 배포**한다.
  → 이 HANDOFF 커밋의 push가 그 재트리거 역할.
- 확인 방법: Vercel MCP `list_deployments` (team `team_wkyMH2JZzIgVQRRJxJ3VBP4D`,
  project `prj_yZ138O41V0ow55ywnGQIdiWYORee`). 최신 production 커밋 SHA가 main HEAD와 같으면 성공.
- 라이브에 안 떠 있으면: 한도 리셋 대기 → 작은 커밋으로 재트리거, 또는 Vercel 대시보드에서 수동 Redeploy.

## 6. 개발 환경 / 검증 기법
- Godot 바이너리: `/usr/local/bin/godot` (4.7.stable). 헤드리스 전용 환경(디스플레이 없음).
- 웹 익스포트 프리셋 이름: **"Web"** (nothreads 변형, COOP/COEP 불필요). 출력 `public/`.
- 한글 폰트: `assets/fonts/Galmuri11.ttf` (OFL, 11px 픽셀폰트). `project.godot`에 custom_font 지정.
- **스크린샷(렌더 검증)**: 디스플레이가 없으므로 `xvfb-run` 사용.
  - `--script` 모드는 **autoload(GameState)가 로드 안 됨** → GameState 참조 스크립트가 컴파일 실패하니 주의.
  - 신뢰할 스크린샷은 **임시 autoload 기법**: `project.godot`의 `[autoload]`에 임시 스크린샷
    스크립트(`ShotAuto="*res://shot_auto.gd"`)를 sed로 추가 → 실제 메인 루프로 실행
    (`xvfb-run -a godot --rendering-driver opengl3 --resolution 640x360`) → 끝나면 원복.
  - 메뉴 등 특정 UI는 임시 autoload에서 `get_first_node_in_group(...)` 으로 노드 찾아 `open()` 호출 후 캡처.

## 7. ★ .tscn / GDScript 함정 (실제로 겪은 것)
- `.tscn`에서 노드의 `script = ExtResource(...)` 줄이 **@export 프로퍼티 오버라이드보다 먼저** 와야 함.
  (순서 틀리면 export 값이 무시됨 — cow가 milk 대신 egg 주던 버그)
- `.tscn`의 `Color()`는 **4인자(r,g,b,a)** 필요. 3인자면 파싱 에러.
- `CanvasItem.draw_texture_rect(texture, rect, tile, modulate=…)` — **첫 인자가 texture, 둘째가 rect**.
  (순서 헷갈려 임포트 실패한 적 있음)
- 타일 반복: `texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED` + `draw_texture_rect(tex, rect, true)`.
- 린터가 `.tscn`을 재포맷해서 "파일이 읽은 뒤 수정됨" 에러 → 편집 직전 다시 Read.

## 8. 핵심 파일 지도
- `autoload/game_state.gd` — 전역 싱글톤(GameState). 돈/아이템/보석/광산깊이/곡괭이레벨,
  SELL_PRICES·ITEM_NAMES·GEMS, 세이브/로드, reset_game(), 곡괭이 강화 테이블 등 게임 상태 전부.
- `scenes/player.gd` / `player.tscn` — 4방향 AnimatedSprite2D, 상호작용.
- `scenes/walk_frames.gd` — `WalkFrames.build(sheet, fps)` 3열×4행 시트→SpriteFrames(down/up/left/right) 헬퍼.
- `scenes/animal.gd` — 동물 베이스(@export product/cooldown/sheet 등). 6종 tscn이 이걸 사용.
- `scenes/processor.gd` — 가공대/제련소 공용(kind="kitchen"|"smelter"). KITCHEN/SMELTER_RECIPES.
- `scenes/region_ground.gd` — 지역 바닥. `ground_texture` 있으면 타일 반복, 없으면 단색.
- `scenes/mine.gd` / `ore_rock.gd` / `descend_point.gd` — 광산(층 하강·광맥·바닥 재채굴·엔딩).
- `scenes/gem_shrine.gd` / `gather_node.gd` / `crop_plot.gd` / `fishing_spot.gd` — 보석제단/채집/밭/낚시.
- `ui/hud.gd` / `process_menu.gd` / `shop_menu.gd` / `smith_menu.gd` / `lab_menu.gd` /
  `travel_menu.gd` / `dialogue_box.gd` — 각 UI. (메뉴는 CanvasLayer + Dim + 불투명 Panel + ScrollContainer 패턴)
- `assets/art/` — 픽셀아트(character/animals/buildings/tiles/objects). PNG는 Pillow로 다운스케일됨.
- `DECISIONS.md` — 기획 결정·[미정] 항목·로드맵.
- `public/` — 빌드 산출물(커밋 대상). `vercel.json` outputDirectory=public.

## 9. 좌표/도구 정보
- repo: `nwind23/henry-s-game` (또는 `Henry-s-game`)
- 작업 브랜치: `claude/godot-4.7-headless-install-2ivzrr`  → main 자동 머지
- Vercel: team `team_wkyMH2JZzIgVQRRJxJ3VBP4D`, project `prj_yZ138O41V0ow55ywnGQIdiWYORee`
- GitHub/Vercel 조작은 MCP 도구 사용 (`gh` CLI 없음). ToolSearch로 스키마 로드 후 호출.

## 10. 남은 로드맵 / 열린 항목 (방향은 정해짐)
- **토캣몬 배경 스토리·생김새 최종 확정**은 현석이(사용자) 몫 — 현재 인트로는 임시 스토리.
- 보석 세공/추가 제작, 밸런스 2차 조정(플레이테스트 피드백 반영) 여지.
- 자세한 결정 내역은 `DECISIONS.md`의 "남은 콘텐츠 로드맵" 참고.
- 직전 플레이테스트 피드백 반영 완료: "너무 쉽다"(난이도↑), "초기화 버튼 숨겨달라"(R버튼),
  "보석이 너무 빨리 모인다"(공물량↑). 추가 피드백 시 같은 맥락으로 조정.
