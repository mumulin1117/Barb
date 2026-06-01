import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var sessionSignalbarBV: NSObjectProtocol?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = rootSurfacebarBV()
        window.makeKeyAndVisible()
        self.window = window
        DispatchQueue.main.async { [weak self] in
            self?.agreementAlertbarBV()
        }
        sessionSignalbarBV = NotificationCenter.default.addObserver(forName: sessionStore.sessionSignalbarBV, object: nil, queue: .main) { [weak self] _ in
            self?.window?.rootViewController = self?.rootSurfacebarBV()
            DispatchQueue.main.async {
                self?.agreementAlertbarBV()
            }
        }
    }

    private func rootSurfacebarBV() -> UIViewController {
        if sessionStore.activeStatebarBV {
            return tabSurfacebarBV(store: localStorebarBV.shared)
        }
        return UINavigationController(rootViewController: loginPagebarBV())
    }

    private func agreementAlertbarBV() {
        guard sessionStore.activeStatebarBV, !sessionStore.agreementAcceptedbarBV else { return }
        guard let root = window?.rootViewController, root.presentedViewController == nil else { return }
        let alert = UIAlertController(title: "End User License Agreement", message: sessionStore.agreementCopybarBV(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Decline", style: .cancel))
        alert.addAction(UIAlertAction(title: "Agree", style: .default) { _ in
            sessionStore.agreementFlowbarBV(true)
        })
        root.present(alert, animated: true)
    }
}
