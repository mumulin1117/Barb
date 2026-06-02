import UIKit

final class homeSurfacebarBV: localSurfacebarBV, UITextViewDelegate {
    private let store: localStorebarBV
    private let scrollSurfacebarBV = UIScrollView()
    private let stackSurfacebarBV = UIStackView()
    private var styleChoicebarBV: replyStylebarBV = .replyToneWarm
    private var draftThreadbarBV: threadFixturebarBV?
    private var draftTextbarBV = ""
    private var regenIndexbarBV = 0
    private weak var draftEntrybarBV: UITextView?

    init(store: localStorebarBV) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        title = "Barb"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if isViewLoaded {
            styleChoicebarBV = store.selectedReplyTonebarBV
            draftThreadbarBV = draftThreadbarBV.flatMap { draftbarBV in
                store.threadPoolbarBV.first { $0.threadSeed == draftbarBV.threadSeed }
            }
            reloadbarBV()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutFlowbarBV()
        reloadbarBV()
    }

    private func layoutFlowbarBV() {
        view.addSubview(scrollSurfacebarBV)
        scrollSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false
        scrollSurfacebarBV.showsVerticalScrollIndicator = false
        scrollSurfacebarBV.backgroundColor = .clear
        stackSurfacebarBV.axis = .vertical
        stackSurfacebarBV.spacing = styleStorebarBV.spacebarBV(18, minimumbarBV: 14, maximumbarBV: 22)
        scrollSurfacebarBV.addSubview(stackSurfacebarBV)
        stackSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false
        let sideInsetbarBV = styleStorebarBV.metricbarBV(20, minimumbarBV: 16, maximumbarBV: 22)
        NSLayoutConstraint.activate([
            scrollSurfacebarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollSurfacebarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollSurfacebarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollSurfacebarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackSurfacebarBV.topAnchor.constraint(equalTo: scrollSurfacebarBV.contentLayoutGuide.topAnchor, constant: styleStorebarBV.spacebarBV(28, minimumbarBV: 16, maximumbarBV: 38)),
            stackSurfacebarBV.leadingAnchor.constraint(equalTo: scrollSurfacebarBV.frameLayoutGuide.leadingAnchor, constant: sideInsetbarBV),
            stackSurfacebarBV.trailingAnchor.constraint(equalTo: scrollSurfacebarBV.frameLayoutGuide.trailingAnchor, constant: -sideInsetbarBV),
            stackSurfacebarBV.bottomAnchor.constraint(equalTo: scrollSurfacebarBV.contentLayoutGuide.bottomAnchor, constant: -styleStorebarBV.spacebarBV(22, minimumbarBV: 16, maximumbarBV: 24))
        ])
    }

    private func reloadbarBV() {
        stackSurfacebarBV.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stackSurfacebarBV.addArrangedSubview(headerSurfacebarBV())
        stackSurfacebarBV.addArrangedSubview(summarySurfacebarBV())
        if let draftThreadbarBV {
            stackSurfacebarBV.addArrangedSubview(draftSurfacebarBV(draftThreadbarBV))
        } else if let threadFlowbarBV = store.replyQueuebarBV().first {
            stackSurfacebarBV.addArrangedSubview(waitingSurfacebarBV(threadFlowbarBV))
        } else {
            stackSurfacebarBV.addArrangedSubview(emptySurfacebarBV())
        }
        stackSurfacebarBV.addArrangedSubview(styleSurfacebarBV())
    }

