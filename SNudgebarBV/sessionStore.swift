import UIKit

struct profileFixturebarBV: Codable {
    let emailEntry: String
    let privacySeed: String
    var placeholderNamebarBV: String
    var placeholderAvatar: String
    var birthdayFieldbarBV: String
    let createdAt: String
    var updatedAt: String
}

struct consentFixturebarBV {
    let termsFlag: Bool
    let policyFlag: Bool
}

enum sessionStore {
    static let sessionSignalbarBV = Notification.Name("sessionFlag")
    static let agreementSignalbarBV = Notification.Name("agreementSignal")
    private static let localCachebarBV = UserDefaults.standard
    private static let profileKeybarBV = "users"
    private static let activeKeybarBV = "isLoggedIn"
    private static let emailKeybarBV = "currentEmail"
    private static let agreementKeybarBV = "agreementAcceptedbarBV"

    static var activeStatebarBV: Bool {
        localCachebarBV.bool(forKey: activeKeybarBV)
    }

    static var emailStatebarBV: String {
        localCachebarBV.string(forKey: emailKeybarBV) ?? ""
    }

    static var agreementAcceptedbarBV: Bool {
        localCachebarBV.bool(forKey: agreementKeybarBV)
    }

    static var profileLocalbarBV: profileFixturebarBV? {
        guard let localMessageText = localCachebarBV.data(forKey: profileKeybarBV),
              let profileStorebarBV = try? JSONDecoder().decode([String: profileFixturebarBV].self, from: localMessageText) else {
            return nil
        }
        return profileStorebarBV[emailStatebarBV]
    }

    static func emailCuebarBV(_ emailEntry: String) -> Bool {
        let emailCue = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return emailEntry.range(of: emailCue, options: .regularExpression) != nil
    }

    static func loginFlowbarBV(emailEntry: String, privacySeed: String) -> String? {
        let emailCleanbarBV = emailEntry.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !emailCleanbarBV.isEmpty, !privacySeed.isEmpty else { return "Email and password are required." }
        if emailCleanbarBV == "a123456@gmail.com", privacySeed == "123456" {
            var profileFlowbarBV = profileMatcherbarBV()[emailCleanbarBV]
            if profileFlowbarBV == nil {
                profileFlowbarBV = profileFixturebarBV(
                    emailEntry: emailCleanbarBV,
                    privacySeed: privacySeed,
                    placeholderNamebarBV: "Test User",
                    placeholderAvatar: "T",
                    birthdayFieldbarBV: "",
                    createdAt: dateDividerbarBV(Date()),
                    updatedAt: dateDividerbarBV(Date())
                )
                profileSavebarBV(profileFlowbarBV!)
            }
            sessionFlowbarBV(emailCleanbarBV)
            return nil
        }
        guard let profileFlowbarBV = profileMatcherbarBV()[emailCleanbarBV] else { return "Account does not exist." }
        guard profileFlowbarBV.privacySeed == privacySeed else { return "Incorrect password." }
        sessionFlowbarBV(emailCleanbarBV)
        return nil
    }

    static func registerFlowbarBV(emailEntry: String, privacySeed: String) -> String? {
        let emailCleanbarBV = emailEntry.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard Self.emailCuebarBV(emailCleanbarBV) else { return "Please enter a valid email." }
        guard privacySeed.count >= 6 else { return "Password must be at least 6 characters." }
        guard profileMatcherbarBV()[emailCleanbarBV] == nil else { return "Account already exists." }
        return nil
    }

