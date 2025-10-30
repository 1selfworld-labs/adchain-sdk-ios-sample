import UIKit
import AdchainSDK

class HomeViewController: UIViewController {

    private let TAG = "HomeViewController"

    // UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let userInfoLabel = UILabel()
    private let featuresLabel = UILabel()
    private let nativeAdButton = UIButton(type: .system)
    private let missionButton = UIButton(type: .system)
    private let adchainHubButton = UIButton(type: .system)
    private let bannerButton = UIButton(type: .system)
    private let adjoeButton = UIButton(type: .system)
    private let nestAdsButton = UIButton(type: .system)
    private let appLaunchTestLabel = UILabel()
    private let appLaunchTextField = UITextField()
    private let appLaunchErrorLabel = UILabel()
    private let addTestButton = UIButton(type: .system)
    private let logoutButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Adchain SDK Sample"
        view.backgroundColor = .systemBackground

        setupUI()
        setupConstraints()
        setupListeners()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    private func setupUI() {
        // Scroll View
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        // Content View
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        // User Info Label
        userInfoLabel.font = .systemFont(ofSize: 16)
        userInfoLabel.numberOfLines = 0
        userInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(userInfoLabel)

        // Features Label
        featuresLabel.text = "SDK Features"
        featuresLabel.font = .systemFont(ofSize: 20, weight: .bold)
        featuresLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(featuresLabel)

        // Native Ad Button
        nativeAdButton.setTitle("Quiz Test", for: .normal)
        nativeAdButton.backgroundColor = .systemBlue
        nativeAdButton.setTitleColor(.white, for: .normal)
        nativeAdButton.layer.cornerRadius = 6
        nativeAdButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nativeAdButton)

        // Mission Button
        missionButton.setTitle("Mission System Test", for: .normal)
        missionButton.backgroundColor = .systemBlue
        missionButton.setTitleColor(.white, for: .normal)
        missionButton.layer.cornerRadius = 6
        missionButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(missionButton)

        // Adchain Hub Button
        adchainHubButton.setTitle("Adchain Hub Test", for: .normal)
        adchainHubButton.backgroundColor = .systemBlue
        adchainHubButton.setTitleColor(.white, for: .normal)
        adchainHubButton.layer.cornerRadius = 6
        adchainHubButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(adchainHubButton)

