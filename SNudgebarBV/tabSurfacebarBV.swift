import UIKit

final class tabSurfacebarBV: UITabBarController {
    private let store: localStorebarBV

    init(store: localStorebarBV) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        store.reloadAccountScopebarBV()
        tabBar.tintColor = styleStorebarBV.purple
        tabBar.unselectedItemTintColor = .systemGray3
        tabBar.backgroundColor = .white
        viewControllers = [
            nav(homeSurfacebarBV(store: store),  "tabHomeIdlebarBV", "tabHomeSelectedbarBV"),
            nav(inboxSurfacebarBV(store: store),  "tabMessagesIdlebarBV", "tabMessagesSelectedbarBV"),
            nav(contactSurfacebarBV(store: store),  "tabContactsIdlebarBV", "tabContactsSelectedbarBV"),
            nav(profileSurfacebarBV(store: store),  "tabPersonalIdlebarBV", "tabPersonalSelectedbarBV")
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