    private func headerSurfacebarBV() -> UIView {
        let rowSurfacebarBV = UIStackView()
        rowSurfacebarBV.axis = .horizontal
        rowSurfacebarBV.alignment = .center
        rowSurfacebarBV.spacing = 16
        let markSurfacebarBV = UILabel()
        markSurfacebarBV.text = "Barb"
        markSurfacebarBV.font = styleStorebarBV.italicFontbarBV(32)
        markSurfacebarBV.textColor = .black
        styleStorebarBV.labelFitbarBV(markSurfacebarBV, factorbarBV: 0.78, linesbarBV: 1)
        let spacerSurfacebarBV = UIView()
        let searchSurfacebarBV = iconButtonbarBV("magnifyingglass")
        let bellSurfacebarBV = iconButtonbarBV("bell.fill")
        searchSurfacebarBV.accessibilityLabel = "Search"
        bellSurfacebarBV.accessibilityLabel = "Notifications"
        searchSurfacebarBV.addAction(UIAction { [weak self] _ in
            self?.showSearchbarBV()
        }, for: .touchUpInside)
        bellSurfacebarBV.addAction(UIAction { [weak self] _ in
            self?.showNotificationCenterbarBV()
        }, for: .touchUpInside)
        let notificationBadgeCounterbarBV = 0
        let badgeSurfacebarBV = UILabel()
        badgeSurfacebarBV.text = "\(notificationBadgeCounterbarBV)"
        badgeSurfacebarBV.textColor = .white
        badgeSurfacebarBV.textAlignment = .center
        badgeSurfacebarBV.font = styleStorebarBV.fontbarBV(10, weight: .heavy)
        badgeSurfacebarBV.backgroundColor = .red
        badgeSurfacebarBV.layer.cornerRadius = 9
        badgeSurfacebarBV.clipsToBounds = true
        bellSurfacebarBV.addSubview(badgeSurfacebarBV)
        badgeSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false
        let avatarSurfacebarBV = avatarSurfacebarBV(initial: sessionStore.profileLocalbarBV?.placeholderAvatar ?? "B", color: styleStorebarBV.pink)
        rowSurfacebarBV.addArrangedSubview(markSurfacebarBV)
        rowSurfacebarBV.addArrangedSubview(spacerSurfacebarBV)
        rowSurfacebarBV.addArrangedSubview(searchSurfacebarBV)
        rowSurfacebarBV.addArrangedSubview(bellSurfacebarBV)
        rowSurfacebarBV.addArrangedSubview(avatarSurfacebarBV)
        let toolSizebarBV = styleStorebarBV.controlbarBV(46)
        let badgeSizebarBV = styleStorebarBV.metricbarBV(18, minimumbarBV: 16, maximumbarBV: 18)
        NSLayoutConstraint.activate([
            rowSurfacebarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(54, minimumbarBV: 48, maximumbarBV: 58)),
            searchSurfacebarBV.widthAnchor.constraint(equalToConstant: toolSizebarBV),
            searchSurfacebarBV.heightAnchor.constraint(equalToConstant: toolSizebarBV),
            bellSurfacebarBV.widthAnchor.constraint(equalToConstant: toolSizebarBV),
            bellSurfacebarBV.heightAnchor.constraint(equalToConstant: toolSizebarBV),
            avatarSurfacebarBV.widthAnchor.constraint(equalToConstant: toolSizebarBV),
            avatarSurfacebarBV.heightAnchor.constraint(equalToConstant: toolSizebarBV),
            badgeSurfacebarBV.topAnchor.constraint(equalTo: bellSurfacebarBV.topAnchor, constant: 2),
            badgeSurfacebarBV.trailingAnchor.constraint(equalTo: bellSurfacebarBV.trailingAnchor, constant: -2),
            badgeSurfacebarBV.widthAnchor.constraint(equalToConstant: badgeSizebarBV),
            badgeSurfacebarBV.heightAnchor.constraint(equalToConstant: badgeSizebarBV)
        ])
        return rowSurfacebarBV
    }

    private func iconButtonbarBV(_ imageNamebarBV: String) -> UIButton {
        let buttonSurfacebarBV = UIButton(type: .system)
        buttonSurfacebarBV.setImage(UIImage(systemName: imageNamebarBV), for: .normal)
        buttonSurfacebarBV.tintColor = .black
        buttonSurfacebarBV.backgroundColor = imageNamebarBV == "bell.fill" ? UIColor.white.withAlphaComponent(0.72) : .clear
        buttonSurfacebarBV.layer.cornerRadius = 24
        return buttonSurfacebarBV
    }

    private func showSearchbarBV() {
        navigationController?.pushViewController(homeSearchSurfacebarBV(storebarBV: store), animated: true)
    }

    private func showNotificationCenterbarBV() {
        navigationController?.pushViewController(homeNotificationSurfacebarBV(), animated: true)
    }

    private func showAITonesbarBV() {
        let tonesbarBV = aiTonesSurfacebarBV(storebarBV: store)
        tonesbarBV.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(tonesbarBV, animated: true)
    }

    private func summarySurfacebarBV() -> UIView {
        let cardSurfacebarBV = cardSurfacebarBV(cornerRadius: 20)
        let unreadCounterbarBV = store.threadPoolbarBV.reduce(0) { $0 + $1.unreadCounter }
        let labelSurfacebarBV = UILabel()
        labelSurfacebarBV.attributedText = summaryTextbarBV(unreadCounterbarBV: unreadCounterbarBV)
        styleStorebarBV.labelFitbarBV(labelSurfacebarBV, factorbarBV: 0.52, linesbarBV: 1)
        labelSurfacebarBV.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        let dotRowbarBV = UIStackView()
        dotRowbarBV.axis = .horizontal
        dotRowbarBV.alignment = .center
        dotRowbarBV.spacing = unreadCounterbarBV > 6 ? 5 : 7
        dotRowbarBV.setContentCompressionResistancePriority(.required, for: .horizontal)
        dotRowbarBV.setContentHuggingPriority(.required, for: .horizontal)
        for indexbarBV in 0..<unreadCounterbarBV {
            dotRowbarBV.addArrangedSubview(dotSurfacebarBV(activebarBV: indexbarBV == 0, totalbarBV: unreadCounterbarBV))
        }
        let spacerbarBV = UIView()
        let contentRowbarBV = UIStackView(arrangedSubviews: [labelSurfacebarBV, spacerbarBV, dotRowbarBV])
        contentRowbarBV.axis = .horizontal
        contentRowbarBV.alignment = .center
        contentRowbarBV.spacing = styleStorebarBV.metricbarBV(10, minimumbarBV: 6, maximumbarBV: 12)
        cardSurfacebarBV.addSubview(contentRowbarBV)
        contentRowbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardSurfacebarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(78, minimumbarBV: 68, maximumbarBV: 86)),
            contentRowbarBV.leadingAnchor.constraint(equalTo: cardSurfacebarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(20, minimumbarBV: 14, maximumbarBV: 22)),
            contentRowbarBV.trailingAnchor.constraint(equalTo: cardSurfacebarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(20, minimumbarBV: 14, maximumbarBV: 22)),
            contentRowbarBV.centerYAnchor.constraint(equalTo: cardSurfacebarBV.centerYAnchor)
        ])
        return cardSurfacebarBV
    }

    private func summaryTextbarBV(unreadCounterbarBV: Int) -> NSAttributedString {
        let textSurfacebarBV = NSMutableAttributedString(
            string: "\(unreadCounterbarBV)",
            attributes: [.font: styleStorebarBV.titleFont(24), .foregroundColor: styleStorebarBV.blue]
        )
        textSurfacebarBV.append(NSAttributedString(
            string: " unread · waiting for reply",
            attributes: [.font: styleStorebarBV.fontbarBV(17, weight: .heavy), .foregroundColor: UIColor.black]
        ))
        return textSurfacebarBV
    }

    private func dotSurfacebarBV(activebarBV: Bool, totalbarBV: Int) -> UIView {
        let activeWidthbarBV = totalbarBV > 6 ? CGFloat(24) : CGFloat(30)
        let inactiveSizebarBV = totalbarBV > 6 ? CGFloat(7) : CGFloat(9)
        if activebarBV {
            let markSurfacebarBV = gradientBadgebarBV()
            NSLayoutConstraint.activate([
                markSurfacebarBV.widthAnchor.constraint(equalToConstant: activeWidthbarBV),
                markSurfacebarBV.heightAnchor.constraint(equalToConstant: inactiveSizebarBV)
            ])
            markSurfacebarBV.layer.cornerRadius = inactiveSizebarBV / 2
            markSurfacebarBV.clipsToBounds = true
            return markSurfacebarBV
        }
        let markSurfacebarBV = UIView()
        markSurfacebarBV.backgroundColor = UIColor.systemGray4
        markSurfacebarBV.layer.cornerRadius = inactiveSizebarBV / 2
        NSLayoutConstraint.activate([
            markSurfacebarBV.widthAnchor.constraint(equalToConstant: inactiveSizebarBV),
            markSurfacebarBV.heightAnchor.constraint(equalToConstant: inactiveSizebarBV)
        ])
        return markSurfacebarBV
    }

    private func waitingSurfacebarBV(_ threadFlowbarBV: threadFixturebarBV) -> UIView {
        let shellSurfacebarBV = UIView()
        let haloSurfacebarBV = cardStripbarBV()
        haloSurfacebarBV.layer.cornerRadius = 42
        haloSurfacebarBV.clipsToBounds = true
        haloSurfacebarBV.alpha = 0.52
        let layerSurfacebarBV = UIView()
        layerSurfacebarBV.backgroundColor = UIColor.white.withAlphaComponent(0.28)
        layerSurfacebarBV.layer.borderColor = UIColor(red: 128 / 255, green: 196 / 255, blue: 1, alpha: 0.62).cgColor
        layerSurfacebarBV.layer.borderWidth = 1
        layerSurfacebarBV.layer.cornerRadius = 44
        layerSurfacebarBV.layer.maskedCorners = [.layerMaxXMinYCorner]
        let cardSurfacebarBV = UIView()
        cardSurfacebarBV.backgroundColor = .white
        cardSurfacebarBV.layer.cornerRadius = 36
        cardSurfacebarBV.layer.maskedCorners = [.layerMinXMaxYCorner]
        cardSurfacebarBV.clipsToBounds = true
        let latestbarBV = store.localThreadPreviewbarBV(for: threadFlowbarBV)
        let contactbarBV = threadFlowbarBV.personaPoolbarBV.first.flatMap { store.contactMatcherbarBV(contactSeed: $0) }
        let topStripbarBV = cardStripbarBV()
        let tagSurfacebarBV = UILabel()
        tagSurfacebarBV.text = "  • \(contactbarBV?.groupFilter.rawValue ?? "Friend") · Waiting 2h  "
        tagSurfacebarBV.textColor = styleStorebarBV.pink
        tagSurfacebarBV.backgroundColor = UIColor.white.withAlphaComponent(0.86)
        tagSurfacebarBV.layer.cornerRadius = 8
        tagSurfacebarBV.clipsToBounds = true
        tagSurfacebarBV.font = styleStorebarBV.fontbarBV(16, weight: .bold)
        styleStorebarBV.labelFitbarBV(tagSurfacebarBV, factorbarBV: 0.68, linesbarBV: 1)
        let timeSurfacebarBV = UILabel()
        timeSurfacebarBV.text = "Today 9:30"
        timeSurfacebarBV.textAlignment = .right
        timeSurfacebarBV.font = styleStorebarBV.fontbarBV(16, weight: .heavy)
        styleStorebarBV.labelFitbarBV(timeSurfacebarBV, factorbarBV: 0.7, linesbarBV: 1)
        timeSurfacebarBV.setContentCompressionResistancePriority(.required, for: .horizontal)
        tagSurfacebarBV.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        topStripbarBV.addSubview(tagSurfacebarBV)
        topStripbarBV.addSubview(timeSurfacebarBV)
        tagSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false
        timeSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false
        let avatarSurfacebarBV = avatarSurfacebarBV(initial: contactbarBV?.placeholderAvatar ?? "M", color: styleStorebarBV.purple)
        let nameSurfacebarBV = UILabel()
        nameSurfacebarBV.text = threadFlowbarBV.localThreadTitle
        nameSurfacebarBV.font = styleStorebarBV.fontbarBV(25, weight: .heavy)
        styleStorebarBV.labelFitbarBV(nameSurfacebarBV, factorbarBV: 0.72, linesbarBV: 1)
        let noteSurfacebarBV = UILabel()
        noteSurfacebarBV.text = contactbarBV?.placeholderNotebarBV ?? "Familiar contact"
        noteSurfacebarBV.textColor = UIColor.black.withAlphaComponent(0.45)
        noteSurfacebarBV.font = styleStorebarBV.fontbarBV(18, weight: .regular)
        styleStorebarBV.labelFitbarBV(noteSurfacebarBV, factorbarBV: 0.74, linesbarBV: 2)
        let textSurfacebarBV = UILabel()
        textSurfacebarBV.text = "\"\(latestbarBV?.localMessageText ?? "Tap AI Reply to keep the conversation moving.")\""
        textSurfacebarBV.font = styleStorebarBV.fontbarBV(22, weight: .regular)
        textSurfacebarBV.numberOfLines = 0
        textSurfacebarBV.lineBreakMode = .byWordWrapping
        let replyHolderbarBV = UIView()
        let replyButtonbarBV = UIButton(type: .system)
        replyButtonbarBV.setImage(UIImage(named: "aiReplaybarBV")?.withRenderingMode(.alwaysOriginal), for: .normal)
        replyButtonbarBV.imageView?.contentMode = .scaleAspectFit
        replyButtonbarBV.tintColor = .clear
        replyButtonbarBV.accessibilityLabel = "AI Reply"
        replyButtonbarBV.addAction(UIAction { [weak self] _ in self?.draftStartbarBV(threadFlowbarBV) }, for: .touchUpInside)
        replyHolderbarBV.addSubview(replyButtonbarBV)
        replyButtonbarBV.translatesAutoresizingMaskIntoConstraints = false
        let laterButtonbarBV = UIButton(type: .system)
        laterButtonbarBV.setTitle("Later", for: .normal)
        laterButtonbarBV.setTitleColor(.black, for: .normal)
        laterButtonbarBV.titleLabel?.font = styleStorebarBV.fontbarBV(23, weight: .heavy)
        styleStorebarBV.buttonFitbarBV(laterButtonbarBV)
        laterButtonbarBV.backgroundColor = UIColor(red: 246 / 255, green: 246 / 255, blue: 248 / 255, alpha: 1)
        laterButtonbarBV.layer.cornerRadius = 28
        laterButtonbarBV.addAction(UIAction { [weak self] _ in self?.laterFlowbarBV(threadFlowbarBV) }, for: .touchUpInside)
        let nameStackbarBV = UIStackView(arrangedSubviews: [nameSurfacebarBV, noteSurfacebarBV])
        nameStackbarBV.axis = .vertical
        nameStackbarBV.spacing = styleStorebarBV.spacebarBV(4, minimumbarBV: 3, maximumbarBV: 5)
        let profileRowbarBV = UIStackView(arrangedSubviews: [avatarSurfacebarBV, nameStackbarBV])
        profileRowbarBV.axis = .horizontal
        profileRowbarBV.alignment = .center
        profileRowbarBV.spacing = styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)
        let contentStackbarBV = UIStackView(arrangedSubviews: [profileRowbarBV, textSurfacebarBV, replyHolderbarBV, laterButtonbarBV])
        contentStackbarBV.axis = .vertical
        contentStackbarBV.spacing = styleStorebarBV.spacebarBV(18, minimumbarBV: 14, maximumbarBV: 20)
        shellSurfacebarBV.addSubview(haloSurfacebarBV)
        shellSurfacebarBV.addSubview(layerSurfacebarBV)
        shellSurfacebarBV.addSubview(cardSurfacebarBV)
        cardSurfacebarBV.addSubview(topStripbarBV)
        cardSurfacebarBV.addSubview(contentStackbarBV)
        [haloSurfacebarBV, layerSurfacebarBV, cardSurfacebarBV, topStripbarBV, contentStackbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        let avatarSizebarBV = styleStorebarBV.metricbarBV(62, minimumbarBV: 52, maximumbarBV: 68)
        let buttonHeightbarBV = styleStorebarBV.controlbarBV(54)
        NSLayoutConstraint.activate([
            shellSurfacebarBV.heightAnchor.constraint(greaterThanOrEqualToConstant: styleStorebarBV.spacebarBV(430, minimumbarBV: 360, maximumbarBV: 500)),
            haloSurfacebarBV.topAnchor.constraint(equalTo: shellSurfacebarBV.topAnchor),
            haloSurfacebarBV.leadingAnchor.constraint(equalTo: shellSurfacebarBV.leadingAnchor),
            haloSurfacebarBV.trailingAnchor.constraint(equalTo: shellSurfacebarBV.trailingAnchor),
            haloSurfacebarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(96, minimumbarBV: 76, maximumbarBV: 112)),
            layerSurfacebarBV.topAnchor.constraint(equalTo: shellSurfacebarBV.topAnchor, constant: styleStorebarBV.spacebarBV(72, minimumbarBV: 54, maximumbarBV: 84)),
            layerSurfacebarBV.leadingAnchor.constraint(equalTo: shellSurfacebarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(28, minimumbarBV: 18, maximumbarBV: 34)),
            layerSurfacebarBV.trailingAnchor.constraint(equalTo: shellSurfacebarBV.trailingAnchor),
            layerSurfacebarBV.bottomAnchor.constraint(equalTo: shellSurfacebarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(42, minimumbarBV: 30, maximumbarBV: 50)),
            cardSurfacebarBV.topAnchor.constraint(equalTo: shellSurfacebarBV.topAnchor, constant: styleStorebarBV.spacebarBV(48, minimumbarBV: 34, maximumbarBV: 56)),
            cardSurfacebarBV.leadingAnchor.constraint(equalTo: shellSurfacebarBV.leadingAnchor),
            cardSurfacebarBV.trailingAnchor.constraint(equalTo: shellSurfacebarBV.trailingAnchor),
            cardSurfacebarBV.bottomAnchor.constraint(equalTo: shellSurfacebarBV.bottomAnchor),
            topStripbarBV.topAnchor.constraint(equalTo: cardSurfacebarBV.topAnchor),
            topStripbarBV.leadingAnchor.constraint(equalTo: cardSurfacebarBV.leadingAnchor),
            topStripbarBV.trailingAnchor.constraint(equalTo: cardSurfacebarBV.trailingAnchor),
            topStripbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(62, minimumbarBV: 54, maximumbarBV: 72)),
            tagSurfacebarBV.leadingAnchor.constraint(equalTo: topStripbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(22, minimumbarBV: 14, maximumbarBV: 30)),
            tagSurfacebarBV.centerYAnchor.constraint(equalTo: topStripbarBV.centerYAnchor),
            tagSurfacebarBV.trailingAnchor.constraint(lessThanOrEqualTo: timeSurfacebarBV.leadingAnchor, constant: -12),
            timeSurfacebarBV.trailingAnchor.constraint(equalTo: topStripbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(22, minimumbarBV: 14, maximumbarBV: 30)),
            timeSurfacebarBV.centerYAnchor.constraint(equalTo: topStripbarBV.centerYAnchor),
            avatarSurfacebarBV.widthAnchor.constraint(equalToConstant: avatarSizebarBV),
            avatarSurfacebarBV.heightAnchor.constraint(equalToConstant: avatarSizebarBV),
            contentStackbarBV.topAnchor.constraint(equalTo: topStripbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(26, minimumbarBV: 18, maximumbarBV: 34)),
            contentStackbarBV.leadingAnchor.constraint(equalTo: cardSurfacebarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(24, minimumbarBV: 18, maximumbarBV: 28)),
            contentStackbarBV.trailingAnchor.constraint(equalTo: cardSurfacebarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(24, minimumbarBV: 18, maximumbarBV: 28)),
            contentStackbarBV.bottomAnchor.constraint(equalTo: cardSurfacebarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(32, minimumbarBV: 24, maximumbarBV: 40)),
            replyHolderbarBV.heightAnchor.constraint(equalToConstant: buttonHeightbarBV),
            replyButtonbarBV.centerXAnchor.constraint(equalTo: replyHolderbarBV.centerXAnchor),
            replyButtonbarBV.centerYAnchor.constraint(equalTo: replyHolderbarBV.centerYAnchor),
            replyButtonbarBV.heightAnchor.constraint(equalToConstant: buttonHeightbarBV),
            laterButtonbarBV.heightAnchor.constraint(equalToConstant: buttonHeightbarBV)
        ])
        let replayRatiobarBV = replyButtonbarBV.widthAnchor.constraint(equalTo: replyButtonbarBV.heightAnchor, multiplier: 771 / 168)
        replayRatiobarBV.priority = .defaultHigh
        NSLayoutConstraint.activate([
            replyButtonbarBV.widthAnchor.constraint(lessThanOrEqualTo: replyHolderbarBV.widthAnchor),
            replayRatiobarBV
        ])
        return shellSurfacebarBV
    }

    private func draftSurfacebarBV(_ threadFlowbarBV: threadFixturebarBV) -> UIView {
        let shellSurfacebarBV = UIView()
        let haloSurfacebarBV = cardStripbarBV()
        haloSurfacebarBV.layer.cornerRadius = 42
        haloSurfacebarBV.clipsToBounds = true
        haloSurfacebarBV.alpha = 0.52
        let layerSurfacebarBV = UIView()
        layerSurfacebarBV.backgroundColor = UIColor.white.withAlphaComponent(0.28)
        layerSurfacebarBV.layer.borderColor = UIColor(red: 128 / 255, green: 196 / 255, blue: 1, alpha: 0.62).cgColor
        layerSurfacebarBV.layer.borderWidth = 1
        layerSurfacebarBV.layer.cornerRadius = 44
        layerSurfacebarBV.layer.maskedCorners = [.layerMaxXMinYCorner]
        let cardSurfacebarBV = UIView()
        cardSurfacebarBV.backgroundColor = .white
        let latestbarBV = store.localThreadPreviewbarBV(for: threadFlowbarBV)
        let headerSurfacebarBV = UIView()
        headerSurfacebarBV.backgroundColor = .white
        headerSurfacebarBV.layer.cornerRadius = 12
        let lineSurfacebarBV = UIView()
        lineSurfacebarBV.backgroundColor = styleStorebarBV.blue
        let metaSurfacebarBV = UILabel()
        metaSurfacebarBV.text = "↳ REPLYING TO \(threadFlowbarBV.localThreadTitle.uppercased()) · 11:24"
        metaSurfacebarBV.textColor = styleStorebarBV.blue
        metaSurfacebarBV.font = styleStorebarBV.fontbarBV(15, weight: .heavy)
        styleStorebarBV.labelFitbarBV(metaSurfacebarBV, factorbarBV: 0.68, linesbarBV: 1)
        let quoteSurfacebarBV = UILabel()
        quoteSurfacebarBV.text = "\"\(latestbarBV?.localMessageText ?? "")\""
        quoteSurfacebarBV.font = styleStorebarBV.fontbarBV(17, weight: .regular)
        quoteSurfacebarBV.textColor = UIColor(red: 37 / 255, green: 15 / 255, blue: 73 / 255, alpha: 1)
        quoteSurfacebarBV.numberOfLines = 0
        let draftBadgebarBV = gradientBadgebarBV()
        draftBadgebarBV.layer.cornerRadius = 10
        draftBadgebarBV.clipsToBounds = true
        let draftLabelbarBV = UILabel()
        draftLabelbarBV.text = "✦  AI DRAFT"
        draftLabelbarBV.textColor = .white
        draftLabelbarBV.textAlignment = .center
        draftLabelbarBV.font = styleStorebarBV.fontbarBV(16, weight: .heavy)
        styleStorebarBV.labelFitbarBV(draftLabelbarBV, factorbarBV: 0.68, linesbarBV: 1)
        draftBadgebarBV.addSubview(draftLabelbarBV)
        headerSurfacebarBV.addSubview(lineSurfacebarBV)
        headerSurfacebarBV.addSubview(metaSurfacebarBV)
        headerSurfacebarBV.addSubview(quoteSurfacebarBV)
        headerSurfacebarBV.addSubview(draftBadgebarBV)
        [lineSurfacebarBV, metaSurfacebarBV, quoteSurfacebarBV, draftBadgebarBV, draftLabelbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        let toneSurfacebarBV = UILabel()
        toneSurfacebarBV.text = " •  \(styleChoicebarBV.rawValue) "
        toneSurfacebarBV.textColor = .white
        toneSurfacebarBV.font = styleStorebarBV.fontbarBV(18, weight: .heavy)
        styleStorebarBV.labelFitbarBV(toneSurfacebarBV, factorbarBV: 0.68, linesbarBV: 1)
        toneSurfacebarBV.backgroundColor = styleStorebarBV.pink
        toneSurfacebarBV.layer.cornerRadius = 12
        toneSurfacebarBV.clipsToBounds = true
        let unlockSurfacebarBV = UILabel()
        unlockSurfacebarBV.text = "FREE THIS DRAFT"
        unlockSurfacebarBV.textAlignment = .right
        unlockSurfacebarBV.textColor = UIColor(red: 37 / 255, green: 15 / 255, blue: 73 / 255, alpha: 1)
        unlockSurfacebarBV.font = styleStorebarBV.fontbarBV(16, weight: .heavy)
        styleStorebarBV.labelFitbarBV(unlockSurfacebarBV, factorbarBV: 0.68, linesbarBV: 1)
        let optionRowbarBV = UIStackView(arrangedSubviews: [toneSurfacebarBV, unlockSurfacebarBV])
        optionRowbarBV.axis = .horizontal
        optionRowbarBV.distribution = .equalSpacing
        let entrySurfacebarBV = UITextView()
        entrySurfacebarBV.delegate = self
        entrySurfacebarBV.text = draftTextbarBV.isEmpty ? "Please enter your reply..." : draftTextbarBV
        entrySurfacebarBV.textColor = draftTextbarBV.isEmpty ? UIColor.black.withAlphaComponent(0.45) : .black
        entrySurfacebarBV.font = styleStorebarBV.fontbarBV(draftTextbarBV.isEmpty ? 21 : 22, weight: .regular)
        entrySurfacebarBV.isEditable = false
        entrySurfacebarBV.isScrollEnabled = false
        entrySurfacebarBV.backgroundColor = .white
        entrySurfacebarBV.layer.borderColor = UIColor(red: 192 / 255, green: 235 / 255, blue: 1, alpha: 1).cgColor
        entrySurfacebarBV.layer.borderWidth = 1
        entrySurfacebarBV.layer.cornerRadius = 12
        entrySurfacebarBV.textContainerInset = UIEdgeInsets(top: 18, left: 16, bottom: 18, right: 16)
        draftEntrybarBV = entrySurfacebarBV
        let regenButtonbarBV = plainButtonbarBV("Regen", borderbarBV: true)
        regenButtonbarBV.addAction(UIAction { [weak self] _ in self?.draftRegenbarBV() }, for: .touchUpInside)
        let editButtonbarBV = plainButtonbarBV("Edit", borderbarBV: false)
        editButtonbarBV.addAction(UIAction { [weak self] _ in self?.draftEditbarBV() }, for: .touchUpInside)
        let sendButtonbarBV = gradientPill(type: .system)
        sendButtonbarBV.setTitle("Send", for: .normal)
        sendButtonbarBV.setTitleColor(.black, for: .normal)
        sendButtonbarBV.titleLabel?.font = styleStorebarBV.fontbarBV(20, weight: .heavy)
        styleStorebarBV.buttonFitbarBV(sendButtonbarBV)
        sendButtonbarBV.addAction(UIAction { [weak self] _ in self?.draftSendbarBV() }, for: .touchUpInside)
        let actionRowbarBV = UIStackView(arrangedSubviews: [regenButtonbarBV, editButtonbarBV, sendButtonbarBV])
        actionRowbarBV.axis = .horizontal
        actionRowbarBV.distribution = .fillEqually
        actionRowbarBV.spacing = styleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 12)
        let stackDraftbarBV = UIStackView(arrangedSubviews: [headerSurfacebarBV, optionRowbarBV, entrySurfacebarBV, actionRowbarBV])
        stackDraftbarBV.axis = .vertical
        stackDraftbarBV.spacing = styleStorebarBV.spacebarBV(18, minimumbarBV: 14, maximumbarBV: 22)
        shellSurfacebarBV.addSubview(haloSurfacebarBV)
        shellSurfacebarBV.addSubview(layerSurfacebarBV)
        shellSurfacebarBV.addSubview(cardSurfacebarBV)
        cardSurfacebarBV.addSubview(stackDraftbarBV)
        [haloSurfacebarBV, layerSurfacebarBV, cardSurfacebarBV, stackDraftbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        let actionHeightbarBV = styleStorebarBV.controlbarBV(54)
        NSLayoutConstraint.activate([
            shellSurfacebarBV.heightAnchor.constraint(greaterThanOrEqualToConstant: styleStorebarBV.spacebarBV(540, minimumbarBV: 460, maximumbarBV: 610)),
            haloSurfacebarBV.topAnchor.constraint(equalTo: shellSurfacebarBV.topAnchor),
            haloSurfacebarBV.leadingAnchor.constraint(equalTo: shellSurfacebarBV.leadingAnchor),
            haloSurfacebarBV.trailingAnchor.constraint(equalTo: shellSurfacebarBV.trailingAnchor),
            haloSurfacebarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(96, minimumbarBV: 76, maximumbarBV: 112)),
            layerSurfacebarBV.topAnchor.constraint(equalTo: shellSurfacebarBV.topAnchor, constant: styleStorebarBV.spacebarBV(72, minimumbarBV: 54, maximumbarBV: 84)),
            layerSurfacebarBV.leadingAnchor.constraint(equalTo: shellSurfacebarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(28, minimumbarBV: 18, maximumbarBV: 34)),
            layerSurfacebarBV.trailingAnchor.constraint(equalTo: shellSurfacebarBV.trailingAnchor),
            layerSurfacebarBV.bottomAnchor.constraint(equalTo: shellSurfacebarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(42, minimumbarBV: 30, maximumbarBV: 50)),
            cardSurfacebarBV.topAnchor.constraint(equalTo: shellSurfacebarBV.topAnchor, constant: styleStorebarBV.spacebarBV(48, minimumbarBV: 34, maximumbarBV: 56)),
            cardSurfacebarBV.leadingAnchor.constraint(equalTo: shellSurfacebarBV.leadingAnchor),
            cardSurfacebarBV.trailingAnchor.constraint(equalTo: shellSurfacebarBV.trailingAnchor),
            cardSurfacebarBV.bottomAnchor.constraint(equalTo: shellSurfacebarBV.bottomAnchor),
            stackDraftbarBV.topAnchor.constraint(equalTo: cardSurfacebarBV.topAnchor, constant: styleStorebarBV.spacebarBV(46, minimumbarBV: 32, maximumbarBV: 56)),
            stackDraftbarBV.leadingAnchor.constraint(equalTo: cardSurfacebarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(22, minimumbarBV: 16, maximumbarBV: 24)),
            stackDraftbarBV.trailingAnchor.constraint(equalTo: cardSurfacebarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(22, minimumbarBV: 16, maximumbarBV: 24)),
            stackDraftbarBV.bottomAnchor.constraint(equalTo: cardSurfacebarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(30, minimumbarBV: 22, maximumbarBV: 36)),
            headerSurfacebarBV.heightAnchor.constraint(greaterThanOrEqualToConstant: styleStorebarBV.metricbarBV(100, minimumbarBV: 88, maximumbarBV: 112)),
            lineSurfacebarBV.leadingAnchor.constraint(equalTo: headerSurfacebarBV.leadingAnchor),
            lineSurfacebarBV.topAnchor.constraint(equalTo: headerSurfacebarBV.topAnchor),
            lineSurfacebarBV.bottomAnchor.constraint(equalTo: headerSurfacebarBV.bottomAnchor),
            lineSurfacebarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(3, minimumbarBV: 2, maximumbarBV: 3)),
            metaSurfacebarBV.leadingAnchor.constraint(equalTo: headerSurfacebarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(20, minimumbarBV: 16, maximumbarBV: 24)),
            metaSurfacebarBV.topAnchor.constraint(equalTo: headerSurfacebarBV.topAnchor, constant: styleStorebarBV.spacebarBV(18, minimumbarBV: 14, maximumbarBV: 22)),
            quoteSurfacebarBV.leadingAnchor.constraint(equalTo: metaSurfacebarBV.leadingAnchor),
            quoteSurfacebarBV.trailingAnchor.constraint(equalTo: headerSurfacebarBV.trailingAnchor, constant: -20),
            quoteSurfacebarBV.topAnchor.constraint(equalTo: metaSurfacebarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            draftBadgebarBV.trailingAnchor.constraint(equalTo: headerSurfacebarBV.trailingAnchor),
            draftBadgebarBV.topAnchor.constraint(equalTo: headerSurfacebarBV.topAnchor, constant: -36),
            draftBadgebarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(124, minimumbarBV: 108, maximumbarBV: 132)),
            draftBadgebarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.controlbarBV(42)),
            draftLabelbarBV.topAnchor.constraint(equalTo: draftBadgebarBV.topAnchor),
            draftLabelbarBV.leadingAnchor.constraint(equalTo: draftBadgebarBV.leadingAnchor),
            draftLabelbarBV.trailingAnchor.constraint(equalTo: draftBadgebarBV.trailingAnchor),
            draftLabelbarBV.bottomAnchor.constraint(equalTo: draftBadgebarBV.bottomAnchor),
            toneSurfacebarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.controlbarBV(44)),
            toneSurfacebarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(124, minimumbarBV: 104, maximumbarBV: 136)),
            entrySurfacebarBV.heightAnchor.constraint(greaterThanOrEqualToConstant: styleStorebarBV.metricbarBV(draftTextbarBV.isEmpty ? 108 : 136, minimumbarBV: draftTextbarBV.isEmpty ? 96 : 120, maximumbarBV: draftTextbarBV.isEmpty ? 118 : 150)),
            actionRowbarBV.heightAnchor.constraint(equalToConstant: actionHeightbarBV)
        ])
        return shellSurfacebarBV
    }

    private func styleSurfacebarBV() -> UIView {
        let cardSurfacebarBV = cardSurfacebarBV(cornerRadius: 20)
        let titleSurfacebarBV = UILabel()
        titleSurfacebarBV.text = "✦  AI REPLY STYLE"
        titleSurfacebarBV.font = styleStorebarBV.fontbarBV(18, weight: .heavy)
        titleSurfacebarBV.textColor = .black
        styleStorebarBV.labelFitbarBV(titleSurfacebarBV, factorbarBV: 0.68, linesbarBV: 1)
        let botSurfacebarBV = UIImageView(image: UIImage(named: "AIIconbarBV"))
        botSurfacebarBV.contentMode = .scaleAspectFit
        let entrySurfacebarBV = UIButton(type: .system)
        entrySurfacebarBV.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        entrySurfacebarBV.tintColor = UIColor.black.withAlphaComponent(0.38)
        entrySurfacebarBV.accessibilityLabel = "AI Tones"
        entrySurfacebarBV.addAction(UIAction { [weak self] _ in
            self?.showAITonesbarBV()
        }, for: .touchUpInside)
        let headerRowbarBV = UIStackView(arrangedSubviews: [titleSurfacebarBV, UIView(), botSurfacebarBV, entrySurfacebarBV])
        headerRowbarBV.axis = .horizontal
        headerRowbarBV.alignment = .center
        let rowSurfacebarBV = UIStackView()
        rowSurfacebarBV.distribution = .fillEqually
        rowSurfacebarBV.spacing = styleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 12)
        var tonesbarBV: [replyStylebarBV] = [.replyToneWarm, .replyToneShortbarBV, .replyTonePolite]
        if !tonesbarBV.contains(styleChoicebarBV) {
            tonesbarBV.append(styleChoicebarBV)
        }
        for tonebarBV in tonesbarBV {
            rowSurfacebarBV.addArrangedSubview(styleButtonbarBV(tonebarBV))
        }
        let stackbarBV = UIStackView(arrangedSubviews: [headerRowbarBV, rowSurfacebarBV])
        stackbarBV.axis = .vertical
        stackbarBV.spacing = styleStorebarBV.spacebarBV(16, minimumbarBV: 12, maximumbarBV: 20)
        cardSurfacebarBV.addSubview(stackbarBV)
        stackbarBV.translatesAutoresizingMaskIntoConstraints = false
        let botSizebarBV = styleStorebarBV.metricbarBV(38, minimumbarBV: 34, maximumbarBV: 40)
        NSLayoutConstraint.activate([
            cardSurfacebarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(130, minimumbarBV: 118, maximumbarBV: 142)),
            stackbarBV.topAnchor.constraint(equalTo: cardSurfacebarBV.topAnchor, constant: styleStorebarBV.spacebarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            stackbarBV.leadingAnchor.constraint(equalTo: cardSurfacebarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            stackbarBV.trailingAnchor.constraint(equalTo: cardSurfacebarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            rowSurfacebarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.controlbarBV(50)),
            botSurfacebarBV.widthAnchor.constraint(equalToConstant: botSizebarBV),
            botSurfacebarBV.heightAnchor.constraint(equalToConstant: botSizebarBV),
            entrySurfacebarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(30, minimumbarBV: 28, maximumbarBV: 32)),
            entrySurfacebarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(30, minimumbarBV: 28, maximumbarBV: 32))
        ])
        return cardSurfacebarBV
    }

    private func styleButtonbarBV(_ tonebarBV: replyStylebarBV) -> UIButton {
        let buttonSurfacebarBV: UIButton = tonebarBV == styleChoicebarBV ? gradientPill(type: .system) : UIButton(type: .system)
        if let choiceSurfacebarBV = buttonSurfacebarBV as? gradientPill {
            choiceSurfacebarBV.colorsbarBV = styleStorebarBV.replyChoiceColorsbarBV
            choiceSurfacebarBV.locationsbarBV = styleStorebarBV.replyChoiceLocationsbarBV
            choiceSurfacebarBV.cornerRadiusbarBV = 16
        }
        buttonSurfacebarBV.setTitle(tonebarBV.rawValue, for: .normal)
        buttonSurfacebarBV.titleLabel?.font = styleStorebarBV.fontbarBV(tonesNeedCompactbarBV() ? 16 : 20, weight: .heavy)
        styleStorebarBV.buttonFitbarBV(buttonSurfacebarBV, factorbarBV: 0.68)
        buttonSurfacebarBV.setTitleColor(tonebarBV == styleChoicebarBV ? .white : .darkGray, for: .normal)
        buttonSurfacebarBV.backgroundColor = tonebarBV == styleChoicebarBV ? .clear : UIColor.systemGray6
        buttonSurfacebarBV.layer.cornerRadius = 16
        buttonSurfacebarBV.clipsToBounds = true
        buttonSurfacebarBV.addAction(UIAction { [weak self] _ in
            self?.styleChoicebarBV = tonebarBV
            if self?.draftThreadbarBV != nil {
                self?.regenIndexbarBV = 0
                self?.draftGeneratebarBV()
            }
            self?.reloadbarBV()
        }, for: .touchUpInside)
        return buttonSurfacebarBV
    }

    private func tonesNeedCompactbarBV() -> Bool {
        ![replyStylebarBV.replyToneWarm, .replyToneShortbarBV, .replyTonePolite].contains(styleChoicebarBV)
    }

    private func emptySurfacebarBV() -> UIView {
        let cardSurfacebarBV = cardSurfacebarBV(cornerRadius: 24)
        let textSurfacebarBV = UILabel()
        textSurfacebarBV.text = "No unread messages waiting for reply."
        textSurfacebarBV.font = styleStorebarBV.fontbarBV(20, weight: .heavy)
        textSurfacebarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(textSurfacebarBV, factorbarBV: 0.7, linesbarBV: 0)
        cardSurfacebarBV.addSubview(textSurfacebarBV)
        textSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardSurfacebarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(150, minimumbarBV: 120, maximumbarBV: 180)),
            textSurfacebarBV.centerXAnchor.constraint(equalTo: cardSurfacebarBV.centerXAnchor),
            textSurfacebarBV.centerYAnchor.constraint(equalTo: cardSurfacebarBV.centerYAnchor)
        ])
        return cardSurfacebarBV
    }

    private func plainButtonbarBV(_ titlebarBV: String, borderbarBV: Bool) -> UIButton {
        let buttonSurfacebarBV = UIButton(type: .system)
        buttonSurfacebarBV.setTitle(titlebarBV, for: .normal)
        buttonSurfacebarBV.setTitleColor(.black, for: .normal)
        buttonSurfacebarBV.titleLabel?.font = styleStorebarBV.fontbarBV(19, weight: .bold)
        styleStorebarBV.buttonFitbarBV(buttonSurfacebarBV)
        buttonSurfacebarBV.backgroundColor = borderbarBV ? .white : UIColor.systemGray6
        buttonSurfacebarBV.layer.cornerRadius = 14
        buttonSurfacebarBV.layer.borderWidth = borderbarBV ? 1 : 0
        buttonSurfacebarBV.layer.borderColor = UIColor.systemGray4.cgColor
        return buttonSurfacebarBV
    }

    private func cardStripbarBV() -> gradientBadgebarBV {
        let stripSurfacebarBV = gradientBadgebarBV()
        stripSurfacebarBV.colorsbarBV = styleStorebarBV.cardStripColorsbarBV
        stripSurfacebarBV.locationsbarBV = styleStorebarBV.cardStripLocationsbarBV
        return stripSurfacebarBV
    }

    private func draftStartbarBV(_ threadFlowbarBV: threadFixturebarBV) {
        draftThreadbarBV = threadFlowbarBV
        regenIndexbarBV = 0
        draftGeneratebarBV()
        reloadbarBV()
    }

    private func laterFlowbarBV(_ threadFlowbarBV: threadFixturebarBV) {
        draftThreadbarBV = nil
        draftTextbarBV = ""
        store.laterQueuebarBV(threadFlowbarBV)
        reloadbarBV()
        scrollSurfacebarBV.setContentOffset(.zero, animated: true)
    }

    private func draftGeneratebarBV() {
        guard let threadFlowbarBV = draftThreadbarBV, let latestbarBV = store.localThreadPreviewbarBV(for: threadFlowbarBV) else { return }
        let basebarBV = store.generatedDraftbarBV(for: latestbarBV, tone: styleChoicebarBV)
        if regenIndexbarBV == 0 {
            draftTextbarBV = basebarBV
            return
        }
        switch styleChoicebarBV {
        case .replyToneShortbarBV:
            draftTextbarBV = "I hear you. Please rest tonight, and message me when you feel up to it."
        case .replyTonePolite:
            draftTextbarBV = "Thank you for telling me. I hope you can take some time to rest, and I am here if you would like to talk."
        default:
            draftTextbarBV = "That sounds really tiring. I hope tonight gives you a little space to breathe, and I am here if you want to talk."
        }
    }

    private func draftRegenbarBV() {
        guard store.spendCoinsbarBV(amountbarBV: 100, typebarBV: "aiReplyRegeneratebarBV") else {
            presentCoinShortagebarBV()
            return
        }
        regenIndexbarBV += 1
        draftGeneratebarBV()
        reloadbarBV()
    }

    private func presentCoinShortagebarBV() {
        let alertbarBV = UIAlertController(
            title: "Not enough coins",
            message: "Sorry, you don't have enough coins to pay, please go to recharge",
            preferredStyle: .alert
        )
        alertbarBV.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertbarBV.addAction(UIAlertAction(title: "Buy", style: .default) { [weak self] _ in
            guard let self else { return }
            let topUpbarBV = topUpSurfacebarBV(storebarBV: self.store)
            topUpbarBV.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(topUpbarBV, animated: true)
        })
        present(alertbarBV, animated: true)
    }

    private func draftEditbarBV() {
        draftEntrybarBV?.isEditable = true
        draftEntrybarBV?.textColor = .black
        draftEntrybarBV?.becomeFirstResponder()
    }

    private func draftSendbarBV() {
        guard let threadFlowbarBV = draftThreadbarBV else { return }
        let textbarBV = (draftEntrybarBV?.text ?? draftTextbarBV).trimmingCharacters(in: .whitespacesAndNewlines)
        guard !textbarBV.isEmpty, textbarBV != "Please enter your reply..." else { return }
        store.sendButton(textbarBV, in: threadFlowbarBV)
        draftThreadbarBV = nil
        draftTextbarBV = ""
        reloadbarBV()
    }

    func textViewDidChange(_ textView: UITextView) {
        draftTextbarBV = textView.text
    }
}

