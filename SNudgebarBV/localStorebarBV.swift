import Foundation
import StoreKit

final class localStorebarBV {
    static let shared = localStorebarBV()

    private struct contactStateSnapshotbarBV: Codable {
        var contactsbarBV: [trustedContact]
        var requestsbarBV: [contactRequestbarBV]
        var blockedbarBV: [blockedUserbarBV]
        var mutedSeedsbarBV: [UUID]
    }

    private let contactStateKeybarBV = "contactStateSnapshotbarBV"
    private let coinBalanceKeybarBV = "coinBalancebarBV"
    private let coinTransactionsKeybarBV = "coinTransactionsbarBV"
    private let coinPurchaseSeedKeybarBV = "coinPurchaseSeedbarBV"
    private let selectedStyleKeybarBV = "selectedAIStylebarBV"
    private let selectedReplyToneKeybarBV = "selectedReplyTonebarBV"
    private let unlockedReplyToneKeybarBV = "unlockedReplyTonebarBV"
    private let notificationSettingsKeybarBV = "notificationSettingsbarBV"
    private let privacySettingsKeybarBV = "privacySettingsbarBV"
    let profileSeedletbarBV = UUID()
    private(set) var contactPoolbarBV: [trustedContact] = []
    private(set) var threadPoolbarBV: [threadFixturebarBV] = []
    private(set) var messagePoolbarBV: [UUID: [messageFixturebarBV]] = [:]
    private(set) var styleUnlock: Set<replyStylebarBV> = [.replyToneWarm, .replyToneShortbarBV, .replyTonePolite]
    private(set) var reportRecordsbarBV: [reportRecordbarBV] = []
    private(set) var groupReportRecordsbarBV: [groupReportRecordbarBV] = []
    private(set) var blockedUsersbarBV: [blockedUserbarBV] = []
    private(set) var contactRequestsbarBV: [contactRequestbarBV] = []
    private var mutedContactsbarBV: Set<UUID> = []
    private(set) var coinBalance = 2222
    private(set) var coinTransactionsbarBV: [coinTransactionbarBV] = []
    private var coinPurchaseSeedsbarBV: Set<String> = []
    private(set) var selectedAIStylebarBV = "gentle"
    private(set) var selectedReplyTonebarBV: replyStylebarBV = .replyToneWarm
    private(set) var notificationSettingsFlowbarBV = notificationSettingsbarBV.defaultStatebarBV
    private(set) var privacySettingsFlowbarBV = privacySettingsbarBV.defaultStatebarBV
    private var coinUpdateTaskbarBV: Task<Void, Never>?

    private init() {
        seedFlow()
        restorePersonalStatebarBV()
        restoreContactStatebarBV()
        beginCoinPurchaseUpdatesbarBV()
    }

    func messagePool(for thread: threadFixturebarBV) -> [messageFixturebarBV] {
        messagePoolbarBV[thread.threadSeed, default: []].sorted { $0.localMessageTime < $1.localMessageTime }
    }

    func contactMatcherbarBV(contactSeed: UUID) -> trustedContact? {
        contactPoolbarBV.first { $0.contactSeed == contactSeed }
    }

    func contactProfilebarBV(contactbarBV: trustedContact) -> trustedContact {
        contactMatcherbarBV(contactSeed: contactbarBV.contactSeed) ?? contactbarBV
    }

    func contactIDbarBV(for contactbarBV: trustedContact) -> String {
        let seedbarBV = abs(contactbarBV.placeholderNamebarBV.unicodeScalars.reduce(0) { partialbarBV, scalarbarBV in
            partialbarBV + Int(scalarbarBV.value)
        })
        return String(format: "%04d", (seedbarBV % 9000) + 1000)
    }

    func connectedSincebarBV(for contactbarBV: trustedContact) -> String {
        switch contactbarBV.groupFilter {
        case .familyFilterbarBV:
            return "Jan 2024"
        case .friendFilter:
            return contactbarBV.pinFlagbarBV ? "Sep 2024" : "Oct 2024"
        case .workFilterbarBV:
            return "Aug 2024"
        case .otherFilter:
            return "Nov 2024"
        }
    }

    func mutedFlagbarBV(contactbarBV: trustedContact) -> Bool {
        mutedContactsbarBV.contains(contactbarBV.contactSeed)
    }

    func pinFlagbarBV(contactbarBV: trustedContact) -> Bool {
        contactMatcherbarBV(contactSeed: contactbarBV.contactSeed)?.pinFlagbarBV ?? contactbarBV.pinFlagbarBV
    }

    func setMutedbarBV(_ mutedbarBV: Bool, contactbarBV: trustedContact) {
        if mutedbarBV {
            mutedContactsbarBV.insert(contactbarBV.contactSeed)
        } else {
            mutedContactsbarBV.remove(contactbarBV.contactSeed)
        }
        persistContactStatebarBV()
    }

    func setPinnedbarBV(_ pinnedbarBV: Bool, contactbarBV: trustedContact) {
        if let indexbarBV = contactPoolbarBV.firstIndex(where: { $0.contactSeed == contactbarBV.contactSeed }) {
            contactPoolbarBV[indexbarBV].pinFlagbarBV = pinnedbarBV
        }
        for indexbarBV in threadPoolbarBV.indices where !threadPoolbarBV[indexbarBV].smallGroupFlag && threadPoolbarBV[indexbarBV].personaPoolbarBV.contains(contactbarBV.contactSeed) {
            threadPoolbarBV[indexbarBV].pinFlagbarBV = pinnedbarBV
        }
        if pinnedbarBV,
           let threadIndexbarBV = threadPoolbarBV.firstIndex(where: { !$0.smallGroupFlag && $0.personaPoolbarBV.contains(contactbarBV.contactSeed) }) {
            let threadbarBV = threadPoolbarBV.remove(at: threadIndexbarBV)
            threadPoolbarBV.insert(threadbarBV, at: 0)
        }
        persistContactStatebarBV()
    }

