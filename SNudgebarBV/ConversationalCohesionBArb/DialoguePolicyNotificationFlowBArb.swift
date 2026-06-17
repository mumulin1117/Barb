import UIKit
import UserNotifications

extension DialoguePolicyInteractionModelBArb: UNUserNotificationCenterDelegate {
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
