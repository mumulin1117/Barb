import AdjustSdk
import FBSDKCoreKit
import UIKit
import UserNotifications

final class DialoguePolicyInteractionModelBArb: NSObject {
    static let dialoguePolicyBArb = DialoguePolicyInteractionModelBArb()

    var uiConfigurationBArb: ConversationalCohesionSemanticLayerBArb {
        ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb
    }

    private override init() {
        super.init()
    }

    func interactionFlowFacebookBridgeBArb(
        uiConfigurationApplicationBArb: UIApplication,
        naturalFlowOptionsBArb: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        ApplicationDelegate.shared.application(uiConfigurationApplicationBArb, didFinishLaunchingWithOptions: naturalFlowOptionsBArb)
        ApplicationDelegate.shared.initializeSDK()
    }

    func contextResolverOpenURLBArb(
        uiConfigurationAppBArb: UIApplication,
        semanticNetworkLinkBArb: URL,
        uiConfigurationOptionsBArb: [UIApplication.OpenURLOptionsKey: Any]
    ) -> Bool {
        ApplicationDelegate.shared.application(uiConfigurationAppBArb, open: semanticNetworkLinkBArb, options: uiConfigurationOptionsBArb)
    }

    func dialogueManagementNaturalFlowBArb(with uiWindowSurfaceBArb: UIWindow) {
        messageTelemetryNaturalFlowLaunchBArb()
//        safeAreaLayoutGuideScreenGuardBArb(uiWindowSurfaceBArb: uiWindowSurfaceBArb)
    }

    func contextResolverRootViewControllerBArb() -> UIViewController {
        ContextEngineRootViewControllerBArb()
    }

    func messageTelemetryContextCachingPushBArb(contextCachingDeviceTokenBArb: Data) {
        let lexicalAnchorTokenBArb = contextCachingDeviceTokenBArb.map { String(format: ReplySuggestionLexicalGraphBArb.textFormattingLexicalAnchorBArb, $0) }.joined()
        UserDefaults.standard.set(lexicalAnchorTokenBArb, forKey: ReplySuggestionLexicalGraphBArb.messageTelemetryContextCachingGraphBArb)
    }

    private func messageTelemetryNaturalFlowLaunchBArb() {
        Adjust.addGlobalCallbackParameter(ContextRetentionLexicalAnchorBArb.contextCachingDeviceIdentifierBArb(), forKey: ReplySuggestionLexicalGraphBArb.messageTelemetryLexicalDiversityBArb)
        guard let uiConfigurationBArb = messageTelemetryUIConfigurationBArb() else { return }
        Adjust.initSdk(uiConfigurationBArb)
        Adjust.attribution { _ in
            let messageTelemetryInteractionModelBArb = ADJEvent(eventToken: ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.messageTelemetryNaturalFlowBArb)
            Adjust.trackEvent(messageTelemetryInteractionModelBArb)
        }
        Adjust.adid { messageTelemetryLexicalAnchorValueBArb in
            ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.messageTelemetryLexicalAnchorBArb = messageTelemetryLexicalAnchorValueBArb
        }
    }

    private func messageTelemetryUIConfigurationBArb() -> ADJConfig? {
        let uiConfigurationBArb = ADJConfig(appToken: ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.messageTelemetryLexicalGraphBArb, environment: ADJEnvironmentProduction)
        uiConfigurationBArb?.logLevel = .verbose
        uiConfigurationBArb?.delegate = self
        uiConfigurationBArb?.enableSendingInBackground()
        return uiConfigurationBArb
    }

    func messageSuggestionInteractionFlowBArb() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { contextValidationGrantedBArb, _ in
            DispatchQueue.main.async {
                if contextValidationGrantedBArb {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

   
}

extension DialoguePolicyInteractionModelBArb: AdjustDelegate {}

extension DialoguePolicyInteractionModelBArb: UNUserNotificationCenterDelegate {
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
