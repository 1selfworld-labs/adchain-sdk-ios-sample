import UIKit
import AdchainSDK

class MainViewController: UIViewController {
    
    private let TAG = "MainActivity"
    
    // UI Components matching Android
    private let loginContainer = UIView()
    private let menuContainer = UIView()
    private let initSdkButton = UIButton(type: .system)
    private let userIdTextField = UITextField()
    private let userIdErrorLabel = UILabel()
    private let loginButton = UIButton(type: .system)
    private let skipLoginButton = UIButton(type: .system)
    private let logoutButton = UIButton(type: .system)
    private let userInfoLabel = UILabel()
    private var isSkipMode = false  // Track if user skipped login for testing
    private var isSdkInitialized = false  // Track SDK initialization status
    private let nativeAdButton = UIButton(type: .system)
    private let missionButton = UIButton(type: .system)
    private let adchainHubButton = UIButton(type: .system)
    private let bannerButton = UIButton(type: .system)
    private let adjoeButton = UIButton(type: .system)

    // App Launch Test
    private let appLaunchTestLabel = UILabel()
    private let appLaunchTextField = UITextField()
    private let appLaunchErrorLabel = UILabel()
    private let addTestButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Adchain SDK Sample"
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupConstraints()
        
        // Set default test user ID like Android
        userIdTextField.text = "test_user_123"
        