    @discardableResult
    func removeContactbarBV(contactbarBV: trustedContact) -> Bool {
        let countbarBV = contactPoolbarBV.count
        contactPoolbarBV.removeAll { $0.contactSeed == contactbarBV.contactSeed }
        mutedContactsbarBV.remove(contactbarBV.contactSeed)
        let changedbarBV = countbarBV != contactPoolbarBV.count
        if changedbarBV {
            persistContactStatebarBV()
        }
        return changedbarBV
    }

    func threadForContactbarBV(contactbarBV: trustedContact) -> threadFixturebarBV {
        if let threadbarBV = threadPoolbarBV.first(where: { !$0.smallGroupFlag && $0.personaPoolbarBV.contains(contactbarBV.contactSeed) }) {
            return threadbarBV
        }
        let threadbarBV = threadFixturebarBV(
            threadSeed: UUID(),
            localThreadTitle: contactbarBV.placeholderNamebarBV,
            personaPoolbarBV: [contactbarBV.contactSeed],
            smallGroupFlag: false,
            unreadCounter: 0,
            pinFlagbarBV: pinFlagbarBV(contactbarBV: contactbarBV)
        )
        threadPoolbarBV.append(threadbarBV)
        messagePoolbarBV[threadbarBV.threadSeed] = [
            messageFixturebarBV(
                messageSeed: UUID(),
                threadSeed: threadbarBV.threadSeed,
                personaSeed: contactbarBV.contactSeed,
                localMessageText: "Glad we're connected here.",
                localMessageType: .textBubblebarBV,
                localMessageTime: Date().addingTimeInterval(-300),
                sentFlag: false
            )
        ]
        return threadbarBV
    }

    func localThreadPreviewbarBV(for thread: threadFixturebarBV) -> messageFixturebarBV? {
        messagePool(for: thread).last
    }

    func groupMemberCountbarBV(for thread: threadFixturebarBV) -> Int {
        thread.smallGroupFlag ? thread.personaPoolbarBV.count + 1 : thread.personaPoolbarBV.count
    }

    func previewTextbarBV(for thread: threadFixturebarBV) -> String {
        guard let latestbarBV = localThreadPreviewbarBV(for: thread) else {
            return thread.smallGroupFlag ? "\(groupMemberCountbarBV(for: thread)) members" : ""
        }
        guard thread.smallGroupFlag else { return latestbarBV.localMessageText }
        if latestbarBV.sentFlag {
            return "You: \(latestbarBV.localMessageText)"
        }
        let senderbarBV = contactMatcherbarBV(contactSeed: latestbarBV.personaSeed)?.placeholderNamebarBV.components(separatedBy: " ").first ?? "Member"
        return "\(senderbarBV): \(latestbarBV.localMessageText)"
    }

    func contactCardFlowbarBV() -> contactCardbarBV {
        let profilebarBV = sessionStore.profileLocalbarBV
        let cleanNamebarBV = profilebarBV?.placeholderNamebarBV.trimmingCharacters(in: .whitespacesAndNewlines)
        let displayNamebarBV: String
        if let cleanNamebarBV, !cleanNamebarBV.isEmpty {
            displayNamebarBV = cleanNamebarBV
        } else {
            displayNamebarBV = "Mia"
        }
        let avatarTextbarBV = profilebarBV?.placeholderAvatar.trimmingCharacters(in: .whitespacesAndNewlines)
        let avatarbarBV: String
        if let avatarTextbarBV, !avatarTextbarBV.isEmpty {
            avatarbarBV = avatarTextbarBV
        } else {
            avatarbarBV = String(displayNamebarBV.prefix(1)).uppercased()
        }
        let idbarBV = "0824"
        return contactCardbarBV(
            userIdbarBV: profilebarBV?.emailEntry ?? "local-user-barBV",
            namebarBV: displayNamebarBV,
            avatarbarBV: avatarbarBV,
            barbIdbarBV: "BARB ID · \(idbarBV)",
            qrCodeValuebarBV: "barb://user/\(idbarBV)",
            shareLinkbarBV: "https://example.com/invite/barb-\(idbarBV)",
            pendingRequestCountbarBV: pendingRequestsbarBV().count
        )
    }

    func aiStyleOptionsbarBV() -> [aiStylebarBV] {
        [
            aiStylebarBV(
                styleSeedbarBV: "gentle",
                titlebarBV: "Gentle",
                subtitlebarBV: "Soft pace, soft edges.",
                emojibarBV: "🥰 ☁️ 💛",
                unlockFlagbarBV: true,
                selectedFlagbarBV: selectedAIStylebarBV == "gentle"
            ),
            aiStylebarBV(
                styleSeedbarBV: "cheerful",
                titlebarBV: "Cheerful",
                subtitlebarBV: "Bright and easy.",
                emojibarBV: "🎉 😄 ✨",
                unlockFlagbarBV: true,
                selectedFlagbarBV: selectedAIStylebarBV == "cheerful"
            ),
            aiStylebarBV(
                styleSeedbarBV: "playful",
                titlebarBV: "Playful",
                subtitlebarBV: "Colorful and fun.",
                emojibarBV: "🌈 😄",
                unlockFlagbarBV: true,
                selectedFlagbarBV: selectedAIStylebarBV == "playful"
            )
        ]
    }

    func replyToneOptionsbarBV() -> [aiStylebarBV] {
        replyStylebarBV.allCases.map { tonebarBV in
            aiStylebarBV(
                styleSeedbarBV: tonebarBV.rawValue,
                titlebarBV: tonebarBV.rawValue,
                subtitlebarBV: replyToneSubtitlebarBV(tonebarBV),
                emojibarBV: replyToneEmojibarBV(tonebarBV),
                unlockFlagbarBV: styleUnlock.contains(tonebarBV),
                selectedFlagbarBV: selectedReplyTonebarBV == tonebarBV
            )
        }
    }

