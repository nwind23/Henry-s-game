# 현석이의 모험 (Henry-s-game)

토캣몬이 동물을 키우고, 생산품을 가공해 팔고, 광산을 파 내려가 전설의 보석을
모으는 2D 생활·농장·수집 시뮬레이션. **전투 없음.**

- 엔진: **Godot 4.7** (GDScript), 2D 탑다운
- 만드는 사람: 아빠(지용) + 아들(현석)
- 작은 단위로 만들어 에디터 Play로 자주 확인합니다.

## 실행 방법 (에디터)

1. Godot 4.7로 이 폴더(`project.godot`)를 엽니다.
2. 상단의 ▶(Play, F5)를 누릅니다.
3. 메인 씬 `scenes/village.tscn`이 실행됩니다.

조작:

| 동작 | 키 |
| --- | --- |
| 이동 | WASD / 화살표 / 게임패드 |
| 상호작용 | E / 스페이스 / 게임패드 A |

해볼 것: 토캣몬으로 **닭**에게 다가가 상호작용 → 달걀 획득 → **상점** 앞에서
상호작용 → 달걀 판매. 좌상단 HUD에서 돈·달걀 수가 갱신됩니다.

## 현재 진행 상황

- ✅ **슬라이스 1**: 마을 + 토캣몬 이동 + 닭 달걀 + 상점 판매 + HUD
- ⬜ 다음: 동물·가공·지역을 하나씩 추가

비주얼은 임시 도형(`_draw()`)이며, 카이로소프트풍 픽셀 스프라이트로 교체 예정.
한글 UI 폰트는 픽셀 한글 폰트 **Galmuri11**(OFL)을 사용합니다.

## 프로젝트 구조

```
project.godot          # Godot 4.7 설정(입력맵, Nearest 필터, autoload)
autoload/game_state.gd # 돈 + 인벤토리 싱글톤
scenes/                # village / player / chicken / shop (.tscn + .gd)
ui/                    # hud (.tscn + .gd)
assets/fonts/          # Galmuri11 픽셀 한글 폰트
DECISIONS.md           # [미정] 항목에 쓴 임시값 기록
```

## Godot 4.7 설치 (헤드리스 / 웹 세션)

이 저장소는 Godot 4.7 표준 Linux 바이너리를 `--headless` 모드로 사용합니다.
`SessionStart` 훅(`.claude/settings.json` → `.claude/hooks/install-godot.sh`)이
각 웹 세션 시작 시 `/usr/local/bin/godot`로 자동 설치합니다(멱등성).

```bash
bash .claude/hooks/install-godot.sh   # 수동 설치
godot --version                        # 4.7.stable.official
godot --headless --import              # 에셋 임포트(CI/헤드리스)
```

## 웹 익스포트 (실험적)

기획서대로 웹은 **후순위/불안정**이지만, 빠른 미리보기용으로 동작합니다.
`export_presets.cfg`에 **Web** 프리셋이 있고, 스레드 미사용(nothreads) 모드라
별도의 COOP/COEP 헤더 없이도 로컬 서버에서 띄울 수 있습니다.

```bash
# 1) 웹 export templates 설치(약 1.28GB, 한 번만 — SessionStart 훅에는 미포함)
bash .claude/hooks/install-export-templates.sh

# 2) 빌드 (→ public/ 에 출력)
godot --headless --export-release "Web" public/index.html

# 3) 로컬 미리보기 (브라우저에서 http://localhost:8099/)
python3 -m http.server 8099 -d public
```

헤드리스 Chromium에서 부팅·렌더링(한국어 HUD 포함) 확인 완료.

### Vercel 배포

이 저장소는 Vercel에 연결되어 **`main`에 푸시하면 자동 배포**됩니다.
Godot 웹 빌드(`public/`)를 **커밋**하고 `vercel.json`에서 정적 서빙
(`outputDirectory: public`, 빌드 단계 없음)하도록 설정했습니다.

> 참고: Vercel은 Godot를 빌드할 수 없어, 익스포트 결과(`public/`, `index.wasm`
> 약 39MB 포함)를 직접 커밋합니다. 게임을 바꾼 뒤에는 위 2)로 **재익스포트한
> `public/`을 커밋**해야 배포에 반영됩니다.
