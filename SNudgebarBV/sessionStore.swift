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
    private static let barbCachebarBV = UserDefaults.standard
    private static let profileKeybarBV = "users"
    private static let activeKeybarBV = "isLoggedIn"
    private static let emailKeybarBV = "currentEmail"
    private static let agreementKeybarBV = "agreementAcceptedbarBV"

    static var activeStatebarBV: Bool {
        barbCachebarBV.bool(forKey: activeKeybarBV)
    }

    static var emailStatebarBV: String {
        barbCachebarBV.string(forKey: emailKeybarBV) ?? ""
    }

    static var agreementAcceptedbarBV: Bool {
        barbCachebarBV.bool(forKey: agreementKeybarBV)
    }

    static var profileSnapshotbarBV: profileFixturebarBV? {
        guard let messageCopybarBV = barbCachebarBV.data(forKey: profileKeybarBV),
              let profileStorebarBV = try? JSONDecoder().decode([String: profileFixturebarBV].self, from: messageCopybarBV) else {
            return nil
        }
        return profileStorebarBV[emailStatebarBV]
    }

    static var seedAccountFlagbarBV: Bool {
        emailStatebarBV.lowercased() == "a123456@gmail.com"
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
                    placeholderNamebarBV: "Mia Tanaka",
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
        barbCachebarBV.set(false, forKey: activeKeybarBV)
        barbCachebarBV.removeObject(forKey: emailKeybarBV)
        NotificationCenter.default.post(name: sessionSignalbarBV, object: nil)
    }

    static func deleteAccountSnapshotbarBV() {
        let currentEmailbarBV = emailStatebarBV
        if !currentEmailbarBV.isEmpty {
            var profileStorebarBV = profileMatcherbarBV()
            profileStorebarBV.removeValue(forKey: currentEmailbarBV)
            if let messageCopybarBV = try? JSONEncoder().encode(profileStorebarBV) {
                barbCachebarBV.set(messageCopybarBV, forKey: profileKeybarBV)
            }
        }
        barbCachebarBV.set(false, forKey: activeKeybarBV)
        barbCachebarBV.removeObject(forKey: emailKeybarBV)
        barbCachebarBV.removeObject(forKey: "loginTime")
        NotificationCenter.default.post(name: sessionSignalbarBV, object: nil)
    }

    static func agreementFlowbarBV(_ agreementStatebarBV: Bool) {
        barbCachebarBV.set(agreementStatebarBV, forKey: agreementKeybarBV)
        NotificationCenter.default.post(name: agreementSignalbarBV, object: nil)
    }

    static func agreementCopybarBV() -> String {
        """
        Please review and accept the End User License Agreement before using Barb.

        Barb is a familiar-contacts messaging experience with AI-assisted reply tools. It is designed for one-on-one chats, small group conversations, contact controls, privacy settings, reporting, blocking, and optional coin-based AI tone features. You choose the people you add, and you remain responsible for every message you write, edit, generate, or send.

        Safety and User Content
        Barb follows Apple's user-generated content safety expectations. Do not create, send, request, encourage, or distribute abusive, harassing, threatening, hateful, sexually explicit, exploitative, deceptive, illegal, spam, scam, self-harm, or otherwise objectionable content. Do not impersonate others, target minors, bypass safety controls, or use AI suggestions to pressure, deceive, or harm another person. Barb provides reporting, blocking, and safer contact controls to support respectful everyday communication.

        Privacy and Device Data
        Barb keeps your account state, profile, selected contacts, conversations, settings, safety actions, and wallet state on this device unless a feature clearly asks you to use Apple purchase services or share content through iOS. You can manage privacy settings, blocked contacts, and account state inside the app.

        EULA
        Your use of Barb is subject to Apple's Standard End User License Agreement where applicable. The app is licensed, not sold. You may not misuse, reverse engineer, redistribute, interfere with safety controls, disrupt the app, violate Apple platform rules, or use Barb in a way that violates law or these terms.

        By tapping Agree, you confirm that you understand these terms and will use Barb responsibly.
        """
    }

    private static func sessionFlowbarBV(_ emailEntry: String) {
        barbCachebarBV.set(true, forKey: activeKeybarBV)
        barbCachebarBV.set(emailEntry, forKey: emailKeybarBV)
        barbCachebarBV.set(Date().timeIntervalSince1970, forKey: "loginTime")
        NotificationCenter.default.post(name: sessionSignalbarBV, object: nil)
    }

    private static func profileSavebarBV(_ profileFlowbarBV: profileFixturebarBV) {
        var profileStorebarBV = profileMatcherbarBV()
        profileStorebarBV[profileFlowbarBV.emailEntry] = profileFlowbarBV
        if let messageCopybarBV = try? JSONEncoder().encode(profileStorebarBV) {
            barbCachebarBV.set(messageCopybarBV, forKey: profileKeybarBV)
        }
    }

    private static func profileMatcherbarBV() -> [String: profileFixturebarBV] {
        guard let messageCopybarBV = barbCachebarBV.data(forKey: profileKeybarBV),
              let profileStorebarBV = try? JSONDecoder().decode([String: profileFixturebarBV].self, from: messageCopybarBV) else {
            return [:]
        }
        return profileStorebarBV
    }

    private static func birthdayCuebarBV(_ birthdayFieldbarBV: String) -> Bool {
        let messageMomentbarBV = DateFormatter()
        messageMomentbarBV.dateFormat = "yyyy-MM-dd"
        messageMomentbarBV.locale = Locale(identifier: "en_US_POSIX")
        messageMomentbarBV.isLenient = false
        return messageMomentbarBV.date(from: birthdayFieldbarBV) != nil
    }

    private static func dateDividerbarBV(_ dateDivider: Date) -> String {
        let messageMomentbarBV = DateFormatter()
        messageMomentbarBV.dateFormat = "yyyy-MM-dd"
        return messageMomentbarBV.string(from: dateDivider)
    }
}
