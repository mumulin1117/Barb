import UIKit
import UserNotifications

extension DialoguePolicyInteractionModelBArb: UNUserNotificationCenterDelegate {
    func messageSuggestionInteractionFlowBArb() {
        guard !messageSuggestionPermissionStateBArb else { return }
        messageSuggestionPermissionStateBArb = true
        let messageSuggestionCenterBArb = UNUserNotificationCenter.current()
        messageSuggestionCenterBArb.delegate = self
        messageSuggestionCenterBArb.getNotificationSettings { [weak self] messageSuggestionSettingsBArb in
            switch messageSuggestionSettingsBArb.authorizationStatus {
            case .notDetermined:
                messageSuggestionCenterBArb.requestAuthorization(options: [.alert, .sound, .badge]) { contextValidationGrantedBArb, _ in
                    DispatchQueue.main.async {
                        if contextValidationGrantedBArb {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            case .authorized, .provisional, .ephemeral:
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            case .denied:
                break
            @unknown default:
                self?.messageSuggestionPermissionStateBArb = false
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