    var unlockedAIStyleCountbarBV: Int {
        aiStyleOptionsbarBV().filter(\.unlockFlagbarBV).count
    }

    var unlockedReplyToneCountbarBV: Int {
        styleUnlock.count
    }

    func selectAIStylebarBV(_ stylebarBV: aiStylebarBV) {
        guard stylebarBV.unlockFlagbarBV else { return }
        selectedAIStylebarBV = stylebarBV.styleSeedbarBV
        UserDefaults.standard.set(selectedAIStylebarBV, forKey: selectedStyleKeybarBV)
    }

    @discardableResult
    func selectReplyTonebarBV(_ tonebarBV: replyStylebarBV) -> Bool {
        guard styleUnlock.contains(tonebarBV) else { return false }
        selectedReplyTonebarBV = tonebarBV
        UserDefaults.standard.set(tonebarBV.rawValue, forKey: selectedReplyToneKeybarBV)
        return true
    }

    private func replyToneSubtitlebarBV(_ tonebarBV: replyStylebarBV) -> String {
        switch tonebarBV {
        case .replyToneWarm:
            return "Gentle everyday replies."
        case .replyToneShortbarBV:
            return "Brief and direct."
        case .replyTonePolite:
            return "Respectful and careful."
        case .replyToneGentlebarBV:
            return "Softer reassurance."
        case .replyToneCheerful:
            return "Brighter, lighter energy."
        case .replyToneCaringbarBV:
            return "More supportive wording."
        case .replyToneApology:
            return "Helpful when you need to repair."
        case .replyToneBoundarybarBV:
            return "Kind but clear limits."
        case .replyToneProfessionalbarBV:
            return "Clean and work-friendly."
        }
    }

    private func replyToneEmojibarBV(_ tonebarBV: replyStylebarBV) -> String {
        switch tonebarBV {
        case .replyToneWarm:
            return "☁️ 💛"
        case .replyToneShortbarBV:
            return "✦"
        case .replyTonePolite:
            return "🤍"
        case .replyToneGentlebarBV:
            return "🥰"
        case .replyToneCheerful:
            return "🎉"
        case .replyToneCaringbarBV:
            return "🫶"
        case .replyToneApology:
            return "🌧️"
        case .replyToneBoundarybarBV:
            return "🧭"
        case .replyToneProfessionalbarBV:
            return "💼"
        }
    }

    @discardableResult
    func spendCoinsbarBV(amountbarBV: Int, typebarBV: String) -> Bool {
        guard amountbarBV > 0, coinBalance >= amountbarBV else { return false }
        coinBalance -= amountbarBV
        let transactionbarBV = coinTransactionbarBV(
            transactionSeedbarBV: UUID(),
            packageSeedbarBV: typebarBV,
            priceTextbarBV: "local",
            coinAmountbarBV: -amountbarBV,
            createdAtbarBV: Date(),
            typebarBV: typebarBV
        )
        coinTransactionsbarBV.append(transactionbarBV)
        persistCoinBalancebarBV()
        persistCoinTransactionsbarBV()
        return true
    }

    func currentNotificationSettingsbarBV() -> notificationSettingsbarBV {
        notificationSettingsFlowbarBV
    }

    func setAllowNotificationsbarBV(_ valuebarBV: Bool) {
        notificationSettingsFlowbarBV.allowNotificationsbarBV = valuebarBV
        persistNotificationSettingsbarBV()
    }

    func setNewMessagesbarBV(_ valuebarBV: Bool) {
        notificationSettingsFlowbarBV.newMessagesbarBV = valuebarBV
        persistNotificationSettingsbarBV()
    }

    func setFriendRequestsbarBV(_ valuebarBV: Bool) {
        notificationSettingsFlowbarBV.friendRequestsbarBV = valuebarBV
        persistNotificationSettingsbarBV()
    }

    func setGroupMentionsOnlybarBV(_ valuebarBV: Bool) {
        notificationSettingsFlowbarBV.groupMentionsOnlybarBV = valuebarBV
        persistNotificationSettingsbarBV()
    }

    func setVibrationbarBV(_ valuebarBV: Bool) {
        notificationSettingsFlowbarBV.vibrationbarBV = valuebarBV
        persistNotificationSettingsbarBV()
    }

    func setInAppSoundbarBV(_ valuebarBV: Bool) {
        notificationSettingsFlowbarBV.inAppSoundbarBV = valuebarBV
        persistNotificationSettingsbarBV()
    }

    func setQuietHoursEnabledbarBV(_ valuebarBV: Bool) {
        notificationSettingsFlowbarBV.quietHoursEnabledbarBV = valuebarBV
        persistNotificationSettingsbarBV()
    }

    func currentPrivacySettingsbarBV() -> privacySettingsbarBV {
        privacySettingsFlowbarBV
    }

    func setSearchByPhonebarBV(_ valuebarBV: Bool) {
        privacySettingsFlowbarBV.searchByPhonebarBV = valuebarBV
        persistPrivacySettingsbarBV()
    }

    func setSearchByEmailbarBV(_ valuebarBV: Bool) {
        privacySettingsFlowbarBV.searchByEmailbarBV = valuebarBV
        persistPrivacySettingsbarBV()
    }

    func setShowOnlinebarBV(_ valuebarBV: Bool) {
        privacySettingsFlowbarBV.showOnlinebarBV = valuebarBV
        persistPrivacySettingsbarBV()
    }

    func setReadReceiptsbarBV(_ valuebarBV: Bool) {
        privacySettingsFlowbarBV.readReceiptsbarBV = valuebarBV
        persistPrivacySettingsbarBV()
    }

    func setTypingIndicatorbarBV(_ valuebarBV: Bool) {
        privacySettingsFlowbarBV.typingIndicatorbarBV = valuebarBV
        persistPrivacySettingsbarBV()
    }