final class gradientBadgebarBV: UIView {
    var colorsbarBV: [UIColor] = [styleStorebarBV.mint, styleStorebarBV.purple, styleStorebarBV.pink] {
        didSet { refreshbarBV() }
    }
    var locationsbarBV: [NSNumber]? {
        didSet { refreshbarBV() }
    }

    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configurebarBV()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configurebarBV()
    }

    private func configurebarBV() {
        refreshbarBV()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        refreshbarBV()
    }

    private func refreshbarBV() {
        guard let gradientbarBV = layer as? CAGradientLayer else { return }
        gradientbarBV.colors = colorsbarBV.map(\.cgColor)
        gradientbarBV.locations = locationsbarBV
        gradientbarBV.startPoint = CGPoint(x: 0, y: 0.5)
        gradientbarBV.endPoint = CGPoint(x: 1, y: 0.5)
    }
}

private final class homeSearchSurfacebarBV: localSurfacebarBV, UITextFieldDelegate {
    private let storebarBV: localStorebarBV
    private let scrollSurfacebarBV = UIScrollView()
    private let stackSurfacebarBV = UIStackView()
    private let fieldSurfacebarBV = UITextField()
    private let resultStackbarBV = UIStackView()
    private var visibleThreadsbarBV: [threadFixturebarBV] = []

