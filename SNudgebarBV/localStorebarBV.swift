import Foundation

final class localStorebarBV {
    static let shared = localStorebarBV()

    let profileSeedletbarBV = UUID()
    private(set) var contactPoolbarBV: [trustedContact] = []
    private(set) var threadPoolbarBV: [threadFixturebarBV] = []
    private(set) var messagePoolbarBV: [UUID: [messageFixturebarBV]] = [:]
    private(set) var styleUnlock: Set<replyStylebarBV> = [.replyToneWarm, .replyToneShortbarBV, .replyTonePolite]
    private(set) var coinBalance = 2222

    private init() {
        seedFlow()
    }

    func messagePool(for thread: threadFixturebarBV) -> [messageFixturebarBV] {
        messagePoolbarBV[thread.threadSeed, default: []].sorted { $0.localMessageTime < $1.localMessageTime }
    }

    func contactMatcherbarBV(contactSeed: UUID) -> trustedContact? {
        contactPoolbarBV.first { $0.contactSeed == contactSeed }
    }

    func localThreadPreviewbarBV(for thread: threadFixturebarBV) -> messageFixturebarBV? {
        messagePool(for: thread).last
    }

    func replyQueuebarBV() -> [threadFixturebarBV] {
        threadPoolbarBV.filter { $0.unreadCounter > 0 }
    }

    func sendButton(_ localMessageText: String, in thread: threadFixturebarBV) {
        let messageFixture = messageFixturebarBV(
            messageSeed: UUID(),
            threadSeed: thread.threadSeed,
            personaSeed: profileSeedletbarBV,
            localMessageText: localMessageText,
            localMessageType: .textBubblebarBV,
            localMessageTime: Date(),
            sentFlag: true
        )
        messagePoolbarBV[thread.threadSeed, default: []].append(messageFixture)
        if let queueCheckbarBV = threadPoolbarBV.firstIndex(where: { $0.threadSeed == thread.threadSeed }) {
            threadPoolbarBV[queueCheckbarBV].unreadCounter = 0
        }
    }

    func generatedDraftbarBV(for messageFixture: messageFixturebarBV, tone: replyStylebarBV) -> String {
        let contextHint = messageFixture.localMessageText.lowercased()
        if contextHint.contains("tired") || contextHint.contains("heavy") {
            switch tone {
            case .replyToneShortbarBV:
                return "I'm sorry you're feeling tired. Please get some rest tonight."
            case .replyTonePolite:
                return "I'm sorry to hear that. I hope you can rest well, and I'm here if you need anything."
            case .replyToneProfessionalbarBV:
                return "Thanks for sharing that with me. Please take the time you need, and let me know how I can help."
            default:
                return "That sounds really tiring. I hope you can get some rest tonight, and I'm here if you want to talk."
            }
        }
        if contextHint.contains("tomorrow") || contextHint.contains("late") {
            switch tone {
            case .replyToneShortbarBV:
                return "No problem. See you tomorrow."
            case .replyTonePolite:
                return "That works for me. Thanks for letting me know."
            default:
                return "No worries at all. Take your time, and I'll see you tomorrow."
            }
        }
        if contextHint.contains("page") || contextHint.contains("book") {
            switch tone {
            case .replyToneShortbarBV:
                return "Sure, I'll send the page numbers."
            case .replyTonePolite:
                return "Of course. I'll share the page numbers in a moment."
            default:
                return "Sure, I can share them. Give me a moment and I'll send the page numbers."
            }
        }
        switch tone {
        case .replyToneShortbarBV:
            return "Got it. I'll reply soon."
        case .replyTonePolite:
            return "Thanks for the message. I'll get back to you shortly."
        default:
            return "Thanks for telling me. I appreciate it, and I'll reply properly in a moment."
        }
    }

    func toneUnlockbarBV(_ tone: replyStylebarBV) -> Bool {
        guard !styleUnlock.contains(tone), coinBalance >= 400 else { return false }
        coinBalance -= 400
        styleUnlock.insert(tone)
        return true
    }

