import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        DialoguePolicyInteractionModelBArb.dialoguePolicyBArb.interactionFlowFacebookBridgeBArb(uiConfigurationApplicationBArb: application, naturalFlowOptionsBArb: launchOptions)
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        DialoguePolicyInteractionModelBArb.dialoguePolicyBArb.messageTelemetryContextCachingPushBArb(contextCachingDeviceTokenBArb: deviceToken)
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        DialoguePolicyInteractionModelBArb.dialoguePolicyBArb.contextResolverOpenURLBArb(uiConfigurationAppBArb: app, semanticNetworkLinkBArb: url, uiConfigurationOptionsBArb: options)
    }
}
