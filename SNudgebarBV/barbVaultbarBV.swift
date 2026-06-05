import Foundation
import StoreKit
private struct CoinPackCipherbarBV {
    
    static func textbarBV(_ seedbarBV: [UInt8], keybarBV: UInt8 = 0x5A) -> String {
        let decodedbarBV = seedbarBV.map { $0 ^ keybarBV }
        return String(bytes: decodedbarBV, encoding: .utf8) ?? ""
    }
    
    static func amountbarBV(_ rawbarBV: Int, saltbarBV: Int) -> Int {
        return (rawbarBV ^ saltbarBV) - saltbarBV
    }
}
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
            shareLinkbarBV: "https://app.zt7ymojx.link/invite/barb-\(idbarBV)",
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
            coinPackagebarBV(packageSeedbarBV: "coinSeedTinybarBV", priceTextbarBV: CoinPackCipherbarBV.textbarBV([126, 106, 116, 99, 99]), coinAmountbarBV: CoinVaultbarBV.tinybarBV, productSeedbarBV: "zpahwfmgsqdenfzm", selectedFlagbarBV: selectedSeedbarBV == nil || selectedSeedbarBV == "coinSeedTinybarBV"),
            coinPackagebarBV(packageSeedbarBV: "coinSeedSmallbarBV", priceTextbarBV: CoinPackCipherbarBV.textbarBV([126, 107, 116, 99, 99]), coinAmountbarBV: CoinVaultbarBV.smallbarBV, productSeedbarBV: "atscffxokgxltmtg", selectedFlagbarBV: selectedSeedbarBV == "coinSeedSmallbarBV"),
            coinPackagebarBV(packageSeedbarBV: "coinSeedMediumbarBV", priceTextbarBV: CoinPackCipherbarBV.textbarBV([126, 105, 116, 99, 99]), coinAmountbarBV: CoinVaultbarBV.mediumbarBV, productSeedbarBV: "bdzffbuiokgxledhn", selectedFlagbarBV: selectedSeedbarBV == "coinSeedMediumbarBV"),
            coinPackagebarBV(packageSeedbarBV: "coinSeedPlusbarBV", priceTextbarBV: CoinPackCipherbarBV.textbarBV([126, 110, 116, 99, 99]), coinAmountbarBV: CoinVaultbarBV.plusbarBV, productSeedbarBV: "lyxwmsvcssjvfmbl", selectedFlagbarBV: selectedSeedbarBV == "coinSeedPlusbarBV"),
            coinPackagebarBV(packageSeedbarBV: "coinSeedBrightbarBV", priceTextbarBV: CoinPackCipherbarBV.textbarBV([126, 111, 116, 99, 99]), coinAmountbarBV: CoinVaultbarBV.brightbarBV, productSeedbarBV: "ksjnkjbfbrgubrhhet", selectedFlagbarBV: selectedSeedbarBV == "coinSeedBrightbarBV"),
            coinPackagebarBV(packageSeedbarBV: "coinSeedLargebarBV", priceTextbarBV: CoinPackCipherbarBV.textbarBV([126, 99, 116, 99, 99]), coinAmountbarBV: CoinVaultbarBV.largebarBV, productSeedbarBV: "qzilbdteuuclzugu", selectedFlagbarBV: selectedSeedbarBV == "coinSeedLargebarBV"),
            coinPackagebarBV(packageSeedbarBV: "coinSeedDeepbarBV", priceTextbarBV: CoinPackCipherbarBV.textbarBV([126, 107, 99, 116, 99, 99]), coinAmountbarBV: CoinVaultbarBV.deepbarBV, productSeedbarBV: "eistclsausdiozdv", selectedFlagbarBV: selectedSeedbarBV == "coinSeedDeepbarBV"),
            coinPackagebarBV(packageSeedbarBV: "coinSeedWidebarBV", priceTextbarBV: CoinPackCipherbarBV.textbarBV([126, 110, 99, 116, 99, 99]), coinAmountbarBV: CoinVaultbarBV.widebarBV, productSeedbarBV: "hgndagerljbzabzu", selectedFlagbarBV: selectedSeedbarBV == "coinSeedWidebarBV"),
            coinPackagebarBV(packageSeedbarBV: "coinSeedMaxbarBV", priceTextbarBV:CoinPackCipherbarBV.textbarBV([126, 99, 99, 116, 99, 99]), coinAmountbarBV: CoinVaultbarBV.maxbarBV, productSeedbarBV: "vvwmjkywykouceap", selectedFlagbarBV: selectedSeedbarBV == "coinSeedMaxbarBV")
        ]
    }
    private enum CoinVaultbarBV {
        
        
        
        static func coinbarBV(_ valuebarBV: Int) -> Int {
            return valuebarBV  - 113
        }
        
        static let tinybarBV = coinbarBV(513)
        static let smallbarBV = coinbarBV(913)
        static let mediumbarBV = coinbarBV(1763)
        static let plusbarBV = coinbarBV(2563)
        static let brightbarBV = coinbarBV(3363)
        static let largebarBV = coinbarBV(5263)
        static let deepbarBV = coinbarBV(10913)
        static let widebarBV = coinbarBV(29513)
        static let maxbarBV = coinbarBV(63813)
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

    private func replyCipherbarBV(_ payloadbarBV: String) -> String {
        guard let databarBV = Data(base64Encoded: payloadbarBV) else { return "" }
        let keybarBV: [UInt8] = [0x43, 0x19, 0x72, 0x2d, 0x5a, 0x07, 0x31, 0x68, 0x0c]
        let bytesbarBV = databarBV.enumerated().map { itembarBV in
            itembarBV.element ^ keybarBV[itembarBV.offset % keybarBV.count]
        }
        return String(bytes: bytesbarBV, encoding: .utf8) ?? ""
    }

    private func replyDraftPoolbarBV(for messageFixturebarBV: messageFixturebarBV, tonebarBV: replyStylebarBV) -> [String] {
        let contextHintbarBV = messageFixturebarBV.messageCopybarBV.lowercased()
        let tiredContextbarBV = contextHintbarBV.contains(replyCipherbarBV("N3AASD4=")) || contextHintbarBV.contains(replyCipherbarBV("K3wTWyM="))
        let bookContextbarBV = contextHintbarBV.contains(replyCipherbarBV("IXYdRg==")) || contextHintbarBV.contains(replyCipherbarBV("M3gVSA==")) || contextHintbarBV.contains(replyCipherbarBV("IHETXS5iQw=="))
        switch tonebarBV {
        case .replyToneShortbarBV:
            return [
                tiredContextbarBV ? replyCipherbarBV("F3ETWXp0Xh1iJ2pSWTVyVgAiY14XWXp0XgVpY2sXXi4p") : replyCipherbarBV("BHYGDTNzH0hFZHUeDShiQQR1Y2odQjQp"),
                replyCipherbarBV("CjkaSDt1ERFjNjdSeTtsVEhlNzkXTCl+Hw=="),
                replyCipherbarBV("F3ETWXpqUANpMDkBSDR0VEYsEXwBWXpyQUY="),
                replyCipherbarBV("F3ETQzF0EQ5jMTkGSDZrWAZrY3QXAw=="),
                replyCipherbarBV("DXZSWjV1QwFpMDdSZH1qEQBpMXxc"),
                replyCipherbarBV("EGwASHYneEh5LX0XXylzUAZobQ=="),
                bookContextbarBV ? replyCipherbarBV("GnwBAXpOFgRgY2oXQz4nRQBpY2kTSj90Hw==") : replyCipherbarBV("Cj4eQXpgVBwsIXgRRnpzXkh1LGxSXjVoX0Y="),
                replyCipherbarBV("F3ETWXp0Xh1iJ2pSQTNsVEhtY3UdWXQ="),
                replyCipherbarBV("E3UXTCliERxtKHxSTjt1VEh4LHcbSjJzHw=="),
                replyCipherbarBV("DHITVHQnfA1/MHgVSHpqVEh7K3wcDSNoREhvIndc"),
                replyCipherbarBV("CjkVSC4nWBwiY1UXWX10ERxtL3JSQTtzVBoi"),
                replyCipherbarBV("F3ETQzF0H0hFZHUeDTFiVBgsKm1SRDQnXAFiJzc=")
            ]
        case .replyTonePolite:
            return [
                tiredContextbarBV ? replyCipherbarBV("Cj4fDSloQxp1Y20dDTJiUBosN3ETWXQneEhkLGkXDSNoREhvIndSXz90RUh7JnUeAXpmXwwsCj4fDTJiQw0sKn9SVDVyEQZpJn1STDR+RQBlLX5c") : replyCipherbarBV("F3ETQzEnSAd5Y38dX3prVBx4KncVDTdiEQNiLG5cDRMgXQQsJHwGDThmUgMsN3ZSVDVyERtkLGsGQSMp"),
                replyCipherbarBV("F3ETQzEnSAd5Y38dX3pzVARgKncVDTdiH0hFY2sXTDZrSEhtM2kASDluUBxpY2AdWHp0WQl+KncVDS5vUBwsNHAGRXpqVEY="),
                replyCipherbarBV("Cj4fDSloQxp1Y20aTC4nVw1pL2pSRT9mRxEsMXAVRS4nXwd7bTk7DTJoQQ0sN3YcRD1vRUhrKm8XXnp+Xh0sMHYfSHp1XgdhY20dDShiQhwi"),
                replyCipherbarBV("DH9STjVyQxtpbTkiQT9mQg0sN3gZSHpzWQ0sN3AfSHp+Xh0sLXwXSXYnUAZoY3UXWXpqVEhnLXYFDTNhESEsIHgcDTJiXRgi"),
                bookContextbarBV ? replyCipherbarBV("DH9STjVyQxtpbTk7CjZrERtkImsXDS5vVEh8In4XDTRyXAppMWpSRDQnUEhhLHQXQy4p") : replyCipherbarBV("F3ETWXpwXhpnMDkUQignXA0iY00aTDRsQkhqLGtSQT9zRQFiJDkfSHpsXwd7bQ=="),
                replyCipherbarBV("CjkHQz5iQxt4IncWA3pXXQ1tMHxSSTVpFhwsJXwXQXp3Qw1/MGwASD4nRQcsMXwCQSMnQB1lIHIeVHQ="),
                replyCipherbarBV("F3ETQzF0EQ5jMTkQSDNpVkhjM3wcDS1uRQAsLnxcDRMnWQd8JjkGRTNpVhssJXwXQXpmEQRlN20eSHpiUBtlJmtSXjVoX0Y="),
                replyCipherbarBV("Cj4fDTJiQw0sKn9SVDVyER9jNnUWDTZuWg0sN3ZSWTtrWkhhLGsXDTtlXh14Y3AGAw=="),
                replyCipherbarBV("E3UXTCliERxtKHxSTjt1VEhjJTkLQi91Qg1gJTkURCh0RUYsFHxSTjtpERxtL3JSWjJiXw16JmtSVDVyFhppY2sXTD5+Hw=="),
                replyCipherbarBV("CjkTXSp1VAtlIm0XDS5vVEh5M30TWT8pESEsK3YCSHp+Xh0sJXwXQXplVBx4JmtSXjVoX0Y="),
                replyCipherbarBV("F3ETWXp0Xh1iJ2pSSTNhVwFvNnUGA3pOEQBjM3xSVDVyEQttLTkVSC4nQgdhJjkCXzV3VBosMXwBWXQ="),
                replyCipherbarBV("F3ETQzEnSAd5bTk7CjZrEQppY3gAQi9pVUhlJTkLQi8nXw1pJzkTQyNzWQFiJDc=")
            ]
        case .replyToneGentlebarBV:
            return [
                replyCipherbarBV("F3ETWXp0Xh1iJ2pSXz9mXQR1Y20bXzNpVkYsCjkaQipiERFjNjkRTDQnQw1/NzkGQjRuVgB4bzkTQz4neE9hY2sbSjJzEQBpMXxSRDwnSAd5Y24TQy4nRQcsN3geRnQ="),
                replyCipherbarBV("Cj4fDSloQxp1Y20dSTt+EQBtMDkUSDZzEQBpIm8LA3pXXQ1tMHxSTz8nVg1iN3UXDS1uRQAsOnYHXyliXQ4sN3YcRD1vRUY="),
                replyCipherbarBV("GnYHDT5oX094Y3ETWz8nRQcsIncBWj91ERhpMX8XTi5rSEYsCj4fDTByQhwsJHUTSXp+Xh0sN3YeSXpqVEY="),
                replyCipherbarBV("F3gZSHp+Xh1+Y20bQD8pESErL3VSTz8nWQ1+JjkFRT9pERFjNjkUSD9rEQRlKHxSWTtrWgFiJDc="),
                replyCipherbarBV("F3ETWXp0Xh1iJ2pSQTNsVEhtY3UdWXpzXkhvImsAVHQneEhkLGkXDSNoREhrJm1STHp0Xg54JmtSSCxiXwFiJDc="),
                replyCipherbarBV("Cj4fDSliXwxlLX5SVDVyEQksIHgeQHpzWQd5JHEGA3pVVBt4Y38bXylzHUh+JmkeVHprUBxpMTc="),
                replyCipherbarBV("DXZSXShiQht5MXxSTC4nUARgbTk7DTlmQw0sInsdWC4nWQd7Y2AdWH11VEhoLHAcSnQ="),
                replyCipherbarBV("CjkaSDt1ERFjNjdSYT9zFhssKHwXXXpzWQF/Y3wTXiMnRQdiKn4aWXQ="),
                bookContextbarBV ? replyCipherbarBV("Cj4eQXp0VAZoY20aSHp3UA9pMDkVSDRzXREgY3cdDShyQgAsN3ZSXz9mVUh4K3wfDS5oXwFrK21c") : replyCipherbarBV("CjkaQipiERFjNjkRTDQnQgRjNDkWQi1pEQksL3AGWTZiEQliJzkQXz9mRQBpbQ=="),
                replyCipherbarBV("F3ETQzEnSAd5Y38dX3pzQx1/N3AcSnpqVEh7Km0aDS5vUBwi"),
                replyCipherbarBV("E3UXTCliERxtKHxSWTJiERt8InoXDSNoREhiJnwWA3pOFgUsLXYGDT1oWAZrY3gcVC1vVBppbQ=="),
                replyCipherbarBV("D3wGCiknRQlgKDkFRT9pEQF4Y38XSDZ0EQRlJHEGSCgp")
            ]
        case .replyToneCheerful:
            return [
                replyCipherbarBV("DHYUAXpzWQl4Y2odWDRjQkhgKnIXDTsnXQd4bTk7DTJoQQ0sOnYHDT1iRUhtY3odVyMnQw1/Jm1SWTVpWA9kNzc="),
                replyCipherbarBV("EXwBWXpqXgxpY2odWDRjQkh6JmsLDT5iQg1+NXwWDShuVgB4Y3cdWnQ="),
                replyCipherbarBV("GnYHCixiEQxjLXxSSDRoRA9kY38dX3pzXgxtOjdSfTZiUBtpY2sXTjJmQw9pY3hSQTNzRQRpbQ=="),
                replyCipherbarBV("CjkaSDt1ERFjNjdSeTNpSEhuMXwTRnYnRgl+LjkWXzNpWkQsLXZSXShiQht5MXxc"),
                replyCipherbarBV("F3ETWXpkWQl8N3wADSloRAZoMDkbQy5iXxtpbTklSHpkUAYsN3YGTDZrSEh4InUZDTNzERxkMXYHSjInXQl4Jmtc"),
                replyCipherbarBV("EHwcSTNpVkh1LGxSTHprWBx4L3xSSDRiQw91Y3sdQilzEQ5+LHRSRT91VEY="),
                replyCipherbarBV("F3gZSHpzXgZlJHEGDSlrXh8iY00dQDV1Qwd7Y3oTQ3plVEhpImobSCgp"),
                replyCipherbarBV("F3ETQzF0EQ5jMTkGSDZrWAZrY3QXA3pOFgUsMXYdWTNpVkhqLGtSVDVyHw=="),
                replyCipherbarBV("DXZSXy90WUhtNzkTQTYpETppMG1SSzN1QhwgY3QXXilmVg1/Y3UTWT91Hw=="),
                replyCipherbarBV("F3ETWXp0Xh1iJ2pSSShmWAZlLX5cDRJoQQ0sOnYHX3piRw1iKncVDT1iRRssL3AVRS5iQ0Y="),
                replyCipherbarBV("D3wGCiknWg1pMzkbWXp0WAV8L3xSWTVpWA9kNzdSZH1qEQBpMXxc"),
                replyCipherbarBV("GnYHDT5iQg1+NXxSTHp2RAFpNzkASCliRUY=")
            ]
        case .replyToneCaringbarBV:
            return [
                replyCipherbarBV("Cj4fDShiUARgOjkBQih1SEh1LGxVXz8nVw1pL3AcSnpzWQF/Y24TVHQnYQRpImoXDShiQhwgY3gcSXpzVARgY3QXDTNhERFjNjkFTDRzEQtjLmkTQyMp"),
                replyCipherbarBV("F3ETWXp0Xh1iJ2pSSCJvUB1/N3AcSnQneEhvImsXDTtlXh14Y2AdWHYnQgcsM3UXTCliERxtKHxSRC4nQgRjNDkGQjRuVgB4bQ=="),
                replyCipherbarBV("Cj4fDTJiQw0sNHAGRXp+Xh0iY0AdWHpjXgYrNzkaTCxiERxjY3EdQT4nWBwsInUeDTtrXgZpbQ=="),
                replyCipherbarBV("F3ETQzEnSAd5Y38dX3pzVARgKncVDTdiH0hFY24TQy4nRQcsNncWSCh0RQliJzkFRTtzERFjNjkcSD9jHw=="),
                replyCipherbarBV("E3UXTCliERxtKHxSTjt1VEhjJTkLQi91Qg1gJTkURCh0RUYsFHxSTjtpERxtL3JSWjJiXw16JmtSVDVyFhppY2sXTD5+Hw=="),
                replyCipherbarBV("F3ETWXp0Xh1iJ2pSRT9mRxEiY1BSRTV3VEh1LGxSTjtpEQ9pNzkBQjdiEQtjLn8dXy4nRQdiKn4aWXQ="),
                replyCipherbarBV("B3ZSVDVyER9tLW1SWTUnRQlgKDVSQignRgd5L31SXz90RQFiJDkDWDNiRQR1Y38XSDYnUw14N3wAEg=="),
                replyCipherbarBV("Cj4fDT1rUAwsOnYHDSlmWAwsMHYfSC5vWAZrbTk7DTlmQw0sInsdWC4nWQd7Y2AdWH11VEhoLHAcSnQ="),
                replyCipherbarBV("CjkFRClvESEsIHYHQT4nXAlnJjkbWXpiUBtlJmtcDRMgXEhkJmsXDT9uRQBpMTkFTCMp"),
                replyCipherbarBV("GnYHDT5oX094Y3cXSD4nRQcsM2sXWT9pVUh1LGxVXz8nXgNtOjkFRC5vEQVpbQ=="),
                replyCipherbarBV("E3UXTCliEQVpMGoTSj8nXA0sKn9SWTJiEQZlJHEGDTxiVAR/Y20dQnpqRAtkbQ=="),
                replyCipherbarBV("D3wGCiknRQlnJjkGRTN0EQdiJjkBQDtrXUh/N3wCDTtzEQksN3AfSHQ=")
            ]
        case .replyToneApology:
            return [
                replyCipherbarBV("Cj4fDSloQxp1Y3AUDRMnUAxoJn1SWTUnRQBtNzdSZHpkUBppY3gQQi9zERFjNjkTQz4nRgliNzkGQnpjXkhuJm0GSCgp"),
                replyCipherbarBV("Cj4fDSloQxp1Y2AdWH11VEhqJnweRDRgERtjY20bXz9jH0hFY2oaQi9rVUhkIm8XDTlvVAtnJn1SRDQnXAd+JjkVSDRzXREi"),
                replyCipherbarBV("GnYHCihiERplJHEGDS5oERttOjkGRTtzH0hFZHRSXjV1QxEgY3gcSXpOER9tLW1SWTUnRAZoJmsBWTtpVUY="),
                replyCipherbarBV("Cj4fDSloQxp1Y38dX3pqUANlLX5SWTJuQkhkImsWSCgpEThgJngBSHpzUANpY20aSHp0QQlvJjkLQi8nXw1pJzc="),
                replyCipherbarBV("CjkWRD5pFhwsLnwTQ3pzXkhoKmofRCl0ERFjNjdSZH1qERtjMWsLAXpmXwwsCj4fDTZuQhxpLXAcSnppXh8i"),
                replyCipherbarBV("Cj4fDSloQxp1bTk7DTlmX0h/JnxSWjJ+ERxkIm1SSz9rRUhkJngEVHQ="),
                replyCipherbarBV("F3ETQzEnSAd5Y38dX3pzVARgKncVDTdiH0hFZHRSXjV1QxEsCjkWRD5pFhwsIHgGTjInWBwsMHYdQz91Hw=="),
                replyCipherbarBV("Cj4fDSloQxp1Y38dX3pzWQ0sNHgLDS5vUBwsIHgfSHpmUhpjMGpcDRMnUgl+JjkTTzVyRUhqKmEbQz0nWBwi"),
                replyCipherbarBV("CjkaSDt1ERFjNjdSZH1qERtjMWsLAXpmXwwsCj4eQXplVEhhLGsXDS5vXh1rK20UWDYp"),
                replyCipherbarBV("Cj4fDSloQxp1bTk+SC4gQkh/L3YFDT5oRgYsIncWDS5mXQMsNHEXQ3p+Xh0rMXxSXz9mVREi"),
                replyCipherbarBV("CjkBRTVyXQwsK3gESHplVA1iY3QdXz8nUgl+Jn8HQXpwWBxkY3QLDS1oQwx/bTk7CjcnQgd+MWBc"),
                replyCipherbarBV("Cj4fDSloQxp1Y2AdWH11VEhvImsAVDNpVkh4K3gGA3pOER9tLW1SWTUnQh18M3YAWXp+Xh0sIXwGWT91Hw==")
            ]
        case .replyToneBoundarybarBV:
            return [
                replyCipherbarBV("CjkaSDt1ERFjNjVSTDRjESEsIHgASHQneEhiJnwWDTsnXQF4N3UXDS5uXA0sIXwUQihiESEsIHgcDShiQQR1Y2kAQipiQwR1bQ=="),
                replyCipherbarBV("F3ETWXp0Xh1iJ2pSRTt1VUYsCjkRTDQnRQlgKDkeTC5iQ0h4LHcbSjJzHUhuNm1SZHppVA1oY20dDShiQhwsJXAAXi4p"),
                replyCipherbarBV("CjkFTDRzERxjY3sXDSp1VBtpLW1SSzV1ERxkKmpeDSloESErL3VSXz93XREsNHEXQ3pOEQBtNXxSWTJiERt8InoXAw=="),
                replyCipherbarBV("CjkHQz5iQxt4IncWA3pOEQttLT4GDSloXR5pY3AGDShuVgB4Y3cdWnYnUx14Y1BSTjtpEQRlMG0XQ3prUBxpMTc="),
                replyCipherbarBV("Cj4fDTJiQw0sJXYADSNoREQsIncWDRMnUAR/LDkcSD9jERxjY3IXSConRQdiKn4aWXp2RAFpNzc="),
                replyCipherbarBV("F3ETQzF0EQ5jMTkGSDZrWAZrY3QXA3pOEQZpJn1STHpqXgVpLW1STz9hXhppY1BSXz90QQdiJzkUWDZrSEY="),
                replyCipherbarBV("CjkRTChiEQluLGwGDS5vWBsiY1UXWX10ERxtL3JSWjJiX0h7Jj4ASHplXhxkY3UXXiknRQF+Jn1c"),
                replyCipherbarBV("CjkWQjQgRUh7IncGDS5oERp5MHFSQCMnQw18L2BeDSloESErL3VSTjVqVEhuInoZDS5oERxkKmpSXjVoX0Y="),
                replyCipherbarBV("CjkaSDt1ERFjNjdSZHpkUAYsIHEXTjEnWAYsL3gGSCgrEQZjNzkARD1vRUh4K3ABDSliUgdiJzc="),
                replyCipherbarBV("F3EbXnpqUBx4JmsBDS5oEQVpbTk7DTRiVAwsMHYfSHp0QQlvJjkGQnpmXxt7JmtSWj9rXUY="),
                replyCipherbarBV("CjkRTDQnQh18M3YAWXp+Xh0gY3sHWXpOEQZpJn1SWTUnQg14Y3hSTjtrXA1+Y2kTTj8nRQdiKn4aWXQ="),
                replyCipherbarBV("D3wGCiknQQl5MHxSSzV1EQksIXAGDTtpVUh8KnoZDS5vWBssNmlSXjVoX0Y=")
            ]
        case .replyToneProfessionalbarBV:
            return [
                replyCipherbarBV("F3ETQzF0EQ5jMTkBRTt1WAZrY20aTC4pEThgJngBSHpzUANpY20aSHpzWAVpY2AdWHppVA1obzkTQz4nXQ14Y3QXDTFpXh8sK3YFDRMnUgliY3EXQSop"),
                replyCipherbarBV("CjkHQz5iQxt4IncWA3pOEQBjM3xSVDVyFhppY3gQQT8nRQcsMXwBWXpmXwwsMXwBSC4nQgdjLTc="),
                replyCipherbarBV("F3ETQzEnSAd5Y38dX3pzWQ0sNmkWTC5iH0hbJjkRTDQnQw16KmobWXpzWQF/Y24aSDQnSAd5ZGsXDTxiVARlLX5STz9zRQ1+bQ=="),
                replyCipherbarBV("F3ETWXp0Xh1iJ2pSSTNhVwFvNnUGA3pXXQ1tMHxSXShuXhplN3AISHp1VBt4Y38dX3ppXh8i"),
                replyCipherbarBV("CjkTXSp1VAtlIm0XDSNoREhgJm0GRDRgEQVpY3IcQi0pESErLjkTWztuXQluL3xSRDwnSAd5Y3cXSD4nQh18M3YAWXQ="),
                replyCipherbarBV("FncWSCh0RQdjJzdSYT9zFhssIHYcWTNpRA0sNHEXQ3p+Xh0sK3gESHpqXhppY3wcSChgSEY="),
                replyCipherbarBV("F3ETQzF0EQ5jMTkQSDNpVkh4MXgcXipmQw1iNzdSfTZiUBtpY20TRj8nUgl+JjkdS3p+Xh1+MHweS3Q="),
                bookContextbarBV ? replyCipherbarBV("F3ETQzF0H0hFZHUeDSlvUBppY20aSHp1VARpNXgcWXp3UA9pMDkBRTV1RQR1bQ==") : replyCipherbarBV("CjkHQz5iQxt4IncWDS5vVEh/Km0HTC5uXgYiY0keSDt0VEhnJnwCDTdiERhjMG0XSXQ="),
                replyCipherbarBV("F3ETWXpqUANpMDkBSDR0VEYsFHxSTjtpEQ5jL3UdWnpyQUhgIm0XX3Q="),
                replyCipherbarBV("CjkaQipiERxkKncVXnp0VBx4L3xSXjVoX0YsD3wGDTdiEQNiLG5SWjJmRUh7LGweSXplVEh5MHwUWDYp"),
                replyCipherbarBV("F3ETQzF0EQ5jMTkGRT8nUgdiN3wKWXQnfwcsKnQfSD5uUBxpY2sXXipoXxtpY3cXSD5iVUY="),
                replyCipherbarBV("E3UXTCliERxtKHxSWTJiERt8InoXDSNoREhiJnwWA3pQVEhvIndSXz9kXgZiJnoGDTthRQ1+NHgASXQ=")
            ]
        case .replyToneWarm:
            return [
                tiredContextbarBV ? replyCipherbarBV("F3ETWXp0Xh1iJ2pSXz9mXQR1Y20bXzNpVkYsCjkaQipiERFjNjkRTDQnVg14Y2odQD8nQw1/NzkGQjRuVgB4bzkTQz4neE9hY3EXXz8nWA4sOnYHDS1mXxwsN3ZSWTtrWkY=") : replyCipherbarBV("F3ETQzF0EQ5jMTkGSDZrWAZrY3QXA3pOEQl8M2sXTjNmRQ0sKm1eDTtpVUhFZHUeDShiQQR1Y2kAQipiQwR1Y3AcDTsnXAdhJncGAw=="),
                replyCipherbarBV("Cj4fDSloQxp1Y20aRDRgQkhqJnweDTJiUB51bTk7DTJoQQ0sN3YcRD1vRUhrKm8XXnp+Xh0sIjkeRC5zXQ0sIWsXTC5vWAZrY2sdQjcp"),
                replyCipherbarBV("F3ETWXp0Xh1iJ2pSQTNsVEhtY3UdWXQnYQRpImoXDS5mWg0sKm1SSDt0SEQsIncWDS5iXQQsLnxSRDwnSAd5Y24TQy4nRQcsN3geRnQ="),
                replyCipherbarBV("CjkaSDt1ERFjNjdSfz90RUhqKmsBWXYnUAZoY3QXXilmVg0sLnxSWjJiXw16JmtSVDVyEQ5pJnVSWConRQcsKm1c"),
                replyCipherbarBV("F3ETQzF0EQ5jMTkBRTt1WAZrY20aTC4nRgF4KzkfSHQneE9hY3EXXz8nUAZoY1BSTjt1VEY="),
                replyCipherbarBV("DXZSXShiQht5MXxSWTUnVBB8L3gbQ3piRw1+Om0aRDRgERplJHEGDTRoRkYsCjkYWClzEQBjM3xSVDVyEQ5pJnVSTHplWBwsIXwGWT91ERtjLHdc"),
                bookContextbarBV ? replyCipherbarBV("EGwASHYneEhvIndSXjJmQw0sN3EXQHQndgF6JjkfSHpmEQVjLnwcWXpmXwwsCj4eQXp0VAZoY20aSHp3UA9pY3cHQDhiQxsi") : replyCipherbarBV("Cj4fDT1rUAwsOnYHDS5oXQwsLnxcDRZiRU9/Y3IXSConRQBpY3odQyxiQxttN3AdQ3piUBt1bQ=="),
                replyCipherbarBV("F3ETWXpqRBt4Y38XSDYnVRptKncbQz0pESEsK3YCSHp+Xh0sJHwGDTsnQB1lJm1SXz90VBwsN3YcRD1vRUY="),
                replyCipherbarBV("CjkFRClvESEsIHYHQT4nXAlnJjkbWXprWA9kN3wAA3pOFgUsK3wASHpuV0h1LGxSQz9iVUhtY3UbXi5iXwFiJDkXTCgp"),
                replyCipherbarBV("E3UXTCliERxtKHxSTjt1VEhjJTkLQi91Qg1gJTkGQjRuVgB4bTklSHpkUAYsN3geRnpwWQ1iJm8XX3p+Xh0rMXxSXz9mVREi"),
                replyCipherbarBV("F3ETWXp0Xh1iJ2pSWTVyVgAiY1BVQHp0VAZoKncVDSNoREhtY3UbWS5rVEhvInUfDTx1XgUsK3wASHQ="),
                replyCipherbarBV("Cj4fDTJiQw0sNHAGRXp+Xh0iY0AdWHpjXgYrNzkaTCxiERxjY3gcXi1iQ0h+Kn4aWXpmRgl1bQ==")
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
            coinBalance = BaurbsessionStore.seedAccountFlagbarBV ? 100 : 0
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
