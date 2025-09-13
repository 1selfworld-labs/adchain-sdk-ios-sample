import UIKit
import AdchainSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // EXACT Android Constants
    private let APP_KEY = "100000002"
    private let APP_SECRET = "3ANgfF9Zfbm79oa6"
    private let TAG = "AdchainSample"
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("\(TAG): Initializing Adchain SDK...")
        
        // Exact Android SDK initialization pattern
        let config = AdchainSdkConfig.Builder(appKey: APP_KEY, appSecret: APP_SECRET)
            .setEnvironment(.development) // Android: AdchainSdkConfig.Environment.DEVELOPMENT
            .setTimeout(30000) // Android: 30000L (30 seconds)
            .build()
        
        AdchainSdk.shared.initialize(application: application, sdkConfig: config)
        
        print("\(TAG): Adchain SDK initialized successfully with App KEY: \(APP_KEY)")
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
