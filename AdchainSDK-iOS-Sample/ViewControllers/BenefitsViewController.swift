import UIKit
import AdchainSDK

class BenefitsViewController: UIViewController {

    private let TAG = "BenefitsViewController"
    private let PLACEMENT_ID = "sample-test-ios-placement"

    private var offerwallView: AdchainOfferwallView?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupOfferwallView()
        loadOfferwall()
    }

    private func setupOfferwallView() {
        let offerwallView = AdchainOfferwallView()
        offerwallView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(offerwallView)
        self.offerwallView = offerwallView

        // Use SafeArea layout guide for proper tab bar and status bar handling
        NSLayoutConstraint.activate([
            offerwallView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            offerwallView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            offerwallView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            offerwallView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        // Set callbacks
        class OfferwallCallbackImpl: NSObject, OfferwallCallback {
            weak var viewController: BenefitsViewController?

            init(viewController: BenefitsViewController) {
                self.viewController = viewController
            }

            func onOpened() {
                print("Offerwall opened in benefits tab")
            }

            func onClosed() {
                print("Offerwall closed in benefits tab")
            }

            func onError(_ message: String) {
                print("Offerwall error: \(message)")
                guard let vc = viewController else { return }
                DispatchQueue.main.async {
                    vc.showToast("Offerwall error: \(message)")
                }
            }

            func onRewardEarned(_ amount: Int) {
                print("Reward earned: \(amount)")
                guard let vc = viewController else { return }
                DispatchQueue.main.async {
                    vc.showToast("Reward earned: \(amount) points!")
                }
            }
        }

        offerwallView.setCallback(OfferwallCallbackImpl(viewController: self))

        // Set event callback (SDK v1.0.47+)
        class EventCallbackImpl: NSObject, OfferwallEventCallback {
            weak var viewController: BenefitsViewController?

            init(viewController: BenefitsViewController) {
                self.viewController = viewController
            }

            func onCustomEvent(eventType: String, payload: [String: Any]) {
                print("[WebView → App] Custom Event: \(eventType), payload: \(payload)")

                guard let vc = viewController else { return }

                DispatchQueue.main.async {
                    switch eventType {
                    case "show_toast":
                        let message = payload["message"] as? String ?? "No message"
                        vc.showToast("🎉 WebView Message: \(message)")
                    case "navigate":
                        let screen = payload["screen"] as? String ?? "unknown"
                        vc.showToast("🧭 Navigate to: \(screen)")
                    case "share":
                        let title = payload["title"] as? String ?? ""
                        let url = payload["url"] as? String ?? ""
                        vc.showToast("📤 Share: \(title)")
                    case "buy_ticket":
                        let ticketId = payload["ticketId"] as? String ?? "N/A"
                        vc.showToast("🎫 Ticket: \(ticketId)")
                    case "show_ticket_list":
                        let userId = payload["userId"] as? String ?? "N/A"
                        vc.showToast("📋 Ticket List: \(userId)")
                    default:
                        vc.showToast("📨 Event: \(eventType)")
                    }
                }
            }

            func onDataRequest(requestId: String, requestType: String, params: [String: Any]) -> [String: Any]? {
                print("[WebView → App] Data Request: id=\(requestId), type=\(requestType), params=\(params)")

                // Return data based on request type
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
        }

        offerwallView.setEventCallback(EventCallbackImpl(viewController: self))
    }

    private func loadOfferwall() {
        guard AdchainSdk.shared.getConfig() != nil,
              AdchainSdk.shared.getCurrentUser() != nil else {
            print("\(TAG): SDK not initialized or user not logged in")
            showToast("Please login first")
            return
        }

        print("\(TAG): Loading offerwall with placementId: \(PLACEMENT_ID)")
        offerwallView?.loadOfferwall(placementId: PLACEMENT_ID)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Cleanup if needed
    }

    private func showToast(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true)
        }
    }
}
