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
        tabBar.tintColor = styleStorebarBV.purple
        tabBar.unselectedItemTintColor = .systemGray3
        tabBar.backgroundColor = .white
        viewControllers = [
            nav(homeSurfacebarBV(store: store), "Home", "house.fill"),
            nav(inboxSurfacebarBV(store: store), "Messages", "message.fill"),
            nav(contactSurfacebarBV(store: store), "Contacts", "person.crop.rectangle.stack.fill"),
            nav(profileSurfacebarBV(store: store), "Personal", "person.fill")
        ]
    }

    private func nav(_ controller: UIViewController, _ localThreadTitle: String, _ image: String) -> UIViewController {
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.prefersLargeTitles = false
        navigation.navigationBar.tintColor = .black
        navigation.tabBarItem = UITabBarItem(title: localThreadTitle, image: UIImage(systemName: image), selectedImage: nil)
        return navigation
    }
}