    func setAllowAILearningbarBV(_ valuebarBV: Bool) {
        privacySettingsFlowbarBV.allowAILearningbarBV = valuebarBV
        persistPrivacySettingsbarBV()
    }

    func coinPackagesbarBV(selectedSeedbarBV: String? = nil) -> [coinPackagebarBV] {
        [
            coinPackagebarBV(packageSeedbarBV: "coinSeedTinybarBV", priceTextbarBV: "$0.99", coinAmountbarBV: 400, productSeedbarBV: "zpahwfmgsqdenfzm", selectedFlagbarBV: selectedSeedbarBV == nil || selectedSeedbarBV == "coinSeedTinybarBV"),
            coinPackagebarBV(packageSeedbarBV: "coinSeedSmallbarBV", priceTextbarBV: "$1.99", coinAmountbarBV: 800, productSeedbarBV: "atscffxokgxltmtg", selectedFlagbarBV: selectedSeedbarBV == "coinSeedSmallbarBV"),
            coinPackagebarBV(packageSeedbarBV: "coinSeedMediumbarBV", priceTextbarBV: "$3.99", coinAmountbarBV: 1650, productSeedbarBV: "bdzffbuiokgxledhn", selectedFlagbarBV: selectedSeedbarBV == "coinSeedMediumbarBV"),
            coinPackagebarBV(packageSeedbarBV: "coinSeedPlusbarBV", priceTextbarBV: "$4.99", coinAmountbarBV: 2450, productSeedbarBV: "lyxwmsvcssjvfmbl", selectedFlagbarBV: selectedSeedbarBV == "coinSeedPlusbarBV"),
            coinPackagebarBV(packageSeedbarBV: "coinSeedBrightbarBV", priceTextbarBV: "$5.99", coinAmountbarBV: 3250, productSeedbarBV: "KSJNkjbfbrgubrhhet", selectedFlagbarBV: selectedSeedbarBV == "coinSeedBrightbarBV"),
            coinPackagebarBV(packageSeedbarBV: "coinSeedLargebarBV", priceTextbarBV: "$9.99", coinAmountbarBV: 5150, productSeedbarBV: "qzilbdteuuclzugu", selectedFlagbarBV: selectedSeedbarBV == "coinSeedLargebarBV"),
            coinPackagebarBV(packageSeedbarBV: "coinSeedDeepbarBV", priceTextbarBV: "$19.99", coinAmountbarBV: 10800, productSeedbarBV: "eistclsausdiozdv", selectedFlagbarBV: selectedSeedbarBV == "coinSeedDeepbarBV"),
            coinPackagebarBV(packageSeedbarBV: "coinSeedWidebarBV", priceTextbarBV: "$49.99", coinAmountbarBV: 29400, productSeedbarBV: "hgndagerljbzabzu", selectedFlagbarBV: selectedSeedbarBV == "coinSeedWidebarBV"),
            coinPackagebarBV(packageSeedbarBV: "coinSeedMaxbarBV", priceTextbarBV: "$99.99", coinAmountbarBV: 63700, productSeedbarBV: "vvwmjkywykouceap", selectedFlagbarBV: selectedSeedbarBV == "coinSeedMaxbarBV")
        ]
    }

    @discardableResult
    func rechargeCoinsbarBV(packagebarBV: coinPackagebarBV) -> Int {
        coinBalance += packagebarBV.coinAmountbarBV
        let transactionbarBV = coinTransactionbarBV(
            transactionSeedbarBV: UUID(),
            packageSeedbarBV: packagebarBV.packageSeedbarBV,
            priceTextbarBV: packagebarBV.priceTextbarBV,
            coinAmountbarBV: packagebarBV.coinAmountbarBV,
            createdAtbarBV: Date(),
            typebarBV: "recharge"
        )
        coinTransactionsbarBV.append(transactionbarBV)
        persistCoinBalancebarBV()
        persistCoinTransactionsbarBV()
        return coinBalance
    }

    @discardableResult
    func grantPurchasedCoinsbarBV(packagebarBV: coinPackagebarBV, purchaseSeedbarBV: String) -> (balancebarBV: Int, grantedbarBV: Bool) {
        guard !coinPurchaseSeedsbarBV.contains(purchaseSeedbarBV) else {
            return (coinBalance, false)
        }
        coinPurchaseSeedsbarBV.insert(purchaseSeedbarBV)
        coinBalance += packagebarBV.coinAmountbarBV
        let transactionbarBV = coinTransactionbarBV(
            transactionSeedbarBV: UUID(),
            packageSeedbarBV: packagebarBV.packageSeedbarBV,
            priceTextbarBV: packagebarBV.priceTextbarBV,
            coinAmountbarBV: packagebarBV.coinAmountbarBV,
            createdAtbarBV: Date(),
            typebarBV: "appleIAPPurchasebarBV"
        )
        coinTransactionsbarBV.append(transactionbarBV)
        persistCoinBalancebarBV()
        persistCoinTransactionsbarBV()
        persistCoinPurchaseSeedsbarBV()
        return (coinBalance, true)
    }

    func pendingRequestsbarBV() -> [contactRequestbarBV] {
        contactRequestsbarBV.filter {
            $0.requestTypebarBV == .pendingRequestbarBV && $0.statusbarBV == .pendingStatusbarBV
        }
    }

    func sentRequestsbarBV() -> [contactRequestbarBV] {
        contactRequestsbarBV.filter {
            $0.requestTypebarBV == .sentRequestbarBV && $0.statusbarBV == .pendingStatusbarBV
        }
    }

