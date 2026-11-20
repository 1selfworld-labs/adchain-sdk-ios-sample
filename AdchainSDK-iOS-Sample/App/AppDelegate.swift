import UIKit
import AdchainSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // EXACT Android Constants
    private let APP_KEY = "123456782"
    private let APP_SECRET = "abcdefghigjk"
    private let TAG = "AdchainSample"
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // SDK 초기화를 자동으로 하지 않음
        // MainViewController에서 선택적으로 초기화할 수 있도록 함
        print("\(TAG): Application created - SDK initialization skipped for testing")

        return true
    }

    // listener는 SDK가 강한 참조를 유지하지 않을 수 있으므로 프로퍼티로 보관
    private var initListener: SampleInitListener?

    // SDK 초기화 함수 (외부에서 호출 가능)
    // 권장 패턴: 초기화 성공(onSuccess) 이후에 login 호출
    // loginUser를 넘기면 onSuccess 안에서 login까지 수행, 넘기지 않으면 초기화만 수행
    func initializeAdchainSdk(loginUser: AdchainSdkUser? = nil) {
        print("\(TAG): Initializing Adchain SDK...")

        let config = AdchainSdkConfig.Builder(appKey: APP_KEY, appSecret: APP_SECRET)
            .setEnvironment(.staging)
            .build()

//        AdchainSdk.setLogLevel(.debug)
        let listener = SampleInitListener(tag: TAG, loginUser: loginUser)
        initListener = listener
        // Fix: Use UIApplication.shared directly to avoid casting issues
        AdchainSdk.shared.initialize(application: UIApplication.shared, sdkConfig: config, listener: listener)
    }

    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}


// SDK 초기화 결과 listener (콜백은 메인 스레드)
private final class SampleInitListener: NSObject, AdchainSdkInitListener {
    private let tag: String
    private let loginUser: AdchainSdkUser?

    init(tag: String, loginUser: AdchainSdkUser?) {
        self.tag = tag
        self.loginUser = loginUser
    }

    func onSuccess() {
        print("\(tag): Adchain SDK initialized successfully")
        guard let user = loginUser else { return }
        AdchainSdk.shared.login(adchainSdkUser: user, listener: SampleLoginListener(tag: tag))
    }

    func onFailure(_ error: AdchainInitError) {
        print("\(tag): Adchain SDK initialization failed: \(error.description)")
    }
}

private final class SampleLoginListener: NSObject, AdchainSdkLoginListener {
    private let tag: String

    init(tag: String) {
        self.tag = tag
    }

    func onSuccess() {
        print("\(tag): Login successful")
    }

    func onFailure(_ error: AdchainLoginError) {
        print("\(tag): Login failed: \(error.description)")
    }
}
