import UIKit
import AdchainSDK

class LoginViewController: UIViewController {

    private let TAG = "LoginViewController"
    private var isSdkInitialized = false

    // UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let cardView = UIView()
    private let loginTitleLabel = UILabel()
    private let initSdkButton = UIButton(type: .system)
    private let userIdTextField = UITextField()
    private let userIdErrorLabel = UILabel()
    private let loginButton = UIButton(type: .system)
    private let skipLoginButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Adchain SDK Sample"
        view.backgroundColor = .systemBackground

        setupUI()
        setupConstraints()
        setupListeners()

        // Set default test user ID like Android
        userIdTextField.text = "test_user_123"
    }

    private func setupUI() {
        // Scroll View
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        // Content View
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        // Title Label
        titleLabel.text = "Adchain SDK Sample"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        // Card View
        cardView.backgroundColor = .secondarySystemBackground
        cardView.layer.cornerRadius = 8
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        // Login Title Label
        loginTitleLabel.text = "SDK Initialization and Login"
        loginTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        loginTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(loginTitleLabel)

        // Initialize SDK Button
        initSdkButton.setTitle("Initialize SDK", for: .normal)
        initSdkButton.backgroundColor = .systemGray
        initSdkButton.setTitleColor(.white, for: .normal)
        initSdkButton.layer.cornerRadius = 6
        initSdkButton.layer.borderWidth = 1
        initSdkButton.layer.borderColor = UIColor.systemBlue.cgColor
        initSdkButton.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(initSdkButton)

        // User ID TextField
        userIdTextField.placeholder = "User ID"
        userIdTextField.borderStyle = .roundedRect
        userIdTextField.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(userIdTextField)

        // Error Label
        userIdErrorLabel.textColor = .systemRed
        userIdErrorLabel.font = .systemFont(ofSize: 14)
        userIdErrorLabel.isHidden = true
        userIdErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(userIdErrorLabel)

        // Login Button
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 6
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(loginButton)

        // Skip Login Button
        skipLoginButton.setTitle("Skip Login (Test without initialization)", for: .normal)
        skipLoginButton.setTitleColor(.systemBlue, for: .normal)
        skipLoginButton.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(skipLoginButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Title Label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Card View
            cardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            // Login Title Label
            loginTitleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            loginTitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),

            // Initialize SDK Button
            initSdkButton.topAnchor.constraint(equalTo: loginTitleLabel.bottomAnchor, constant: 16),
            initSdkButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            initSdkButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            initSdkButton.heightAnchor.constraint(equalToConstant: 44),

            // User ID TextField
            userIdTextField.topAnchor.constraint(equalTo: initSdkButton.bottomAnchor, constant: 16),
            userIdTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            userIdTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            userIdTextField.heightAnchor.constraint(equalToConstant: 44),

            // Error Label
            userIdErrorLabel.topAnchor.constraint(equalTo: userIdTextField.bottomAnchor, constant: 4),
            userIdErrorLabel.leadingAnchor.constraint(equalTo: userIdTextField.leadingAnchor),
            userIdErrorLabel.trailingAnchor.constraint(equalTo: userIdTextField.trailingAnchor),

            // Login Button
            loginButton.topAnchor.constraint(equalTo: userIdErrorLabel.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 44),

            // Skip Login Button
            skipLoginButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 8),
            skipLoginButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            skipLoginButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            skipLoginButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            skipLoginButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func setupListeners() {
        initSdkButton.addTarget(self, action: #selector(performSdkInitialization), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(performLogin), for: .touchUpInside)
        skipLoginButton.addTarget(self, action: #selector(performSkipLogin), for: .touchUpInside)
    }

    @objc private func performSdkInitialization() {
        if isSdkInitialized {
            showToast("SDK already initialized")
            return
        }

        print("\(TAG): Initializing SDK...")

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            showToast("Failed to get app delegate")
            return
        }

        // Initialize SDK
        appDelegate.initializeAdchainSdk()

        // Wait for SDK initialization
        let maxWaitTime = 5.0
        let pollInterval = 0.1
        var elapsedTime = 0.0

        Timer.scheduledTimer(withTimeInterval: pollInterval, repeats: true) { timer in
            elapsedTime += pollInterval

            if AdchainSdk.shared.isInitialized() {
                timer.invalidate()
                self.isSdkInitialized = true
                self.showToast("SDK initialized successfully")
                self.updateSDKButton()
                print("\(self.TAG): SDK initialized in \(elapsedTime)s")
            } else if elapsedTime >= maxWaitTime {
                timer.invalidate()
                self.showToast("SDK initialization timeout. Please check network.")
                print("\(self.TAG): SDK initialization timeout after \(maxWaitTime)s")
            }
        }
    }

    @objc private func performLogin() {
        guard let userId = userIdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !userId.isEmpty else {
            userIdErrorLabel.text = "Please enter a user ID"
            userIdErrorLabel.isHidden = false
            return
        }

        userIdErrorLabel.isHidden = true

        print("\(TAG): Attempting login with user ID: \(userId)")

        let user = AdchainSdkUser(
            userId: userId,
            gender: .male,
            birthYear: 1990
        )

        class LoginListenerImpl: NSObject, AdchainSdkLoginListener {
            weak var viewController: LoginViewController?

            init(viewController: LoginViewController) {
                self.viewController = viewController
            }

            func onSuccess() {
                guard let vc = viewController else { return }
                print("\(vc.TAG): Login successful")
                DispatchQueue.main.async {
                    vc.showToast("Login successful!")
                    vc.navigateToTabBar()
                }
            }

            func onFailure(_ error: AdchainLoginError) {
                guard let vc = viewController else { return }
                print("\(vc.TAG): Login failed: \(error)")

                let errorMessage = error.description

                DispatchQueue.main.async {
                    vc.showToast(errorMessage)
                }
            }
        }

        AdchainSdk.shared.login(adchainSdkUser: user, listener: LoginListenerImpl(viewController: self))
    }

    @objc private func performSkipLogin() {
        print("\(TAG): Skipping login for testing without SDK initialization")
        showToast("Test mode: SDK not initialized, testing graceful error handling")
        navigateToTabBar()
    }

    private func updateSDKButton() {
        initSdkButton.isEnabled = !isSdkInitialized
        initSdkButton.setTitle(isSdkInitialized ? "SDK Initialized ✓" : "Initialize SDK", for: .normal)
        initSdkButton.backgroundColor = isSdkInitialized ? .systemGreen : .systemGray
    }

    private func navigateToTabBar() {
        let tabBarVC = TabBarController()
        tabBarVC.modalPresentationStyle = .fullScreen

        if let window = view.window {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = tabBarVC
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