        // Banner Button
        bannerButton.setTitle("Banner Test", for: .normal)
        bannerButton.backgroundColor = .systemBlue
        bannerButton.setTitleColor(.white, for: .normal)
        bannerButton.layer.cornerRadius = 6
        bannerButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bannerButton)

        // Adjoe Button
        adjoeButton.setTitle("Adjoe Offerwall Test", for: .normal)
        adjoeButton.backgroundColor = .systemBlue
        adjoeButton.setTitleColor(.white, for: .normal)
        adjoeButton.layer.cornerRadius = 6
        adjoeButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(adjoeButton)

        // NestAds Button
        nestAdsButton.setTitle("NestAds Offerwall Test", for: .normal)
        nestAdsButton.backgroundColor = .systemGreen
        nestAdsButton.setTitleColor(.white, for: .normal)
        nestAdsButton.layer.cornerRadius = 6
        nestAdsButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nestAdsButton)

        // App Launch Test Label
        appLaunchTestLabel.text = "App Launch Test"
        appLaunchTestLabel.font = .systemFont(ofSize: 16, weight: .bold)
        appLaunchTestLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(appLaunchTestLabel)

        // App Launch TextField
        appLaunchTextField.placeholder = "URL Scheme (e.g., instagram://)"
        appLaunchTextField.borderStyle = .roundedRect
        appLaunchTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(appLaunchTextField)

        // App Launch Error Label
        appLaunchErrorLabel.textColor = .systemRed
        appLaunchErrorLabel.font = .systemFont(ofSize: 14)
        appLaunchErrorLabel.isHidden = true
        appLaunchErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(appLaunchErrorLabel)

        // Add Test Button
        addTestButton.setTitle("Add Test Button to Offerwall", for: .normal)
        addTestButton.layer.borderWidth = 1
        addTestButton.layer.borderColor = UIColor.systemBlue.cgColor
        addTestButton.layer.cornerRadius = 6
        addTestButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addTestButton)

        // Logout Button
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = UIColor.systemBlue.cgColor
        logoutButton.layer.cornerRadius = 6
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoutButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),

            // User Info Label
            userInfoLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            userInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            userInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            // Features Label
            featuresLabel.topAnchor.constraint(equalTo: userInfoLabel.bottomAnchor, constant: 16),
            featuresLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            // Native Ad Button
            nativeAdButton.topAnchor.constraint(equalTo: featuresLabel.bottomAnchor, constant: 16),
            nativeAdButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nativeAdButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nativeAdButton.heightAnchor.constraint(equalToConstant: 44),

            // Mission Button
            missionButton.topAnchor.constraint(equalTo: nativeAdButton.bottomAnchor, constant: 8),
            missionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            missionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            missionButton.heightAnchor.constraint(equalToConstant: 44),

            // Adchain Hub Button
            adchainHubButton.topAnchor.constraint(equalTo: missionButton.bottomAnchor, constant: 8),
            adchainHubButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            adchainHubButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            adchainHubButton.heightAnchor.constraint(equalToConstant: 44),

            // Banner Button
            bannerButton.topAnchor.constraint(equalTo: adchainHubButton.bottomAnchor, constant: 8),
            bannerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerButton.heightAnchor.constraint(equalToConstant: 44),

            // Adjoe Button
            adjoeButton.topAnchor.constraint(equalTo: bannerButton.bottomAnchor, constant: 8),
            adjoeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            adjoeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            adjoeButton.heightAnchor.constraint(equalToConstant: 44),

            // NestAds Button
            nestAdsButton.topAnchor.constraint(equalTo: adjoeButton.bottomAnchor, constant: 8),
            nestAdsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nestAdsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nestAdsButton.heightAnchor.constraint(equalToConstant: 44),

            // App Launch Test Label
            appLaunchTestLabel.topAnchor.constraint(equalTo: nestAdsButton.bottomAnchor, constant: 16),
            appLaunchTestLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            // App Launch TextField
            appLaunchTextField.topAnchor.constraint(equalTo: appLaunchTestLabel.bottomAnchor, constant: 12),
            appLaunchTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            appLaunchTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            appLaunchTextField.heightAnchor.constraint(equalToConstant: 44),

            // App Launch Error Label
            appLaunchErrorLabel.topAnchor.constraint(equalTo: appLaunchTextField.bottomAnchor, constant: 4),
            appLaunchErrorLabel.leadingAnchor.constraint(equalTo: appLaunchTextField.leadingAnchor),
            appLaunchErrorLabel.trailingAnchor.constraint(equalTo: appLaunchTextField.trailingAnchor),

            // Add Test Button
            addTestButton.topAnchor.constraint(equalTo: appLaunchErrorLabel.bottomAnchor, constant: 8),
            addTestButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            addTestButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            addTestButton.heightAnchor.constraint(equalToConstant: 44),

            // Logout Button
            logoutButton.topAnchor.constraint(equalTo: addTestButton.bottomAnchor, constant: 24),
            logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func setupListeners() {
        nativeAdButton.addTarget(self, action: #selector(openNativeAd), for: .touchUpInside)
        missionButton.addTarget(self, action: #selector(openMission), for: .touchUpInside)
        adchainHubButton.addTarget(self, action: #selector(openAdchainHub), for: .touchUpInside)
        bannerButton.addTarget(self, action: #selector(performBannerTest), for: .touchUpInside)
        adjoeButton.addTarget(self, action: #selector(performAdjoeTest), for: .touchUpInside)
        nestAdsButton.addTarget(self, action: #selector(performNestAdsTest), for: .touchUpInside)
        addTestButton.addTarget(self, action: #selector(performAddTestButton), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(performLogout), for: .touchUpInside)
    }

    private func updateUI() {
        let isLoggedIn = AdchainSdk.shared.isLoggedIn
        let currentUser = AdchainSdk.shared.getCurrentUser()

        userInfoLabel.text = if isLoggedIn && currentUser != nil {
            "✓ Logged in as: \(currentUser!.userId)"
        } else {
            "⚠️ Not logged in"
        }
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
        print("\(TAG): Opening Adchain Hub (Offerwall)")

        AdchainSdk.shared.openOfferwall(
            presentingViewController: self,
            placementId: "adchain_hub"
        )
    }

    @objc private func performBannerTest() {
        print("\(TAG): Starting Banner Test")

        AdchainBanner.shared.getBanner(
            placementId: "banner_test",
            onSuccess: { bannerResponse in
                print("\(self.TAG): Banner loaded successfully")

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

        class AdjoeCallbackImpl: NSObject, OfferwallCallback {
            weak var viewController: HomeViewController?

            init(viewController: HomeViewController) {
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

        AdchainSdk.shared.openAdjoeOfferwall(
            presentingViewController: self,
            placementId: "main_adjoe_test",
            callback: AdjoeCallbackImpl(viewController: self)
        )
    }

    @objc private func performNestAdsTest() {
        print("\(TAG): Starting NestAds Offerwall Test")

        class NestAdsCallbackImpl: NSObject, OfferwallCallback {
            weak var viewController: HomeViewController?

            init(viewController: HomeViewController) {
                self.viewController = viewController
            }

            func onOpened() {
                guard let vc = viewController else { return }
                print("\(vc.TAG): NestAds Offerwall opened successfully")
            }

            func onClosed() {
                guard let vc = viewController else { return }
                print("\(vc.TAG): NestAds Offerwall closed by user")
            }

            func onError(_ message: String) {
                guard let vc = viewController else { return }
                print("\(vc.TAG): NestAds Offerwall error: \(message)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "NestAds Error",
                        message: message,
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    vc.present(alert, animated: true)
                }
            }

            func onRewardEarned(_ amount: Int) {
                guard let vc = viewController else { return }
                print("\(vc.TAG): NestAds reward earned: \(amount)")
            }
        }

        AdchainSdk.shared.openOfferwallNestAds(
            presentingViewController: self,
            placementId: "c3c3fc08-2ba1-4243-93f7-f4d0d71c23a3",
            callback: NestAdsCallbackImpl(viewController: self)
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

        let testCode = """
window.AdchainBridge.checkAppInstalled('\(urlScheme)');
window.onAppInstalledResult = function(result) { alert('설치: ' + result.installed + '\\n식별자: ' + result.identifier); };
"""

        UIPasteboard.general.string = testCode

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

    @objc private func performLogout() {
        print("\(TAG): Performing logout")
        AdchainSdk.shared.logout()
        showToast("Logged out successfully")

        // Navigate back to LoginViewController
        if let window = view.window {
            let loginVC = LoginViewController()
            let navController = UINavigationController(rootViewController: loginVC)
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = navController
            }, completion: nil)
        }
    }

    private func showToast(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true)
        }
    }
}
