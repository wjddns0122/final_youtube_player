# 🎥 AI 요약 기능이 탑재된 유튜브 플레이어 (YouTube Player with AI Summary)

> **Google Gemini 1.5 Flash AI**를 연동하여 유튜브 영상 재생과 동시에 영상의 핵심 내용을 실시간으로 요약해 주는 Flutter 모바일 애플리케이션 프로젝트입니다.

---

## 🌟 프로젝트 주요 특징 (Key Features)

1. **🎬 고성능 유튜브 재생기 통합**
   - `youtube_player_flutter` 라이브러리를 활용해 유튜브 영상을 인앱에서 끊김 없이 원활하게 재생합니다.
   
2. **✨ Gemini AI 기반 자동 요약 노트**
   - Google의 최신 경량 고성능 모델인 **Gemini 1.5 Flash API**를 연동했습니다.
   - 비디오 정보를 읽어 들여 핵심 포인트를 친절하고 읽기 쉬운 한국어로 요약해 주며, 이모지와 함께 가독성 높은 리스트 형태로 결과를 제공합니다.

3. **🔒 안전한 환경 변수 분리 (.env)**
   - API 키와 같은 민감한 정보를 하드코딩하지 않고 프로젝트 루트의 `.env` 파일에서 관리합니다.
   - `flutter_dotenv` 패키지를 통해 구동 시점에 키를 주입받아 보안성을 강화했습니다.

4. **💎 높은 수준의 UI/UX 디테일**
   - **다크 테마 디자인**: 시각적 피로를 최소화하는 블랙 배경에 고급스러운 카드 UI(글래스모피즘 스타일)를 적용했습니다.
   - **반응형 스크롤 구조**: 요약 텍스트 길이에 맞춰 유연하게 스크롤되어 화면 오버플로우(Overflow)를 완벽히 방지합니다.
   - **철저한 예외 처리**: API 키 미설정 가이드 제공, 네트워크 지연 시 세련된 로딩 상태 표시, 요약 실패 시 '다시 시도(Retry)' 버튼 제공 등 사용자 경험을 향상시켰습니다.

---

## 🛠 기술 스택 (Tech Stack)

| 기술 분류 | 기술명 | 용도 |
| :--- | :--- | :--- |
| **Framework** | Flutter (Dart SDK ^3.11.5) | 크로스플랫폼 모바일 앱 개발 |
| **Generative AI** | Google Generative AI (Gemini 1.5 Flash) | 유튜브 영상 정보(제목 및 설명) 요약 생성 |
| **Env Management**| flutter_dotenv | API 키 등의 환경 변수 외부 관리 |
| **Video Playback** | youtube_player_flutter | 유튜브 인앱 재생 컨트롤러 |

---

## 📂 프로젝트 구조 (Architecture & Directory Structure)

```text
lib/
├── main.dart                          # 앱의 진입점 (환경 변수 로드 및 초기화)
├── model/
│   └── video_model.dart               # 영상 정보 데이터 구조 (ID, 제목, 설명 등)
├── component/
│   └── custom_youtube_player.dart     # 핵심 컴포넌트 (유튜브 플레이어 및 AI 요약 통신/카드 UI)
└── screen/
    └── home_screen.dart               # 메인 화면 (SafeArea 및 전체 레이아웃 구성)
```

---

## 🚀 설정 및 실행 방법 (Setup & Installation)

### 1. 패키지 설치
프로젝트 루트 폴더에서 아래 명령어를 실행하여 의존성을 내려받습니다.
```bash
flutter pub get
```

### 2. 환경 변수 설정 (.env)
프로젝트 루트 디렉토리에 있는 [`.env`](file:///Users/nojeong-un/devs/youtube_player_project/.env) 파일을 열고, 발급받은 Gemini API 키를 작성합니다.
```env
GEMINI_API_KEY=발급받은_Gemini_API_키
```
> 💡 **API 키 발급 안내**: [Google AI Studio](https://aistudio.google.com/)에서 무료로 쉽게 API 키를 발급받을 수 있습니다.

### 3. 프로젝트 실행
```bash
flutter run
```

---

## 🎤 발표 및 데모 시 시나리오 (Presentation Highlights)

1. **보안 지향 설계 소개**: API 키 노출 우려를 방지하기 위해 `.env` 파일과 `flutter_dotenv`를 활용하는 모범 사례를 구현했습니다.
2. **에러 핸들링 시연**: 
   - API 키가 기입되지 않았을 때 뜨는 **"API 키 설정 요청 경고 화면"**을 먼저 보여준 후,
   - `.env`에 키를 넣고 앱을 다시 켰을 때 정상적으로 **"로딩 애니메이션 -> AI 요약 내용 완성"** 단계로 스무스하게 전환되는 UX 완성도를 중점적으로 어필합니다.
3. **요약 고도화 프롬프트**: Gemini 모델에 주입하는 시스템 지시어(System Instructions)를 활용해 제목과 설명글 내의 노이즈를 제거하고 정제된 요약본만 추출하도록 유도했습니다.
