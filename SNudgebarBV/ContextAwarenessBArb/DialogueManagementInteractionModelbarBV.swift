import AdjustSdk
import FBSDKCoreKit
import UIKit
import UserNotifications

final class DialogueManagementInteractionModelbarBV: NSObject {
    static let shared = DialogueManagementInteractionModelbarBV()

    var configbarBV: ContextAwarenessSemanticLayerbarBV {
        ContextAwarenessSemanticLayerbarBV.shared
    }

    private override init() {
        super.init()
    }

    func interactionFlowFacebookBridgebarBV(
        applicationbarBV: UIApplication,
        launchOptionsbarBV: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        ApplicationDelegate.shared.application(applicationbarBV, didFinishLaunchingWithOptions: launchOptionsbarBV)
        ApplicationDelegate.shared.initializeSDK()
    }

    func contextResolverOpenURLbarBV(
        appbarBV: UIApplication,
        urlbarBV: URL,
        optionsbarBV: [UIApplication.OpenURLOptionsKey: Any]
    ) -> Bool {
        ApplicationDelegate.shared.application(appbarBV, open: urlbarBV, options: optionsbarBV)
    }

    func dialogueManagementBootstrapbarBV(with windowbarBV: UIWindow) {
        messageTelemetryLaunchbarBV()
//        safeAreaLayoutGuideScreenGuardbarBV(windowbarBV: windowbarBV)
        messageSuggestionNotificationbarBV()
    }

    func contextResolverSurfacebarBV() -> UIViewController {
        ContextResolverRootViewControllerbarBV()
    }

    func messageTelemetryPushTokenbarBV(deviceTokenbarBV: Data) {
        let tokenbarBV = deviceTokenbarBV.map { String(format: MessageSuggestionLexicalGraphbarBV.byteHexFormatbarBV, $0) }.joined()
        UserDefaults.standard.set(tokenbarBV, forKey: MessageSuggestionLexicalGraphbarBV.pushTokenCachebarBV)
    }

    private func messageTelemetryLaunchbarBV() {
        Adjust.addGlobalCallbackParameter(ContextCachingLexicalAnchorbarBV.contextCachingDeviceIdentifierbarBV(), forKey: MessageSuggestionLexicalGraphbarBV.adjustDistinctIDbarBV)
        guard let configbarBV = messageTelemetryConfigurationbarBV() else { return }
        Adjust.initSdk(configbarBV)
        Adjust.attribution { _ in
            let eventbarBV = ADJEvent(eventToken: ContextAwarenessSemanticLayerbarBV.shared.messageTelemetryLaunchTokenbarBV)
            Adjust.trackEvent(eventbarBV)
        }
        Adjust.adid { adIDbarBV in
            ContextAwarenessSemanticLayerbarBV.shared.messageTelemetryIdentifierbarBV = adIDbarBV
        }
    }

    private func messageTelemetryConfigurationbarBV() -> ADJConfig? {
        let configbarBV = ADJConfig(appToken: ContextAwarenessSemanticLayerbarBV.shared.messageTelemetryAppTokenbarBV, environment: ADJEnvironmentProduction)
        configbarBV?.logLevel = .verbose
        configbarBV?.delegate = self
        configbarBV?.enableSendingInBackground()
        return configbarBV
    }

    private func messageSuggestionNotificationbarBV() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { grantedbarBV, _ in
            DispatchQueue.main.async {
                if grantedbarBV {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

   
}

extension DialogueManagementInteractionModelbarBV: AdjustDelegate {}

extension DialogueManagementInteractionModelbarBV: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }
}
