# AdChain SDK iOS Sample

iOS용 AdChain SDK를 통합한 샘플 애플리케이션입니다. SDK의 주요 기능을 시연하고 구현 가이드를 제공합니다.

## 📋 목차

- [개요](#개요)
- [주요 기능](#주요-기능)
- [요구사항](#요구사항)
- [설치 및 실행](#설치-및-실행)
- [프로젝트 구조](#프로젝트-구조)
- [SDK 통합 가이드](#sdk-통합-가이드)
- [주요 API 사용법](#주요-api-사용법)
- [문제 해결](#문제-해결)

## 개요

이 샘플 앱은 AdChain SDK의 다음 기능들을 구현합니다:

- ✅ SDK 초기화 및 사용자 로그인
- ✅ Quiz (네이티브 광고) 시스템
- ✅ Mission (미션/리워드) 시스템
- ✅ Offerwall (AdChain Hub)
- ✅ Banner 광고

## 주요 기능

### 1. SDK 초기화
수동 SDK 초기화 옵션을 제공하여 개발/테스트 시 유연성을 제공합니다.

### 2. 사용자 로그인
- 정상 로그인: SDK 초기화 후 사용자 ID로 로그인
- 스킵 모드: SDK 미초기화 상태에서 에러 핸들링 테스트

### 3. Quiz System
네이티브 퀴즈 광고를 로드하고 표시합니다.
- 퀴즈 이벤트 목록 조회
- 퀴즈 참여 및 완료 추적
- 리워드 지급

### 4. Mission System
미션 기반 리워드 시스템을 구현합니다.
- 미션 목록 조회 및 진행 상황 표시
- 미션 참여 및 완료
- 리워드 클레임

### 5. Offerwall (AdChain Hub)
오퍼월 화면을 WebView로 표시합니다.

### 6. Banner Ads
배너 광고 정보를 조회하고 표시합니다.

## 요구사항

- **iOS**: 15.0 이상
- **Xcode**: 16.4 이상
- **Swift**: 5.0 이상
- **Dependencies**:
  - AdChainSDK (로컬 참조: `../adchain-sdk-ios`)

## 설치 및 실행

### 1. 저장소 클론

```bash
git clone https://github.com/1selfworld-labs/adchain-sdk-ios-sample.git
cd adchain-sdk-ios-sample
```

### 2. SDK 확인

프로젝트는 로컬 SDK를 참조합니다. 상위 폴더에 `adchain-sdk-ios`가 있는지 확인하세요:

```bash
ls ../adchain-sdk-ios
```

### 3. 프로젝트 열기

```bash
open AdchainSDK-iOS-Sample.xcodeproj
```

### 4. 설정 변경

**AppDelegate.swift**에서 앱 인증 정보를 확인/수정하세요:

```swift
private let APP_KEY = "123456782"
private let APP_SECRET = "abcdefghigjk"
```

환경 설정도 필요에 따라 변경 가능합니다:

```swift
.setEnvironment(.development)  // .production, .staging, .development
```

### 5. 실행

- 시뮬레이터 또는 실제 디바이스 선택
- `Cmd + R` 또는 Run 버튼 클릭

## 프로젝트 구조

```
AdchainSDK-iOS-Sample/
├── App/
│   ├── AppDelegate.swift          # SDK 초기화 로직
│   └── SceneDelegate.swift        # Scene 설정
├── ViewControllers/
│   ├── MainViewController.swift   # 메인 화면 (로그인/메뉴)
│   ├── Mission/
│   │   ├── MissionViewController.swift
│   │   ├── MissionTableViewCell.swift
│   │   └── OfferwallPromotionTableViewCell.swift
│   └── NativeAd/
│       ├── NativeAdViewController.swift
│       └── Quiz/
│           └── QuizTableViewCell.swift
├── Assets.xcassets/               # 앱 리소스
├── Base.lproj/                    # 스토리보드
└── Info.plist                     # 앱 설정
```

## SDK 통합 가이드

### 1. SDK 초기화

```swift
import AdchainSDK

// AppDelegate.swift
func initializeAdchainSdk() {
    let config = AdchainSdkConfig.Builder(appKey: APP_KEY, appSecret: APP_SECRET)
        .setEnvironment(.development)
        .setTimeout(30000)
        .build()

    AdchainSdk.shared.initialize(application: UIApplication.shared, sdkConfig: config)
}
```

### 2. 사용자 로그인

```swift
let user = AdchainSdkUser(
    userId: "user_123",
    gender: .male,
    birthYear: 1990
)

AdchainSdk.shared.login(adchainSdkUser: user, listener: self)
```

### 3. Quiz 로드

```swift
let quiz = AdchainQuiz()
quiz.setQuizEventsListener(self)

quiz.load(
    onSuccess: { response in
        print("Loaded \(response.events.count) quizzes")
    },
    onFailure: { error in
        print("Failed: \(error)")
    }
)
```

### 4. Mission 로드

```swift
let mission = AdchainMission()
mission.eventsListener = self

mission.load(
    onSuccess: { missions, progress in
        print("Loaded \(missions.count) missions")
        print("Progress: \(progress.current)/\(progress.total)")
    },
    onFailure: { error in
        print("Failed: \(error)")
    }
)
```

### 5. Offerwall 열기

```swift
AdchainSdk.shared.openOfferwall(
    presentingViewController: self,
    placementId: "main_offerwall"
)
```

### 6. Banner 조회

```swift
AdchainBanner.shared.getBanner(
    placementId: "banner_main",
    onSuccess: { response in
        print("Title: \(response.titleText ?? "")")
        print("Image: \(response.imageUrl ?? "")")
    },
    onFailure: { error in
        print("Failed: \(error)")
    }
)
```

## 주요 API 사용법

### 환경 설정

| Environment | 서버 URL |
|------------|----------|
| `.production` | `https://adchain-api.1self.world` |
| `.staging` | `https://adchain-stage-api.1self.world` |
| `.development` | `http://localhost:3000` |

**참고**: `.development` 환경을 사용하려면 로컬에 백엔드 서버가 실행 중이어야 합니다.

### 이벤트 리스너 구현

#### Quiz Events

```swift
extension YourViewController: AdchainQuizEventsListener {
    func onImpressed(_ quizEvent: QuizEvent) {
        print("Quiz impressed: \(quizEvent.id)")
    }

    func onClicked(_ quizEvent: QuizEvent) {
        print("Quiz clicked: \(quizEvent.id)")
    }

    func onQuizCompleted(_ quizEvent: QuizEvent, rewardAmount: Int) {
        print("Quiz completed! Reward: \(rewardAmount)")
    }
}
```

#### Mission Events

```swift
extension YourViewController: AdchainMissionEventsListener {
    func onImpressed(_ mission: Mission) { }
    func onClicked(_ mission: Mission) { }
    func onCompleted(_ mission: Mission) { }
    func onProgressed(_ mission: Mission) { }
    func onRefreshed(unitId: String?) { }
}
```

## 문제 해결

### SDK 초기화 실패

**증상**: "SDK not initialized" 오류

**해결방법**:
1. `APP_KEY`와 `APP_SECRET`이 올바른지 확인
2. 네트워크 연결 확인
3. 환경 설정 확인 (development 환경은 로컬 서버 필요)

### 로컬 SDK를 찾을 수 없음

**증상**: "Package not found" 오류

**해결방법**:
```bash
# 상위 폴더에 SDK가 있는지 확인
ls ../adchain-sdk-ios

# 없다면 SDK를 클론
cd ..
git clone https://github.com/1selfworld-labs/adchain-sdk-ios.git
```

### 시뮬레이터 실행 오류

**증상**: "requires iOS 18.5" 오류

**해결방법**: 이미 deployment target이 iOS 15.0으로 설정되어 있습니다. Xcode를 재시작하거나 클린 빌드를 수행하세요:

```bash
# Xcode에서
Cmd + Shift + K  # Clean Build Folder
Cmd + R          # Run
```

## 라이선스

이 샘플 앱은 MIT 라이선스 하에 제공됩니다.

## 지원

- **Issues**: [GitHub Issues](https://github.com/1selfworld-labs/adchain-sdk-ios-sample/issues)
- **문서**: [SDK 문서](https://github.com/1selfworld-labs/adchain-sdk-ios)

---

**버전**: 1.0.0
**최종 업데이트**: 2025년 10월 11일
