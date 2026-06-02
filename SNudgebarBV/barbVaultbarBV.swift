import Foundation
import StoreKit

final class barbVaultbarBV {
    static let shared = barbVaultbarBV()

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
    private(set) var coinBalance = 0
    private(set) var coinTransactionsbarBV: [coinTransactionbarBV] = []
    private var coinPurchaseSeedsbarBV: Set<String> = []
    private(set) var selectedAIStylebarBV = "gentle"
    private(set) var selectedReplyTonebarBV: replyStylebarBV = .replyToneWarm
    private(set) var notificationSettingsFlowbarBV = notificationSettingsbarBV.defaultStatebarBV
    private(set) var privacySettingsFlowbarBV = privacySettingsbarBV.defaultStatebarBV
    private var coinUpdateTaskbarBV: Task<Void, Never>?

    private init() {
        restorePersonalStatebarBV()
        reloadAccountScopebarBV()
        beginCoinPurchaseUpdatesbarBV()
    }

    func reloadAccountScopebarBV() {
        restorePersonalStatebarBV()
        if BaurbsessionStore.seedAccountFlagbarBV {
            seedFlow()
            restoreContactStatebarBV()
        } else {
            clearPreviewDatabarBV()
        }
    }

    func messagePool(for thread: threadFixturebarBV) -> [messageFixturebarBV] {
        messagePoolbarBV[thread.threadSeed, default: []].sorted { $0.messageMomentbarBV < $1.messageMomentbarBV }
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
            threadTitlebarBV: contactbarBV.placeholderNamebarBV,
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
                messageCopybarBV: "Glad we're connected here.",
                messageFormbarBV: .textBubblebarBV,
                messageMomentbarBV: Date().addingTimeInterval(-300),
                sentFlag: false
            )
        ]
        return threadbarBV
    }

    func threadPreviewbarBV(for thread: threadFixturebarBV) -> messageFixturebarBV? {
        messagePool(for: thread).last
    }

    func groupMemberCountbarBV(for thread: threadFixturebarBV) -> Int {
        thread.smallGroupFlag ? thread.personaPoolbarBV.count + 1 : thread.personaPoolbarBV.count
    }

    func previewTextbarBV(for thread: threadFixturebarBV) -> String {
        guard let latestbarBV = threadPreviewbarBV(for: thread) else {
            return thread.smallGroupFlag ? "\(groupMemberCountbarBV(for: thread)) members" : ""
        }
        guard thread.smallGroupFlag else { return latestbarBV.messageCopybarBV }
        if latestbarBV.sentFlag {
            return "You: \(latestbarBV.messageCopybarBV)"
        }
        let senderbarBV = contactMatcherbarBV(contactSeed: latestbarBV.personaSeed)?.placeholderNamebarBV.components(separatedBy: " ").first ?? "Member"
        return "\(senderbarBV): \(latestbarBV.messageCopybarBV)"
    }

    func contactCardFlowbarBV() -> contactCardbarBV {
        let profilebarBV = BaurbsessionStore.profileSnapshotbarBV
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
            userIdbarBV: profilebarBV?.emailEntry ?? "barb-user-barBV",
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
        UserDefaults.standard.set(tonebarBV.rawValue, forKey: accountStorageKeybarBV(selectedReplyToneKeybarBV))
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
            priceTextbarBV: "coins",
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

    func sendButton(_ messageCopybarBV: String, in thread: threadFixturebarBV) {
        let messageFixture = messageFixturebarBV(
            messageSeed: UUID(),
            threadSeed: thread.threadSeed,
            personaSeed: profileSeedletbarBV,
            messageCopybarBV: messageCopybarBV,
            messageFormbarBV: .textBubblebarBV,
            messageMomentbarBV: Date(),
            sentFlag: true
        )
        messagePoolbarBV[thread.threadSeed, default: []].append(messageFixture)
        if let queueCheckbarBV = threadPoolbarBV.firstIndex(where: { $0.threadSeed == thread.threadSeed }) {
            threadPoolbarBV[queueCheckbarBV].unreadCounter = 0
        }
    }

    func generatedDraftbarBV(for messageFixture: messageFixturebarBV, tone: replyStylebarBV, variantbarBV: Int? = nil) -> String {
        let poolbarBV = replyDraftPoolbarBV(for: messageFixture, tonebarBV: tone)
        guard !poolbarBV.isEmpty else { return "" }
        if let variantbarBV {
            return poolbarBV[abs(variantbarBV) % poolbarBV.count]
        }
        return poolbarBV.randomElement() ?? poolbarBV[0]
    }

    private func replyDraftPoolbarBV(for messageFixturebarBV: messageFixturebarBV, tonebarBV: replyStylebarBV) -> [String] {
        let contextHintbarBV = messageFixturebarBV.messageCopybarBV.lowercased()
        let tiredContextbarBV = contextHintbarBV.contains("tired") || contextHintbarBV.contains("heavy")
        let bookContextbarBV = contextHintbarBV.contains("book") || contextHintbarBV.contains("page") || contextHintbarBV.contains("chapter")
        switch tonebarBV {
        case .replyToneShortbarBV:
            return [
                tiredContextbarBV ? "That sounds tough. Get some rest." : "Got it. I'll reply soon.",
                "I hear you. Take it easy.",
                "That makes sense. Rest up.",
                "Thanks for telling me.",
                "No worries. I'm here.",
                "Sure, I understand.",
                bookContextbarBV ? "Yes, I'll send the pages." : "I'll get back to you soon.",
                "That sounds like a lot.",
                "Please take care tonight.",
                "Okay. Message me when you can.",
                "I get it. Let's talk later.",
                "Thanks. I'll keep it in mind."
            ]
        case .replyTonePolite:
            return [
                tiredContextbarBV ? "I'm sorry to hear that. I hope you can rest well, and I'm here if you need anything." : "Thank you for letting me know. I'll get back to you shortly.",
                "Thank you for telling me. I really appreciate you sharing that with me.",
                "I'm sorry that feels heavy right now. I hope tonight gives you some room to rest.",
                "Of course. Please take the time you need, and let me know if I can help.",
                bookContextbarBV ? "Of course. I'll share the page numbers in a moment." : "That works for me. Thanks for letting me know.",
                "I understand. Please don't feel pressured to reply quickly.",
                "Thanks for being open with me. I hope things feel a little easier soon.",
                "I'm here if you would like to talk more about it.",
                "Please take care of yourself first. We can talk whenever you're ready.",
                "I appreciate the update. I hope you feel better soon.",
                "That sounds difficult. I hope you can get some proper rest.",
                "Thank you. I'll be around if you need anything."
            ]
        case .replyToneGentlebarBV:
            return [
                "That sounds really tiring. I hope you can rest tonight, and I'm right here if you want to talk.",
                "I'm sorry today has felt heavy. Please be gentle with yourself tonight.",
                "You don't have to answer perfectly. I'm just glad you told me.",
                "Take your time. I'll be here when you feel like talking.",
                "That sounds like a lot to carry. I hope you get a softer evening.",
                "I'm sending you a calm thought. Rest first, reply later.",
                "No pressure at all. I care about how you're doing.",
                "I hear you. Let's keep this easy tonight.",
                bookContextbarBV ? "I'll send the pages gently, no rush to read them tonight." : "I hope you can slow down a little and breathe.",
                "Thank you for trusting me with that.",
                "Please take the space you need. I'm not going anywhere.",
                "Let's talk when it feels lighter."
            ]
        case .replyToneCheerful:
            return [
                "Oof, that sounds like a lot. I hope you get a cozy reset tonight.",
                "Rest mode sounds very deserved right now.",
                "You've done enough for today. Please recharge a little.",
                "I hear you. Tiny break, warm drink, no pressure.",
                "That chapter sounds intense. We can totally talk it through later.",
                "Sending you a little energy boost from here.",
                "Take tonight slow. Tomorrow can be easier.",
                "Thanks for telling me. I'm rooting for you.",
                "No rush at all. Rest first, messages later.",
                "That sounds draining. Hope your evening gets lighter.",
                "Let's keep it simple tonight. I'm here.",
                "You deserve a quiet reset."
            ]
        case .replyToneCaringbarBV:
            return [
                "I'm really sorry you're feeling this way. Please rest, and tell me if you want company.",
                "That sounds exhausting. I care about you, so please take it slow tonight.",
                "I'm here with you. You don't have to hold it all alone.",
                "Thank you for telling me. I want to understand what you need.",
                "Please take care of yourself first. We can talk whenever you're ready.",
                "That sounds heavy. I hope you can get some comfort tonight.",
                "Do you want to talk, or would resting quietly feel better?",
                "I'm glad you said something. I care about how you're doing.",
                "I wish I could make it easier. I'm here either way.",
                "You don't need to pretend you're okay with me.",
                "Please message me if the night feels too much.",
                "Let's take this one small step at a time."
            ]
        case .replyToneApology:
            return [
                "I'm sorry if I added to that. I care about you and want to do better.",
                "I'm sorry you're feeling so tired. I should have checked in more gently.",
                "You're right to say that. I'm sorry, and I want to understand.",
                "I'm sorry for making this harder. Please take the space you need.",
                "I didn't mean to dismiss you. I'm sorry, and I'm listening now.",
                "I'm sorry. I can see why that felt heavy.",
                "Thank you for telling me. I'm sorry I didn't catch it sooner.",
                "I'm sorry for the way that came across. I care about fixing it.",
                "I hear you. I'm sorry, and I'll be more thoughtful.",
                "I'm sorry. Let's slow down and talk when you're ready.",
                "I should have been more careful with my words. I'm sorry.",
                "I'm sorry you're carrying that. I want to support you better."
            ]
        case .replyToneBoundarybarBV:
            return [
                "I hear you, and I care. I need a little time before I can reply properly.",
                "That sounds hard. I can talk later tonight, but I need to rest first.",
                "I want to be present for this, so I'll reply when I have the space.",
                "I understand. I can't solve it right now, but I can listen later.",
                "I'm here for you, and I also need to keep tonight quiet.",
                "Thanks for telling me. I need a moment before I respond fully.",
                "I care about this. Let's talk when we're both less tired.",
                "I don't want to rush my reply, so I'll come back to this soon.",
                "I hear you. I can check in later, not right this second.",
                "This matters to me. I need some space to answer well.",
                "I can support you, but I need to set a calmer pace tonight.",
                "Let's pause for a bit and pick this up soon."
            ]
        case .replyToneProfessionalbarBV:
            return [
                "Thanks for sharing that. Please take the time you need, and let me know how I can help.",
                "I understand. I hope you're able to rest and reset soon.",
                "Thank you for the update. We can revisit this when you're feeling better.",
                "That sounds difficult. Please prioritize rest for now.",
                "I appreciate you letting me know. I'm available if you need support.",
                "Understood. Let's continue when you have more energy.",
                "Thanks for being transparent. Please take care of yourself.",
                bookContextbarBV ? "Thanks. I'll share the relevant pages shortly." : "I understand the situation. Please keep me posted.",
                "That makes sense. We can follow up later.",
                "I hope things settle soon. Let me know what would be useful.",
                "Thanks for the context. No immediate response needed.",
                "Please take the space you need. We can reconnect afterward."
            ]
        case .replyToneWarm:
            return [
                tiredContextbarBV ? "That sounds really tiring. I hope you can get some rest tonight, and I'm here if you want to talk." : "Thanks for telling me. I appreciate it, and I'll reply properly in a moment.",
                "I'm sorry things feel heavy. I hope tonight gives you a little breathing room.",
                "That sounds like a lot. Please take it easy, and tell me if you want to talk.",
                "I hear you. Rest first, and message me whenever you feel up to it.",
                "Thanks for sharing that with me. I'm here and I care.",
                "No pressure to explain everything right now. I just hope you feel a bit better soon.",
                bookContextbarBV ? "Sure, I can share them. Give me a moment and I'll send the page numbers." : "I'm glad you told me. Let's keep the conversation easy.",
                "That must feel draining. I hope you get a quiet reset tonight.",
                "I wish I could make it lighter. I'm here if you need a listening ear.",
                "Please take care of yourself tonight. We can talk whenever you're ready.",
                "That sounds tough. I'm sending you a little calm from here.",
                "I'm here with you. You don't have to answer right away."
            ]
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

    private func clearPreviewDatabarBV() {
        contactPoolbarBV.removeAll()
        threadPoolbarBV.removeAll()
        messagePoolbarBV.removeAll()
        contactRequestsbarBV.removeAll()
        blockedUsersbarBV.removeAll()
        mutedContactsbarBV.removeAll()
        reportRecordsbarBV.removeAll()
        groupReportRecordsbarBV.removeAll()
    }

    private func accountSuffixbarBV() -> String {
        let emailbarBV = BaurbsessionStore.emailStatebarBV.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return emailbarBV.isEmpty ? "guestbarBV" : emailbarBV
    }

    private func accountStorageKeybarBV(_ basebarBV: String) -> String {
        "\(basebarBV).\(accountSuffixbarBV())"
    }

    private func restorePersonalStatebarBV() {
        let balanceKeybarBV = accountStorageKeybarBV(coinBalanceKeybarBV)
        let transactionKeybarBV = accountStorageKeybarBV(coinTransactionsKeybarBV)
        let purchaseKeybarBV = accountStorageKeybarBV(coinPurchaseSeedKeybarBV)
        if UserDefaults.standard.object(forKey: balanceKeybarBV) != nil {
            let storedBalancebarBV = UserDefaults.standard.integer(forKey: balanceKeybarBV)
            let purchaseRecordsMissingbarBV = UserDefaults.standard.data(forKey: transactionKeybarBV) == nil
                && UserDefaults.standard.array(forKey: purchaseKeybarBV) == nil
            if !BaurbsessionStore.seedAccountFlagbarBV, purchaseRecordsMissingbarBV, storedBalancebarBV > 0 {
                coinBalance = 0
                persistCoinBalancebarBV()
            } else {
                coinBalance = storedBalancebarBV
            }
        } else if BaurbsessionStore.seedAccountFlagbarBV, UserDefaults.standard.object(forKey: coinBalanceKeybarBV) != nil {
            coinBalance = UserDefaults.standard.integer(forKey: coinBalanceKeybarBV)
            persistCoinBalancebarBV()
        } else {
            coinBalance = BaurbsessionStore.seedAccountFlagbarBV ? 2222 : 0
            persistCoinBalancebarBV()
        }
        if let databarBV = UserDefaults.standard.data(forKey: transactionKeybarBV),
           let recordsbarBV = try? JSONDecoder().decode([coinTransactionbarBV].self, from: databarBV) {
            coinTransactionsbarBV = recordsbarBV
        } else if BaurbsessionStore.seedAccountFlagbarBV,
                  let databarBV = UserDefaults.standard.data(forKey: coinTransactionsKeybarBV),
                  let recordsbarBV = try? JSONDecoder().decode([coinTransactionbarBV].self, from: databarBV) {
            coinTransactionsbarBV = recordsbarBV
            persistCoinTransactionsbarBV()
        } else {
            coinTransactionsbarBV = []
        }
        if let seedsbarBV = UserDefaults.standard.array(forKey: purchaseKeybarBV) as? [String] {
            coinPurchaseSeedsbarBV = Set(seedsbarBV)
        } else if BaurbsessionStore.seedAccountFlagbarBV,
                  let seedsbarBV = UserDefaults.standard.array(forKey: coinPurchaseSeedKeybarBV) as? [String] {
            coinPurchaseSeedsbarBV = Set(seedsbarBV)
            persistCoinPurchaseSeedsbarBV()
        } else {
            coinPurchaseSeedsbarBV = []
        }
        if let stylebarBV = UserDefaults.standard.string(forKey: selectedStyleKeybarBV), !stylebarBV.isEmpty {
            selectedAIStylebarBV = stylebarBV
        }
        styleUnlock = [.replyToneWarm, .replyToneShortbarBV, .replyTonePolite]
        selectedReplyTonebarBV = .replyToneWarm
        let selectedToneKeybarBV = accountStorageKeybarBV(selectedReplyToneKeybarBV)
        let unlockedToneKeybarBV = accountStorageKeybarBV(unlockedReplyToneKeybarBV)
        if let toneRawPoolbarBV = UserDefaults.standard.array(forKey: unlockedToneKeybarBV) as? [String] {
            let restoredbarBV = toneRawPoolbarBV.compactMap { replyStylebarBV(rawValue: $0) }
            styleUnlock.formUnion(restoredbarBV)
        } else if BaurbsessionStore.seedAccountFlagbarBV,
                  let toneRawPoolbarBV = UserDefaults.standard.array(forKey: unlockedReplyToneKeybarBV) as? [String] {
            let restoredbarBV = toneRawPoolbarBV.compactMap { replyStylebarBV(rawValue: $0) }
            styleUnlock.formUnion(restoredbarBV)
            persistReplyToneUnlockbarBV()
        } else {
            persistReplyToneUnlockbarBV()
        }
        if let toneRawbarBV = UserDefaults.standard.string(forKey: selectedToneKeybarBV),
           let tonebarBV = replyStylebarBV(rawValue: toneRawbarBV),
           styleUnlock.contains(tonebarBV) {
            selectedReplyTonebarBV = tonebarBV
        } else if BaurbsessionStore.seedAccountFlagbarBV,
                  let toneRawbarBV = UserDefaults.standard.string(forKey: selectedReplyToneKeybarBV),
                  let tonebarBV = replyStylebarBV(rawValue: toneRawbarBV),
                  styleUnlock.contains(tonebarBV) {
            selectedReplyTonebarBV = tonebarBV
            UserDefaults.standard.set(tonebarBV.rawValue, forKey: selectedToneKeybarBV)
        } else {
            UserDefaults.standard.set(selectedReplyTonebarBV.rawValue, forKey: selectedToneKeybarBV)
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
        UserDefaults.standard.set(coinBalance, forKey: accountStorageKeybarBV(coinBalanceKeybarBV))
    }

    private func persistCoinTransactionsbarBV() {
        guard let databarBV = try? JSONEncoder().encode(coinTransactionsbarBV) else { return }
        UserDefaults.standard.set(databarBV, forKey: accountStorageKeybarBV(coinTransactionsKeybarBV))
    }

    private func persistCoinPurchaseSeedsbarBV() {
        UserDefaults.standard.set(Array(coinPurchaseSeedsbarBV), forKey: accountStorageKeybarBV(coinPurchaseSeedKeybarBV))
    }

    private func persistReplyToneUnlockbarBV() {
        UserDefaults.standard.set(styleUnlock.map(\.rawValue), forKey: accountStorageKeybarBV(unlockedReplyToneKeybarBV))
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

        let privateThreadFlagbarBV = threadFixturebarBV(threadSeed: stableSeedbarBV("30000000-0000-4000-8000-000000000001"), threadTitlebarBV: "Mia Tanaka", personaPoolbarBV: [quietFriend.contactSeed], smallGroupFlag: false, unreadCounter: 1, pinFlagbarBV: true)
        let smallGroupFlag = threadFixturebarBV(threadSeed: stableSeedbarBV("30000000-0000-4000-8000-000000000002"), threadTitlebarBV: "Sunday Slow Reading", personaPoolbarBV: [quietFriend.contactSeed, readingFriend.contactSeed, climbingBuddy.contactSeed, teaFriend.contactSeed], smallGroupFlag: true, unreadCounter: 2, pinFlagbarBV: false)
        let familyThread = threadFixturebarBV(threadSeed: stableSeedbarBV("30000000-0000-4000-8000-000000000003"), threadTitlebarBV: "Mom", personaPoolbarBV: [parentPersona.contactSeed], smallGroupFlag: false, unreadCounter: 1, pinFlagbarBV: false)
        threadPoolbarBV = [privateThreadFlagbarBV, smallGroupFlag, familyThread]

        messagePoolbarBV[privateThreadFlagbarBV.threadSeed] = [
            messageFixturebarBV(messageSeed: UUID(), threadSeed: privateThreadFlagbarBV.threadSeed, personaSeed: quietFriend.contactSeed, messageCopybarBV: "Hey, did you finish the book I lent you?", messageFormbarBV: .textBubblebarBV, messageMomentbarBV: Date().addingTimeInterval(-7000), sentFlag: false),
            messageFixturebarBV(messageSeed: UUID(), threadSeed: privateThreadFlagbarBV.threadSeed, personaSeed: profileSeedletbarBV, messageCopybarBV: "Almost. The last chapter is heavy.", messageFormbarBV: .textBubblebarBV, messageMomentbarBV: Date().addingTimeInterval(-6800), sentFlag: true),
            messageFixturebarBV(messageSeed: UUID(), threadSeed: privateThreadFlagbarBV.threadSeed, personaSeed: quietFriend.contactSeed, messageCopybarBV: "I've been feeling a little tired lately. Hope you're doing okay...", messageFormbarBV: .textBubblebarBV, messageMomentbarBV: Date().addingTimeInterval(-1200), sentFlag: false)
        ]
        messagePoolbarBV[smallGroupFlag.threadSeed] = [
            messageFixturebarBV(messageSeed: UUID(), threadSeed: smallGroupFlag.threadSeed, personaSeed: quietFriend.contactSeed, messageCopybarBV: "Are we still reading chapter five tonight?", messageFormbarBV: .textBubblebarBV, messageMomentbarBV: Date().addingTimeInterval(-3600), sentFlag: false),
            messageFixturebarBV(messageSeed: UUID(), threadSeed: smallGroupFlag.threadSeed, personaSeed: readingFriend.contactSeed, messageCopybarBV: "Yes, I marked a few lines I really liked.", messageFormbarBV: .textBubblebarBV, messageMomentbarBV: Date().addingTimeInterval(-3000), sentFlag: false),
            messageFixturebarBV(messageSeed: UUID(), threadSeed: smallGroupFlag.threadSeed, personaSeed: profileSeedletbarBV, messageCopybarBV: "I'll join after dinner.", messageFormbarBV: .textBubblebarBV, messageMomentbarBV: Date().addingTimeInterval(-2500), sentFlag: true),
            messageFixturebarBV(messageSeed: UUID(), threadSeed: smallGroupFlag.threadSeed, personaSeed: climbingBuddy.contactSeed, messageCopybarBV: "Great, see you all later.", messageFormbarBV: .textBubblebarBV, messageMomentbarBV: Date().addingTimeInterval(-900), sentFlag: false)
        ]
        messagePoolbarBV[familyThread.threadSeed] = [
            messageFixturebarBV(messageSeed: UUID(), threadSeed: familyThread.threadSeed, personaSeed: parentPersona.contactSeed, messageCopybarBV: "Are you eating well this week?", messageFormbarBV: .textBubblebarBV, messageMomentbarBV: Date().addingTimeInterval(-1400), sentFlag: false)
        ]
    }
}
