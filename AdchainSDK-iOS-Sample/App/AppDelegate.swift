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

    // SDK 초기화 함수 (외부에서 호출 가능)
    func initializeAdchainSdk() {
        print("\(TAG): Initializing Adchain SDK...")

        // Exact Android SDK initialization pattern
        let config = AdchainSdkConfig.Builder(appKey: APP_KEY, appSecret: APP_SECRET)
            .setEnvironment(.production)
            .build()

        // Fix: Use UIApplication.shared directly to avoid casting issues
        AdchainSdk.shared.initialize(application: UIApplication.shared, sdkConfig: config)

        print("\(TAG): Adchain SDK initialized successfully with App KEY: \(APP_KEY)")
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
