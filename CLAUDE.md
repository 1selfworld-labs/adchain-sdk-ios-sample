# CLAUDE.md - AI 개발 프로세스 문서

## ⚠️ 절대 원칙
- 이 워커는 할당된 디렉토리 내에서만 파일을 수정한다
- 다른 레포의 파일은 읽기만 가능하며, 수정이 필요하면 오케스트레이터에게 보고한다

## Team Context
- **Worker ID**: `ios-sample`
- **Orchestrator**: 상위 디렉토리 (`adchain-sdk/`)
- **담당 범위**: `adchain-sdk-ios-sample/` (AdChain iOS 샘플앱)
- **Upstream**: `adchain-sdk-ios-release` (SPM/CocoaPods로 참조), `adchain-sdk-ios` (로컬 SPM 개발 시)
- **Downstream**: 없음 (최종 소비자)

### Agent Teams 프로토콜
- 팀 설정 파일: `~/.claude/teams/adchain-sdk/config.json`에서 팀원 목록 확인
- 작업 확인: TaskList → TaskGet으로 할당된 작업의 상세 내용 확인
- 작업 시작: TaskUpdate(status: "in_progress") → 작업 수행
- 작업 완료: TaskUpdate(status: "completed") → TaskList로 다음 작업 확인
- 오케스트레이터 보고: SendMessage(type: "message", recipient: "team-lead", content: "...", summary: "...")
- 다른 워커 문의: SendMessage(type: "message", recipient: "{워커-name}", content: "...", summary: "...")
- 종료 요청 수신 시: SendMessage(type: "shutdown_response", request_id: "{id}", approve: true)

---

> AdChain SDK iOS Sample 프로젝트의 AI 지원 개발 과정 및 기술 결정사항

**작성일**: 2025년 10월 11일 (초기 작성)
**최종 업데이트**: 2025년 10월 30일
**프로젝트**: AdChain SDK iOS Sample
**AI 모델**: Claude (Anthropic)

---

## 📋 목차