    @discardableResult
    func acceptRequestbarBV(_ requestbarBV: contactRequestbarBV) -> trustedContact? {
        guard let indexbarBV = contactRequestsbarBV.firstIndex(where: { $0.requestSeedbarBV == requestbarBV.requestSeedbarBV }) else { return nil }
        contactRequestsbarBV[indexbarBV].statusbarBV = .acceptedStatusbarBV
        if let existingbarBV = contactPoolbarBV.first(where: { $0.placeholderNamebarBV == requestbarBV.namebarBV }) {
            _ = threadForContactbarBV(contactbarBV: existingbarBV)
            persistContactStatebarBV()
            return existingbarBV
        }
        let contactbarBV = trustedContact(
            contactSeed: UUID(),
            placeholderNamebarBV: requestbarBV.namebarBV,
            placeholderNotebarBV: requestbarBV.sourceTextbarBV,
            groupFilter: .friendFilter,
            placeholderAvatar: requestbarBV.avatarbarBV,
            onlineFlagbarBV: false,
            blockFlag: false,
            pinFlagbarBV: false
        )
        contactPoolbarBV.append(contactbarBV)
        _ = threadForContactbarBV(contactbarBV: contactbarBV)
        persistContactStatebarBV()
        return contactbarBV
    }

    func rejectRequestbarBV(_ requestbarBV: contactRequestbarBV) {
        guard let indexbarBV = contactRequestsbarBV.firstIndex(where: { $0.requestSeedbarBV == requestbarBV.requestSeedbarBV }) else { return }
        contactRequestsbarBV[indexbarBV].statusbarBV = .rejectedStatusbarBV
        persistContactStatebarBV()
    }

    func cancelRequestbarBV(_ requestbarBV: contactRequestbarBV) {
        guard let indexbarBV = contactRequestsbarBV.firstIndex(where: { $0.requestSeedbarBV == requestbarBV.requestSeedbarBV }) else { return }
        contactRequestsbarBV[indexbarBV].statusbarBV = .cancelledStatusbarBV
        persistContactStatebarBV()
    }

    func replyQueuebarBV() -> [threadFixturebarBV] {
        threadPoolbarBV.filter { $0.unreadCounter > 0 }
    }

    func laterQueuebarBV(_ thread: threadFixturebarBV) {
        guard let queueCheckbarBV = threadPoolbarBV.firstIndex(where: { $0.threadSeed == thread.threadSeed }) else { return }
        let threadFlowbarBV = threadPoolbarBV.remove(at: queueCheckbarBV)
        threadPoolbarBV.append(threadFlowbarBV)
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
        guard !styleUnlock.contains(tone), spendCoinsbarBV(amountbarBV: 400, typebarBV: "aiToneUnlockbarBV") else { return false }
        styleUnlock.insert(tone)
        persistReplyToneUnlockbarBV()
        _ = selectReplyTonebarBV(tone)
        return true
    }

    func blockedFlagbarBV(contactSeedbarBV: UUID) -> Bool {
        blockedUsersbarBV.contains { $0.contactSeedbarBV == contactSeedbarBV }
    }

    @discardableResult
    func blockUserbarBV(contactbarBV: trustedContact) -> blockedUserbarBV {
        let blockedbarBV: blockedUserbarBV
        if let currentbarBV = blockedUsersbarBV.first(where: { $0.contactSeedbarBV == contactbarBV.contactSeed }) {
            blockedbarBV = currentbarBV
        } else {
            blockedbarBV = blockedUserbarBV(
                contactSeedbarBV: contactbarBV.contactSeed,
                namebarBV: contactbarBV.placeholderNamebarBV,
                avatarbarBV: contactbarBV.placeholderAvatar,
                blockedAtbarBV: Date()
            )
            blockedUsersbarBV.append(blockedbarBV)
        }

        purgeContactFootprintbarBV(contactSeedbarBV: contactbarBV.contactSeed)
        persistContactStatebarBV()
        return blockedbarBV
    }

    func unblockUserbarBV(_ blockedbarBV: blockedUserbarBV) {
        blockedUsersbarBV.removeAll { $0.contactSeedbarBV == blockedbarBV.contactSeedbarBV }
        if let indexbarBV = contactPoolbarBV.firstIndex(where: { $0.contactSeed == blockedbarBV.contactSeedbarBV }) {
            contactPoolbarBV[indexbarBV].blockFlag = false
        }
        persistContactStatebarBV()
    }

    @discardableResult
    func submitReportbarBV(
        threadbarBV: threadFixturebarBV,
        messagebarBV: messageFixturebarBV?,
        contactbarBV: trustedContact?,
        reasonbarBV: reportReasonbarBV,
        detailsbarBV: String
    ) -> reportRecordbarBV {
        let recordbarBV = reportRecordbarBV(
            reportSeedbarBV: UUID(),
            threadSeedbarBV: threadbarBV.threadSeed,
            messageSeedbarBV: messagebarBV?.messageSeed,
            contactSeedbarBV: contactbarBV?.contactSeed,
            reasonTextbarBV: reasonbarBV.rawValue,
            detailTextbarBV: detailsbarBV,
            createdAtbarBV: Date()
        )
        reportRecordsbarBV.append(recordbarBV)
        return recordbarBV
    }

    @discardableResult
    func submitGroupReportbarBV(
        threadbarBV: threadFixturebarBV,
        messagebarBV: messageFixturebarBV?,
        reasonbarBV: groupReportReasonbarBV,
        hiddenNamebarBV: Bool
    ) -> groupReportRecordbarBV {
        let recordbarBV = groupReportRecordbarBV(
            reportSeedbarBV: UUID(),
            threadSeedbarBV: threadbarBV.threadSeed,
            messageSeedbarBV: messagebarBV?.messageSeed,
            reasonTextbarBV: reasonbarBV.rawValue,
            hiddenNamebarBV: hiddenNamebarBV,
            createdAtbarBV: Date()
        )
        groupReportRecordsbarBV.append(recordbarBV)
        return recordbarBV
    }

