import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        DialogueManagementInteractionModelbarBV.shared.interactionFlowFacebookBridgebarBV(applicationbarBV: application, launchOptionsbarBV: launchOptions)
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
        DialogueManagementInteractionModelbarBV.shared.messageTelemetryPushTokenbarBV(deviceTokenbarBV: deviceToken)
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        DialogueManagementInteractionModelbarBV.shared.contextResolverOpenURLbarBV(appbarBV: app, urlbarBV: url, optionsbarBV: options)
    }
}