    private func seedFlow() {
        let quietFriend = trustedContact(contactSeed: UUID(), placeholderNamebarBV: "Mia Tanaka", placeholderNotebarBV: "College, the quiet one", groupFilter: .friendFilter, placeholderAvatar: "M", onlineFlagbarBV: true, blockFlag: false, pinFlagbarBV: true)
        let climbingBuddy = trustedContact(contactSeed: UUID(), placeholderNamebarBV: "Kallisto", placeholderNotebarBV: "Climbing buddy", groupFilter: .friendFilter, placeholderAvatar: "K", onlineFlagbarBV: true, blockFlag: false, pinFlagbarBV: false)
        let parentPersona = trustedContact(contactSeed: UUID(), placeholderNamebarBV: "Mom", placeholderNotebarBV: "Call her on Sundays", groupFilter: .familyFilterbarBV, placeholderAvatar: "M", onlineFlagbarBV: false, blockFlag: false, pinFlagbarBV: false)
        let caregiverRole = trustedContact(contactSeed: UUID(), placeholderNamebarBV: "Dad", placeholderNotebarBV: "Loves the garden", groupFilter: .familyFilterbarBV, placeholderAvatar: "D", onlineFlagbarBV: false, blockFlag: false, pinFlagbarBV: false)
        let siblingPersona = trustedContact(contactSeed: UUID(), placeholderNamebarBV: "Sis", placeholderNotebarBV: "Texting buddy", groupFilter: .familyFilterbarBV, placeholderAvatar: "S", onlineFlagbarBV: true, blockFlag: false, pinFlagbarBV: false)
        let weekendPlanner = trustedContact(contactSeed: UUID(), placeholderNamebarBV: "Lukas Nilsson", placeholderNotebarBV: "Weekend planner", groupFilter: .friendFilter, placeholderAvatar: "L", onlineFlagbarBV: true, blockFlag: false, pinFlagbarBV: false)
        let poetryPal = trustedContact(contactSeed: UUID(), placeholderNamebarBV: "Aiko", placeholderNotebarBV: "Poetry pen-pal", groupFilter: .friendFilter, placeholderAvatar: "A", onlineFlagbarBV: false, blockFlag: false, pinFlagbarBV: false)
        contactPoolbarBV = [parentPersona, caregiverRole, siblingPersona, quietFriend, climbingBuddy, weekendPlanner, poetryPal]

        let privateThreadFlagbarBV = threadFixturebarBV(threadSeed: UUID(), localThreadTitle: "Mia Tanaka", personaPoolbarBV: [quietFriend.contactSeed], smallGroupFlag: false, unreadCounter: 1, pinFlagbarBV: true)
        let smallGroupFlag = threadFixturebarBV(threadSeed: UUID(), localThreadTitle: "Sunday Slow Reading", personaPoolbarBV: [quietFriend.contactSeed, climbingBuddy.contactSeed, weekendPlanner.contactSeed, poetryPal.contactSeed], smallGroupFlag: true, unreadCounter: 2, pinFlagbarBV: false)
        let familyThread = threadFixturebarBV(threadSeed: UUID(), localThreadTitle: "Mom", personaPoolbarBV: [parentPersona.contactSeed], smallGroupFlag: false, unreadCounter: 1, pinFlagbarBV: false)
        threadPoolbarBV = [privateThreadFlagbarBV, smallGroupFlag, familyThread]

        messagePoolbarBV[privateThreadFlagbarBV.threadSeed] = [
            messageFixturebarBV(messageSeed: UUID(), threadSeed: privateThreadFlagbarBV.threadSeed, personaSeed: quietFriend.contactSeed, localMessageText: "Hey, did you finish the book I lent you?", localMessageType: .textBubblebarBV, localMessageTime: Date().addingTimeInterval(-7000), sentFlag: false),
            messageFixturebarBV(messageSeed: UUID(), threadSeed: privateThreadFlagbarBV.threadSeed, personaSeed: profileSeedletbarBV, localMessageText: "Almost. The last chapter is heavy.", localMessageType: .textBubblebarBV, localMessageTime: Date().addingTimeInterval(-6800), sentFlag: true),
            messageFixturebarBV(messageSeed: UUID(), threadSeed: privateThreadFlagbarBV.threadSeed, personaSeed: quietFriend.contactSeed, localMessageText: "I've been feeling a little tired lately. Hope you're doing okay...", localMessageType: .textBubblebarBV, localMessageTime: Date().addingTimeInterval(-1200), sentFlag: false)
        ]
        messagePoolbarBV[smallGroupFlag.threadSeed] = [
            messageFixturebarBV(messageSeed: UUID(), threadSeed: smallGroupFlag.threadSeed, personaSeed: poetryPal.contactSeed, localMessageText: "Anyone bringing the new translation tomorrow?", localMessageType: .textBubblebarBV, localMessageTime: Date().addingTimeInterval(-3600), sentFlag: false),
            messageFixturebarBV(messageSeed: UUID(), threadSeed: smallGroupFlag.threadSeed, personaSeed: climbingBuddy.contactSeed, localMessageText: "I have it. Will arrive a bit late though.", localMessageType: .textBubblebarBV, localMessageTime: Date().addingTimeInterval(-3000), sentFlag: false),
            messageFixturebarBV(messageSeed: UUID(), threadSeed: smallGroupFlag.threadSeed, personaSeed: weekendPlanner.contactSeed, localMessageText: "No rush. Tea will be ready.", localMessageType: .textBubblebarBV, localMessageTime: Date().addingTimeInterval(-2500), sentFlag: false),
            messageFixturebarBV(messageSeed: UUID(), threadSeed: smallGroupFlag.threadSeed, personaSeed: quietFriend.contactSeed, localMessageText: "Could someone share the page numbers?", localMessageType: .textBubblebarBV, localMessageTime: Date().addingTimeInterval(-900), sentFlag: false)
        ]
        messagePoolbarBV[familyThread.threadSeed] = [
            messageFixturebarBV(messageSeed: UUID(), threadSeed: familyThread.threadSeed, personaSeed: parentPersona.contactSeed, localMessageText: "Are you eating well this week?", localMessageType: .textBubblebarBV, localMessageTime: Date().addingTimeInterval(-1400), sentFlag: false)
        ]
    }
}
