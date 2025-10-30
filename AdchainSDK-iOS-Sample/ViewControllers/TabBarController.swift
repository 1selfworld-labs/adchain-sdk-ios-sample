import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
    }

    private func setupTabBar() {
        // Home Tab
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house"),
            tag: 0
        )
        let homeNav = UINavigationController(rootViewController: homeVC)

        // Benefits Tab
        let benefitsVC = BenefitsViewController()
        benefitsVC.tabBarItem = UITabBarItem(
            title: "혜택",
            image: UIImage(systemName: "gift"),
            tag: 1
        )

        viewControllers = [homeNav, benefitsVC]

        // Tab bar appearance (matching Android #007AFF blue)
        tabBar.tintColor = UIColor(red: 0, green: 0.48, blue: 1.0, alpha: 1.0) // #007AFF
        tabBar.unselectedItemTintColor = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1.0) // #8E8E93
        tabBar.backgroundColor = .systemBackground
    }
}
