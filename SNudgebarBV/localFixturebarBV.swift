import Foundation

enum contactGroupbarBV: String, CaseIterable {
    case familyFilterbarBV = "Family"
    case friendFilter = "Friend"
    case workFilterbarBV = "Work"
    case otherFilter = "Other"
}

enum localMessageType {
    case textBubblebarBV
    case voiceBubblebarBV
    case imageBubblebarBV
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

struct trustedContact: Hashable {
    let contactSeed: UUID
    var placeholderNamebarBV: String
    var placeholderNotebarBV: String
    var groupFilter: contactGroupbarBV
    var placeholderAvatar: String
    var onlineFlagbarBV: Bool
    var blockFlag: Bool
    var pinFlagbarBV: Bool
}

struct messageFixturebarBV: Hashable {
    let messageSeed: UUID
    let threadSeed: UUID
    let personaSeed: UUID
    var localMessageText: String
    var localMessageType: localMessageType
    var localMessageTime: Date
    var sentFlag: Bool
}

struct threadFixturebarBV: Hashable {
    let threadSeed: UUID
    var localThreadTitle: String
    var personaPoolbarBV: [UUID]
    var smallGroupFlag: Bool
    var unreadCounter: Int
    var pinFlagbarBV: Bool
}