    init(storebarBV: localStorebarBV) {
        self.storebarBV = storebarBV
        super.init(nibName: nil, bundle: nil)
        title = "Search"
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSurfacebarBV()
        reloadResultsbarBV(querybarBV: "")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fieldSurfacebarBV.becomeFirstResponder()
    }

    private func configureSurfacebarBV() {
        let tapbarBV = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardbarBV))
        tapbarBV.cancelsTouchesInView = false
        view.addGestureRecognizer(tapbarBV)
        view.addSubview(scrollSurfacebarBV)
        scrollSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false
        scrollSurfacebarBV.keyboardDismissMode = .interactive
        scrollSurfacebarBV.showsVerticalScrollIndicator = false
        scrollSurfacebarBV.addSubview(stackSurfacebarBV)
        stackSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false
        stackSurfacebarBV.axis = .vertical
        stackSurfacebarBV.spacing = styleStorebarBV.spacebarBV(18, minimumbarBV: 14, maximumbarBV: 22)

        stackSurfacebarBV.addArrangedSubview(headerbarBV())
        stackSurfacebarBV.addArrangedSubview(searchCardbarBV())
        stackSurfacebarBV.addArrangedSubview(resultCardbarBV())

        let sideInsetbarBV = styleStorebarBV.metricbarBV(20, minimumbarBV: 16, maximumbarBV: 22)
        NSLayoutConstraint.activate([
            scrollSurfacebarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollSurfacebarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollSurfacebarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollSurfacebarBV.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            stackSurfacebarBV.topAnchor.constraint(equalTo: scrollSurfacebarBV.contentLayoutGuide.topAnchor, constant: styleStorebarBV.spacebarBV(16, minimumbarBV: 12, maximumbarBV: 22)),
            stackSurfacebarBV.leadingAnchor.constraint(equalTo: scrollSurfacebarBV.frameLayoutGuide.leadingAnchor, constant: sideInsetbarBV),
            stackSurfacebarBV.trailingAnchor.constraint(equalTo: scrollSurfacebarBV.frameLayoutGuide.trailingAnchor, constant: -sideInsetbarBV),
            stackSurfacebarBV.bottomAnchor.constraint(equalTo: scrollSurfacebarBV.contentLayoutGuide.bottomAnchor, constant: -styleStorebarBV.spacebarBV(26, minimumbarBV: 20, maximumbarBV: 30))
        ])
    }

    private func headerbarBV() -> UIView {
        let headerSurfacebarBV = UIView()
        let backSurfacebarBV = UIButton(type: .system)
        backSurfacebarBV.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backSurfacebarBV.tintColor = .black
        backSurfacebarBV.accessibilityLabel = "Back"
        backSurfacebarBV.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)

        let titleSurfacebarBV = UILabel()
        titleSurfacebarBV.text = "Search"
        titleSurfacebarBV.font = styleStorebarBV.fontbarBV(26, weight: .heavy)
        titleSurfacebarBV.textColor = .black
        titleSurfacebarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(titleSurfacebarBV, factorbarBV: 0.72, linesbarBV: 1)

        headerSurfacebarBV.addSubview(backSurfacebarBV)
        headerSurfacebarBV.addSubview(titleSurfacebarBV)
        backSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false
        titleSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false

        let buttonSizebarBV = styleStorebarBV.controlbarBV(44)
        NSLayoutConstraint.activate([
            headerSurfacebarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(52, minimumbarBV: 46, maximumbarBV: 56)),
            backSurfacebarBV.leadingAnchor.constraint(equalTo: headerSurfacebarBV.leadingAnchor),
            backSurfacebarBV.centerYAnchor.constraint(equalTo: headerSurfacebarBV.centerYAnchor),
            backSurfacebarBV.widthAnchor.constraint(equalToConstant: buttonSizebarBV),
            backSurfacebarBV.heightAnchor.constraint(equalToConstant: buttonSizebarBV),
            titleSurfacebarBV.centerXAnchor.constraint(equalTo: headerSurfacebarBV.centerXAnchor),
            titleSurfacebarBV.centerYAnchor.constraint(equalTo: headerSurfacebarBV.centerYAnchor),
            titleSurfacebarBV.leadingAnchor.constraint(greaterThanOrEqualTo: backSurfacebarBV.trailingAnchor, constant: 8),
            titleSurfacebarBV.trailingAnchor.constraint(lessThanOrEqualTo: headerSurfacebarBV.trailingAnchor, constant: -buttonSizebarBV - 8)
        ])
        return headerSurfacebarBV
    }

    private func searchCardbarBV() -> UIView {
        let cardSurfacebarBV = cardSurfacebarBV(cornerRadius: 24)
        let iconSurfacebarBV = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconSurfacebarBV.tintColor = .black
        iconSurfacebarBV.contentMode = .scaleAspectFit
        fieldSurfacebarBV.placeholder = "Search contacts or messages..."
        fieldSurfacebarBV.font = styleStorebarBV.fontbarBV(17, weight: .semibold)
        fieldSurfacebarBV.textColor = .black
        fieldSurfacebarBV.returnKeyType = .search
        fieldSurfacebarBV.clearButtonMode = .whileEditing
        fieldSurfacebarBV.autocapitalizationType = .none
        fieldSurfacebarBV.autocorrectionType = .no
        fieldSurfacebarBV.delegate = self
        fieldSurfacebarBV.addAction(UIAction { [weak self] _ in
            self?.reloadResultsbarBV(querybarBV: self?.fieldSurfacebarBV.text ?? "")
        }, for: .editingChanged)

        let rowSurfacebarBV = UIStackView(arrangedSubviews: [iconSurfacebarBV, fieldSurfacebarBV])
        rowSurfacebarBV.axis = .horizontal
        rowSurfacebarBV.alignment = .center
        rowSurfacebarBV.spacing = styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)
        cardSurfacebarBV.addSubview(rowSurfacebarBV)
        rowSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cardSurfacebarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.controlbarBV(58)),
            iconSurfacebarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(22, minimumbarBV: 20, maximumbarBV: 24)),
            iconSurfacebarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(22, minimumbarBV: 20, maximumbarBV: 24)),
            rowSurfacebarBV.leadingAnchor.constraint(equalTo: cardSurfacebarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(18, minimumbarBV: 16, maximumbarBV: 20)),
            rowSurfacebarBV.trailingAnchor.constraint(equalTo: cardSurfacebarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(18, minimumbarBV: 16, maximumbarBV: 20)),
            rowSurfacebarBV.topAnchor.constraint(equalTo: cardSurfacebarBV.topAnchor),
            rowSurfacebarBV.bottomAnchor.constraint(equalTo: cardSurfacebarBV.bottomAnchor)
        ])
        return cardSurfacebarBV
    }

    private func resultCardbarBV() -> UIView {
        let cardSurfacebarBV = cardSurfacebarBV(cornerRadius: 24)
        let titleSurfacebarBV = UILabel()
        titleSurfacebarBV.text = "LOCAL RESULTS"
        titleSurfacebarBV.font = styleStorebarBV.fontbarBV(14, weight: .heavy)
        titleSurfacebarBV.textColor = UIColor.black.withAlphaComponent(0.62)
        titleSurfacebarBV.letterSpacingbarBV(1.2)

        resultStackbarBV.axis = .vertical
        resultStackbarBV.spacing = styleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12)

        let stackbarBV = UIStackView(arrangedSubviews: [titleSurfacebarBV, resultStackbarBV])
        stackbarBV.axis = .vertical
        stackbarBV.spacing = styleStorebarBV.spacebarBV(14, minimumbarBV: 12, maximumbarBV: 18)
        cardSurfacebarBV.addSubview(stackbarBV)
        stackbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackbarBV.topAnchor.constraint(equalTo: cardSurfacebarBV.topAnchor, constant: styleStorebarBV.spacebarBV(18, minimumbarBV: 16, maximumbarBV: 22)),
            stackbarBV.leadingAnchor.constraint(equalTo: cardSurfacebarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(16, minimumbarBV: 14, maximumbarBV: 18)),
            stackbarBV.trailingAnchor.constraint(equalTo: cardSurfacebarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(16, minimumbarBV: 14, maximumbarBV: 18)),
            stackbarBV.bottomAnchor.constraint(equalTo: cardSurfacebarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(18, minimumbarBV: 16, maximumbarBV: 22))
        ])
        return cardSurfacebarBV
    }

    private func reloadResultsbarBV(querybarBV: String) {
        let cleanbarBV = querybarBV.trimmingCharacters(in: .whitespacesAndNewlines)
        resultStackbarBV.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if cleanbarBV.isEmpty {
            visibleThreadsbarBV = []
            resultStackbarBV.addArrangedSubview(emptyStatebarBV(
                titlebarBV: "Search your familiar space.",
                messagebarBV: "Look up contacts, chats, or message text stored locally on this device."
            ))
            return
        }

        visibleThreadsbarBV = storebarBV.threadPoolbarBV.filter { threadbarBV in
            searchableTextbarBV(for: threadbarBV).localizedCaseInsensitiveContains(cleanbarBV)
        }

        guard !visibleThreadsbarBV.isEmpty else {
            resultStackbarBV.addArrangedSubview(emptyStatebarBV(
                titlebarBV: "No local results.",
                messagebarBV: "Try another contact name or message phrase."
            ))
            return
        }

        for threadbarBV in visibleThreadsbarBV {
            resultStackbarBV.addArrangedSubview(resultRowbarBV(threadbarBV))
        }
    }

    private func searchableTextbarBV(for threadbarBV: threadFixturebarBV) -> String {
        var partsbarBV = [threadbarBV.localThreadTitle, storebarBV.previewTextbarBV(for: threadbarBV)]
        for contactSeedbarBV in threadbarBV.personaPoolbarBV {
            if let contactbarBV = storebarBV.contactMatcherbarBV(contactSeed: contactSeedbarBV) {
                partsbarBV.append(contactbarBV.placeholderNamebarBV)
                partsbarBV.append(contactbarBV.placeholderNotebarBV)
                partsbarBV.append(localEmailbarBV(for: contactbarBV))
                partsbarBV.append(localPhonebarBV(for: contactbarBV))
            }
        }
        partsbarBV.append(contentsOf: storebarBV.messagePool(for: threadbarBV).map(\.localMessageText))
        return partsbarBV.joined(separator: " ")
    }

    private func localEmailbarBV(for contactbarBV: trustedContact) -> String {
        let slugbarBV = contactbarBV.placeholderNamebarBV
            .replacingOccurrences(of: " ", with: ".")
            .lowercased()
        return "\(slugbarBV)@barb.local"
    }

    private func localPhonebarBV(for contactbarBV: trustedContact) -> String {
        let seedbarBV = abs(contactbarBV.placeholderNamebarBV.unicodeScalars.reduce(0) { partialbarBV, scalarbarBV in
            partialbarBV + Int(scalarbarBV.value)
        })
        return "555\(seedbarBV % 9000000 + 1000000)"
    }

    private func resultRowbarBV(_ threadbarBV: threadFixturebarBV) -> UIControl {
        let rowSurfacebarBV = UIControl()
        rowSurfacebarBV.backgroundColor = UIColor.white.withAlphaComponent(0.92)
        rowSurfacebarBV.layer.cornerRadius = 18
        rowSurfacebarBV.layer.masksToBounds = true
        rowSurfacebarBV.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.navigationController?.pushViewController(threadPagebarBV(store: self.storebarBV, thread: threadbarBV), animated: true)
        }, for: .touchUpInside)

        let contactbarBV = threadbarBV.personaPoolbarBV.first.flatMap { storebarBV.contactMatcherbarBV(contactSeed: $0) }
        let avatarTextbarBV = threadbarBV.smallGroupFlag ? "G" : (contactbarBV?.placeholderAvatar ?? String(threadbarBV.localThreadTitle.prefix(1)).uppercased())
        let avatarSurfacebarBV = avatarSurfacebarBV(initial: avatarTextbarBV, color: threadbarBV.smallGroupFlag ? styleStorebarBV.mint : styleStorebarBV.purple)
        avatarSurfacebarBV.font = styleStorebarBV.fontbarBV(18, weight: .heavy)

        let titleSurfacebarBV = UILabel()
        titleSurfacebarBV.text = threadbarBV.localThreadTitle
        titleSurfacebarBV.font = styleStorebarBV.fontbarBV(17, weight: .heavy)
        titleSurfacebarBV.textColor = .black
        styleStorebarBV.labelFitbarBV(titleSurfacebarBV, factorbarBV: 0.72, linesbarBV: 1)

        let previewSurfacebarBV = UILabel()
        previewSurfacebarBV.text = storebarBV.previewTextbarBV(for: threadbarBV)
        previewSurfacebarBV.font = styleStorebarBV.fontbarBV(14, weight: .regular)
        previewSurfacebarBV.textColor = styleStorebarBV.mutedText
        styleStorebarBV.labelFitbarBV(previewSurfacebarBV, factorbarBV: 0.72, linesbarBV: 2)

        let textStackbarBV = UIStackView(arrangedSubviews: [titleSurfacebarBV, previewSurfacebarBV])
        textStackbarBV.axis = .vertical
        textStackbarBV.spacing = 4
        textStackbarBV.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let typeSurfacebarBV = UILabel()
        typeSurfacebarBV.text = threadbarBV.smallGroupFlag ? "Group" : "Private"
        typeSurfacebarBV.textAlignment = .center
        typeSurfacebarBV.font = styleStorebarBV.fontbarBV(12, weight: .heavy)
        typeSurfacebarBV.textColor = threadbarBV.smallGroupFlag ? styleStorebarBV.purple : styleStorebarBV.blue
        typeSurfacebarBV.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.92)
        typeSurfacebarBV.layer.cornerRadius = 12
        typeSurfacebarBV.clipsToBounds = true
        styleStorebarBV.labelFitbarBV(typeSurfacebarBV, factorbarBV: 0.68, linesbarBV: 1)

        let rowStackbarBV = UIStackView(arrangedSubviews: [avatarSurfacebarBV, textStackbarBV, typeSurfacebarBV])
        rowStackbarBV.axis = .horizontal
        rowStackbarBV.alignment = .center
        rowStackbarBV.spacing = styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)
        rowSurfacebarBV.addSubview(rowStackbarBV)
        rowStackbarBV.translatesAutoresizingMaskIntoConstraints = false

        let avatarSizebarBV = styleStorebarBV.metricbarBV(44, minimumbarBV: 40, maximumbarBV: 48)
        NSLayoutConstraint.activate([
            rowSurfacebarBV.heightAnchor.constraint(greaterThanOrEqualToConstant: styleStorebarBV.metricbarBV(74, minimumbarBV: 66, maximumbarBV: 82)),
            avatarSurfacebarBV.widthAnchor.constraint(equalToConstant: avatarSizebarBV),
            avatarSurfacebarBV.heightAnchor.constraint(equalToConstant: avatarSizebarBV),
            typeSurfacebarBV.widthAnchor.constraint(greaterThanOrEqualToConstant: styleStorebarBV.metricbarBV(64, minimumbarBV: 56, maximumbarBV: 70)),
            typeSurfacebarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(28, minimumbarBV: 26, maximumbarBV: 30)),
            rowStackbarBV.topAnchor.constraint(equalTo: rowSurfacebarBV.topAnchor, constant: styleStorebarBV.spacebarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            rowStackbarBV.leadingAnchor.constraint(equalTo: rowSurfacebarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            rowStackbarBV.trailingAnchor.constraint(equalTo: rowSurfacebarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            rowStackbarBV.bottomAnchor.constraint(equalTo: rowSurfacebarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(12, minimumbarBV: 10, maximumbarBV: 14))
        ])
        return rowSurfacebarBV
    }

    private func emptyStatebarBV(titlebarBV: String, messagebarBV: String) -> UIView {
        let surfacebarBV = UIView()
        let iconSurfacebarBV = UIImageView(image: UIImage(systemName: "sparkle.magnifyingglass"))
        iconSurfacebarBV.tintColor = styleStorebarBV.purple
        iconSurfacebarBV.contentMode = .scaleAspectFit

        let titleSurfacebarBV = UILabel()
        titleSurfacebarBV.text = titlebarBV
        titleSurfacebarBV.font = styleStorebarBV.fontbarBV(18, weight: .heavy)
        titleSurfacebarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(titleSurfacebarBV, factorbarBV: 0.72, linesbarBV: 0)

        let messageSurfacebarBV = UILabel()
        messageSurfacebarBV.text = messagebarBV
        messageSurfacebarBV.font = styleStorebarBV.fontbarBV(15, weight: .regular)
        messageSurfacebarBV.textColor = styleStorebarBV.mutedText
        messageSurfacebarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(messageSurfacebarBV, factorbarBV: 0.72, linesbarBV: 0)

        let stackbarBV = UIStackView(arrangedSubviews: [iconSurfacebarBV, titleSurfacebarBV, messageSurfacebarBV])
        stackbarBV.axis = .vertical
        stackbarBV.alignment = .center
        stackbarBV.spacing = styleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12)
        surfacebarBV.addSubview(stackbarBV)
        stackbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            surfacebarBV.heightAnchor.constraint(greaterThanOrEqualToConstant: styleStorebarBV.metricbarBV(170, minimumbarBV: 140, maximumbarBV: 190)),
            iconSurfacebarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(34, minimumbarBV: 30, maximumbarBV: 38)),
            iconSurfacebarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(34, minimumbarBV: 30, maximumbarBV: 38)),
            stackbarBV.leadingAnchor.constraint(equalTo: surfacebarBV.leadingAnchor, constant: 12),
            stackbarBV.trailingAnchor.constraint(equalTo: surfacebarBV.trailingAnchor, constant: -12),
            stackbarBV.centerYAnchor.constraint(equalTo: surfacebarBV.centerYAnchor)
        ])
        return surfacebarBV
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let threadbarBV = visibleThreadsbarBV.first {
            navigationController?.pushViewController(threadPagebarBV(store: storebarBV, thread: threadbarBV), animated: true)
        }
        return true
    }

    @objc private func dismissKeyboardbarBV() {
        view.endEditing(true)
    }
}

