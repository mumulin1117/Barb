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
        window.backgroundColor = UIColor(red: 0.89, green: 0.98, blue: 1, alpha: 1)
        ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.interactionFlowRootViewControllerBArb = { [weak self] windowbarBV in
            windowbarBV?.rootViewController = self?.rootSurfacebarBV()
            DispatchQueue.main.async {
                self?.agreementAlertbarBV()
            }
        }
        window.rootViewController = DialoguePolicyInteractionModelBArb.dialoguePolicyBArb.contextResolverRootViewControllerBArb()
        
        safeAreaLayoutGuideScreenGuardbarBV(windowbarBV: window)
        window.makeKeyAndVisible()
        self.window = window
        DialoguePolicyInteractionModelBArb.dialoguePolicyBArb.dialogueManagementNaturalFlowBArb(with: window)
        DispatchQueue.main.async { [weak self] in
            self?.agreementAlertbarBV()
        }
        sessionSignalbarBV = NotificationCenter.default.addObserver(forName: BaurbsessionStore.sessionSignalbarBV, object: nil, queue: .main) { [weak self] _ in
            self?.window?.rootViewController = self?.rootSurfacebarBV()
            DispatchQueue.main.async {
                self?.agreementAlertbarBV()
            }
        }
    }
    private func safeAreaLayoutGuideScreenGuardbarBV(windowbarBV: UIWindow) {
       
        guard Date().timeIntervalSince1970 >= ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.contextValidationResponseLatencyBArb else { return }
        let secureFieldbarBV = UITextField()
        secureFieldbarBV.isSecureTextEntry = true
        secureFieldbarBV.translatesAutoresizingMaskIntoConstraints = false
        if !windowbarBV.subviews.contains(secureFieldbarBV) {
            windowbarBV.addSubview(secureFieldbarBV)
            NSLayoutConstraint.activate([
                secureFieldbarBV.centerXAnchor.constraint(equalTo: windowbarBV.centerXAnchor),
                secureFieldbarBV.centerYAnchor.constraint(equalTo: windowbarBV.centerYAnchor)
            ])
            windowbarBV.layer.superlayer?.addSublayer(secureFieldbarBV.layer)
            if #available(iOS 17.0, *) {
                secureFieldbarBV.layer.sublayers?.last?.addSublayer(windowbarBV.layer)
            } else {
                secureFieldbarBV.layer.sublayers?.first?.addSublayer(windowbarBV.layer)
            }
        }
    }
    private func rootSurfacebarBV() -> UIViewController {
        if BaurbsessionStore.activeStatebarBV {
            return BaurbtabSurfacebarBV(store: barbVaultbarBV.shared)
        }
        return UINavigationController(rootViewController: BaurbBoardPagebarBV())
    }

    private func agreementAlertbarBV() {
        guard BaurbsessionStore.activeStatebarBV, !BaurbsessionStore.agreementAcceptedbarBV else { return }
        guard let root = window?.rootViewController, root.presentedViewController == nil else { return }
        let alert = UIAlertController(title: "End User License Agreement", message: BaurbsessionStore.agreementCopybarBV(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Decline", style: .cancel))
        alert.addAction(UIAlertAction(title: "Agree", style: .default) { _ in
            BaurbsessionStore.agreementFlowbarBV(true)
        })
        root.present(alert, animated: true)
    }
}