    private func restoreContactStatebarBV() {
        guard let databarBV = UserDefaults.standard.data(forKey: contactStateKeybarBV),
              let snapshotbarBV = try? JSONDecoder().decode(contactStateSnapshotbarBV.self, from: databarBV) else {
            return
        }
        contactPoolbarBV = snapshotbarBV.contactsbarBV
        contactRequestsbarBV = snapshotbarBV.requestsbarBV
        blockedUsersbarBV = snapshotbarBV.blockedbarBV
        mutedContactsbarBV = Set(snapshotbarBV.mutedSeedsbarBV)
        for blockedbarBV in blockedUsersbarBV {
            purgeContactFootprintbarBV(contactSeedbarBV: blockedbarBV.contactSeedbarBV)
        }
    }

    private func restorePersonalStatebarBV() {
        if UserDefaults.standard.object(forKey: coinBalanceKeybarBV) != nil {
            coinBalance = UserDefaults.standard.integer(forKey: coinBalanceKeybarBV)
        } else {
            persistCoinBalancebarBV()
        }
        if let databarBV = UserDefaults.standard.data(forKey: coinTransactionsKeybarBV),
           let recordsbarBV = try? JSONDecoder().decode([coinTransactionbarBV].self, from: databarBV) {
            coinTransactionsbarBV = recordsbarBV
        }
        if let seedsbarBV = UserDefaults.standard.array(forKey: coinPurchaseSeedKeybarBV) as? [String] {
            coinPurchaseSeedsbarBV = Set(seedsbarBV)
        }
        if let stylebarBV = UserDefaults.standard.string(forKey: selectedStyleKeybarBV), !stylebarBV.isEmpty {
            selectedAIStylebarBV = stylebarBV
        }
        if let toneRawbarBV = UserDefaults.standard.string(forKey: selectedReplyToneKeybarBV),
           let tonebarBV = replyStylebarBV(rawValue: toneRawbarBV) {
            selectedReplyTonebarBV = tonebarBV
        }
        if let toneRawPoolbarBV = UserDefaults.standard.array(forKey: unlockedReplyToneKeybarBV) as? [String] {
            let restoredbarBV = toneRawPoolbarBV.compactMap { replyStylebarBV(rawValue: $0) }
            styleUnlock.formUnion(restoredbarBV)
        } else {
            persistReplyToneUnlockbarBV()
        }
        if let databarBV = UserDefaults.standard.data(forKey: notificationSettingsKeybarBV),
           let settingsbarBV = try? JSONDecoder().decode(notificationSettingsbarBV.self, from: databarBV) {
            notificationSettingsFlowbarBV = settingsbarBV
        } else {
            persistNotificationSettingsbarBV()
        }
        if let databarBV = UserDefaults.standard.data(forKey: privacySettingsKeybarBV),
           let settingsbarBV = try? JSONDecoder().decode(privacySettingsbarBV.self, from: databarBV) {
            privacySettingsFlowbarBV = settingsbarBV
        } else {
            persistPrivacySettingsbarBV()
        }
    }

    private func persistCoinBalancebarBV() {
        UserDefaults.standard.set(coinBalance, forKey: coinBalanceKeybarBV)
    }

    private func persistCoinTransactionsbarBV() {
        guard let databarBV = try? JSONEncoder().encode(coinTransactionsbarBV) else { return }
        UserDefaults.standard.set(databarBV, forKey: coinTransactionsKeybarBV)
    }

    private func persistCoinPurchaseSeedsbarBV() {
        UserDefaults.standard.set(Array(coinPurchaseSeedsbarBV), forKey: coinPurchaseSeedKeybarBV)
    }

    private func persistReplyToneUnlockbarBV() {
        UserDefaults.standard.set(styleUnlock.map(\.rawValue), forKey: unlockedReplyToneKeybarBV)
    }

    private func persistNotificationSettingsbarBV() {
        guard let databarBV = try? JSONEncoder().encode(notificationSettingsFlowbarBV) else { return }
        UserDefaults.standard.set(databarBV, forKey: notificationSettingsKeybarBV)
    }

    private func persistPrivacySettingsbarBV() {
        guard let databarBV = try? JSONEncoder().encode(privacySettingsFlowbarBV) else { return }
        UserDefaults.standard.set(databarBV, forKey: privacySettingsKeybarBV)
    }

    private func beginCoinPurchaseUpdatesbarBV() {
        coinUpdateTaskbarBV?.cancel()
        coinUpdateTaskbarBV = Task { @MainActor [weak self] in
            for await verificationbarBV in Transaction.updates {
                guard let self else { return }
                guard case .verified(let transactionbarBV) = verificationbarBV else { continue }
                self.applyCoinPurchasebarBV(
                    productSeedbarBV: transactionbarBV.productID,
                    purchaseSeedbarBV: "\(transactionbarBV.id)"
                )
                await transactionbarBV.finish()
            }
        }
    }

    private func applyCoinPurchasebarBV(productSeedbarBV: String, purchaseSeedbarBV: String) {
        guard let packagebarBV = coinPackagesbarBV().first(where: { $0.productSeedbarBV == productSeedbarBV }) else { return }
        grantPurchasedCoinsbarBV(packagebarBV: packagebarBV, purchaseSeedbarBV: purchaseSeedbarBV)
    }

    private func persistContactStatebarBV() {
        let snapshotbarBV = contactStateSnapshotbarBV(
            contactsbarBV: contactPoolbarBV,
            requestsbarBV: contactRequestsbarBV,
            blockedbarBV: blockedUsersbarBV,
            mutedSeedsbarBV: Array(mutedContactsbarBV)
        )
        guard let databarBV = try? JSONEncoder().encode(snapshotbarBV) else { return }
        UserDefaults.standard.set(databarBV, forKey: contactStateKeybarBV)
    }