        setupListeners()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI() // Android: onResume()
    }
    
    private func setupUI() {
        // Configure login container
        loginContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginContainer)
        
        // Title label
        let titleLabel = UILabel()
        titleLabel.text = "Adchain SDK Sample"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        loginContainer.addSubview(titleLabel)
        
        // Card view for login
        let cardView = UIView()
        cardView.backgroundColor = .secondarySystemBackground
        cardView.layer.cornerRadius = 8
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        cardView.translatesAutoresizingMaskIntoConstraints = false
        loginContainer.addSubview(cardView)
        
        // User login label
        let userLoginLabel = UILabel()
        userLoginLabel.text = "SDK Initialization and Login"
        userLoginLabel.font = .systemFont(ofSize: 18, weight: .bold)
        userLoginLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(userLoginLabel)

        // Initialize SDK button
        initSdkButton.setTitle("Initialize SDK", for: .normal)
        initSdkButton.backgroundColor = .systemGray
        initSdkButton.setTitleColor(.white, for: .normal)
        initSdkButton.layer.cornerRadius = 6
        initSdkButton.layer.borderWidth = 1
        initSdkButton.layer.borderColor = UIColor.systemBlue.cgColor
        initSdkButton.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(initSdkButton)
        
        // User ID text field
        userIdTextField.placeholder = "User ID"
        userIdTextField.borderStyle = .roundedRect
        userIdTextField.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(userIdTextField)
        
        // Error label
        userIdErrorLabel.textColor = .systemRed
        userIdErrorLabel.font = .systemFont(ofSize: 14)
        userIdErrorLabel.isHidden = true
        userIdErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(userIdErrorLabel)
        
        // Login button
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 6
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(loginButton)

        // Skip Login button
        skipLoginButton.setTitle("Skip Login (Test without initialization)", for: .normal)
        skipLoginButton.setTitleColor(.systemBlue, for: .normal)
        skipLoginButton.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(skipLoginButton)
        
        // Configure menu container
        menuContainer.translatesAutoresizingMaskIntoConstraints = false
        menuContainer.isHidden = true
        view.addSubview(menuContainer)
        
        // User info label
        userInfoLabel.font = .systemFont(ofSize: 16)
        userInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        menuContainer.addSubview(userInfoLabel)
        
        // SDK Features label
        let featuresLabel = UILabel()
        featuresLabel.text = "SDK Features"
        featuresLabel.font = .systemFont(ofSize: 20, weight: .bold)
        featuresLabel.translatesAutoresizingMaskIntoConstraints = false
        menuContainer.addSubview(featuresLabel)
        
        // Native Ad button
        nativeAdButton.setTitle("Quiz Test", for: .normal)
        nativeAdButton.backgroundColor = .systemBlue
        nativeAdButton.setTitleColor(.white, for: .normal)
        nativeAdButton.layer.cornerRadius = 6
        nativeAdButton.translatesAutoresizingMaskIntoConstraints = false
        menuContainer.addSubview(nativeAdButton)
        
        // Mission button
        missionButton.setTitle("Mission System Test", for: .normal)
        missionButton.backgroundColor = .systemBlue
        missionButton.setTitleColor(.white, for: .normal)
        missionButton.layer.cornerRadius = 6
        missionButton.translatesAutoresizingMaskIntoConstraints = false
        menuContainer.addSubview(missionButton)
        
        // Adchain Hub button
        adchainHubButton.setTitle("Adchain Hub Test", for: .normal)
        adchainHubButton.backgroundColor = .systemBlue
        adchainHubButton.setTitleColor(.white, for: .normal)
        adchainHubButton.layer.cornerRadius = 6
        adchainHubButton.translatesAutoresizingMaskIntoConstraints = false
        menuContainer.addSubview(adchainHubButton)
        
        // Banner button
        bannerButton.setTitle("Banner Test", for: .normal)
        bannerButton.backgroundColor = .systemBlue
        bannerButton.setTitleColor(.white, for: .normal)
        bannerButton.layer.cornerRadius = 6
        bannerButton.translatesAutoresizingMaskIntoConstraints = false
        menuContainer.addSubview(bannerButton)

        // Adjoe button
        adjoeButton.setTitle("Adjoe Offerwall Test", for: .normal)
        adjoeButton.backgroundColor = .systemBlue
        adjoeButton.setTitleColor(.white, for: .normal)
        adjoeButton.layer.cornerRadius = 6
        adjoeButton.translatesAutoresizingMaskIntoConstraints = false
        menuContainer.addSubview(adjoeButton)

        // App Launch Test Section
        appLaunchTestLabel.text = "App Launch Test"
        appLaunchTestLabel.font = .systemFont(ofSize: 16, weight: .bold)
        appLaunchTestLabel.translatesAutoresizingMaskIntoConstraints = false
        menuContainer.addSubview(appLaunchTestLabel)

        // App Launch Text Field
        appLaunchTextField.placeholder = "URL Scheme (e.g., instagram://)"
        appLaunchTextField.borderStyle = .roundedRect
        appLaunchTextField.translatesAutoresizingMaskIntoConstraints = false
        menuContainer.addSubview(appLaunchTextField)

        // App Launch Error Label
        appLaunchErrorLabel.textColor = .systemRed
        appLaunchErrorLabel.font = .systemFont(ofSize: 14)
        appLaunchErrorLabel.isHidden = true
        appLaunchErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        menuContainer.addSubview(appLaunchErrorLabel)

        // Add Test Button
        addTestButton.setTitle("Add Test Button to Offerwall", for: .normal)
        addTestButton.layer.borderWidth = 1
        addTestButton.layer.borderColor = UIColor.systemBlue.cgColor
        addTestButton.layer.cornerRadius = 6
        addTestButton.translatesAutoresizingMaskIntoConstraints = false
        menuContainer.addSubview(addTestButton)

        // Logout button
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = UIColor.systemBlue.cgColor
        logoutButton.layer.cornerRadius = 6
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        menuContainer.addSubview(logoutButton)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Login container
            loginContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            loginContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Title label
            titleLabel.topAnchor.constraint(equalTo: loginContainer.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: loginContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: loginContainer.trailingAnchor),
            
            // Card view
            cardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            cardView.leadingAnchor.constraint(equalTo: loginContainer.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: loginContainer.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: loginContainer.bottomAnchor),
            
            // User login label
            userLoginLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            userLoginLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),

            // Initialize SDK button
            initSdkButton.topAnchor.constraint(equalTo: userLoginLabel.bottomAnchor, constant: 16),
            initSdkButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            initSdkButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            initSdkButton.heightAnchor.constraint(equalToConstant: 44),

            // User ID text field
            userIdTextField.topAnchor.constraint(equalTo: initSdkButton.bottomAnchor, constant: 16),
            userIdTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            userIdTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            userIdTextField.heightAnchor.constraint(equalToConstant: 44),

            // Error label
            userIdErrorLabel.topAnchor.constraint(equalTo: userIdTextField.bottomAnchor, constant: 4),
            userIdErrorLabel.leadingAnchor.constraint(equalTo: userIdTextField.leadingAnchor),
            userIdErrorLabel.trailingAnchor.constraint(equalTo: userIdTextField.trailingAnchor),

            // Login button
            loginButton.topAnchor.constraint(equalTo: userIdErrorLabel.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 44),

            // Skip Login button
            skipLoginButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 8),
            skipLoginButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            skipLoginButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            skipLoginButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            skipLoginButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Menu container
            menuContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            menuContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            menuContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // User info label
            userInfoLabel.topAnchor.constraint(equalTo: menuContainer.topAnchor),
            userInfoLabel.leadingAnchor.constraint(equalTo: menuContainer.leadingAnchor),
            
            // Features label
            featuresLabel.topAnchor.constraint(equalTo: userInfoLabel.bottomAnchor, constant: 16),
            featuresLabel.leadingAnchor.constraint(equalTo: menuContainer.leadingAnchor),
            
            // Native Ad button
            nativeAdButton.topAnchor.constraint(equalTo: featuresLabel.bottomAnchor, constant: 16),
            nativeAdButton.leadingAnchor.constraint(equalTo: menuContainer.leadingAnchor),
            nativeAdButton.trailingAnchor.constraint(equalTo: menuContainer.trailingAnchor),
            nativeAdButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Mission button
            missionButton.topAnchor.constraint(equalTo: nativeAdButton.bottomAnchor, constant: 8),
            missionButton.leadingAnchor.constraint(equalTo: menuContainer.leadingAnchor),
            missionButton.trailingAnchor.constraint(equalTo: menuContainer.trailingAnchor),
            missionButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Adchain Hub button
            adchainHubButton.topAnchor.constraint(equalTo: missionButton.bottomAnchor, constant: 8),
            adchainHubButton.leadingAnchor.constraint(equalTo: menuContainer.leadingAnchor),
            adchainHubButton.trailingAnchor.constraint(equalTo: menuContainer.trailingAnchor),
            adchainHubButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Banner button
            bannerButton.topAnchor.constraint(equalTo: adchainHubButton.bottomAnchor, constant: 8),
            bannerButton.leadingAnchor.constraint(equalTo: menuContainer.leadingAnchor),
            bannerButton.trailingAnchor.constraint(equalTo: menuContainer.trailingAnchor),
            bannerButton.heightAnchor.constraint(equalToConstant: 44),

            // Adjoe button
            adjoeButton.topAnchor.constraint(equalTo: bannerButton.bottomAnchor, constant: 8),
            adjoeButton.leadingAnchor.constraint(equalTo: menuContainer.leadingAnchor),
            adjoeButton.trailingAnchor.constraint(equalTo: menuContainer.trailingAnchor),
            adjoeButton.heightAnchor.constraint(equalToConstant: 44),

            // App Launch Test Label
            appLaunchTestLabel.topAnchor.constraint(equalTo: adjoeButton.bottomAnchor, constant: 16),
            appLaunchTestLabel.leadingAnchor.constraint(equalTo: menuContainer.leadingAnchor),

            // App Launch Text Field
            appLaunchTextField.topAnchor.constraint(equalTo: appLaunchTestLabel.bottomAnchor, constant: 12),
            appLaunchTextField.leadingAnchor.constraint(equalTo: menuContainer.leadingAnchor),
            appLaunchTextField.trailingAnchor.constraint(equalTo: menuContainer.trailingAnchor),
            appLaunchTextField.heightAnchor.constraint(equalToConstant: 44),

            // App Launch Error Label
            appLaunchErrorLabel.topAnchor.constraint(equalTo: appLaunchTextField.bottomAnchor, constant: 4),
            appLaunchErrorLabel.leadingAnchor.constraint(equalTo: appLaunchTextField.leadingAnchor),
            appLaunchErrorLabel.trailingAnchor.constraint(equalTo: appLaunchTextField.trailingAnchor),

            // Add Test Button
            addTestButton.topAnchor.constraint(equalTo: appLaunchErrorLabel.bottomAnchor, constant: 8),
            addTestButton.leadingAnchor.constraint(equalTo: menuContainer.leadingAnchor),
            addTestButton.trailingAnchor.constraint(equalTo: menuContainer.trailingAnchor),
            addTestButton.heightAnchor.constraint(equalToConstant: 44),

            // Logout button
            logoutButton.topAnchor.constraint(equalTo: addTestButton.bottomAnchor, constant: 24),
            logoutButton.leadingAnchor.constraint(equalTo: menuContainer.leadingAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: menuContainer.trailingAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: menuContainer.bottomAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    private func setupConstraints() {
        // Constraints are set in setupUI method
    }
    
    private func setupListeners() {
        initSdkButton.addTarget(self, action: #selector(performSdkInitialization), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(performLogin), for: .touchUpInside)
        skipLoginButton.addTarget(self, action: #selector(performSkipLogin), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(performLogout), for: .touchUpInside)
        nativeAdButton.addTarget(self, action: #selector(openNativeAd), for: .touchUpInside)
        missionButton.addTarget(self, action: #selector(openMission), for: .touchUpInside)
        adchainHubButton.addTarget(self, action: #selector(openAdchainHub), for: .touchUpInside)
        bannerButton.addTarget(self, action: #selector(performBannerTest), for: .touchUpInside)
        adjoeButton.addTarget(self, action: #selector(performAdjoeTest), for: .touchUpInside)
        addTestButton.addTarget(self, action: #selector(performAddTestButton), for: .touchUpInside)
    }
    
    @objc private func performSdkInitialization() {
        if isSdkInitialized {
            showToast("SDK already initialized")
            return
        }

        print("\(TAG): Initializing SDK...")
        do {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                showToast("Failed to get app delegate")
                return
            }

            appDelegate.initializeAdchainSdk()
            isSdkInitialized = true
            showToast("SDK initialized successfully")
            updateUI()
        } catch {
            print("\(TAG): SDK initialization failed: \(error)")
            showToast("SDK initialization failed: \(error.localizedDescription)")
        }
    }

    @objc private func performSkipLogin() {
        print("\(TAG): Skipping login for testing without SDK initialization")
        isSkipMode = true
        showToast("Test mode: SDK not initialized, testing graceful error handling")
        updateUI()
    }

    @objc private func performLogin() {
        // EXACT Android login implementation
        guard let userId = userIdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !userId.isEmpty else {
            userIdErrorLabel.text = "Please enter a user ID"
            userIdErrorLabel.isHidden = false
            return
        }

        userIdErrorLabel.isHidden = true
        
        print("\(TAG): Attempting login with user ID: \(userId)")
        
        // EXACT Android user creation pattern
        let user = AdchainSdkUser(
            userId: userId,
            gender: .male, // Android: AdchainSdkUser.Gender.MALE
            birthYear: 1990
        )
        
        // EXACT Android login listener implementation
        class LoginListenerImpl: NSObject, AdchainSdkLoginListener {
            weak var viewController: MainViewController?
            
            init(viewController: MainViewController) {
                self.viewController = viewController
            }
            
            func onSuccess() {
                guard let vc = viewController else { return }
                print("\(vc.TAG): Login successful")
                DispatchQueue.main.async {
                    vc.showToast("Login successful!")
                    vc.updateUI()
                }
            }
            
            func onFailure(_ error: AdchainLoginError) {
                guard let vc = viewController else { return }
                print("\(vc.TAG): Login failed: \(error)")
                
                // EXACT Android error mapping
                let errorMessage = error.description
                
                DispatchQueue.main.async {
                    vc.showToast(errorMessage)
                }
            }
        }
        
        AdchainSdk.shared.login(adchainSdkUser: user, listener: LoginListenerImpl(viewController: self))
    }
    
    @objc private func performLogout() {
        print("\(TAG): Performing logout")

        AdchainSdk.shared.logout()
        isSkipMode = false
        showToast("Logged out successfully")
        updateUI()
    }
    
    @objc private func openNativeAd() {
        let nativeAdVC = NativeAdViewController()
        navigationController?.pushViewController(nativeAdVC, animated: true)
    }
    
    @objc private func openMission() {
        let missionVC = MissionViewController()
        navigationController?.pushViewController(missionVC, animated: true)
    }
    
    @objc private func openAdchainHub() {
        // EXACT Android offerwall opening with callback
        print("\(TAG): Opening Adchain Hub (Offerwall)")

        AdchainSdk.shared.openOfferwall(
            presentingViewController: self,
            placementId: "adchain_hub"
        )
    }
    
    @objc private func performBannerTest() {
        print("\(TAG): Starting Banner Test")

        // SDK의 Banner API 호출
        AdchainBanner.shared.getBanner(
            placementId: "banner_test",  // Banner test placement ID
            onSuccess: { bannerResponse in
                print("\(self.TAG): Banner loaded successfully")

                // 팝업으로 Banner 데이터 표시
                let linkUrl = bannerResponse.linkType == "external"
                    ? bannerResponse.externalLinkUrl
                    : bannerResponse.internalLinkUrl

                let message = """
                Banner Data Received:

                Title: \(bannerResponse.titleText ?? "")
                Image URL: \(bannerResponse.imageUrl ?? "")
                Link Type: \(bannerResponse.linkType ?? "")
                Link URL: \(linkUrl ?? "")
                """

                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Banner Test Result",
                        message: message,
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            },
            onFailure: { error in
                print("\(self.TAG): Banner load failed: \(error)")

                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Banner Test Failed",
                        message: "Error: \(error)",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        )
    }

    @objc private func performAdjoeTest() {
        print("\(TAG): Starting Adjoe Offerwall Test")

        // Adjoe Offerwall Callback implementation (matching Android)
        class AdjoeCallbackImpl: NSObject, OfferwallCallback {
            weak var viewController: MainViewController?

            init(viewController: MainViewController) {
                self.viewController = viewController
            }

            func onOpened() {
                guard let vc = viewController else { return }
                print("\(vc.TAG): Adjoe Offerwall opened successfully")
            }

            func onClosed() {
                guard let vc = viewController else { return }
                print("\(vc.TAG): Adjoe Offerwall closed by user")
            }

            func onError(_ message: String) {
                guard let vc = viewController else { return }
                print("\(vc.TAG): Adjoe Offerwall error: \(message)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Adjoe Error",
                        message: message,
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    vc.present(alert, animated: true)
                }
            }

            func onRewardEarned(_ amount: Int) {
                guard let vc = viewController else { return }
                print("\(vc.TAG): Adjoe reward earned: \(amount)")
            }
        }

        // SDK의 Adjoe API 호출 (Android와 동일한 콜백 포함)
        AdchainSdk.shared.openAdjoeOfferwall(
            presentingViewController: self,
            placementId: "main_adjoe_test",
            callback: AdjoeCallbackImpl(viewController: self)
        )
    }

    @objc private func performAddTestButton() {
        guard let urlScheme = appLaunchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !urlScheme.isEmpty else {
            appLaunchErrorLabel.text = "URL Scheme을 입력하세요 (예: instagram://)"
            appLaunchErrorLabel.isHidden = false
            return
        }

        appLaunchErrorLabel.isHidden = true
        print("\(TAG): Preparing app launch test for URL scheme: \(urlScheme)")

        // 테스트 코드를 클립보드에 복사
        let testCode = """
window.AdchainBridge.checkAppInstalled('\(urlScheme)');
window.onAppInstalledResult = function(result) { alert('설치: ' + result.installed + '\\n식별자: ' + result.identifier); };
"""

        UIPasteboard.general.string = testCode

        // 안내 다이얼로그 표시
        let alert = UIAlertController(
            title: "앱 실행 테스트 방법",
            message: """
            테스트 코드가 클립보드에 복사되었습니다!

            테스트 방법:
            1. "Adchain Hub Test" 버튼을 눌러 Offerwall를 엽니다
            2. Safari Web Inspector로 콘솔을 엽니다
            3. 복사된 코드를 콘솔에 붙여넣고 실행합니다

            테스트 URL Scheme: \(urlScheme)

            또는 아래 버튼을 눌러 Offerwall를 바로 열 수 있습니다.
            """,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Offerwall 열기", style: .default) { [weak self] _ in
            guard let self = self else { return }
            AdchainSdk.shared.openOfferwall(
                presentingViewController: self,
                placementId: "app_launch_test"
            )
            self.showToast("콘솔에서 테스트 코드를 실행하세요")
        })

        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }

    private func updateUI() {
        let isLoggedIn = AdchainSdk.shared.isLoggedIn

        // Update SDK init button state
        initSdkButton.isEnabled = !isSdkInitialized
        initSdkButton.setTitle(isSdkInitialized ? "SDK Initialized ✓" : "Initialize SDK", for: .normal)
        initSdkButton.backgroundColor = isSdkInitialized ? .systemGreen : .systemGray

        switch (isSkipMode, isLoggedIn) {
        case (true, _):  // Skip mode
            loginContainer.isHidden = true
            menuContainer.isHidden = false
            userInfoLabel.text = "⚠️ Test Mode: SDK Not Initialized\nTesting graceful error handling"
            userInfoLabel.numberOfLines = 0

        case (false, true):  // Logged in
            loginContainer.isHidden = true
            menuContainer.isHidden = false
            userInfoLabel.text = "✓ Logged in as: \(AdchainSdk.shared.getCurrentUser()?.userId ?? "Unknown")"
            userInfoLabel.numberOfLines = 1

        case (false, false):  // Show login
            loginContainer.isHidden = false
            menuContainer.isHidden = true
            userIdTextField.text = ""
        }
    }
    
    private func showToast(_ message: String) {
        // iOS Toast implementation
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true)
        }
    }
}