- [프로젝트 개요](#프로젝트-개요)
- [마이그레이션 프로세스](#마이그레이션-프로세스)
- [주요 API 변경사항](#주요-api-변경사항)
- [최신 기능 추가 (2025-10-30)](#최신-기능-추가-2025-10-30)
- [기술적 결정사항](#기술적-결정사항)
- [문제 해결 과정](#문제-해결-과정)
- [코드 패턴 및 베스트 프랙티스](#코드-패턴-및-베스트-프랙티스)
- [향후 개선 방향](#향후-개선-방향)

---

## 프로젝트 개요

### 목적
AdChain SDK의 최신 API에 맞춰 iOS 샘플 애플리케이션을 마이그레이션하고, SDK 통합 베스트 프랙티스를 시연하는 것

### 주요 작업
1. **Deprecated API 식별**: SDK 소스 코드 분석을 통한 구 API 파악
2. **새로운 API 매핑**: 구 API → 신 API 마이그레이션 경로 수립
3. **샘플 앱 업데이트**: 3개 주요 ViewController 수정
4. **빌드 검증**: 시뮬레이터 배포 및 동작 확인
5. **문서화**: README 및 기술 문서 작성

---

## 마이그레이션 프로세스

### Phase 1: API 분석 (READONLY MODE)

#### 분석 대상 SDK 파일
```
AdchainSDK/Sources/
├── Core/
│   ├── AdchainSdk.swift
│   └── AdchainSdkConfig.swift
├── Banner/
│   └── AdchainBanner.swift
├── Mission/
│   ├── AdchainMission.swift
│   └── AdchainMissionEventsListener.swift
├── Quiz/
│   └── AdchainQuiz.swift
└── Network/Models/Response/
    └── BannerInfoResponse.swift
```

#### 발견된 변경사항 (6개)
1. `AdchainSdk.openOfferwall()` 시그니처 변경
2. `AdchainMission()` 초기화 파라미터 변경
3. `AdchainQuiz()` 초기화 파라미터 변경
4. `AdchainQuiz.load()` 콜백 타입 변경
5. `BannerInfoResponse` 구조 변경
6. `AdchainMissionEventsListener` 프로토콜 메서드 추가

### Phase 2: 마이그레이션 계획 (PLAN MODE)

```markdown
변경 범위:
- ViewControllers/MainViewController.swift
- ViewControllers/Mission/MissionViewController.swift
- ViewControllers/NativeAd/NativeAdViewController.swift

예상 리스크: 🟡 중간
- 프로토콜 준수 실패 가능성
- 배너 URL 처리 로직 오류 가능성
```

### Phase 3: 코드 수정 (EDIT MODE)

승인된 범위 내에서 3개 파일 수정 완료

### Phase 4: 검증 및 배포 (EXECUTE MODE)

```bash
✅ Xcode 빌드 성공
✅ iOS 15.0 deployment target 설정
✅ iPhone 15 Pro 시뮬레이터 배포 (iOS 17.4)
✅ 앱 실행 확인 (PID: 28944)
```

---

## 주요 API 변경사항

### 1. Offerwall API 변경

**이전 (Deprecated)**
```swift
AdchainSdk.shared.openOfferwall(
    presentingViewController: self
)
```

**현재 (최신)**
```swift
AdchainSdk.shared.openOfferwall(
    presentingViewController: self,
    placementId: "adchain_hub"  // 필수 파라미터
)
```

**마이그레이션 가이드**
- `placementId` 파라미터가 필수로 변경됨
- 각 사용처에 적절한 placement ID 지정 필요
- 예: `"adchain_hub"`, `"mission_offerwall_promotion"`, `"quiz_empty_banner"`

**영향 받은 파일**
- `MainViewController.swift`: 2개소
- `MissionViewController.swift`: 2개소
- `NativeAdViewController.swift`: 1개소

---

### 2. AdchainMission 초기화 변경

**이전 (Deprecated)**
```swift
let mission = AdchainMission(unitId: "mission_unit_id")
```

**현재 (최신)**
```swift
let mission = AdchainMission()  // unitId 제거
```

**마이그레이션 가이드**
- `unitId` 파라미터가 초기화 시점에서 제거됨
- Unit ID는 이제 WebView 또는 네트워크 요청 시점에 자동 처리됨
- 기존 `unitId` 문자열은 제거 가능

**기술적 배경**
SDK 내부에서 `unitId`를 동적으로 관리하도록 변경되어, 클라이언트 코드가 이를 명시할 필요가 없어짐

---

### 3. AdchainQuiz 초기화 변경

**이전 (Deprecated)**
```swift
let quiz = AdchainQuiz(unitId: "quiz_unit_id")
```

**현재 (최신)**
```swift
let quiz = AdchainQuiz()  // unitId 제거
```

**마이그레이션 가이드**
- Mission과 동일한 패턴
- `unitId` 파라미터 제거
- 초기화 코드 단순화

---

### 4. Quiz Load 콜백 타입 변경

**이전 (Deprecated)**
```swift
quiz.load(
    onSuccess: { events in  // [QuizEvent]
        if events.isEmpty {
            showEmptyState()
        }
    },
    onFailure: { error in }
)
```

**현재 (최신)**
```swift
quiz.load(
    onSuccess: { response in  // QuizResponse
        if response.events.isEmpty {
            showEmptyState()
        }
        // response.titleText 등 추가 정보 접근 가능
    },
    onFailure: { error in }
)
```

**마이그레이션 가이드**
1. 콜백 파라미터를 `events` → `response`로 변경
2. 이벤트 배열 접근 시 `response.events` 사용
3. 추가 메타데이터 활용 가능: `response.titleText`, `response.rewardUrl` 등

**QuizResponse 구조**
```swift
public struct QuizResponse {
    let events: [QuizEvent]
    let titleText: String?
    let rewardUrl: String?
    // ... 기타 메타데이터
}
```

---

### 5. BannerInfoResponse 구조 변경

**이전 (Deprecated)**
```swift
struct BannerInfoResponse {
    let linkUrl: String?  // 단일 URL 필드
}

// 사용 예
if let url = banner.linkUrl {
    openURL(url)
}
```

**현재 (최신)**
```swift
struct BannerInfoResponse {
    let linkType: String?           // "internal" | "external"
    let internalLinkUrl: String?    // 내부 링크
    let externalLinkUrl: String?    // 외부 링크
}

// 사용 예
let linkUrl = banner.linkType == "external"
    ? banner.externalLinkUrl
    : banner.internalLinkUrl

if let url = linkUrl {
    openURL(url)
}
```

**마이그레이션 가이드**
1. `linkUrl` 필드 제거
2. `linkType`에 따라 적절한 URL 필드 선택
3. 내부/외부 링크 구분 로직 추가

**기술적 배경**
- 내부 링크: 앱 내 딥링크 (예: `adchain://mission/123`)
- 외부 링크: 웹 URL (예: `https://example.com`)
- 서버에서 링크 타입을 구분하여 전달하도록 개선됨

---

### 6. AdchainMissionEventsListener 프로토콜 확장

**이전 (Deprecated)**
```swift
protocol AdchainMissionEventsListener {
    func onImpressed(_ mission: Mission)
    func onClicked(_ mission: Mission)
    func onCompleted(_ mission: Mission)
}
```

**현재 (최신)**
```swift
protocol AdchainMissionEventsListener {
    func onImpressed(_ mission: Mission)
    func onClicked(_ mission: Mission)
    func onCompleted(_ mission: Mission)
    func onProgressed(_ mission: Mission)      // 신규
    func onRefreshed(unitId: String?)          // 신규
}
```

**마이그레이션 가이드**

기존 리스너를 구현한 모든 클래스에 두 메서드 추가 필요:

```swift
extension MissionViewController: AdchainMissionEventsListener {
    // 기존 메서드들...

    // 신규: 미션 진행 상황 업데이트 시 호출
    func onProgressed(_ mission: Mission) {
        print("Mission progressed: \(mission.id)")
        // UI 업데이트 로직
    }

    // 신규: 미션 목록 리프레시 시 호출
    func onRefreshed(unitId: String?) {
        print("Mission list refreshed, unitId: \(unitId ?? "nil")")
        loadMissionData()  // 데이터 재로드
    }
}
```

**사용 시나리오**
- `onProgressed`: 미션 중간 단계 완료 시 (예: 3단계 중 2단계 완료)
- `onRefreshed`: WebView에서 미션 완료 후 목록 갱신 필요 시

---

## 기술적 결정사항

### 1. SDK 초기화 전략

**결정**: 수동 초기화 방식 채택

```swift
// AppDelegate.swift
func application(_ application: UIApplication,
                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // SDK 초기화를 자동으로 하지 않음
    // MainViewController에서 선택적으로 초기화
    return true
}

// MainViewController.swift
@IBAction func initializeSdkButtonTapped(_ sender: UIButton) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.initializeAdchainSdk()
}
```

**근거**
- 개발/테스트 시 SDK 미초기화 상태에서 에러 핸들링 테스트 가능
- 사용자가 초기화 시점을 직접 제어 가능
- 샘플 앱의 교육적 목적에 부합

---

### 2. 환경 설정

**선택**: Development 환경

```swift
let config = AdchainSdkConfig.Builder(appKey: APP_KEY, appSecret: APP_SECRET)
    .setEnvironment(.development)  // 로컬 서버 (localhost:3000)
    .setTimeout(30000)
    .build()
```

**환경별 서버 URL**
```swift
public enum Environment {
    case production   // https://adchain-api.1self.world
    case staging      // https://adchain-stage-api.1self.world
    case development  // http://localhost:3000
}
```

**주의사항**
- Development 환경 사용 시 로컬 백엔드 서버 실행 필수
- 프로덕션 테스트 시 `.production`으로 변경 필요

---

### 3. Deployment Target 설정

**결정**: iOS 15.0 최소 지원

**이슈**
- 초기 설정: iOS 18.5 (너무 높음)
- 시뮬레이터: iOS 17.4
- 충돌 발생

**해결**
```bash
sed -i '' 's/IPHONEOS_DEPLOYMENT_TARGET = 18.5;/IPHONEOS_DEPLOYMENT_TARGET = 15.0;/g' \
    AdchainSDK-iOS-Sample.xcodeproj/project.pbxproj
```

**근거**
- iOS 15 이상이면 대부분의 최신 API 지원
- Swift 5.0 호환성 확보
- 넓은 디바이스 커버리지 (iPhone 8 이상)

---

### 4. 로컬 SDK 참조 방식

**결정**: XCLocalSwiftPackageReference 사용

```xml
<XCLocalSwiftPackageReference key="XCRemoteSwiftPackageReference "AdchainSDK"">
    <RepositoryURL>../adchain-sdk-ios</RepositoryURL>
    <Version>1.0.0</Version>
</XCLocalSwiftPackageReference>
```

**장점**
- SDK와 샘플 앱 동시 개발 가능
- 변경사항 즉시 반영
- 디버깅 용이

**주의사항**
- 상위 폴더에 `adchain-sdk-ios` 필수
- 프로덕션 배포 시 원격 레포지토리로 전환 권장

---

## 문제 해결 과정

### 문제 1: 프로토콜 준수 실패

**증상**
```
Type 'MissionViewController' does not conform to protocol 'AdchainMissionEventsListener'
```

**원인 분석**
- SDK가 `AdchainMissionEventsListener` 프로토콜에 2개 메서드 추가
- 샘플 앱은 구 프로토콜 버전을 구현하고 있었음

**해결 과정**
1. SDK 소스 파일 `AdchainMissionEventsListener.swift` 확인
2. 신규 메서드 2개 발견: `onProgressed`, `onRefreshed`
3. `MissionViewController` extension에 메서드 추가

**적용 코드**
```swift
extension MissionViewController: AdchainMissionEventsListener {
    // ... 기존 메서드들

    func onProgressed(_ mission: Mission) {
        print("\(TAG): Mission progressed: \(mission.id)")
    }

    func onRefreshed(unitId: String?) {
        print("\(TAG): Mission list refreshed, unitId: \(unitId ?? "nil")")
        loadMissionData()
    }
}
```

**교훈**
- 프로토콜 변경은 breaking change
- 모든 구현체에 메서드 추가 필수
- 컴파일 타임에 검증 가능

---

### 문제 2: BannerInfoResponse API 변경

**증상**
```
Value of type 'BannerInfoResponse' has no member 'linkUrl'
```

**원인 분석**
- `linkUrl` 필드가 `linkType`, `internalLinkUrl`, `externalLinkUrl`로 분리됨
- 샘플 앱은 단일 `linkUrl` 필드에 의존하고 있었음

**해결 과정**
1. `BannerInfoResponse.swift` 소스 확인
2. 새 구조 파악: linkType 기반 분기 필요
3. 조건부 로직 구현

**적용 코드**
```swift
// Before
let linkUrl = bannerResponse.linkUrl

// After
let linkUrl = bannerResponse.linkType == "external"
    ? bannerResponse.externalLinkUrl
    : bannerResponse.internalLinkUrl
```

**교훈**
- 단순 필드 이름 변경보다 구조 변경이 더 복잡
- 내부/외부 링크 구분은 UX 개선
- 타입 안전성 증가 (Optional 처리)

---

### 문제 3: iOS 버전 호환성

**증상**
```
The iOS Simulator deployment target 'IPHONEOS_DEPLOYMENT_TARGET' is set to 18.5,
but the range of supported deployment target versions is 17.4 to 17.4.99
```

**원인 분석**
- `project.pbxproj`에 deployment target이 18.5로 설정됨 (너무 높음)
- 사용 가능한 시뮬레이터는 iOS 17.4
- 버전 불일치로 배포 실패

**해결 과정**
1. `project.pbxproj` 파일 검색
2. `IPHONEOS_DEPLOYMENT_TARGET` 값 확인 (4개소)
3. sed 명령으로 일괄 변경 (18.5 → 15.0)

**적용 명령**
```bash
sed -i '' 's/IPHONEOS_DEPLOYMENT_TARGET = 18.5;/IPHONEOS_DEPLOYMENT_TARGET = 15.0;/g' \
    AdchainSDK-iOS-Sample.xcodeproj/project.pbxproj
```

**교훈**
- Deployment target은 실제 지원 디바이스와 일치해야 함
- iOS 15.0은 현실적인 최소 버전 (2021년 릴리스)
- 프로젝트 설정 파일 직접 수정 시 주의 필요

---

## 최신 기능 추가 (2025-10-30)

### SDK v1.0.47 업데이트

AdChain SDK를 v1.0.45에서 v1.0.47로 업데이트했습니다.

**변경 내역**:
- `Package.resolved`: revision 5a0c0df → fd4a633
- `project.pbxproj`: 패키지 참조 ID 업데이트

### Tab 기반 UI 구조로 전환

기존 단일 화면 구조에서 Tab 기반 구조로 전환하여 UX를 개선했습니다.

#### 새로 추가된 ViewController

**1. LoginViewController.swift**
- SDK 초기화 및 사용자 로그인 담당
- 기능:
  - SDK 수동 초기화 (Initialize SDK 버튼)
  - 사용자 ID 입력 및 로그인
  - Skip Login (테스트 모드 - SDK 미초기화 상태 테스트)
  - 로그인 성공 시 TabBarController로 전환

```swift
// 주요 기능
@objc private func performSdkInitialization() {
    appDelegate.initializeAdchainSdk()
    // SDK 초기화 완료까지 폴링
}

@objc private func performLogin() {
    let user = AdchainSdkUser(userId: userId, gender: .male, birthYear: 1990)
    AdchainSdk.shared.login(adchainSdkUser: user, listener: LoginListenerImpl(viewController: self))
}

private func navigateToTabBar() {
    let tabBarVC = TabBarController()
    window.rootViewController = tabBarVC  // 화면 전환
}
```

**2. TabBarController.swift**
- UITabBarController 기반 탭 컨테이너
- 2개 탭: 홈(HomeViewController), 혜택(BenefitsViewController)
- Android와 동일한 색상 적용 (#007AFF)

```swift
private func setupTabBar() {
    let homeVC = HomeViewController()
    homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
    let homeNav = UINavigationController(rootViewController: homeVC)

    let benefitsVC = BenefitsViewController()
    benefitsVC.tabBarItem = UITabBarItem(title: "혜택", image: UIImage(systemName: "gift"), tag: 1)

    viewControllers = [homeNav, benefitsVC]
    tabBar.tintColor = UIColor(red: 0, green: 0.48, blue: 1.0, alpha: 1.0)
}
```

**3. BenefitsViewController.swift**
- AdchainOfferwallView 통합 (SDK v1.0.47의 새 기능)
- WebView ↔ App 양방향 통신 구현
- 기능:
  - AdchainOfferwallView를 UIView로 삽입
  - OfferwallCallback 구현 (onOpened, onClosed, onError, onRewardEarned)
  - OfferwallEventCallback 구현 (onCustomEvent, onDataRequest)

```swift
private func setupOfferwallView() {
    let offerwallView = AdchainOfferwallView()
    view.addSubview(offerwallView)

    // 레이아웃: SafeArea 기준
    NSLayoutConstraint.activate([
        offerwallView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        offerwallView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        offerwallView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        offerwallView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])

    offerwallView.setCallback(OfferwallCallbackImpl(viewController: self))
    offerwallView.setEventCallback(EventCallbackImpl(viewController: self))
}

private func loadOfferwall() {
    offerwallView?.loadOfferwall(placementId: "sample-test-ios-placement")
}
```

**WebView → App 통신 (Custom Events)**:
```swift
func onCustomEvent(eventType: String, payload: [String: Any]) {
    switch eventType {
    case "show_toast":
        let message = payload["message"] as? String ?? ""
        showToast("🎉 WebView Message: \(message)")
    case "navigate":
        let screen = payload["screen"] as? String ?? ""
        showToast("🧭 Navigate to: \(screen)")
    case "share", "buy_ticket", "show_ticket_list":
        // 각 이벤트 처리
    default:
        showToast("📨 Event: \(eventType)")
    }
}
```

**App → WebView 통신 (Data Requests)**:
```swift
func onDataRequest(requestId: String, requestType: String, params: [String: Any]) -> [String: Any]? {
    switch requestType {
    case "user_points":
        return ["points": 12345, "currency": "KRW"]
    case "user_profile":
        return ["userId": "test_123", "nickname": "TestPlayer", "level": 42]
    case "app_version":
        return ["version": "1.0.0", "buildNumber": 100]
    default:
        return nil
    }
}
```

**4. HomeViewController.swift**
- 기존 MainViewController의 메뉴 기능만 포함
- SDK 초기화/로그인 기능은 LoginViewController로 이동
- 기능:
  - Quiz Test
  - Mission System Test
  - Adchain Hub Test
  - Banner Test
  - Adjoe Offerwall Test
  - NestAds Offerwall Test (신규)
  - App Launch Test
  - Logout (LoginViewController로 복귀)

```swift
@objc private func performNestAdsTest() {
    AdchainSdk.shared.openOfferwallNestAds(
        presentingViewController: self,
        placementId: "c3c3fc08-2ba1-4243-93f7-f4d0d71c23a3",
        callback: NestAdsCallbackImpl(viewController: self)
    )
}

@objc private func performLogout() {
    AdchainSdk.shared.logout()
    // LoginViewController로 화면 전환
    let loginVC = LoginViewController()
    let navController = UINavigationController(rootViewController: loginVC)
    window.rootViewController = navController
}
```

#### SceneDelegate 변경

첫 화면을 MainViewController에서 LoginViewController로 변경:

```swift
// Before
let mainViewController = MainViewController()
let navigationController = UINavigationController(rootViewController: mainViewController)

// After
let loginViewController = LoginViewController()
let navigationController = UINavigationController(rootViewController: loginViewController)
```

### 새로운 SDK 기능 활용

#### 1. NestAds Offerwall 지원

SDK v1.0.47에서 추가된 NestAds Offerwall를 통합했습니다.

```swift
AdchainSdk.shared.openOfferwallNestAds(
    presentingViewController: self,
    placementId: "c3c3fc08-2ba1-4243-93f7-f4d0d71c23a3",
    callback: callback
)
```

**특징**:
- ADJOE와 유사한 인터페이스 (OfferwallCallback 사용)
- Placement ID 기반 광고 표시
- 리워드 획득 추적

#### 2. AdchainOfferwallView (View-based Offerwall)

SDK v1.0.47의 새로운 기능으로, UIView로 삽입 가능한 Offerwall입니다.

**기존 방식 (Modal)**:
```swift
AdchainSdk.shared.openOfferwall(presentingViewController: self, placementId: "...")
```

**새로운 방식 (View 삽입)**:
```swift
let offerwallView = AdchainOfferwallView()
view.addSubview(offerwallView)
offerwallView.loadOfferwall(placementId: "...")
```

**장점**:
- Tab 구조에 통합 가능
- 화면 전환 없이 항상 표시
- WebView ↔ App 양방향 통신 지원

**제약사항**:
- SafeArea 레이아웃 필수 (탭바, 상태바 영역 고려)
- SDK 초기화 및 로그인 필수
- 메모리 관리 필요 (화면 이탈 시 정리)

### 아키텍처 변경 요약

#### Before (v1.0.45)
```
AppDelegate → SceneDelegate → MainViewController
                                    ├─ SDK 초기화/로그인
                                    ├─ Quiz/Mission/Offerwall 메뉴
                                    └─ ADJOE 테스트
```

#### After (v1.0.47)
```
AppDelegate → SceneDelegate → LoginViewController
                                    ├─ SDK 초기화
                                    ├─ 로그인
                                    └─ TabBarController
                                           ├─ HomeViewController (NavigationController)
                                           │       ├─ Quiz/Mission 메뉴
                                           │       ├─ ADJOE/NestAds 테스트
                                           │       └─ Logout
                                           └─ BenefitsViewController
                                                   └─ AdchainOfferwallView (WebView 통합)
```

### Android Sample과의 일치성

이번 업데이트로 Android 샘플 앱과 구조가 거의 일치하게 되었습니다:

| 항목 | Android | iOS |
|------|---------|-----|
| **초기 화면** | LoginActivity | LoginViewController |
| **Tab Container** | BottomNavigationView | UITabBarController |
| **홈 화면** | HomeFragment | HomeViewController |
| **혜택 화면** | BenefitsFragment | BenefitsViewController |
| **Offerwall View** | AdchainOfferwallView | AdchainOfferwallView |
| **Event Callback** | OfferwallEventCallback | OfferwallEventCallback |
| **Data Request** | onDataRequest | onDataRequest |

### 테스트 플로우

#### Flow 1: 정상 로그인 플로우
1. 앱 실행 → LoginViewController
2. "Initialize SDK" 버튼 탭
3. User ID 입력 (test_user_123)
4. "Login" 버튼 탭
5. 로그인 성공 → TabBarController 이동
6. "홈" 탭: SDK 기능 메뉴
7. "혜택" 탭: AdchainOfferwallView 표시

#### Flow 2: Skip Login (테스트 모드)
1. 앱 실행 → LoginViewController
2. "Skip Login" 버튼 탭
3. TabBarController 이동 (SDK 미초기화 상태)
4. "혜택" 탭: SDK 미초기화 오류 처리 확인
5. "홈" 탭에서 각 기능 테스트 시 오류 핸들링 확인

---

## 코드 패턴 및 베스트 프랙티스

### 1. SDK 초기화 패턴

```swift
// AppDelegate.swift
private let APP_KEY = "123456782"
private let APP_SECRET = "abcdefghigjk"

func initializeAdchainSdk() {
    let config = AdchainSdkConfig.Builder(appKey: APP_KEY, appSecret: APP_SECRET)
        .setEnvironment(.development)
        .setTimeout(30000)
        .build()

    AdchainSdk.shared.initialize(application: UIApplication.shared, sdkConfig: config)
}
```

**베스트 프랙티스**
- ✅ 앱 키와 시크릿을 상수로 분리
- ✅ Builder 패턴으로 설정 구성
- ✅ 타임아웃 명시적 설정 (30초)
- ⚠️ 프로덕션에서는 `.env` 파일 사용 권장

---

### 2. 사용자 로그인 패턴

```swift
func loginUser() {
    let user = AdchainSdkUser(
        userId: userIdTextField.text ?? "",
        gender: .male,
        birthYear: 1990
    )

    AdchainSdk.shared.login(adchainSdkUser: user, listener: self)
}

// AdchainSdkListener 구현
extension MainViewController: AdchainSdkListener {
    func onLoginSuccess(_ userId: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(title: "로그인 성공", message: "userId: \(userId)")
        }
    }

    func onLoginFailure(_ error: AdchainAdError) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(title: "로그인 실패", message: error.description)
        }
    }
}
```

**베스트 프랙티스**
- ✅ 콜백은 항상 메인 스레드에서 UI 업데이트
- ✅ `[weak self]` 사용으로 순환 참조 방지
- ✅ 에러 핸들링 명시적 처리

---

### 3. Quiz 로드 및 표시 패턴

```swift
func loadQuizEvents() {
    adchainQuiz = AdchainQuiz()
    adchainQuiz?.setQuizEventsListener(self)

    adchainQuiz?.load(
        onSuccess: { [weak self] response in
            guard let self = self else { return }

            if response.events.isEmpty {
                self.showEmptyState()
            } else {
                let limitedQuizzes = Array(response.events.prefix(3))
                self.showSuccessState(events: limitedQuizzes)
            }
        },
        onFailure: { [weak self] error in
            self?.showErrorState(error: error)
        }
    )
}
```

**베스트 프랙티스**
- ✅ Quiz 인스턴스를 프로퍼티로 유지 (이벤트 리스너 연결 유지)
- ✅ 빈 상태 처리 (UX 개선)
- ✅ 표시 개수 제한 (성능 최적화)

---

### 4. Mission 로드 및 표시 패턴

```swift
func loadMissionData() {
    adchainMission = AdchainMission()
    adchainMission?.eventsListener = self

    adchainMission?.load(
        onSuccess: { [weak self] missions, progress in
            guard let self = self else { return }

            self.missions = missions
            self.currentProgress = progress.current
            self.totalMissions = progress.total

            DispatchQueue.main.async {
                self.updateProgressLabel()
                self.tableView.reloadData()
            }
        },
        onFailure: { [weak self] error in
            self?.showErrorState(error: error)
        }
    )
}
```

**베스트 프랙티스**
- ✅ 진행 상황 (progress) 활용
- ✅ UI 업데이트는 메인 스레드에서
- ✅ 리프레시 로직 분리 (`onRefreshed` 콜백에서 재호출)

---

### 5. Offerwall 열기 패턴

```swift
@IBAction func openOfferwallButtonTapped(_ sender: UIButton) {
    AdchainSdk.shared.openOfferwall(
        presentingViewController: self,
        placementId: "adchain_hub"
    )
}
```

**Placement ID 명명 규칙**
```swift
"adchain_hub"                    // 메인 오퍼월
"mission_offerwall_promotion"    // 미션 프로모션 배너
"quiz_empty_banner"              // 퀴즈 빈 상태 배너
"mission_empty_banner"           // 미션 빈 상태 배너
```

**베스트 프랙티스**
- ✅ Placement ID는 화면/위치별로 고유하게 지정
- ✅ 명명 규칙 일관성 유지
- ✅ 분석 및 추적 가능성 확보

---

### 6. 배너 조회 패턴

```swift
func performBannerTest() {
    AdchainBanner.shared.getBanner(
        placementId: "banner_main",
        onSuccess: { [weak self] bannerResponse in
            guard let self = self else { return }

            DispatchQueue.main.async {
                // 링크 타입에 따라 URL 선택
                let linkUrl = bannerResponse.linkType == "external"
                    ? bannerResponse.externalLinkUrl
                    : bannerResponse.internalLinkUrl

                self.showBannerResult(
                    title: bannerResponse.titleText ?? "",
                    imageUrl: bannerResponse.imageUrl ?? "",
                    linkUrl: linkUrl
                )
            }
        },
        onFailure: { [weak self] error in
            self?.showErrorState(error: error)
        }
    )
}
```

**베스트 프랙티스**
- ✅ linkType 기반 분기 처리
- ✅ Optional 체이닝으로 안전한 접근
- ✅ 기본값 제공 (`??`)

---

## 향후 개선 방향

### 1. 에러 핸들링 개선

**현재**
```swift
onFailure: { error in
    print("Error: \(error)")
}
```

**제안**
```swift
onFailure: { [weak self] error in
    switch error {
    case .notInitialized:
        self?.showSDKNotInitializedAlert()
    case .networkError:
        self?.showNetworkErrorAlert(retry: true)
    case .unauthorized:
        self?.showLoginRequiredAlert()
    default:
        self?.showGenericError(error)
    }
}
```

---

### 2. 로딩 상태 표시

**제안**
```swift
func loadMissionData() {
    showLoadingIndicator()

    adchainMission?.load(
        onSuccess: { [weak self] missions, progress in
            self?.hideLoadingIndicator()
            // ...
        },
        onFailure: { [weak self] error in
            self?.hideLoadingIndicator()
            // ...
        }
    )
}
```

---

### 3. 메모리 관리 최적화

**제안**
```swift
class MissionViewController: UIViewController {
    private var adchainMission: AdchainMission?

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // 화면 이동 시 리소스 정리
        adchainMission?.eventsListener = nil
    }

    deinit {
        print("MissionViewController deallocated")
    }
}
```

---

### 4. 테스트 커버리지 추가

**제안**
```swift
// MissionViewControllerTests.swift
func testMissionLoad() {
    let mockMission = AdchainMission()
    let expectation = self.expectation(description: "Mission loaded")

    mockMission.load(
        onSuccess: { missions, progress in
            XCTAssertGreaterThan(missions.count, 0)
            expectation.fulfill()
        },
        onFailure: { error in
            XCTFail("Should not fail: \(error)")
        }
    )

    waitForExpectations(timeout: 5)
}
```

---

### 5. Analytics 통합

**제안**
```swift
extension MissionViewController: AdchainMissionEventsListener {
    func onClicked(_ mission: Mission) {
        // 기존 로직
        print("Mission clicked: \(mission.id)")

        // Analytics 이벤트 추가
        Analytics.logEvent("mission_clicked", parameters: [
            "mission_id": mission.id,
            "mission_title": mission.title,
            "user_id": AdchainSdk.shared.getCurrentUser()?.userId ?? ""
        ])
    }
}
```

---

## 부록

### A. 환경 변수 관리 (.env)

**프로덕션 권장 방식**
```swift
// Config.swift
struct Config {
    static let appKey = ProcessInfo.processInfo.environment["ADCHAIN_APP_KEY"] ?? ""
    static let appSecret = ProcessInfo.processInfo.environment["ADCHAIN_APP_SECRET"] ?? ""
}
```

**.gitignore 추가**
```
.env
.env.local
.env.production
```

---

### B. CI/CD 통합 예시

**GitHub Actions 워크플로우**
```yaml
name: Build and Test

on: [push, pull_request]

jobs:
  build:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2

      - name: Build
        run: |
          xcodebuild -project AdchainSDK-iOS-Sample.xcodeproj \
                     -scheme AdchainSDK-iOS-Sample \
                     -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
                     build

      - name: Test
        run: |
          xcodebuild test \
                     -project AdchainSDK-iOS-Sample.xcodeproj \
                     -scheme AdchainSDK-iOS-Sample \
                     -destination 'platform=iOS Simulator,name=iPhone 15 Pro'
```

---

### C. 참조 링크

- **SDK 소스 코드**: `../adchain-sdk-ios/`
- **GitHub Repository**: https://github.com/1selfworld-labs/adchain-sdk-ios-sample
- **SDK 문서**: https://github.com/1selfworld-labs/adchain-sdk-ios

---

## 변경 이력

| 날짜 | 버전 | 변경 내용 | 작성자 |
|------|------|-----------|--------|
| 2025-10-11 | 1.0.0 | 초기 마이그레이션 및 문서 작성 | Claude AI |
| 2025-10-30 | 1.0.1 | SDK v1.0.47 업데이트, Tab 기반 UI 구조로 전환, AdchainOfferwallView 통합, NestAds 지원 추가 | Claude AI |

---

**문서 유지보수 정책**
- SDK API 변경 시 즉시 업데이트
- 새로운 베스트 프랙티스 발견 시 추가
- 커뮤니티 피드백 반영

**문의 및 기여**
- Issues: [GitHub Issues](https://github.com/1selfworld-labs/adchain-sdk-ios-sample/issues)
- Pull Requests 환영

---

© 2025 AdChain SDK Team. All rights reserved.