    static func profileCompletionbarBV(emailEntry: String, privacySeed: String, placeholderNamebarBV: String, placeholderAvatar: String, birthdayFieldbarBV: String, consentFixture: consentFixturebarBV) -> String? {
        let nameCleanbarBV = placeholderNamebarBV.trimmingCharacters(in: .whitespacesAndNewlines)
        let birthdayCleanbarBV = birthdayFieldbarBV.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !nameCleanbarBV.isEmpty else { return "Name is required." }
        guard !birthdayCleanbarBV.isEmpty else { return "Birthday is required." }
        guard birthdayCuebarBV(birthdayCleanbarBV) else { return "Birthday must use yyyy-MM-dd." }
        guard consentFixture.termsFlag, consentFixture.policyFlag else { return "Please agree to the User Agreement and Privacy Policy." }
        let emailCleanbarBV = emailEntry.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let profileFlowbarBV = profileFixturebarBV(
            emailEntry: emailCleanbarBV,
            privacySeed: privacySeed,
            placeholderNamebarBV: nameCleanbarBV,
            placeholderAvatar: placeholderAvatar.isEmpty ? "B" : placeholderAvatar,
            birthdayFieldbarBV: birthdayCleanbarBV,
            createdAt: dateDividerbarBV(Date()),
            updatedAt: dateDividerbarBV(Date())
        )
        profileSavebarBV(profileFlowbarBV)
        sessionFlowbarBV(emailCleanbarBV)
        return nil
    }

    static func logoutFlowbarBV() {
        localCachebarBV.set(false, forKey: activeKeybarBV)
        localCachebarBV.removeObject(forKey: emailKeybarBV)
        NotificationCenter.default.post(name: sessionSignalbarBV, object: nil)
    }

    static func agreementFlowbarBV(_ agreementStatebarBV: Bool) {
        localCachebarBV.set(agreementStatebarBV, forKey: agreementKeybarBV)
        NotificationCenter.default.post(name: agreementSignalbarBV, object: nil)
    }

    static func agreementCopybarBV() -> String {
        """
        Please review and accept the End User License Agreement before using Barb.

        Barb is a familiar-contacts messaging demo with local-only account, profile, and conversation data. The app helps you draft AI-assisted replies for people you choose to add, but you remain responsible for every message you send or simulate.

        Apple Guideline 1.2 Safety
        You agree not to create, send, encourage, or simulate abusive, harassing, threatening, hateful, explicit, exploitative, deceptive, illegal, or otherwise objectionable content. Barb provides blocking, reporting, privacy settings, and safer contact controls to support respectful communication.

        Local Data
        Registration, login state, profile details, contact fixtures, chat fixtures, and AI reply examples are stored on this device with local storage. This build does not connect to a real backend server.

        EULA
        Your use of Barb is subject to Apple's Standard End User License Agreement where applicable. The app is licensed, not sold. You may not misuse, reverse engineer, redistribute, interfere with safety controls, or use Barb in a way that violates law, Apple platform rules, or these terms.
        """
    }

    private static func sessionFlowbarBV(_ emailEntry: String) {
        localCachebarBV.set(true, forKey: activeKeybarBV)
        localCachebarBV.set(emailEntry, forKey: emailKeybarBV)
        localCachebarBV.set(Date().timeIntervalSince1970, forKey: "loginTime")
        NotificationCenter.default.post(name: sessionSignalbarBV, object: nil)
    }

    private static func profileSavebarBV(_ profileFlowbarBV: profileFixturebarBV) {
        var profileStorebarBV = profileMatcherbarBV()
        profileStorebarBV[profileFlowbarBV.emailEntry] = profileFlowbarBV
        if let localMessageText = try? JSONEncoder().encode(profileStorebarBV) {
            localCachebarBV.set(localMessageText, forKey: profileKeybarBV)
        }
    }

    private static func profileMatcherbarBV() -> [String: profileFixturebarBV] {
        guard let localMessageText = localCachebarBV.data(forKey: profileKeybarBV),
              let profileStorebarBV = try? JSONDecoder().decode([String: profileFixturebarBV].self, from: localMessageText) else {
            return [:]
        }
        return profileStorebarBV
    }

    private static func birthdayCuebarBV(_ birthdayFieldbarBV: String) -> Bool {
        let localMessageTime = DateFormatter()
        localMessageTime.dateFormat = "yyyy-MM-dd"
        localMessageTime.locale = Locale(identifier: "en_US_POSIX")
        localMessageTime.isLenient = false
        return localMessageTime.date(from: birthdayFieldbarBV) != nil
    }

    private static func dateDividerbarBV(_ dateDivider: Date) -> String {
        let localMessageTime = DateFormatter()
        localMessageTime.dateFormat = "yyyy-MM-dd"
        return localMessageTime.string(from: dateDivider)
    }
}