private final class homeNotificationSurfacebarBV: localSurfacebarBV {
    private let scrollSurfacebarBV = UIScrollView()
    private let stackSurfacebarBV = UIStackView()

    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Notifications"
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSurfacebarBV()
    }

    private func configureSurfacebarBV() {
        view.addSubview(scrollSurfacebarBV)
        scrollSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false
        scrollSurfacebarBV.showsVerticalScrollIndicator = false
        scrollSurfacebarBV.addSubview(stackSurfacebarBV)
        stackSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false
        stackSurfacebarBV.axis = .vertical
        stackSurfacebarBV.spacing = styleStorebarBV.spacebarBV(22, minimumbarBV: 18, maximumbarBV: 26)
        stackSurfacebarBV.addArrangedSubview(headerbarBV())
        stackSurfacebarBV.addArrangedSubview(emptyCardbarBV())

        let sideInsetbarBV = styleStorebarBV.metricbarBV(20, minimumbarBV: 16, maximumbarBV: 22)
        NSLayoutConstraint.activate([
            scrollSurfacebarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollSurfacebarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollSurfacebarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollSurfacebarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackSurfacebarBV.topAnchor.constraint(equalTo: scrollSurfacebarBV.contentLayoutGuide.topAnchor, constant: styleStorebarBV.spacebarBV(16, minimumbarBV: 12, maximumbarBV: 22)),
            stackSurfacebarBV.leadingAnchor.constraint(equalTo: scrollSurfacebarBV.frameLayoutGuide.leadingAnchor, constant: sideInsetbarBV),
            stackSurfacebarBV.trailingAnchor.constraint(equalTo: scrollSurfacebarBV.frameLayoutGuide.trailingAnchor, constant: -sideInsetbarBV),
            stackSurfacebarBV.bottomAnchor.constraint(equalTo: scrollSurfacebarBV.contentLayoutGuide.bottomAnchor, constant: -styleStorebarBV.spacebarBV(26, minimumbarBV: 20, maximumbarBV: 30))
        ])
    }

    private func headerbarBV() -> UIView {
        let headerSurfacebarBV = UIView()
        let backSurfacebarBV = UIButton(type: .system)
        backSurfacebarBV.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backSurfacebarBV.tintColor = .black
        backSurfacebarBV.accessibilityLabel = "Back"
        backSurfacebarBV.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)

        let titleSurfacebarBV = UILabel()
        titleSurfacebarBV.text = "Notifications"
        titleSurfacebarBV.font = styleStorebarBV.fontbarBV(26, weight: .heavy)
        titleSurfacebarBV.textColor = .black
        titleSurfacebarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(titleSurfacebarBV, factorbarBV: 0.72, linesbarBV: 1)

        headerSurfacebarBV.addSubview(backSurfacebarBV)
        headerSurfacebarBV.addSubview(titleSurfacebarBV)
        backSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false
        titleSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false
        let buttonSizebarBV = styleStorebarBV.controlbarBV(44)
        NSLayoutConstraint.activate([
            headerSurfacebarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(52, minimumbarBV: 46, maximumbarBV: 56)),
            backSurfacebarBV.leadingAnchor.constraint(equalTo: headerSurfacebarBV.leadingAnchor),
            backSurfacebarBV.centerYAnchor.constraint(equalTo: headerSurfacebarBV.centerYAnchor),
            backSurfacebarBV.widthAnchor.constraint(equalToConstant: buttonSizebarBV),
            backSurfacebarBV.heightAnchor.constraint(equalToConstant: buttonSizebarBV),
            titleSurfacebarBV.centerXAnchor.constraint(equalTo: headerSurfacebarBV.centerXAnchor),
            titleSurfacebarBV.centerYAnchor.constraint(equalTo: headerSurfacebarBV.centerYAnchor),
            titleSurfacebarBV.leadingAnchor.constraint(greaterThanOrEqualTo: backSurfacebarBV.trailingAnchor, constant: 8),
            titleSurfacebarBV.trailingAnchor.constraint(lessThanOrEqualTo: headerSurfacebarBV.trailingAnchor, constant: -buttonSizebarBV - 8)
        ])
        return headerSurfacebarBV
    }

    private func emptyCardbarBV() -> UIView {
        let cardSurfacebarBV = cardSurfacebarBV(cornerRadius: 28)
        let iconShellbarBV = gradientBadgebarBV()
        iconShellbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(34, minimumbarBV: 30, maximumbarBV: 36)
        iconShellbarBV.clipsToBounds = true
        let iconSurfacebarBV = UIImageView(image: UIImage(systemName: "bell.slash.fill"))
        iconSurfacebarBV.tintColor = .white
        iconSurfacebarBV.contentMode = .scaleAspectFit
        iconShellbarBV.addSubview(iconSurfacebarBV)
        iconSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false

        let titleSurfacebarBV = UILabel()
        titleSurfacebarBV.text = "No notifications yet."
        titleSurfacebarBV.font = styleStorebarBV.fontbarBV(24, weight: .heavy)
        titleSurfacebarBV.textAlignment = .center
        titleSurfacebarBV.textColor = .black
        styleStorebarBV.labelFitbarBV(titleSurfacebarBV, factorbarBV: 0.72, linesbarBV: 0)

        let messageSurfacebarBV = UILabel()
        messageSurfacebarBV.text = "Updates about replies, requests, and account activity will appear here."
        messageSurfacebarBV.font = styleStorebarBV.fontbarBV(16, weight: .regular)
        messageSurfacebarBV.textColor = styleStorebarBV.mutedText
        messageSurfacebarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(messageSurfacebarBV, factorbarBV: 0.72, linesbarBV: 0)

        let stackbarBV = UIStackView(arrangedSubviews: [iconShellbarBV, titleSurfacebarBV, messageSurfacebarBV])
        stackbarBV.axis = .vertical
        stackbarBV.alignment = .center
        stackbarBV.spacing = styleStorebarBV.spacebarBV(14, minimumbarBV: 12, maximumbarBV: 18)
        cardSurfacebarBV.addSubview(stackbarBV)
        stackbarBV.translatesAutoresizingMaskIntoConstraints = false
        let iconSizebarBV = styleStorebarBV.metricbarBV(68, minimumbarBV: 60, maximumbarBV: 72)
        NSLayoutConstraint.activate([
            cardSurfacebarBV.heightAnchor.constraint(greaterThanOrEqualToConstant: styleStorebarBV.metricbarBV(310, minimumbarBV: 250, maximumbarBV: 340)),
            iconShellbarBV.widthAnchor.constraint(equalToConstant: iconSizebarBV),
            iconShellbarBV.heightAnchor.constraint(equalToConstant: iconSizebarBV),
            iconSurfacebarBV.centerXAnchor.constraint(equalTo: iconShellbarBV.centerXAnchor),
            iconSurfacebarBV.centerYAnchor.constraint(equalTo: iconShellbarBV.centerYAnchor),
            iconSurfacebarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(30, minimumbarBV: 26, maximumbarBV: 34)),
            iconSurfacebarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(30, minimumbarBV: 26, maximumbarBV: 34)),
            stackbarBV.leadingAnchor.constraint(equalTo: cardSurfacebarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(20, minimumbarBV: 16, maximumbarBV: 24)),
            stackbarBV.trailingAnchor.constraint(equalTo: cardSurfacebarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(20, minimumbarBV: 16, maximumbarBV: 24)),
            stackbarBV.centerYAnchor.constraint(equalTo: cardSurfacebarBV.centerYAnchor)
        ])
        return cardSurfacebarBV
    }
}

private extension UILabel {
    func letterSpacingbarBV(_ spacingbarBV: CGFloat) {
        guard let textbarBV = text, !textbarBV.isEmpty else { return }
        attributedText = NSAttributedString(string: textbarBV, attributes: [.kern: spacingbarBV])
    }
}
