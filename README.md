<img width="3240" height="1350" alt="브랜딩 썸네일" src="https://github.com/user-attachments/assets/4577a38e-780c-4f35-9eba-aed3ddd28328" />

<br>

# <img src="https://github.com/user-attachments/assets/b6f650b9-0509-4205-999b-cbd8cbd3bac2" height="40"/> 하이링구얼 Hilingual

> **프로젝트 기간: 2025.7.7 ~ing**

영어 일기 작성을 통해 꾸준한 영어 루틴 형성을 돕는 iOS 애플리케이션입니다.<br>
매일 제공되는 주제를 바탕으로 영어로 일기를 쓰고, 기록을 관리하며 작문 습관을 만들어갈 수 있습니다.

<br>

## 📌 주요 기능
<!-- <img width="1920" height="1080" alt="24" src="https://github.com/user-attachments/assets/e7e3b394-cac6-4523-b7f8-a96c1e5306fb" />-->

<img width="1920" alt="11" src="https://github.com/user-attachments/assets/9af559e9-f8f8-44f0-9fdf-4c06f1b744e2" />

<br>

<!--
<table>
  <colgroup>
    <col style="width: 200px;" />
    <col style="width: 2000px;" />
  </colgroup>
  <thead>
    <tr>
      <th style="text-align:left;">Feature</th>
      <th style="text-align:left;">Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>영어 일기 주제 제공</strong></td>
      <td>
        매일 영어·한글로 구성된 영작 주제를 제공하여 작문을 유도합니다.<br>
        모든 사용자에게 동일한 주제가 노출되며, 작문의 진입 장벽을 낮춰줍니다.
      </td>
    </tr>
    <tr>
      <td><strong>일기 작성 및 기록 관리</strong></td>
      <td>
        사용자는 원하는 날짜를 선택해 영어 일기를 작성할 수 있으며, 작성한 내용은 수정 및 삭제가 가능합니다.<br>
        작성 기한은 최대 이틀 전까지 허용되며, 작성 후 피드백 요청을 통해 문법 및 표현 교정을 받을 수 있습니다.
      </td>
    </tr>
    <tr>
      <td><strong>작성 현황 캘린더</strong></td>
      <td>
        한 달간의 일기 작성 여부를 시각적으로 확인할 수 있는 캘린더 기능을 제공합니다.<br>
        연속 작성일(스트릭)이 강조되며, 월 이동 및 날짜 선택도 지원하여 작문 루틴을 쉽게 관리할 수 있습니다.
      </td>
    </tr>
    <tr>
      <td><strong>단어장</strong></td>
      <td>
        작성한 일기에서 AI가 추천 표현을 자동 추출하여 단어장에 저장합니다.<br>
        수동 추가는 불가능하며, 최신순 및 A–Z 정렬 기능과 북마크 기능을 통해 효율적으로 단어를 복습할 수 있습니다.
      </td>
    </tr>
  </tbody>
</table>
-->

## 👩‍💻 iOS 파트

