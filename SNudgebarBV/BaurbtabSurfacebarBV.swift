import UIKit

final class BaurbtabSurfacebarBV: UITabBarController {
    private let store: barbVaultbarBV

    init(store: barbVaultbarBV) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        store.reloadAccountScopebarBV()
        tabBar.tintColor = BaurbstyleStorebarBV.purple
        tabBar.unselectedItemTintColor = .systemGray3
        tabBar.backgroundColor = .white
        viewControllers = [
            nav(BaurbhomeSurfacebarBV(store: store),  "tabHomeIdlebarBV", "tabHomeSelectedbarBV"),
            nav(BaurbinboxSurfacebarBV(store: store),  "tabMessagesIdlebarBV", "tabMessagesSelectedbarBV"),
            nav(BaurbcontactSurfacebarBV(store: store),  "tabContactsIdlebarBV", "tabContactsSelectedbarBV"),
            nav(BaurbprofileSurfacebarBV(store: store),  "tabPersonalIdlebarBV", "tabPersonalSelectedbarBV")
        ]
    }

    private func nav(_ controller: UIViewController, _ imagebarBV: String, _ selectedImagebarBV: String) -> UIViewController {
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.prefersLargeTitles = false
        navigation.navigationBar.tintColor = .black
        navigation.tabBarItem = UITabBarItem(
            title: nil,
            image: tabIconbarBV(namebarBV: imagebarBV),
            selectedImage: tabIconbarBV(namebarBV: selectedImagebarBV)
        )
        return navigation
    }

    private func tabIconbarBV(namebarBV: String) -> UIImage? {
        UIImage(named: namebarBV)?.withRenderingMode(.alwaysOriginal)
    }
}