    private func purgeContactFootprintbarBV(contactSeedbarBV: UUID) {
        contactPoolbarBV.removeAll { $0.contactSeed == contactSeedbarBV }
        mutedContactsbarBV.remove(contactSeedbarBV)

        let removedThreadSeedsbarBV = threadPoolbarBV
            .filter { !$0.smallGroupFlag && $0.personaPoolbarBV.contains(contactSeedbarBV) }
            .map(\.threadSeed)
        for threadSeedbarBV in removedThreadSeedsbarBV {
            messagePoolbarBV.removeValue(forKey: threadSeedbarBV)
        }

        threadPoolbarBV.removeAll { threadbarBV in
            !threadbarBV.smallGroupFlag && threadbarBV.personaPoolbarBV.contains(contactSeedbarBV)
        }

        for indexbarBV in threadPoolbarBV.indices {
            guard threadPoolbarBV[indexbarBV].personaPoolbarBV.contains(contactSeedbarBV) else { continue }
            threadPoolbarBV[indexbarBV].personaPoolbarBV.removeAll { $0 == contactSeedbarBV }
            messagePoolbarBV[threadPoolbarBV[indexbarBV].threadSeed]?.removeAll { $0.personaSeed == contactSeedbarBV }
            if threadPoolbarBV[indexbarBV].personaPoolbarBV.isEmpty {
                threadPoolbarBV[indexbarBV].unreadCounter = 0
            }
        }

        let emptyGroupSeedsbarBV = threadPoolbarBV
            .filter { $0.smallGroupFlag && $0.personaPoolbarBV.isEmpty }
            .map(\.threadSeed)
        threadPoolbarBV.removeAll { $0.smallGroupFlag && $0.personaPoolbarBV.isEmpty }
        for threadSeedbarBV in emptyGroupSeedsbarBV {
            messagePoolbarBV.removeValue(forKey: threadSeedbarBV)
        }
    }

    private func stableSeedbarBV(_ uuidbarBV: String) -> UUID {
        UUID(uuidString: uuidbarBV) ?? UUID()
    }