| [**성현주**](https://github.com/hye0njuoo) | [**신혜연**](https://github.com/hyeyeonie) | [**조영서**](https://github.com/jjwm10625) | [**진소은**](https://github.com/rosejinse) |
|:--:|:--:|:--:|:--:|
| [<img src="https://github.com/user-attachments/assets/4160dc06-4731-4e8f-a48a-9c935ac56624" width="250px">](https://github.com/hye0njuoo) | [<img src="https://github.com/user-attachments/assets/c56431eb-4a29-419e-b0ab-1696095ce78c" width="250px">](https://github.com/hyeyeonie) | [<img src="https://github.com/user-attachments/assets/916ecdf7-0b18-41a1-b37b-f31f01c5a6b5" width="250px">](https://github.com/jjwm10625) | [<img src="https://github.com/user-attachments/assets/3dab4cb8-6f01-4e4e-a675-8302539b32bd" width="250px">](https://github.com/rosejinse) |
| `iOS Lead`<br>`스플래시 · 로그인/온보딩 · 단어장` | `iOS Developer`<br>`일기 작성 · 피드백 요청 로딩` | `iOS Developer`<br>`홈 · 캘린더` | `iOS Developer`<br>`일기 자세히 보기` |

<br>

## 🛠 기술 스택

| 영역 | 기술 | 비고 |
|:---:|:---:|---|
| UI 프레임워크 | **UIKit** | 안정적이고 풍부한 레퍼런스, 실무 적합성 |
| 아키텍처 | **MVVM + Clean Architecture** | UI, 도메인, 데이터 계층 분리로 유지보수 용이 |
| 네트워킹 | **Moya** | 추상화된 API 구성, 테스트 용이성, 요청 관리 편의 |
| 비동기/반응형 | **Combine** | 데이터 흐름의 선언적 처리, 상태 바인딩 최적화 |
| OCR 기능 | **VisionKit** | iOS 기본 OCR 지원으로 성능 및 접근성 확보 |
| 애니메이션 | **Lottie** | 감성적인 UI 표현, 디자이너 협업 효율, 벡터 기반 경량 애니메이션 |
| 이미지 처리 | **Kingfisher** | 이미지 캐싱 및 네트워크 병목 방지 |
| 로컬 저장소 | **UserDefaults** | 간단한 유저 설정 및 정보 유지 |
| 의존성 주입 | **DIContainer** | 모듈 간 결합도 최소화, 테스트 편의성 확보 |
| 패키지 관리 및 모듈화 | **SPM** | Swift Package Manager 기반 외부 라이브러리 관리 및 내부 모듈화 구성 |
| 버전 관리 | **Git, GitHub** | 브랜치 전략 기반 협업, PR 및 코드리뷰 활용 |
| 협업 도구 | **Figma, Notion** | 디자인 및 기능 흐름 시각화, 문서화 기반 협업 |

<br>

<!-- 
## 📌 프로젝트 소개

| <img src="이미지_스플래시_URL" width="250"/> | <img src="이미지_온보딩_URL" width="250"/> | <img src="이미지_홈_데이트피커_URL" width="250"/> |
|:--:|:--:|:--:|
| 앱 실행 시 로고 및 초기 로딩 화면 (Splash) | 영어 일기 사용법을 안내하는 온보딩 화면 | 월과 연도를 선택할 수 있는 홈 데이트 피커 뷰 |
| <img src="이미지_홈_날짜선택_URL" width="250"/> | <img src="이미지_일기작성_URL" width="250"/> | <img src="이미지_피드백요청_URL" width="250"/> |
| 원하는 날짜를 선택해 일기 작성을 시작하는 화면 | 영어 일기를 직접 입력하는 작성 뷰 | 작성한 일기에 대해 피드백 요청 버튼을 눌렀을 때의 상태 |
| <img src="이미지_자세히보기_문법_URL" width="250"/> | <img src="이미지_자세히보기_추천표현_URL" width="250"/> | <img src="이미지_단어장_URL" width="250"/> |
| 피드백 상세보기 – 문법 및 철자 교정 탭 | 피드백 상세보기 – 추천 표현 탭 | 추천 표현 기반 자동 저장 단어장 화면 |
-->

<br>

## 🔧 Project Architecture
<img width="2054" height="1270" alt="아키텍쳐" src="https://github.com/user-attachments/assets/d1233b8b-49b5-4f3f-ba8e-33e2dbfde9a1" />

<br>

## 🌐 GitHub Pages

This repository includes a `docs/` directory for GitHub Pages publishing.

- Landing page: `docs/index.html`
- AdMob seller declaration: `docs/app-ads.txt`

If you enable GitHub Pages with the `main` branch and `/docs` folder, the site will be published automatically.

<br>

## 📂 프로젝트 구조
```swift
📦 HilingualNetwork (SPM 패키지)
├── 📁 Sources
│   └── 📁 HilingualNetwork
│       ├── 📁 API          # API 정의 (TargetType 등)
│       ├── 📁 DTO          # 데이터 전송 객체 (요청/응답 모델)
│       ├── 📁 Error        # 네트워크 에러 처리 및 공통 에러 타입
│       ├── 📁 Foundation   # 네트워크 기반 설정 (인터셉터, 공통 프로토콜 등)
│       ├── 📁 Service      # 각 API에 대응하는 서비스 레이어
│       └── 📁 Token        # 토큰 저장/갱신/관리 로직
├── 📄 Package.swift
└── 📄 Package.resolved
```

```swift
📦 HilingualData (SPM 패키지)
├── 📁 Sources
│   └── 📁 HilingualData
│       ├── 📁 Mapper       # DTO → Domain Entity 변환 로직
│       ├── 📁 Repository   # Repository 구현체 (Interface 충족)
│       └── 📁 Token        # Token 저장/불러오기 관련 구현 (ex. UserDefaults 기반 등)
├── 📄 Package.swift
└── 📄 Package.resolved
```

```swift
📦 HilingualDomain (SPM 패키지)
├── 📁 Sources
│   └── 📁 HilingualDomain
│       ├── 📁 Entity         # 순수 도메인 모델 (불변 데이터, 로직 포함 가능)
│       ├── 📁 Interface
│       │   └── 📁 Repository # 추상 Repository 프로토콜 (도메인 로직 독립성 확보)
│       └── 📁 UseCase        # 유스케이스 계층 (비즈니스 로직 담당)
├── 📄 Package.swift
└── 📄 Package.resolved
```

```swift
📦 HilingualPresentation (SPM 패키지)
├── 📁 Sources
│   └── 📁 Presentation
│       ├── 📁 Common                  # 전역적으로 사용하는 공통 요소들
│       │   ├── 📁 Base               # BaseViewController, BaseView 등 공통 베이스 클래스
│       │   ├── 📁 Components         # 공통 UI 컴포넌트 (ex: 버튼, 토스트 등)
│       │   ├── 📁 Extensions         # UIKit, Foundation 등 확장 기능
│       │   ├── 📁 Factory            # 화면 생성 관련 Factory 객체들
│       │   └── 📁 Resources          # 리소스 관련 정리
│       │       ├── 📁 Font           # 커스텀 폰트 관리
│       │       ├── 📁 Lottie         # Lottie 애니메이션 JSON 파일 관리
│       │       └── 🖼️ Assets         # 이미지 에셋, 컬러셋 등
│       ├── 📁 Utils                  # 유틸리티 클래스 모음
│       ├── 📁 Community              # 커뮤니티 관련 화면
│       ├── 📁 Diarydetail            # 일기 상세 화면
│       ├── 📁 DiaryWriting           # 일기 작성 화면
│       ├── 📁 Example                # 예제 테스트 화면 (샘플, 실험용)
│       ├── 📁 Home                   # 홈 화면 관련 구성
│       ├── 📁 Loading                # 로딩 화면
│       ├── 📁 Login                  # 로그인 화면
│       ├── 📁 MyPage                 # 마이페이지 화면
│       ├── 📁 OnBoarding             # 온보딩 화면
│       ├── 📁 Preparing              # 준비 중인 기능들
│       ├── 📁 Splash                 # 스플래시 화면
│       └── 📁 WordBook               # 단어장 기능
├── 📄 Package.swift
└── 📄 Package.resolved
```

```swift
📱 Hilingual (App Main Target)
├── 📁 App                             # 앱 진입점과 환경 설정 관련 모듈
│   ├── 🧩 AppDelegate                # 앱 생명주기 진입 지점
│   ├── 🧩 SceneDelegate              # 씬 생명주기 관리
│   ├── 🧩 AppDIContainer            # DIContainer: 의존성 주입 시작점
│   ├── 🛠️ LaunchScreen              # LaunchScreen.storyboard
│   └── 📁 Config                     # 런타임 환경 및 앱 설정 관련 모음
│       ├── ⚙️ Config                # 환경 enum 정의 (dev, prod 등)
│       ├── 🧩 AppConfig             # 현재 앱의 설정값을 관리 (e.g. 환경별 분기)
│       ├── 🧩 AppBaseURLProvider    # 네트워크 요청의 기본 URL 제공자
│       └── 🖼️ AppIcon               # 앱 아이콘 관리 (dev/prod 분기 등)
├── 📦 Hilingual                      # 앱 바이너리
├── 📝 Info                          # Info.plist
```

<br>

## 📌 Convention

### Code Style
- [Swift 스타일 쉐어 가이드](https://github.com/StyleShare/swift-style-guide)를 따릅니다.  
- `final`, `extension`, `do {}` 패턴 활용, `setStyle / setLayout / setUI` 분리 등 적용.

---

### Commit 태그

| 태그       | 설명                                                   |
|------------|--------------------------------------------------------|
| `feat`     | 새로운 기능 구현                                       |
| `style`    | UI 및 스타일 관련 작업                                 |
| `fix`      | 버그 및 오류 수정                                      |
| `docs`     | 문서 수정 (README 등)                                  |
| `setting`  | 설정 파일 및 환경 구성 변경                            |
| `add`      | 에셋/라이브러리 추가                                   |
| `refactor` | 코드 리팩토링 (기능 변경 없이 구조 개선)              |
| `chore`    | 사소한 수정 및 유지보수 작업                          |
| `hotfix`   | 긴급 수정 (배포 또는 개발 중 발생한 치명적 이슈 해결) |

---

### Commit Message 규칙

1. **소문자**로 작성합니다.  
2. **한글**로 작성합니다.  
3. 제목은 **명령문 형태**, **50자 이내**로 작성합니다.

```markdown
feat: #1 로그인 화면 UI 구현  
add: #3 온보딩 이미지 에셋 추가  
fix: #5 캘린더 날짜 선택 오류 수정  
```

<br>

## ☄️ Trouble Shooting

문제 해결 과정은 아래 Notion 페이지에 정리되어 있습니다.  
[🔗 Trouble Shooting 바로가기](https://hilingual.notion.site/Trouble-Shooting-230829677ebf81028a15c2970ecba082?source=copy_link)
