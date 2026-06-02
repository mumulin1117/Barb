import Foundation

enum contactGroupbarBV: String, CaseIterable, Codable {
    case familyFilterbarBV = "Family"
    case friendFilter = "Friend"
    case workFilterbarBV = "Work"
    case otherFilter = "Other"
}

enum messageFormbarBV {
    case textBubblebarBV
}

enum replyStylebarBV: String, CaseIterable {
    case replyToneWarm = "Warm"
    case replyToneShortbarBV = "Short"
    case replyTonePolite = "Polite"
    case replyToneGentlebarBV = "Gentle"
    case replyToneCheerful = "Cheerful"
    case replyToneCaringbarBV = "Caring"
    case replyToneApology = "Apology"
    case replyToneBoundarybarBV = "Boundary"
    case replyToneProfessionalbarBV = "Professional"

    var isDefaultUnlocked: Bool {
        self == .replyToneWarm || self == .replyToneShortbarBV || self == .replyTonePolite
    }
}

struct aiStylebarBV: Hashable, Codable {
    let styleSeedbarBV: String
    var titlebarBV: String
    var subtitlebarBV: String
    var emojibarBV: String
    var unlockFlagbarBV: Bool
    var selectedFlagbarBV: Bool
}

struct coinPackagebarBV: Hashable, Codable {
    let packageSeedbarBV: String
    var priceTextbarBV: String
    var coinAmountbarBV: Int
    var productSeedbarBV: String
    var selectedFlagbarBV: Bool
}

struct coinTransactionbarBV: Hashable, Codable {
    let transactionSeedbarBV: UUID
    var packageSeedbarBV: String
    var priceTextbarBV: String
    var coinAmountbarBV: Int
    var createdAtbarBV: Date
    var typebarBV: String
}

struct notificationSettingsbarBV: Hashable, Codable {
    var allowNotificationsbarBV: Bool
    var newMessagesbarBV: Bool
    var friendRequestsbarBV: Bool
    var groupMentionsOnlybarBV: Bool
    var soundbarBV: String
    var vibrationbarBV: Bool
    var inAppSoundbarBV: Bool
    var quietHoursEnabledbarBV: Bool
    var quietHoursStartbarBV: String
    var quietHoursEndbarBV: String

    static let defaultStatebarBV = notificationSettingsbarBV(
        allowNotificationsbarBV: true,
        newMessagesbarBV: true,
        friendRequestsbarBV: true,
        groupMentionsOnlybarBV: true,
        soundbarBV: "Default",
        vibrationbarBV: true,
        inAppSoundbarBV: false,
        quietHoursEnabledbarBV: true,
        quietHoursStartbarBV: "22:00",
        quietHoursEndbarBV: "07:30"
    )
}

struct privacySettingsbarBV: Hashable, Codable {
    var searchByPhonebarBV: Bool
    var searchByEmailbarBV: Bool
    var showOnlinebarBV: Bool
    var readReceiptsbarBV: Bool
    var typingIndicatorbarBV: Bool
    var allowAILearningbarBV: Bool

    static let defaultStatebarBV = privacySettingsbarBV(
        searchByPhonebarBV: true,
        searchByEmailbarBV: true,
        showOnlinebarBV: true,
        readReceiptsbarBV: true,
        typingIndicatorbarBV: true,
        allowAILearningbarBV: false
    )
}

struct trustedContact: Hashable, Codable {
    let contactSeed: UUID
    var placeholderNamebarBV: String
    var placeholderNotebarBV: String
    var groupFilter: contactGroupbarBV
    var placeholderAvatar: String
    var onlineFlagbarBV: Bool
    var blockFlag: Bool
    var pinFlagbarBV: Bool
}

struct contactCardbarBV: Hashable, Codable {
    let userIdbarBV: String
    var namebarBV: String
    var avatarbarBV: String
    var barbIdbarBV: String
    var qrCodeValuebarBV: String
    var shareLinkbarBV: String
    var pendingRequestCountbarBV: Int
}

enum contactRequestKindbarBV: String, Codable, Hashable {
    case pendingRequestbarBV
    case sentRequestbarBV
}

enum contactRequestStatusbarBV: String, Codable, Hashable {
    case pendingStatusbarBV
    case acceptedStatusbarBV
    case rejectedStatusbarBV
    case cancelledStatusbarBV
}

struct contactRequestbarBV: Hashable, Codable {
    let requestSeedbarBV: UUID
    var userIdbarBV: String
    var namebarBV: String
    var avatarbarBV: String
    var requestTypebarBV: contactRequestKindbarBV
    var sourceTextbarBV: String
    var statusbarBV: contactRequestStatusbarBV
    var createdAtbarBV: Date
}

struct messageFixturebarBV: Hashable {
    let messageSeed: UUID
    let threadSeed: UUID
    let personaSeed: UUID
    var messageCopybarBV: String
    var messageFormbarBV: messageFormbarBV
    var messageMomentbarBV: Date
    var sentFlag: Bool
}

struct threadFixturebarBV: Hashable {
    let threadSeed: UUID
    var threadTitlebarBV: String
    var personaPoolbarBV: [UUID]
    var smallGroupFlag: Bool
    var unreadCounter: Int
    var pinFlagbarBV: Bool
}

enum reportReasonbarBV: String, CaseIterable {
    case spamScambarBV = "Spam or scam"
    case hateSpeechbarBV = "Hate speech"
    case unsafeContentbarBV = "Sexual or violent content"
    case selfHarmbarBV = "Self-harm or suicide"
    case somethingElsebarBV = "Something else"
}

struct reportRecordbarBV: Hashable {
    let reportSeedbarBV: UUID
    let threadSeedbarBV: UUID
    let messageSeedbarBV: UUID?
    let contactSeedbarBV: UUID?
    var reasonTextbarBV: String
    var detailTextbarBV: String
    var createdAtbarBV: Date
}

struct blockedUserbarBV: Hashable, Codable {
    let contactSeedbarBV: UUID
    var namebarBV: String
    var avatarbarBV: String
    var blockedAtbarBV: Date
}

enum groupReportReasonbarBV: String, CaseIterable {
    case spamGroupbarBV = "Spam in group"
    case harassmentMemberbarBV = "Harassment toward members"
    case unwantedAdbarBV = "Off-topic / unwanted ads"
    case otherGroupbarBV = "Other"
}

struct groupReportRecordbarBV: Hashable {
    let reportSeedbarBV: UUID
    let threadSeedbarBV: UUID
    let messageSeedbarBV: UUID?
    var reasonTextbarBV: String
    var hiddenNamebarBV: Bool
    var createdAtbarBV: Date
}