    private func seedFlow() {
        let quietFriend = trustedContact(contactSeed: stableSeedbarBV("10000000-0000-4000-8000-000000000001"), placeholderNamebarBV: "Mia Tanaka", placeholderNotebarBV: "College, the quiet one", groupFilter: .friendFilter, placeholderAvatar: "M", onlineFlagbarBV: true, blockFlag: false, pinFlagbarBV: true)
        let climbingBuddy = trustedContact(contactSeed: stableSeedbarBV("10000000-0000-4000-8000-000000000002"), placeholderNamebarBV: "Kallisto", placeholderNotebarBV: "Climbing buddy", groupFilter: .friendFilter, placeholderAvatar: "K", onlineFlagbarBV: true, blockFlag: false, pinFlagbarBV: false)
        let readingFriend = trustedContact(contactSeed: stableSeedbarBV("10000000-0000-4000-8000-000000000003"), placeholderNamebarBV: "Lena Brooks", placeholderNotebarBV: "Reads every margin note", groupFilter: .friendFilter, placeholderAvatar: "L", onlineFlagbarBV: true, blockFlag: false, pinFlagbarBV: false)
        let teaFriend = trustedContact(contactSeed: stableSeedbarBV("10000000-0000-4000-8000-000000000004"), placeholderNamebarBV: "Ava Reed", placeholderNotebarBV: "Keeps the reading room calm", groupFilter: .friendFilter, placeholderAvatar: "A", onlineFlagbarBV: true, blockFlag: false, pinFlagbarBV: false)
        let parentPersona = trustedContact(contactSeed: stableSeedbarBV("10000000-0000-4000-8000-000000000005"), placeholderNamebarBV: "Mom", placeholderNotebarBV: "Call her on Sundays", groupFilter: .familyFilterbarBV, placeholderAvatar: "M", onlineFlagbarBV: false, blockFlag: false, pinFlagbarBV: false)
        let caregiverRole = trustedContact(contactSeed: stableSeedbarBV("10000000-0000-4000-8000-000000000006"), placeholderNamebarBV: "Dad", placeholderNotebarBV: "Loves the garden", groupFilter: .familyFilterbarBV, placeholderAvatar: "D", onlineFlagbarBV: false, blockFlag: false, pinFlagbarBV: false)
        let siblingPersona = trustedContact(contactSeed: stableSeedbarBV("10000000-0000-4000-8000-000000000007"), placeholderNamebarBV: "Sis", placeholderNotebarBV: "Texting buddy", groupFilter: .familyFilterbarBV, placeholderAvatar: "S", onlineFlagbarBV: true, blockFlag: false, pinFlagbarBV: false)
        let weekendPlanner = trustedContact(contactSeed: stableSeedbarBV("10000000-0000-4000-8000-000000000008"), placeholderNamebarBV: "Lukas Nilsson", placeholderNotebarBV: "Weekend planner", groupFilter: .friendFilter, placeholderAvatar: "L", onlineFlagbarBV: true, blockFlag: false, pinFlagbarBV: false)
        let poetryPal = trustedContact(contactSeed: stableSeedbarBV("10000000-0000-4000-8000-000000000009"), placeholderNamebarBV: "Aiko", placeholderNotebarBV: "Poetry pen-pal", groupFilter: .friendFilter, placeholderAvatar: "A", onlineFlagbarBV: false, blockFlag: false, pinFlagbarBV: false)
        contactPoolbarBV = [parentPersona, caregiverRole, siblingPersona, quietFriend, climbingBuddy, readingFriend, teaFriend, weekendPlanner, poetryPal]
        contactRequestsbarBV = [
            contactRequestbarBV(
                requestSeedbarBV: stableSeedbarBV("20000000-0000-4000-8000-000000000001"),
                userIdbarBV: "jules-park-barBV",
                namebarBV: "Jules Park",
                avatarbarBV: "J",
                requestTypebarBV: .pendingRequestbarBV,
                sourceTextbarBV: "\"Hey, met at the workshop last week!\"",
                statusbarBV: .pendingStatusbarBV,
                createdAtbarBV: Date().addingTimeInterval(-7200)
            ),
            contactRequestbarBV(
                requestSeedbarBV: stableSeedbarBV("20000000-0000-4000-8000-000000000002"),
                userIdbarBV: "elena-vasquez-barBV",
                namebarBV: "Elena Vasquez",
                avatarbarBV: "E",
                requestTypebarBV: .pendingRequestbarBV,
                sourceTextbarBV: "From your phone contacts",
                statusbarBV: .pendingStatusbarBV,
                createdAtbarBV: Date().addingTimeInterval(-5400)
            ),
            contactRequestbarBV(
                requestSeedbarBV: stableSeedbarBV("20000000-0000-4000-8000-000000000003"),
                userIdbarBV: "tow-w-barBV",
                namebarBV: "Tow w",
                avatarbarBV: "T",
                requestTypebarBV: .sentRequestbarBV,
                sourceTextbarBV: "Sent yesterday · Awaiting confirmation",
                statusbarBV: .pendingStatusbarBV,
                createdAtbarBV: Date().addingTimeInterval(-86_400)
            )
        ]

        let privateThreadFlagbarBV = threadFixturebarBV(threadSeed: stableSeedbarBV("30000000-0000-4000-8000-000000000001"), localThreadTitle: "Mia Tanaka", personaPoolbarBV: [quietFriend.contactSeed], smallGroupFlag: false, unreadCounter: 1, pinFlagbarBV: true)
        let smallGroupFlag = threadFixturebarBV(threadSeed: stableSeedbarBV("30000000-0000-4000-8000-000000000002"), localThreadTitle: "Sunday Slow Reading", personaPoolbarBV: [quietFriend.contactSeed, readingFriend.contactSeed, climbingBuddy.contactSeed, teaFriend.contactSeed], smallGroupFlag: true, unreadCounter: 2, pinFlagbarBV: false)
        let familyThread = threadFixturebarBV(threadSeed: stableSeedbarBV("30000000-0000-4000-8000-000000000003"), localThreadTitle: "Mom", personaPoolbarBV: [parentPersona.contactSeed], smallGroupFlag: false, unreadCounter: 1, pinFlagbarBV: false)
        threadPoolbarBV = [privateThreadFlagbarBV, smallGroupFlag, familyThread]

        messagePoolbarBV[privateThreadFlagbarBV.threadSeed] = [
            messageFixturebarBV(messageSeed: UUID(), threadSeed: privateThreadFlagbarBV.threadSeed, personaSeed: quietFriend.contactSeed, localMessageText: "Hey, did you finish the book I lent you?", localMessageType: .textBubblebarBV, localMessageTime: Date().addingTimeInterval(-7000), sentFlag: false),
            messageFixturebarBV(messageSeed: UUID(), threadSeed: privateThreadFlagbarBV.threadSeed, personaSeed: profileSeedletbarBV, localMessageText: "Almost. The last chapter is heavy.", localMessageType: .textBubblebarBV, localMessageTime: Date().addingTimeInterval(-6800), sentFlag: true),
            messageFixturebarBV(messageSeed: UUID(), threadSeed: privateThreadFlagbarBV.threadSeed, personaSeed: profileSeedletbarBV, localMessageText: "Reading corner", localMessageType: .imageBubblebarBV, localMessageTime: Date().addingTimeInterval(-5200), sentFlag: true),
            messageFixturebarBV(messageSeed: UUID(), threadSeed: privateThreadFlagbarBV.threadSeed, personaSeed: quietFriend.contactSeed, localMessageText: "0:18", localMessageType: .voiceBubblebarBV, localMessageTime: Date().addingTimeInterval(-4100), sentFlag: false),
            messageFixturebarBV(messageSeed: UUID(), threadSeed: privateThreadFlagbarBV.threadSeed, personaSeed: quietFriend.contactSeed, localMessageText: "I've been feeling a little tired lately. Hope you're doing okay...", localMessageType: .textBubblebarBV, localMessageTime: Date().addingTimeInterval(-1200), sentFlag: false)
        ]
        messagePoolbarBV[smallGroupFlag.threadSeed] = [
            messageFixturebarBV(messageSeed: UUID(), threadSeed: smallGroupFlag.threadSeed, personaSeed: quietFriend.contactSeed, localMessageText: "Are we still reading chapter five tonight?", localMessageType: .textBubblebarBV, localMessageTime: Date().addingTimeInterval(-3600), sentFlag: false),
            messageFixturebarBV(messageSeed: UUID(), threadSeed: smallGroupFlag.threadSeed, personaSeed: readingFriend.contactSeed, localMessageText: "Yes, I marked a few lines I really liked.", localMessageType: .textBubblebarBV, localMessageTime: Date().addingTimeInterval(-3000), sentFlag: false),
            messageFixturebarBV(messageSeed: UUID(), threadSeed: smallGroupFlag.threadSeed, personaSeed: profileSeedletbarBV, localMessageText: "I'll join after dinner.", localMessageType: .textBubblebarBV, localMessageTime: Date().addingTimeInterval(-2500), sentFlag: true),
            messageFixturebarBV(messageSeed: UUID(), threadSeed: smallGroupFlag.threadSeed, personaSeed: climbingBuddy.contactSeed, localMessageText: "Great, see you all later.", localMessageType: .textBubblebarBV, localMessageTime: Date().addingTimeInterval(-900), sentFlag: false)
        ]
        messagePoolbarBV[familyThread.threadSeed] = [
            messageFixturebarBV(messageSeed: UUID(), threadSeed: familyThread.threadSeed, personaSeed: parentPersona.contactSeed, localMessageText: "Are you eating well this week?", localMessageType: .textBubblebarBV, localMessageTime: Date().addingTimeInterval(-1400), sentFlag: false)
        ]
    }
}
