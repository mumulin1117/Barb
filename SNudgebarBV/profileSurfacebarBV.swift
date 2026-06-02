import UIKit
import StoreKit

final class profileSurfacebarBV: localSurfacebarBV {
    private let store: localStorebarBV
    private let scrollViewbarBV = UIScrollView()
    private let stack = UIStackView()
    private var coinValueLabelbarBV = UILabel()

    init(store: localStorebarBV) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        title = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        reload()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        reload()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configure() {
        scrollViewbarBV.showsVerticalScrollIndicator = false
        scrollViewbarBV.alwaysBounceVertical = true
        view.addSubview(scrollViewbarBV)
        scrollViewbarBV.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 20)
        scrollViewbarBV.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 32)
        NSLayoutConstraint.activate([
            scrollViewbarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollViewbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollViewbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewbarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stack.topAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.topAnchor, constant: styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 22)),
            stack.leadingAnchor.constraint(equalTo: scrollViewbarBV.frameLayoutGuide.leadingAnchor, constant: sideInsetbarBV),
            stack.trailingAnchor.constraint(equalTo: scrollViewbarBV.frameLayoutGuide.trailingAnchor, constant: -sideInsetbarBV),
            stack.bottomAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.bottomAnchor, constant: -styleStorebarBV.spacebarBV(24, minimumbarBV: 20, maximumbarBV: 30))
        ])
    }

    private func reload() {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stack.addArrangedSubview(headerbarBV())
        let localProfile = sessionStore.profileLocalbarBV
        let avatarTextbarBV = localProfile?.placeholderAvatar.trimmingCharacters(in: .whitespacesAndNewlines)
        let nameTextbarBV = localProfile?.placeholderNamebarBV.trimmingCharacters(in: .whitespacesAndNewlines)
        let fallbackNamebarBV = nameTextbarBV?.isEmpty == false ? nameTextbarBV! : "Mia Tanaka"
        let avatar = avatarSurfacebarBV(initial: avatarTextbarBV?.isEmpty == false ? avatarTextbarBV! : String(fallbackNamebarBV.prefix(1)).uppercased(), color: styleStorebarBV.pink)
        avatar.font = styleStorebarBV.fontbarBV(52, weight: .bold)
        let name = UILabel()
        name.text = fallbackNamebarBV
        name.font = styleStorebarBV.titleFont(29)
        name.textAlignment = .center
        styleStorebarBV.labelFitbarBV(name, factorbarBV: 0.72, linesbarBV: 1)
        let profileStack = UIStackView(arrangedSubviews: [avatar, name])
        profileStack.axis = .vertical
        profileStack.alignment = .center
        profileStack.spacing = styleStorebarBV.spacebarBV(16, minimumbarBV: 10, maximumbarBV: 18)
        let avatarSizebarBV = styleStorebarBV.metricbarBV(136, minimumbarBV: 104, maximumbarBV: 140)
        avatar.widthAnchor.constraint(equalToConstant: avatarSizebarBV).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: avatarSizebarBV).isActive = true
        stack.addArrangedSubview(profileStack)
        stack.addArrangedSubview(balanceCard())
        stack.addArrangedSubview(stylesCard())
        stack.addArrangedSubview(settingsCard())
    }

    private func headerbarBV() -> UIView {
        let headerbarBV = UIView()
        let titleLabelbarBV = UILabel()
        titleLabelbarBV.text = "Personal"
        titleLabelbarBV.font = styleStorebarBV.italicFontbarBV(36)
        titleLabelbarBV.textColor = .black
        styleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.62, linesbarBV: 1)

        let setupButtonbarBV = personalIconButtonbarBV(symbolbarBV: "gearshape")
        setupButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.showSetupbarBV()
        }, for: .touchUpInside)

        let codeButtonbarBV = personalIconButtonbarBV(symbolbarBV: "qrcode.viewfinder")
        codeButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.showContactInvitebarBV()
        }, for: .touchUpInside)

        let buttonStackbarBV = UIStackView(arrangedSubviews: [setupButtonbarBV, codeButtonbarBV])
        buttonStackbarBV.axis = .horizontal
        buttonStackbarBV.spacing = styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)
        buttonStackbarBV.alignment = .center

        headerbarBV.addSubview(titleLabelbarBV)
        headerbarBV.addSubview(buttonStackbarBV)
        titleLabelbarBV.translatesAutoresizingMaskIntoConstraints = false
        buttonStackbarBV.translatesAutoresizingMaskIntoConstraints = false
        let buttonSizebarBV = styleStorebarBV.controlbarBV(52)
        [setupButtonbarBV, codeButtonbarBV].forEach {
            $0.widthAnchor.constraint(equalToConstant: buttonSizebarBV).isActive = true
            $0.heightAnchor.constraint(equalToConstant: buttonSizebarBV).isActive = true
        }
        NSLayoutConstraint.activate([
            headerbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(58, minimumbarBV: 50, maximumbarBV: 62)),
            titleLabelbarBV.leadingAnchor.constraint(equalTo: headerbarBV.leadingAnchor),
            titleLabelbarBV.centerYAnchor.constraint(equalTo: headerbarBV.centerYAnchor),
            titleLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: buttonStackbarBV.leadingAnchor, constant: -styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            buttonStackbarBV.trailingAnchor.constraint(equalTo: headerbarBV.trailingAnchor),
            buttonStackbarBV.centerYAnchor.constraint(equalTo: headerbarBV.centerYAnchor)
        ])
        return headerbarBV
    }

    private func balanceCard() -> UIView {
        let card = personalGradientControlbarBV()
        card.layer.cornerRadius = styleStorebarBV.metricbarBV(24, minimumbarBV: 20, maximumbarBV: 26)
        card.clipsToBounds = true
        card.addAction(UIAction { [weak self] _ in
            self?.showTopUpbarBV()
        }, for: .touchUpInside)

        let coinIconbarBV = UILabel()
        coinIconbarBV.text = "🟡"
        coinIconbarBV.textAlignment = .center
        coinIconbarBV.font = styleStorebarBV.fontbarBV(28, weight: .heavy)
        coinIconbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.36)
        coinIconbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(22, minimumbarBV: 20, maximumbarBV: 24)
        coinIconbarBV.layer.masksToBounds = true

        let label = UILabel()
        label.text = "Available coins"
        label.font = styleStorebarBV.fontbarBV(19, weight: .heavy)
        styleStorebarBV.labelFitbarBV(label, factorbarBV: 0.68, linesbarBV: 1)
        coinValueLabelbarBV = UILabel()
        coinValueLabelbarBV.text = "\(store.coinBalance)"
        coinValueLabelbarBV.font = styleStorebarBV.fontbarBV(24, weight: .heavy)
        coinValueLabelbarBV.textAlignment = .right
        styleStorebarBV.labelFitbarBV(coinValueLabelbarBV, factorbarBV: 0.68, linesbarBV: 1)
        let chevronbarBV = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronbarBV.tintColor = .black
        chevronbarBV.contentMode = .scaleAspectFit
        chevronbarBV.setContentHuggingPriority(.required, for: .horizontal)
        chevronbarBV.setContentCompressionResistancePriority(.required, for: .horizontal)
        let valueStackbarBV = UIStackView(arrangedSubviews: [coinValueLabelbarBV, chevronbarBV])
        valueStackbarBV.axis = .horizontal
        valueStackbarBV.spacing = styleStorebarBV.metricbarBV(8, minimumbarBV: 6, maximumbarBV: 10)
        valueStackbarBV.alignment = .center
        card.addSubview(label)
        card.addSubview(coinIconbarBV)
        card.addSubview(valueStackbarBV)
        label.translatesAutoresizingMaskIntoConstraints = false
        coinIconbarBV.translatesAutoresizingMaskIntoConstraints = false
        valueStackbarBV.translatesAutoresizingMaskIntoConstraints = false
        let iconSizebarBV = styleStorebarBV.metricbarBV(46, minimumbarBV: 40, maximumbarBV: 48)
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(62, minimumbarBV: 56, maximumbarBV: 68)),
            coinIconbarBV.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: styleStorebarBV.metricbarBV(26, minimumbarBV: 18, maximumbarBV: 28)),
            coinIconbarBV.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            coinIconbarBV.widthAnchor.constraint(equalToConstant: iconSizebarBV),
            coinIconbarBV.heightAnchor.constraint(equalTo: coinIconbarBV.widthAnchor),
            label.leadingAnchor.constraint(equalTo: coinIconbarBV.trailingAnchor, constant: styleStorebarBV.metricbarBV(14, minimumbarBV: 10, maximumbarBV: 16)),
            label.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            valueStackbarBV.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -styleStorebarBV.metricbarBV(22, minimumbarBV: 16, maximumbarBV: 24)),
            valueStackbarBV.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            valueStackbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: label.trailingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            chevronbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(14, minimumbarBV: 12, maximumbarBV: 16)),
            chevronbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(22, minimumbarBV: 18, maximumbarBV: 24))
        ])
        return card
    }

    private func stylesCard() -> UIView {
        let wrapperbarBV = UIView()
        let title = UILabel()
        title.text = "AI STYLE SETTINGS"
        title.font = styleStorebarBV.fontbarBV(18, weight: .heavy)
        title.letterSpacingbarBV(1.6)
        styleStorebarBV.labelFitbarBV(title, factorbarBV: 0.7, linesbarBV: 1)
        let badgebarBV = gradientPill(type: .system)
        badgebarBV.setTitle("✦  \(store.unlockedReplyToneCountbarBV) unlocked ›", for: .normal)
        badgebarBV.setTitleColor(.white, for: .normal)
        badgebarBV.titleLabel?.font = styleStorebarBV.fontbarBV(16, weight: .bold)
        badgebarBV.accessibilityLabel = "AI Tones"
        badgebarBV.addAction(UIAction { [weak self] _ in
            self?.showAITonesbarBV()
        }, for: .touchUpInside)
        badgebarBV.colorsbarBV = [styleStorebarBV.mint, styleStorebarBV.purple, styleStorebarBV.pink]
        badgebarBV.cornerRadiusbarBV = styleStorebarBV.metricbarBV(13, minimumbarBV: 12, maximumbarBV: 14)
        styleStorebarBV.buttonFitbarBV(badgebarBV, factorbarBV: 0.68)

        let titleRowbarBV = UIControl()
        titleRowbarBV.accessibilityLabel = "AI Tones"
        titleRowbarBV.addAction(UIAction { [weak self] _ in
            self?.showAITonesbarBV()
        }, for: .touchUpInside)
        titleRowbarBV.addSubview(title)
        titleRowbarBV.addSubview(badgebarBV)
        title.translatesAutoresizingMaskIntoConstraints = false
        badgebarBV.translatesAutoresizingMaskIntoConstraints = false

        let card = cardSurfacebarBV(cornerRadius: styleStorebarBV.metricbarBV(22, minimumbarBV: 18, maximumbarBV: 24))
        let scrollbarBV = UIScrollView()
        scrollbarBV.showsHorizontalScrollIndicator = false
        let rowbarBV = UIStackView()
        rowbarBV.axis = .horizontal
        rowbarBV.spacing = styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)
        for stylebarBV in store.aiStyleOptionsbarBV() {
            let viewbarBV = aiStyleCardbarBV(stylebarBV: stylebarBV)
            viewbarBV.addAction(UIAction { [weak self] _ in
                self?.store.selectAIStylebarBV(stylebarBV)
                self?.reload()
            }, for: .touchUpInside)
            rowbarBV.addArrangedSubview(viewbarBV)
            viewbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(150, minimumbarBV: 132, maximumbarBV: 160)).isActive = true
        }
        card.addSubview(scrollbarBV)
        scrollbarBV.addSubview(rowbarBV)
        wrapperbarBV.addSubview(titleRowbarBV)
        wrapperbarBV.addSubview(card)
        [titleRowbarBV, card, scrollbarBV, rowbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            titleRowbarBV.topAnchor.constraint(equalTo: wrapperbarBV.topAnchor),
            titleRowbarBV.leadingAnchor.constraint(equalTo: wrapperbarBV.leadingAnchor),
            titleRowbarBV.trailingAnchor.constraint(equalTo: wrapperbarBV.trailingAnchor),
            titleRowbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(34, minimumbarBV: 30, maximumbarBV: 36)),
            title.leadingAnchor.constraint(equalTo: titleRowbarBV.leadingAnchor),
            title.centerYAnchor.constraint(equalTo: titleRowbarBV.centerYAnchor),
            title.trailingAnchor.constraint(lessThanOrEqualTo: badgebarBV.leadingAnchor, constant: -styleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            badgebarBV.trailingAnchor.constraint(equalTo: titleRowbarBV.trailingAnchor),
            badgebarBV.centerYAnchor.constraint(equalTo: titleRowbarBV.centerYAnchor),
            badgebarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(116, minimumbarBV: 104, maximumbarBV: 124)),
            badgebarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(30, minimumbarBV: 28, maximumbarBV: 32)),
            card.topAnchor.constraint(equalTo: titleRowbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10)),
            card.leadingAnchor.constraint(equalTo: wrapperbarBV.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: wrapperbarBV.trailingAnchor),
            card.bottomAnchor.constraint(equalTo: wrapperbarBV.bottomAnchor),
            card.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(86, minimumbarBV: 78, maximumbarBV: 96)),
            scrollbarBV.topAnchor.constraint(equalTo: card.topAnchor, constant: styleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            scrollbarBV.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: styleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            scrollbarBV.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -styleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            scrollbarBV.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -styleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            rowbarBV.topAnchor.constraint(equalTo: scrollbarBV.contentLayoutGuide.topAnchor),
            rowbarBV.leadingAnchor.constraint(equalTo: scrollbarBV.contentLayoutGuide.leadingAnchor),
            rowbarBV.trailingAnchor.constraint(equalTo: scrollbarBV.contentLayoutGuide.trailingAnchor),
            rowbarBV.bottomAnchor.constraint(equalTo: scrollbarBV.contentLayoutGuide.bottomAnchor),
            rowbarBV.heightAnchor.constraint(equalTo: scrollbarBV.frameLayoutGuide.heightAnchor)
        ])
        return wrapperbarBV
    }

    private func settingsCard() -> UIView {
        let wrapperbarBV = UIView()
        let titlebarBV = UILabel()
        titlebarBV.text = "MORE SETTINGS"
        titlebarBV.font = styleStorebarBV.fontbarBV(18, weight: .heavy)
        titlebarBV.letterSpacingbarBV(1.6)
        titlebarBV.textColor = .black
        styleStorebarBV.labelFitbarBV(titlebarBV, factorbarBV: 0.7, linesbarBV: 1)
        let card = cardSurfacebarBV()
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        let rowsbarBV: [(String, String, () -> Void)] = [
            ("Profile", "person", { [weak self] in self?.showPrivacybarBV() }),
            ("Notifications", "bell", { [weak self] in self?.showNotificationsbarBV() })
        ]
        for (indexbarBV, rowbarBV) in rowsbarBV.enumerated() {
            let controlbarBV = profileSettingRowbarBV(titlebarBV: rowbarBV.0, symbolbarBV: rowbarBV.1)
            controlbarBV.addAction(UIAction { _ in rowbarBV.2() }, for: .touchUpInside)
            stack.addArrangedSubview(controlbarBV)
            if indexbarBV < rowsbarBV.count - 1 {
                let dividerbarBV = UIView()
                dividerbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.06)
                stack.addArrangedSubview(dividerbarBV)
                dividerbarBV.heightAnchor.constraint(equalToConstant: 1).isActive = true
            }
        }
        wrapperbarBV.addSubview(titlebarBV)
        wrapperbarBV.addSubview(card)
        card.addSubview(stack)
        [titlebarBV, card, stack].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            titlebarBV.topAnchor.constraint(equalTo: wrapperbarBV.topAnchor),
            titlebarBV.leadingAnchor.constraint(equalTo: wrapperbarBV.leadingAnchor),
            titlebarBV.trailingAnchor.constraint(equalTo: wrapperbarBV.trailingAnchor),
            titlebarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(34, minimumbarBV: 30, maximumbarBV: 36)),
            card.topAnchor.constraint(equalTo: titlebarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            card.leadingAnchor.constraint(equalTo: wrapperbarBV.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: wrapperbarBV.trailingAnchor),
            card.bottomAnchor.constraint(equalTo: wrapperbarBV.bottomAnchor),
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10)),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10))
        ])
        return wrapperbarBV
    }

    private func showContactInvitebarBV() {
        let invitebarBV = addContactSurfacebarBV(store: store)
        invitebarBV.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(invitebarBV, animated: true)
    }

    private func showTopUpbarBV() {
        let topUpbarBV = topUpSurfacebarBV(storebarBV: store)
        topUpbarBV.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(topUpbarBV, animated: true)
    }

    private func showSetupbarBV() {
        let setupbarBV = setupSurfacebarBV(storebarBV: store)
        setupbarBV.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(setupbarBV, animated: true)
    }

    private func showPrivacybarBV() {
        let privacybarBV = privacySurfacebarBV(storebarBV: store)
        privacybarBV.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(privacybarBV, animated: true)
    }

    private func showNotificationsbarBV() {
        let notificationsbarBV = notificationsSurfacebarBV(storebarBV: store)
        notificationsbarBV.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(notificationsbarBV, animated: true)
    }

    private func showAITonesbarBV() {
        let tonesbarBV = aiTonesSurfacebarBV(storebarBV: store)
        tonesbarBV.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(tonesbarBV, animated: true)
    }

    private func presentNoticebarBV(_ messagebarBV: String) {
        let alertbarBV = UIAlertController(title: nil, message: messagebarBV, preferredStyle: .alert)
        alertbarBV.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertbarBV, animated: true)
    }
}

final class aiTonesSurfacebarBV: localSurfacebarBV {
    private let storebarBV: localStorebarBV
    private let headerBarbarBV = UIView()
    private let backButtonbarBV = UIButton(type: .system)
    private let titleLabelbarBV = UILabel()
    private let scrollViewbarBV = UIScrollView()
    private let stackbarBV = UIStackView()
    private let toneListbarBV = UIStackView()
    private let statusLabelbarBV = UILabel()
    private var statusWorkbarBV: DispatchWorkItem?

    init(storebarBV: localStorebarBV) {
        self.storebarBV = storebarBV
        super.init(nibName: nil, bundle: nil)
        title = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderbarBV()
        configureScrollbarBV()
        configureStatusbarBV()
        renderTonesbarBV()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        renderTonesbarBV()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureHeaderbarBV() {
        backButtonbarBV.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButtonbarBV.tintColor = .black
        backButtonbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.36)
        backButtonbarBV.layer.cornerRadius = styleStorebarBV.controlbarBV(44) / 2
        backButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)

        titleLabelbarBV.text = "AI Tones"
        titleLabelbarBV.font = styleStorebarBV.fontbarBV(28, weight: .heavy)
        titleLabelbarBV.textColor = .black
        titleLabelbarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.62, linesbarBV: 1)

        view.addSubview(headerBarbarBV)
        [backButtonbarBV, titleLabelbarBV].forEach {
            headerBarbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        headerBarbarBV.translatesAutoresizingMaskIntoConstraints = false

        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)
        let buttonSizebarBV = styleStorebarBV.controlbarBV(44)
        NSLayoutConstraint.activate([
            headerBarbarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: styleStorebarBV.spacebarBV(10, minimumbarBV: 6, maximumbarBV: 14)),
            headerBarbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInsetbarBV),
            headerBarbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInsetbarBV),
            headerBarbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(54, minimumbarBV: 48, maximumbarBV: 58)),
            backButtonbarBV.leadingAnchor.constraint(equalTo: headerBarbarBV.leadingAnchor),
            backButtonbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            backButtonbarBV.widthAnchor.constraint(equalToConstant: buttonSizebarBV),
            backButtonbarBV.heightAnchor.constraint(equalToConstant: buttonSizebarBV),
            titleLabelbarBV.centerXAnchor.constraint(equalTo: headerBarbarBV.centerXAnchor),
            titleLabelbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            titleLabelbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: backButtonbarBV.trailingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            titleLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: headerBarbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(58, minimumbarBV: 48, maximumbarBV: 62))
        ])
    }

    private func configureScrollbarBV() {
        scrollViewbarBV.showsVerticalScrollIndicator = false
        scrollViewbarBV.alwaysBounceVertical = true
        stackbarBV.axis = .vertical
        stackbarBV.spacing = styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 22)
        toneListbarBV.axis = .vertical
        toneListbarBV.spacing = 0

        view.addSubview(scrollViewbarBV)
        scrollViewbarBV.addSubview(stackbarBV)
        [scrollViewbarBV, stackbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        stackbarBV.addArrangedSubview(introCardbarBV())
        stackbarBV.addArrangedSubview(toneSectionbarBV())

        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)
        NSLayoutConstraint.activate([
            scrollViewbarBV.topAnchor.constraint(equalTo: headerBarbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(22, minimumbarBV: 14, maximumbarBV: 28)),
            scrollViewbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollViewbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewbarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackbarBV.topAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.topAnchor),
            stackbarBV.leadingAnchor.constraint(equalTo: scrollViewbarBV.frameLayoutGuide.leadingAnchor, constant: sideInsetbarBV),
            stackbarBV.trailingAnchor.constraint(equalTo: scrollViewbarBV.frameLayoutGuide.trailingAnchor, constant: -sideInsetbarBV),
            stackbarBV.bottomAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.bottomAnchor, constant: -styleStorebarBV.spacebarBV(26, minimumbarBV: 20, maximumbarBV: 32))
        ])
    }

    private func introCardbarBV() -> UIView {
        let cardbarBV = cardSurfacebarBV(cornerRadius: styleStorebarBV.metricbarBV(28, minimumbarBV: 22, maximumbarBV: 30))
        let iconbarBV = gradientBadgebarBV()
        iconbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(26, minimumbarBV: 22, maximumbarBV: 28)
        iconbarBV.clipsToBounds = true

        let sparkbarBV = UIImageView(image: UIImage(systemName: "sparkles"))
        sparkbarBV.tintColor = .white
        sparkbarBV.contentMode = .scaleAspectFit
        iconbarBV.addSubview(sparkbarBV)
        sparkbarBV.translatesAutoresizingMaskIntoConstraints = false

        let titlebarBV = UILabel()
        titlebarBV.text = "Choose your AI tone"
        titlebarBV.font = styleStorebarBV.fontbarBV(24, weight: .heavy)
        titlebarBV.textColor = .black
        styleStorebarBV.labelFitbarBV(titlebarBV, factorbarBV: 0.64, linesbarBV: 1)

        let detailbarBV = UILabel()
        detailbarBV.text = "Unlocked tones shape local AI reply suggestions. Extra tones use the same coin balance as the rest of Barb."
        detailbarBV.font = styleStorebarBV.fontbarBV(15, weight: .medium)
        detailbarBV.textColor = styleStorebarBV.mutedText
        styleStorebarBV.labelFitbarBV(detailbarBV, factorbarBV: 0.72, linesbarBV: 0)

        let textStackbarBV = UIStackView(arrangedSubviews: [titlebarBV, detailbarBV])
        textStackbarBV.axis = .vertical
        textStackbarBV.spacing = styleStorebarBV.spacebarBV(6, minimumbarBV: 4, maximumbarBV: 8)

        let rowbarBV = UIStackView(arrangedSubviews: [iconbarBV, textStackbarBV])
        rowbarBV.axis = .horizontal
        rowbarBV.alignment = .center
        rowbarBV.spacing = styleStorebarBV.metricbarBV(14, minimumbarBV: 10, maximumbarBV: 16)
        cardbarBV.addSubview(rowbarBV)
        rowbarBV.translatesAutoresizingMaskIntoConstraints = false

        let iconSizebarBV = styleStorebarBV.metricbarBV(54, minimumbarBV: 46, maximumbarBV: 58)
        NSLayoutConstraint.activate([
            iconbarBV.widthAnchor.constraint(equalToConstant: iconSizebarBV),
            iconbarBV.heightAnchor.constraint(equalTo: iconbarBV.widthAnchor),
            sparkbarBV.centerXAnchor.constraint(equalTo: iconbarBV.centerXAnchor),
            sparkbarBV.centerYAnchor.constraint(equalTo: iconbarBV.centerYAnchor),
            sparkbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(26, minimumbarBV: 22, maximumbarBV: 28)),
            sparkbarBV.heightAnchor.constraint(equalTo: sparkbarBV.widthAnchor),
            rowbarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor, constant: styleStorebarBV.spacebarBV(20, minimumbarBV: 16, maximumbarBV: 24)),
            rowbarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 22)),
            rowbarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 22)),
            rowbarBV.bottomAnchor.constraint(equalTo: cardbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(20, minimumbarBV: 16, maximumbarBV: 24))
        ])
        return cardbarBV
    }

    private func toneSectionbarBV() -> UIView {
        let wrapperbarBV = UIView()
        let titlebarBV = UILabel()
        titlebarBV.text = "AI TONES"
        titlebarBV.font = styleStorebarBV.fontbarBV(15, weight: .heavy)
        titlebarBV.textColor = UIColor.black.withAlphaComponent(0.78)
        titlebarBV.letterSpacingbarBV(1.4)
        styleStorebarBV.labelFitbarBV(titlebarBV, factorbarBV: 0.68, linesbarBV: 1)

        let cardbarBV = cardSurfacebarBV(cornerRadius: styleStorebarBV.metricbarBV(24, minimumbarBV: 20, maximumbarBV: 28))
        wrapperbarBV.addSubview(titlebarBV)
        wrapperbarBV.addSubview(cardbarBV)
        cardbarBV.addSubview(toneListbarBV)
        [titlebarBV, cardbarBV, toneListbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            titlebarBV.topAnchor.constraint(equalTo: wrapperbarBV.topAnchor),
            titlebarBV.leadingAnchor.constraint(equalTo: wrapperbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(4, minimumbarBV: 0, maximumbarBV: 6)),
            titlebarBV.trailingAnchor.constraint(equalTo: wrapperbarBV.trailingAnchor),
            titlebarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(28, minimumbarBV: 24, maximumbarBV: 30)),
            cardbarBV.topAnchor.constraint(equalTo: titlebarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(7, minimumbarBV: 5, maximumbarBV: 8)),
            cardbarBV.leadingAnchor.constraint(equalTo: wrapperbarBV.leadingAnchor),
            cardbarBV.trailingAnchor.constraint(equalTo: wrapperbarBV.trailingAnchor),
            cardbarBV.bottomAnchor.constraint(equalTo: wrapperbarBV.bottomAnchor),
            toneListbarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor, constant: styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10)),
            toneListbarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            toneListbarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            toneListbarBV.bottomAnchor.constraint(equalTo: cardbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10))
        ])
        return wrapperbarBV
    }

    private func renderTonesbarBV() {
        toneListbarBV.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let optionsbarBV = storebarBV.replyToneOptionsbarBV()
        for (indexbarBV, stylebarBV) in optionsbarBV.enumerated() {
            let rowbarBV = aiToneRowbarBV(stylebarBV: stylebarBV)
            rowbarBV.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                guard let tonebarBV = replyStylebarBV(rawValue: stylebarBV.styleSeedbarBV) else { return }
                if stylebarBV.unlockFlagbarBV {
                    self.storebarBV.selectReplyTonebarBV(tonebarBV)
                    self.renderTonesbarBV()
                    self.showStatusbarBV("\(stylebarBV.titlebarBV) tone selected")
                    return
                }
                if self.storebarBV.toneUnlockbarBV(tonebarBV) {
                    self.renderTonesbarBV()
                    self.showStatusbarBV("\(stylebarBV.titlebarBV) unlocked")
                } else {
                    self.presentCoinShortagebarBV()
                }
            }, for: .touchUpInside)
            toneListbarBV.addArrangedSubview(rowbarBV)
            if indexbarBV < optionsbarBV.count - 1 {
                let dividerbarBV = UIView()
                dividerbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.06)
                toneListbarBV.addArrangedSubview(dividerbarBV)
                dividerbarBV.heightAnchor.constraint(equalToConstant: 1).isActive = true
            }
        }
    }

    private func presentCoinShortagebarBV() {
        let alertbarBV = UIAlertController(
            title: "Not enough coins",
            message: "Sorry, you don't have enough coins to unlock this AI tone.",
            preferredStyle: .alert
        )
        alertbarBV.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertbarBV.addAction(UIAlertAction(title: "Buy", style: .default) { [weak self] _ in
            guard let self else { return }
            let topUpbarBV = topUpSurfacebarBV(storebarBV: self.storebarBV)
            topUpbarBV.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(topUpbarBV, animated: true)
        })
        present(alertbarBV, animated: true)
    }

    private func configureStatusbarBV() {
        statusLabelbarBV.alpha = 0
        statusLabelbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.74)
        statusLabelbarBV.textColor = .white
        statusLabelbarBV.font = styleStorebarBV.fontbarBV(14, weight: .bold)
        statusLabelbarBV.textAlignment = .center
        statusLabelbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(17, minimumbarBV: 15, maximumbarBV: 18)
        statusLabelbarBV.layer.masksToBounds = true
        styleStorebarBV.labelFitbarBV(statusLabelbarBV, factorbarBV: 0.7, linesbarBV: 1)
        view.addSubview(statusLabelbarBV)
        statusLabelbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabelbarBV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabelbarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 22)),
            statusLabelbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: styleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 40)),
            statusLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -styleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 40)),
            statusLabelbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(34, minimumbarBV: 30, maximumbarBV: 36))
        ])
    }

    private func showStatusbarBV(_ textbarBV: String) {
        statusWorkbarBV?.cancel()
        statusLabelbarBV.text = "  \(textbarBV)  "
        UIView.animate(withDuration: 0.18) {
            self.statusLabelbarBV.alpha = 1
        }
        let workbarBV = DispatchWorkItem { [weak self] in
            UIView.animate(withDuration: 0.22) {
                self?.statusLabelbarBV.alpha = 0
            }
        }
        statusWorkbarBV = workbarBV
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25, execute: workbarBV)
    }
}

private enum coinPurchaseResultbarBV {
    case completedbarBV(balancebarBV: Int, grantedbarBV: Bool)
    case cancelledbarBV
    case pendingbarBV
}

private enum coinPurchaseErrorbarBV: LocalizedError {
    case unavailablebarBV
    case unverifiedbarBV
    case unknownbarBV

    var errorDescription: String? {
        switch self {
        case .unavailablebarBV:
            return "This coin package is not available yet."
        case .unverifiedbarBV:
            return "Purchase verification failed."
        case .unknownbarBV:
            return "Purchase could not be completed."
        }
    }
}

@MainActor
private enum coinPurchaseCoordinatorbarBV {
    static func purchasebarBV(packagebarBV: coinPackagebarBV, storebarBV: localStorebarBV) async throws -> coinPurchaseResultbarBV {
        let productsbarBV = try await Product.products(for: [packagebarBV.productSeedbarBV])
        guard let productbarBV = productsbarBV.first(where: { $0.id == packagebarBV.productSeedbarBV }) else {
            throw coinPurchaseErrorbarBV.unavailablebarBV
        }
        let resultbarBV = try await productbarBV.purchase()
        switch resultbarBV {
        case .success(let verificationbarBV):
            let transactionbarBV = try verifiedTransactionbarBV(verificationbarBV)
            let grantbarBV = storebarBV.grantPurchasedCoinsbarBV(
                packagebarBV: packagebarBV,
                purchaseSeedbarBV: "\(transactionbarBV.id)"
            )
            await transactionbarBV.finish()
            return .completedbarBV(balancebarBV: grantbarBV.balancebarBV, grantedbarBV: grantbarBV.grantedbarBV)
        case .userCancelled:
            return .cancelledbarBV
        case .pending:
            return .pendingbarBV
        @unknown default:
            throw coinPurchaseErrorbarBV.unknownbarBV
        }
    }

    private static func verifiedTransactionbarBV(_ verificationbarBV: VerificationResult<Transaction>) throws -> Transaction {
        switch verificationbarBV {
        case .verified(let transactionbarBV):
            return transactionbarBV
        case .unverified:
            throw coinPurchaseErrorbarBV.unverifiedbarBV
        }
    }
}

final class topUpSurfacebarBV: localSurfacebarBV {
    private let storebarBV: localStorebarBV
    private let headerBarbarBV = UIView()
    private let backButtonbarBV = UIButton(type: .system)
    private let titleLabelbarBV = UILabel()
    private let scrollViewbarBV = UIScrollView()
    private let stackbarBV = UIStackView()
    private let balanceValuebarBV = UILabel()
    private let packageGridbarBV = UIStackView()
    private let rechargeButtonbarBV = gradientPill(type: .system)
    private let statusLabelbarBV = UILabel()
    private var statusWorkbarBV: DispatchWorkItem?
    private var selectedPackageSeedbarBV: String
    private var packageCellsbarBV: [coinPackageCellbarBV] = []
    private var purchaseTaskbarBV: Task<Void, Never>?

    init(storebarBV: localStorebarBV) {
        self.storebarBV = storebarBV
        self.selectedPackageSeedbarBV = storebarBV.coinPackagesbarBV().first?.packageSeedbarBV ?? ""
        super.init(nibName: nil, bundle: nil)
        title = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        purchaseTaskbarBV?.cancel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderbarBV()
        configureButtonbarBV()
        configureScrollContentbarBV()
        configureStatusbarBV()
        refreshBalancebarBV()
        renderPackagesbarBV()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        refreshBalancebarBV()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureHeaderbarBV() {
        backButtonbarBV.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButtonbarBV.tintColor = .black
        backButtonbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.36)
        backButtonbarBV.layer.cornerRadius = styleStorebarBV.controlbarBV(44) / 2
        backButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)

        titleLabelbarBV.text = "Top up"
        titleLabelbarBV.font = styleStorebarBV.fontbarBV(28, weight: .heavy)
        titleLabelbarBV.textColor = .black
        titleLabelbarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.66, linesbarBV: 1)

        view.addSubview(headerBarbarBV)
        [backButtonbarBV, titleLabelbarBV].forEach {
            headerBarbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        headerBarbarBV.translatesAutoresizingMaskIntoConstraints = false

        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)
        let buttonSizebarBV = styleStorebarBV.controlbarBV(44)
        NSLayoutConstraint.activate([
            headerBarbarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: styleStorebarBV.spacebarBV(10, minimumbarBV: 6, maximumbarBV: 14)),
            headerBarbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInsetbarBV),
            headerBarbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInsetbarBV),
            headerBarbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(54, minimumbarBV: 48, maximumbarBV: 58)),
            backButtonbarBV.leadingAnchor.constraint(equalTo: headerBarbarBV.leadingAnchor),
            backButtonbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            backButtonbarBV.widthAnchor.constraint(equalToConstant: buttonSizebarBV),
            backButtonbarBV.heightAnchor.constraint(equalToConstant: buttonSizebarBV),
            titleLabelbarBV.centerXAnchor.constraint(equalTo: headerBarbarBV.centerXAnchor),
            titleLabelbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            titleLabelbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: backButtonbarBV.trailingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            titleLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: headerBarbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(58, minimumbarBV: 48, maximumbarBV: 62))
        ])
    }

    private func configureButtonbarBV() {
        rechargeButtonbarBV.setTitle("Recharge", for: .normal)
        rechargeButtonbarBV.setTitleColor(.black, for: .normal)
        rechargeButtonbarBV.titleLabel?.font = styleStorebarBV.fontbarBV(23, weight: .heavy)
        rechargeButtonbarBV.colorsbarBV = [
            UIColor(red: 186 / 255, green: 241 / 255, blue: 1, alpha: 1),
            UIColor(red: 1, green: 211 / 255, blue: 250 / 255, alpha: 1),
            UIColor(red: 153 / 255, green: 226 / 255, blue: 248 / 255, alpha: 1)
        ]
        rechargeButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.rechargebarBV()
        }, for: .touchUpInside)
        view.addSubview(rechargeButtonbarBV)
        rechargeButtonbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rechargeButtonbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)),
            rechargeButtonbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)),
            rechargeButtonbarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 22)),
            rechargeButtonbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(62, minimumbarBV: 54, maximumbarBV: 66))
        ])
    }

    private func configureScrollContentbarBV() {
        scrollViewbarBV.showsVerticalScrollIndicator = false
        scrollViewbarBV.alwaysBounceVertical = true
        stackbarBV.axis = .vertical
        stackbarBV.spacing = styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 20)
        view.addSubview(scrollViewbarBV)
        scrollViewbarBV.addSubview(stackbarBV)
        [scrollViewbarBV, stackbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)
        NSLayoutConstraint.activate([
            scrollViewbarBV.topAnchor.constraint(equalTo: headerBarbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(16, minimumbarBV: 10, maximumbarBV: 20)),
            scrollViewbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollViewbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewbarBV.bottomAnchor.constraint(equalTo: rechargeButtonbarBV.topAnchor, constant: -styleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 18)),
            stackbarBV.topAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.topAnchor),
            stackbarBV.leadingAnchor.constraint(equalTo: scrollViewbarBV.frameLayoutGuide.leadingAnchor, constant: sideInsetbarBV),
            stackbarBV.trailingAnchor.constraint(equalTo: scrollViewbarBV.frameLayoutGuide.trailingAnchor, constant: -sideInsetbarBV),
            stackbarBV.bottomAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.bottomAnchor, constant: -styleStorebarBV.spacebarBV(12, minimumbarBV: 8, maximumbarBV: 16))
        ])
        stackbarBV.addArrangedSubview(balanceCardbarBV())
        stackbarBV.addArrangedSubview(dividerbarBV())
        stackbarBV.addArrangedSubview(packageSectionbarBV())
    }

    private func balanceCardbarBV() -> UIView {
        let cardbarBV = cardSurfacebarBV(cornerRadius: styleStorebarBV.metricbarBV(28, minimumbarBV: 24, maximumbarBV: 30))
        let stripbarBV = personalGradientControlbarBV()
        stripbarBV.isUserInteractionEnabled = false
        stripbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(22, minimumbarBV: 18, maximumbarBV: 24)
        stripbarBV.clipsToBounds = true

        let coinbarBV = UILabel()
        coinbarBV.text = "🟡"
        coinbarBV.font = styleStorebarBV.fontbarBV(26, weight: .heavy)
        coinbarBV.textAlignment = .center
        let titlebarBV = UILabel()
        titlebarBV.text = "Available coins"
        titlebarBV.font = styleStorebarBV.fontbarBV(19, weight: .heavy)
        titlebarBV.textColor = .black
        styleStorebarBV.labelFitbarBV(titlebarBV, factorbarBV: 0.68, linesbarBV: 1)
        let stripStackbarBV = UIStackView(arrangedSubviews: [coinbarBV, titlebarBV])
        stripStackbarBV.axis = .horizontal
        stripStackbarBV.alignment = .center
        stripStackbarBV.spacing = styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)

        balanceValuebarBV.font = styleStorebarBV.fontbarBV(34, weight: .heavy)
        balanceValuebarBV.textAlignment = .center
        balanceValuebarBV.textColor = .black
        styleStorebarBV.labelFitbarBV(balanceValuebarBV, factorbarBV: 0.62, linesbarBV: 1)

        cardbarBV.addSubview(stripbarBV)
        stripbarBV.addSubview(stripStackbarBV)
        cardbarBV.addSubview(balanceValuebarBV)
        [stripbarBV, stripStackbarBV, balanceValuebarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            cardbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(132, minimumbarBV: 118, maximumbarBV: 138)),
            stripbarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor),
            stripbarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor),
            stripbarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor),
            stripbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(58, minimumbarBV: 52, maximumbarBV: 62)),
            stripStackbarBV.leadingAnchor.constraint(equalTo: stripbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(28, minimumbarBV: 20, maximumbarBV: 30)),
            stripStackbarBV.trailingAnchor.constraint(lessThanOrEqualTo: stripbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(20, minimumbarBV: 16, maximumbarBV: 24)),
            stripStackbarBV.centerYAnchor.constraint(equalTo: stripbarBV.centerYAnchor),
            balanceValuebarBV.topAnchor.constraint(equalTo: stripbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(16, minimumbarBV: 12, maximumbarBV: 18)),
            balanceValuebarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(20, minimumbarBV: 16, maximumbarBV: 24)),
            balanceValuebarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(20, minimumbarBV: 16, maximumbarBV: 24))
        ])
        return cardbarBV
    }

    private func dividerbarBV() -> UIView {
        let containerbarBV = UIView()
        let leftbarBV = UIView()
        let rightbarBV = UIView()
        let textbarBV = UILabel()
        leftbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.18)
        rightbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.18)
        textbarBV.text = "or"
        textbarBV.font = styleStorebarBV.fontbarBV(14, weight: .bold)
        textbarBV.textAlignment = .center
        textbarBV.textColor = .black
        [leftbarBV, textbarBV, rightbarBV].forEach {
            containerbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            containerbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(28, minimumbarBV: 24, maximumbarBV: 30)),
            textbarBV.centerXAnchor.constraint(equalTo: containerbarBV.centerXAnchor),
            textbarBV.centerYAnchor.constraint(equalTo: containerbarBV.centerYAnchor),
            textbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(44, minimumbarBV: 34, maximumbarBV: 48)),
            leftbarBV.leadingAnchor.constraint(equalTo: containerbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(10, minimumbarBV: 4, maximumbarBV: 12)),
            leftbarBV.trailingAnchor.constraint(equalTo: textbarBV.leadingAnchor, constant: -styleStorebarBV.metricbarBV(8, minimumbarBV: 6, maximumbarBV: 10)),
            leftbarBV.centerYAnchor.constraint(equalTo: containerbarBV.centerYAnchor),
            leftbarBV.heightAnchor.constraint(equalToConstant: 1),
            rightbarBV.leadingAnchor.constraint(equalTo: textbarBV.trailingAnchor, constant: styleStorebarBV.metricbarBV(8, minimumbarBV: 6, maximumbarBV: 10)),
            rightbarBV.trailingAnchor.constraint(equalTo: containerbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(10, minimumbarBV: 4, maximumbarBV: 12)),
            rightbarBV.centerYAnchor.constraint(equalTo: containerbarBV.centerYAnchor),
            rightbarBV.heightAnchor.constraint(equalToConstant: 1)
        ])
        return containerbarBV
    }

    private func packageSectionbarBV() -> UIView {
        let wrapperbarBV = UIView()
        let titlebarBV = UILabel()
        titlebarBV.text = "TOP UP PACKAGES"
        titlebarBV.font = styleStorebarBV.fontbarBV(18, weight: .heavy)
        titlebarBV.letterSpacingbarBV(1.6)
        styleStorebarBV.labelFitbarBV(titlebarBV, factorbarBV: 0.7, linesbarBV: 1)

        let cardbarBV = cardSurfacebarBV(cornerRadius: styleStorebarBV.metricbarBV(24, minimumbarBV: 20, maximumbarBV: 28))
        packageGridbarBV.axis = .vertical
        packageGridbarBV.spacing = styleStorebarBV.metricbarBV(12, minimumbarBV: 9, maximumbarBV: 14)

        wrapperbarBV.addSubview(titlebarBV)
        wrapperbarBV.addSubview(cardbarBV)
        cardbarBV.addSubview(packageGridbarBV)
        [titlebarBV, cardbarBV, packageGridbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            titlebarBV.topAnchor.constraint(equalTo: wrapperbarBV.topAnchor),
            titlebarBV.leadingAnchor.constraint(equalTo: wrapperbarBV.leadingAnchor),
            titlebarBV.trailingAnchor.constraint(equalTo: wrapperbarBV.trailingAnchor),
            titlebarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(32, minimumbarBV: 28, maximumbarBV: 34)),
            cardbarBV.topAnchor.constraint(equalTo: titlebarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            cardbarBV.leadingAnchor.constraint(equalTo: wrapperbarBV.leadingAnchor),
            cardbarBV.trailingAnchor.constraint(equalTo: wrapperbarBV.trailingAnchor),
            cardbarBV.bottomAnchor.constraint(equalTo: wrapperbarBV.bottomAnchor),
            packageGridbarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor, constant: styleStorebarBV.spacebarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            packageGridbarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(18, minimumbarBV: 12, maximumbarBV: 20)),
            packageGridbarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(18, minimumbarBV: 12, maximumbarBV: 20)),
            packageGridbarBV.bottomAnchor.constraint(equalTo: cardbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(18, minimumbarBV: 14, maximumbarBV: 20))
        ])
        return wrapperbarBV
    }

    private func renderPackagesbarBV() {
        packageGridbarBV.arrangedSubviews.forEach {
            packageGridbarBV.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        packageCellsbarBV.removeAll()
        let packagesbarBV = storebarBV.coinPackagesbarBV(selectedSeedbarBV: selectedPackageSeedbarBV)
        for rowStartbarBV in stride(from: 0, to: packagesbarBV.count, by: 3) {
            let rowbarBV = UIStackView()
            rowbarBV.axis = .horizontal
            rowbarBV.distribution = .fillEqually
            rowbarBV.spacing = styleStorebarBV.metricbarBV(10, minimumbarBV: 7, maximumbarBV: 12)
            for packagebarBV in packagesbarBV[rowStartbarBV..<min(rowStartbarBV + 3, packagesbarBV.count)] {
                let cellbarBV = coinPackageCellbarBV(packagebarBV: packagebarBV)
                cellbarBV.addAction(UIAction { [weak self] _ in
                    self?.selectPackagebarBV(packageSeedbarBV: packagebarBV.packageSeedbarBV, amountbarBV: packagebarBV.coinAmountbarBV)
                }, for: .touchUpInside)
                rowbarBV.addArrangedSubview(cellbarBV)
                packageCellsbarBV.append(cellbarBV)
            }
            while rowbarBV.arrangedSubviews.count < 3 {
                let spacerbarBV = UIView()
                rowbarBV.addArrangedSubview(spacerbarBV)
            }
            packageGridbarBV.addArrangedSubview(rowbarBV)
            rowbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(112, minimumbarBV: 100, maximumbarBV: 118)).isActive = true
        }
    }

    private func selectPackagebarBV(packageSeedbarBV: String, amountbarBV: Int) {
        guard selectedPackageSeedbarBV != packageSeedbarBV else { return }
        selectedPackageSeedbarBV = packageSeedbarBV
        renderPackagesbarBV()
        showStatusbarBV("\(amountbarBV) coins selected")
    }

    private func rechargebarBV() {
        guard let packagebarBV = storebarBV.coinPackagesbarBV(selectedSeedbarBV: selectedPackageSeedbarBV).first(where: { $0.packageSeedbarBV == selectedPackageSeedbarBV }) else {
            showStatusbarBV("Please choose a package")
            return
        }
        purchaseTaskbarBV?.cancel()
        setPurchaseLoadingbarBV(true)
        showStatusbarBV("Starting purchase...")
        purchaseTaskbarBV = Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                let resultbarBV = try await coinPurchaseCoordinatorbarBV.purchasebarBV(packagebarBV: packagebarBV, storebarBV: self.storebarBV)
                guard !Task.isCancelled else { return }
                self.setPurchaseLoadingbarBV(false)
                switch resultbarBV {
                case .completedbarBV(let balancebarBV, let grantedbarBV):
                    self.balanceValuebarBV.text = "\(balancebarBV)"
                    self.showStatusbarBV(grantedbarBV ? "Purchase successful" : "Purchase already applied")
                case .cancelledbarBV:
                    self.showStatusbarBV("Purchase cancelled")
                case .pendingbarBV:
                    self.showStatusbarBV("Purchase pending")
                }
            } catch {
                guard !Task.isCancelled else { return }
                self.setPurchaseLoadingbarBV(false)
                self.showStatusbarBV((error as? LocalizedError)?.errorDescription ?? "Purchase failed")
            }
        }
    }

    private func refreshBalancebarBV() {
        balanceValuebarBV.text = "\(storebarBV.coinBalance)"
    }

    private func setPurchaseLoadingbarBV(_ loadingbarBV: Bool) {
        rechargeButtonbarBV.isEnabled = !loadingbarBV
        rechargeButtonbarBV.alpha = loadingbarBV ? 0.72 : 1
        rechargeButtonbarBV.setTitle(loadingbarBV ? "Processing..." : "Recharge", for: .normal)
        packageCellsbarBV.forEach { $0.isEnabled = !loadingbarBV }
    }

    private func configureStatusbarBV() {
        statusLabelbarBV.alpha = 0
        statusLabelbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.74)
        statusLabelbarBV.textColor = .white
        statusLabelbarBV.font = styleStorebarBV.fontbarBV(14, weight: .bold)
        statusLabelbarBV.textAlignment = .center
        statusLabelbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(17, minimumbarBV: 15, maximumbarBV: 18)
        statusLabelbarBV.layer.masksToBounds = true
        styleStorebarBV.labelFitbarBV(statusLabelbarBV, factorbarBV: 0.7, linesbarBV: 1)
        view.addSubview(statusLabelbarBV)
        statusLabelbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabelbarBV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabelbarBV.bottomAnchor.constraint(equalTo: rechargeButtonbarBV.topAnchor, constant: -styleStorebarBV.spacebarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            statusLabelbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: styleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 40)),
            statusLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -styleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 40)),
            statusLabelbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(34, minimumbarBV: 30, maximumbarBV: 36))
        ])
    }

    private func showStatusbarBV(_ textbarBV: String) {
        statusWorkbarBV?.cancel()
        statusLabelbarBV.text = "  \(textbarBV)  "
        UIView.animate(withDuration: 0.18) {
            self.statusLabelbarBV.alpha = 1
        }
        let workbarBV = DispatchWorkItem { [weak self] in
            UIView.animate(withDuration: 0.22) {
                self?.statusLabelbarBV.alpha = 0
            }
        }
        statusWorkbarBV = workbarBV
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25, execute: workbarBV)
    }
}

private final class setupSurfacebarBV: localSurfacebarBV {
    private let storebarBV: localStorebarBV
    private let headerBarbarBV = UIView()
    private let backButtonbarBV = UIButton(type: .system)
    private let titleLabelbarBV = UILabel()
    private let scrollViewbarBV = UIScrollView()
    private let stackbarBV = UIStackView()
    private let cancelButtonbarBV = gradientPill(type: .system)
    private let statusLabelbarBV = UILabel()
    private var accountSheetbarBV: accountActionSheetbarBV?
    private var statusWorkbarBV: DispatchWorkItem?

    init(storebarBV: localStorebarBV) {
        self.storebarBV = storebarBV
        super.init(nibName: nil, bundle: nil)
        title = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderbarBV()
        configureCancelButtonbarBV()
        configureScrollContentbarBV()
        configureStatusbarBV()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureHeaderbarBV() {
        backButtonbarBV.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButtonbarBV.tintColor = .black
        backButtonbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.36)
        backButtonbarBV.layer.cornerRadius = styleStorebarBV.controlbarBV(44) / 2
        backButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)

        titleLabelbarBV.text = "Set up"
        titleLabelbarBV.font = styleStorebarBV.fontbarBV(28, weight: .heavy)
        titleLabelbarBV.textColor = .black
        titleLabelbarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.66, linesbarBV: 1)

        view.addSubview(headerBarbarBV)
        [backButtonbarBV, titleLabelbarBV].forEach {
            headerBarbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        headerBarbarBV.translatesAutoresizingMaskIntoConstraints = false

        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)
        let buttonSizebarBV = styleStorebarBV.controlbarBV(44)
        NSLayoutConstraint.activate([
            headerBarbarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: styleStorebarBV.spacebarBV(10, minimumbarBV: 6, maximumbarBV: 14)),
            headerBarbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInsetbarBV),
            headerBarbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInsetbarBV),
            headerBarbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(54, minimumbarBV: 48, maximumbarBV: 58)),
            backButtonbarBV.leadingAnchor.constraint(equalTo: headerBarbarBV.leadingAnchor),
            backButtonbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            backButtonbarBV.widthAnchor.constraint(equalToConstant: buttonSizebarBV),
            backButtonbarBV.heightAnchor.constraint(equalToConstant: buttonSizebarBV),
            titleLabelbarBV.centerXAnchor.constraint(equalTo: headerBarbarBV.centerXAnchor),
            titleLabelbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            titleLabelbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: backButtonbarBV.trailingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            titleLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: headerBarbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(58, minimumbarBV: 48, maximumbarBV: 62))
        ])
    }

    private func configureCancelButtonbarBV() {
        cancelButtonbarBV.setTitle("Log Out", for: .normal)
        cancelButtonbarBV.setTitleColor(.black, for: .normal)
        cancelButtonbarBV.titleLabel?.font = styleStorebarBV.fontbarBV(23, weight: .heavy)
        cancelButtonbarBV.colorsbarBV = [
            UIColor(red: 186 / 255, green: 241 / 255, blue: 1, alpha: 1),
            UIColor(red: 1, green: 211 / 255, blue: 250 / 255, alpha: 1),
            UIColor(red: 153 / 255, green: 226 / 255, blue: 248 / 255, alpha: 1)
        ]
        cancelButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.logOutbarBV()
        }, for: .touchUpInside)
        view.addSubview(cancelButtonbarBV)
        cancelButtonbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButtonbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)),
            cancelButtonbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)),
            cancelButtonbarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 22)),
            cancelButtonbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(62, minimumbarBV: 54, maximumbarBV: 66))
        ])
    }

    private func configureScrollContentbarBV() {
        scrollViewbarBV.showsVerticalScrollIndicator = false
        scrollViewbarBV.alwaysBounceVertical = true
        stackbarBV.axis = .vertical
        stackbarBV.spacing = styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 22)
        view.addSubview(scrollViewbarBV)
        scrollViewbarBV.addSubview(stackbarBV)
        [scrollViewbarBV, stackbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)
        NSLayoutConstraint.activate([
            scrollViewbarBV.topAnchor.constraint(equalTo: headerBarbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(38, minimumbarBV: 22, maximumbarBV: 44)),
            scrollViewbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollViewbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewbarBV.bottomAnchor.constraint(equalTo: cancelButtonbarBV.topAnchor, constant: -styleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 18)),
            stackbarBV.topAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.topAnchor),
            stackbarBV.leadingAnchor.constraint(equalTo: scrollViewbarBV.frameLayoutGuide.leadingAnchor, constant: sideInsetbarBV),
            stackbarBV.trailingAnchor.constraint(equalTo: scrollViewbarBV.frameLayoutGuide.trailingAnchor, constant: -sideInsetbarBV),
            stackbarBV.bottomAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.bottomAnchor, constant: -styleStorebarBV.spacebarBV(12, minimumbarBV: 8, maximumbarBV: 16))
        ])
        stackbarBV.addArrangedSubview(settingsCardbarBV())
    }

    private func settingsCardbarBV() -> UIView {
        let cardbarBV = cardSurfacebarBV(cornerRadius: styleStorebarBV.metricbarBV(24, minimumbarBV: 20, maximumbarBV: 28))
        let listbarBV = UIStackView()
        listbarBV.axis = .vertical
        listbarBV.spacing = 0
        let rowsbarBV: [setupRowModelbarBV] = [
            setupRowModelbarBV(titlebarBV: "Terms of Use", symbolbarBV: "doc.text", dangerbarBV: false, actionbarBV: { [weak self] in self?.openTermsbarBV() }),
            setupRowModelbarBV(titlebarBV: "Privacy Policy", symbolbarBV: "shield.lefthalf.filled", dangerbarBV: false, actionbarBV: { [weak self] in self?.openPolicybarBV() }),
            setupRowModelbarBV(titlebarBV: "Privacy", symbolbarBV: "lock.shield", dangerbarBV: false, actionbarBV: { [weak self] in self?.openPrivacySettingsbarBV() }),
            setupRowModelbarBV(titlebarBV: "Contact us", symbolbarBV: "message", dangerbarBV: false, actionbarBV: { [weak self] in self?.openContactSupportbarBV() }),
            setupRowModelbarBV(titlebarBV: "Blocked List", symbolbarBV: "person.crop.circle.badge.xmark", dangerbarBV: false, actionbarBV: { [weak self] in self?.openBlockedListbarBV() }),
            setupRowModelbarBV(titlebarBV: "Delete Account", symbolbarBV: "trash", dangerbarBV: true, actionbarBV: { [weak self] in self?.openDeleteAccountbarBV() })
        ]
        for (indexbarBV, rowbarBV) in rowsbarBV.enumerated() {
            let controlbarBV = setupSettingRowbarBV(modelbarBV: rowbarBV)
            controlbarBV.addAction(UIAction { _ in rowbarBV.actionbarBV() }, for: .touchUpInside)
            listbarBV.addArrangedSubview(controlbarBV)
            if indexbarBV < rowsbarBV.count - 1 {
                let dividerbarBV = UIView()
                dividerbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.06)
                listbarBV.addArrangedSubview(dividerbarBV)
                dividerbarBV.heightAnchor.constraint(equalToConstant: 1).isActive = true
            }
        }
        cardbarBV.addSubview(listbarBV)
        listbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listbarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor, constant: styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10)),
            listbarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            listbarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            listbarBV.bottomAnchor.constraint(equalTo: cardbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10))
        ])
        return cardbarBV
    }

    private func openTermsbarBV() {
        let pagebarBV = agreementPage()
        pagebarBV.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(pagebarBV, animated: true)
    }

    private func openPolicybarBV() {
        let pagebarBV = policyPagebarBV()
        pagebarBV.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(pagebarBV, animated: true)
    }

    private func openPrivacySettingsbarBV() {
        let privacybarBV = privacySurfacebarBV(storebarBV: storebarBV)
        privacybarBV.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(privacybarBV, animated: true)
    }

    private func openContactSupportbarBV() {
        let contactbarBV = contactSupportSurfacebarBV()
        contactbarBV.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(contactbarBV, animated: true)
    }

    private func openBlockedListbarBV() {
        let blockedbarBV = blockedListSurfacebarBV(store: storebarBV)
        blockedbarBV.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(blockedbarBV, animated: true)
    }

    private func openDeleteAccountbarBV() {
        let deletebarBV = deleteAccountSurfacebarBV(storebarBV: storebarBV)
        deletebarBV.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(deletebarBV, animated: true)
    }

    private func logOutbarBV() {
        dismissAccountSheetbarBV()
        showStatusbarBV("Logged out")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            sessionStore.logoutFlowbarBV()
        }
    }

    private func showAccountSheetbarBV() {
        guard accountSheetbarBV == nil else { return }
        let sheetbarBV = accountActionSheetbarBV()
        sheetbarBV.dismissHandlerbarBV = { [weak self] in
            self?.dismissAccountSheetbarBV()
        }
        sheetbarBV.logOutHandlerbarBV = { [weak self] in
            self?.dismissAccountSheetbarBV()
            self?.showStatusbarBV("Logged out")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                sessionStore.logoutFlowbarBV()
            }
        }
        sheetbarBV.deleteHandlerbarBV = { [weak self] in
            self?.dismissAccountSheetbarBV()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self?.openDeleteAccountbarBV()
            }
        }
        view.addSubview(sheetbarBV)
        sheetbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sheetbarBV.topAnchor.constraint(equalTo: view.topAnchor),
            sheetbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetbarBV.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        accountSheetbarBV = sheetbarBV
        sheetbarBV.showbarBV()
    }

    private func dismissAccountSheetbarBV() {
        guard let sheetbarBV = accountSheetbarBV else { return }
        accountSheetbarBV = nil
        sheetbarBV.dismissbarBV()
    }

    private func configureStatusbarBV() {
        statusLabelbarBV.alpha = 0
        statusLabelbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.74)
        statusLabelbarBV.textColor = .white
        statusLabelbarBV.font = styleStorebarBV.fontbarBV(14, weight: .bold)
        statusLabelbarBV.textAlignment = .center
        statusLabelbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(17, minimumbarBV: 15, maximumbarBV: 18)
        statusLabelbarBV.layer.masksToBounds = true
        styleStorebarBV.labelFitbarBV(statusLabelbarBV, factorbarBV: 0.7, linesbarBV: 1)
        view.addSubview(statusLabelbarBV)
        statusLabelbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabelbarBV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabelbarBV.bottomAnchor.constraint(equalTo: cancelButtonbarBV.topAnchor, constant: -styleStorebarBV.spacebarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            statusLabelbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: styleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 40)),
            statusLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -styleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 40)),
            statusLabelbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(34, minimumbarBV: 30, maximumbarBV: 36))
        ])
    }

    private func showStatusbarBV(_ textbarBV: String) {
        statusWorkbarBV?.cancel()
        statusLabelbarBV.text = "  \(textbarBV)  "
        UIView.animate(withDuration: 0.18) {
            self.statusLabelbarBV.alpha = 1
        }
        let workbarBV = DispatchWorkItem { [weak self] in
            UIView.animate(withDuration: 0.22) {
                self?.statusLabelbarBV.alpha = 0
            }
        }
        statusWorkbarBV = workbarBV
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25, execute: workbarBV)
    }
}

private final class contactSupportSurfacebarBV: localSurfacebarBV {
    private let headerBarbarBV = UIView()
    private let backButtonbarBV = UIButton(type: .system)
    private let titleLabelbarBV = UILabel()
    private let scrollViewbarBV = UIScrollView()
    private let contentViewbarBV = UIView()
    private let stackbarBV = UIStackView()
    private let statusLabelbarBV = UILabel()
    private var statusWorkbarBV: DispatchWorkItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = nil
        configureHeaderbarBV()
        configureScrollContentbarBV()
        configureStatusbarBV()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureHeaderbarBV() {
        backButtonbarBV.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButtonbarBV.tintColor = .black
        backButtonbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.36)
        backButtonbarBV.layer.cornerRadius = styleStorebarBV.controlbarBV(44) / 2
        backButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)

        titleLabelbarBV.text = "Contact us"
        titleLabelbarBV.font = styleStorebarBV.fontbarBV(28, weight: .heavy)
        titleLabelbarBV.textColor = .black
        titleLabelbarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.62, linesbarBV: 1)

        view.addSubview(headerBarbarBV)
        [backButtonbarBV, titleLabelbarBV].forEach {
            headerBarbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        headerBarbarBV.translatesAutoresizingMaskIntoConstraints = false

        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)
        let buttonSizebarBV = styleStorebarBV.controlbarBV(44)
        NSLayoutConstraint.activate([
            headerBarbarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: styleStorebarBV.spacebarBV(10, minimumbarBV: 6, maximumbarBV: 14)),
            headerBarbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInsetbarBV),
            headerBarbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInsetbarBV),
            headerBarbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(54, minimumbarBV: 48, maximumbarBV: 58)),
            backButtonbarBV.leadingAnchor.constraint(equalTo: headerBarbarBV.leadingAnchor),
            backButtonbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            backButtonbarBV.widthAnchor.constraint(equalToConstant: buttonSizebarBV),
            backButtonbarBV.heightAnchor.constraint(equalToConstant: buttonSizebarBV),
            titleLabelbarBV.centerXAnchor.constraint(equalTo: headerBarbarBV.centerXAnchor),
            titleLabelbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            titleLabelbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: backButtonbarBV.trailingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            titleLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: headerBarbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(58, minimumbarBV: 48, maximumbarBV: 62))
        ])
    }

    private func configureScrollContentbarBV() {
        scrollViewbarBV.showsVerticalScrollIndicator = false
        scrollViewbarBV.alwaysBounceVertical = true
        stackbarBV.axis = .vertical
        stackbarBV.alignment = .fill
        stackbarBV.spacing = styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 22)

        view.addSubview(scrollViewbarBV)
        scrollViewbarBV.addSubview(contentViewbarBV)
        contentViewbarBV.addSubview(stackbarBV)
        [scrollViewbarBV, contentViewbarBV, stackbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)
        NSLayoutConstraint.activate([
            scrollViewbarBV.topAnchor.constraint(equalTo: headerBarbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 24)),
            scrollViewbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollViewbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewbarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentViewbarBV.topAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.topAnchor),
            contentViewbarBV.leadingAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.leadingAnchor),
            contentViewbarBV.trailingAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.trailingAnchor),
            contentViewbarBV.bottomAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.bottomAnchor),
            contentViewbarBV.widthAnchor.constraint(equalTo: scrollViewbarBV.frameLayoutGuide.widthAnchor),
            stackbarBV.topAnchor.constraint(equalTo: contentViewbarBV.topAnchor),
            stackbarBV.leadingAnchor.constraint(equalTo: contentViewbarBV.leadingAnchor, constant: sideInsetbarBV),
            stackbarBV.trailingAnchor.constraint(equalTo: contentViewbarBV.trailingAnchor, constant: -sideInsetbarBV),
            stackbarBV.bottomAnchor.constraint(equalTo: contentViewbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(30, minimumbarBV: 22, maximumbarBV: 36))
        ])

        stackbarBV.addArrangedSubview(heroCardbarBV())
        stackbarBV.addArrangedSubview(contactCardbarBV())
    }

    private func heroCardbarBV() -> UIView {
        let wrapperbarBV = UIView()
        let iconBackbarBV = gradientPill(type: .system)
        let iconbarBV = UIImageView(image: UIImage(systemName: "envelope.fill"))
        let titlebarBV = UILabel()
        let subtitlebarBV = UILabel()

        iconBackbarBV.isUserInteractionEnabled = false
        iconBackbarBV.colorsbarBV = styleStorebarBV.replyChoiceColorsbarBV
        iconbarBV.tintColor = .white
        iconbarBV.contentMode = .scaleAspectFit

        titlebarBV.text = "We'd love to hear from you"
        titlebarBV.font = styleStorebarBV.fontbarBV(25, weight: .heavy)
        titlebarBV.textColor = .black
        titlebarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(titlebarBV, factorbarBV: 0.58, linesbarBV: 2)

        subtitlebarBV.text = "Bug? Suggestion? Hello?\nPick whichever way works best."
        subtitlebarBV.font = styleStorebarBV.fontbarBV(16, weight: .semibold)
        subtitlebarBV.textColor = styleStorebarBV.mutedText
        subtitlebarBV.textAlignment = .center
        subtitlebarBV.numberOfLines = 0

        let stackbarBV = UIStackView(arrangedSubviews: [iconBackbarBV, titlebarBV, subtitlebarBV])
        stackbarBV.axis = .vertical
        stackbarBV.alignment = .center
        stackbarBV.spacing = styleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 16)
        wrapperbarBV.addSubview(stackbarBV)
        iconBackbarBV.addSubview(iconbarBV)
        [stackbarBV, iconBackbarBV, iconbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        let iconSizebarBV = styleStorebarBV.metricbarBV(72, minimumbarBV: 60, maximumbarBV: 78)
        NSLayoutConstraint.activate([
            stackbarBV.topAnchor.constraint(equalTo: wrapperbarBV.topAnchor, constant: styleStorebarBV.spacebarBV(10, minimumbarBV: 6, maximumbarBV: 12)),
            stackbarBV.leadingAnchor.constraint(equalTo: wrapperbarBV.leadingAnchor),
            stackbarBV.trailingAnchor.constraint(equalTo: wrapperbarBV.trailingAnchor),
            stackbarBV.bottomAnchor.constraint(equalTo: wrapperbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(8, minimumbarBV: 4, maximumbarBV: 10)),
            iconBackbarBV.widthAnchor.constraint(equalToConstant: iconSizebarBV),
            iconBackbarBV.heightAnchor.constraint(equalTo: iconBackbarBV.widthAnchor),
            iconbarBV.centerXAnchor.constraint(equalTo: iconBackbarBV.centerXAnchor),
            iconbarBV.centerYAnchor.constraint(equalTo: iconBackbarBV.centerYAnchor),
            iconbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(34, minimumbarBV: 28, maximumbarBV: 38)),
            iconbarBV.heightAnchor.constraint(equalTo: iconbarBV.widthAnchor)
        ])
        return wrapperbarBV
    }

    private func contactCardbarBV() -> UIView {
        let cardbarBV = cardSurfacebarBV(cornerRadius: styleStorebarBV.metricbarBV(24, minimumbarBV: 20, maximumbarBV: 28))
        let listbarBV = UIStackView()
        listbarBV.axis = .vertical
        listbarBV.spacing = 0
        let rowsbarBV = [
            contactSupportRowModelbarBV(titlebarBV: "Email support", subtitlebarBV: "hello@barb.im", symbolbarBV: "envelope.fill", actionbarBV: { [weak self] in self?.emailSupportbarBV() }),
            contactSupportRowModelbarBV(titlebarBV: "Help Center", subtitlebarBV: "help.barb.im", symbolbarBV: "questionmark.circle.fill", actionbarBV: { [weak self] in self?.showStatusbarBV("Help Center coming soon") }),
            contactSupportRowModelbarBV(titlebarBV: "Send feedback", subtitlebarBV: "In-app form", symbolbarBV: "bubble.left.and.bubble.right.fill", actionbarBV: { [weak self] in self?.showStatusbarBV("Feedback coming soon") }),
            contactSupportRowModelbarBV(titlebarBV: "Twitter / X", subtitlebarBV: "@barbapp", symbolbarBV: "at", actionbarBV: { [weak self] in self?.showStatusbarBV("Twitter / X coming soon") })
        ]
        for (indexbarBV, rowbarBV) in rowsbarBV.enumerated() {
            let controlbarBV = contactSupportItembarBV(modelbarBV: rowbarBV)
            controlbarBV.addAction(UIAction { _ in rowbarBV.actionbarBV() }, for: .touchUpInside)
            listbarBV.addArrangedSubview(controlbarBV)
            if indexbarBV < rowsbarBV.count - 1 {
                let dividerbarBV = UIView()
                dividerbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.06)
                listbarBV.addArrangedSubview(dividerbarBV)
                dividerbarBV.heightAnchor.constraint(equalToConstant: 1).isActive = true
            }
        }
        cardbarBV.addSubview(listbarBV)
        listbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listbarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor, constant: styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10)),
            listbarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            listbarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            listbarBV.bottomAnchor.constraint(equalTo: cardbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10))
        ])
        return cardbarBV
    }

    private func emailSupportbarBV() {
        let mailbarBV = "hello@barb.im"
        guard let urlbarBV = URL(string: "mailto:\(mailbarBV)") else {
            copyEmailbarBV(mailbarBV)
            return
        }
        if UIApplication.shared.canOpenURL(urlbarBV) {
            UIApplication.shared.open(urlbarBV) { [weak self] successbarBV in
                if !successbarBV {
                    self?.copyEmailbarBV(mailbarBV)
                }
            }
        } else {
            copyEmailbarBV(mailbarBV)
        }
    }

    private func copyEmailbarBV(_ mailbarBV: String) {
        UIPasteboard.general.string = mailbarBV
        showStatusbarBV("Email copied")
    }

    private func configureStatusbarBV() {
        statusLabelbarBV.alpha = 0
        statusLabelbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.74)
        statusLabelbarBV.textColor = .white
        statusLabelbarBV.font = styleStorebarBV.fontbarBV(14, weight: .bold)
        statusLabelbarBV.textAlignment = .center
        statusLabelbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(17, minimumbarBV: 15, maximumbarBV: 18)
        statusLabelbarBV.layer.masksToBounds = true
        styleStorebarBV.labelFitbarBV(statusLabelbarBV, factorbarBV: 0.7, linesbarBV: 1)
        view.addSubview(statusLabelbarBV)
        statusLabelbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabelbarBV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabelbarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -styleStorebarBV.spacebarBV(24, minimumbarBV: 16, maximumbarBV: 28)),
            statusLabelbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: styleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 40)),
            statusLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -styleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 40)),
            statusLabelbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(34, minimumbarBV: 30, maximumbarBV: 36))
        ])
    }

    private func showStatusbarBV(_ textbarBV: String) {
        statusWorkbarBV?.cancel()
        statusLabelbarBV.text = "  \(textbarBV)  "
        UIView.animate(withDuration: 0.18) {
            self.statusLabelbarBV.alpha = 1
        }
        let workbarBV = DispatchWorkItem { [weak self] in
            UIView.animate(withDuration: 0.22) {
                self?.statusLabelbarBV.alpha = 0
            }
        }
        statusWorkbarBV = workbarBV
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25, execute: workbarBV)
    }
}

private struct contactSupportRowModelbarBV {
    let titlebarBV: String
    let subtitlebarBV: String
    let symbolbarBV: String
    let actionbarBV: () -> Void
}

private final class contactSupportItembarBV: UIControl {
    private let modelbarBV: contactSupportRowModelbarBV

    init(modelbarBV: contactSupportRowModelbarBV) {
        self.modelbarBV = modelbarBV
        super.init(frame: .zero)
        configurebarBV()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configurebarBV() {
        let iconWrapbarBV = UIView()
        let iconbarBV = UIImageView(image: UIImage(systemName: modelbarBV.symbolbarBV))
        let titlebarBV = UILabel()
        let subtitlebarBV = UILabel()
        let chevronbarBV = UIImageView(image: UIImage(systemName: "chevron.right"))

        iconWrapbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        iconWrapbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(18, minimumbarBV: 16, maximumbarBV: 20)
        iconbarBV.tintColor = styleStorebarBV.purple
        iconbarBV.contentMode = .scaleAspectFit
        titlebarBV.text = modelbarBV.titlebarBV
        titlebarBV.font = styleStorebarBV.fontbarBV(18, weight: .heavy)
        titlebarBV.textColor = .black
        subtitlebarBV.text = modelbarBV.subtitlebarBV
        subtitlebarBV.font = styleStorebarBV.fontbarBV(13, weight: .semibold)
        subtitlebarBV.textColor = styleStorebarBV.mutedText
        chevronbarBV.tintColor = UIColor.black.withAlphaComponent(0.28)
        chevronbarBV.contentMode = .scaleAspectFit
        styleStorebarBV.labelFitbarBV(titlebarBV, factorbarBV: 0.62, linesbarBV: 1)
        styleStorebarBV.labelFitbarBV(subtitlebarBV, factorbarBV: 0.68, linesbarBV: 1)

        let textStackbarBV = UIStackView(arrangedSubviews: [titlebarBV, subtitlebarBV])
        textStackbarBV.axis = .vertical
        textStackbarBV.spacing = styleStorebarBV.spacebarBV(4, minimumbarBV: 3, maximumbarBV: 5)
        [iconWrapbarBV, textStackbarBV, chevronbarBV].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        iconWrapbarBV.addSubview(iconbarBV)
        iconbarBV.translatesAutoresizingMaskIntoConstraints = false

        let iconSizebarBV = styleStorebarBV.metricbarBV(44, minimumbarBV: 38, maximumbarBV: 48)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: styleStorebarBV.metricbarBV(76, minimumbarBV: 68, maximumbarBV: 82)),
            iconWrapbarBV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: styleStorebarBV.metricbarBV(14, minimumbarBV: 10, maximumbarBV: 16)),
            iconWrapbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconWrapbarBV.widthAnchor.constraint(equalToConstant: iconSizebarBV),
            iconWrapbarBV.heightAnchor.constraint(equalTo: iconWrapbarBV.widthAnchor),
            iconbarBV.centerXAnchor.constraint(equalTo: iconWrapbarBV.centerXAnchor),
            iconbarBV.centerYAnchor.constraint(equalTo: iconWrapbarBV.centerYAnchor),
            iconbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(20, minimumbarBV: 17, maximumbarBV: 22)),
            iconbarBV.heightAnchor.constraint(equalTo: iconbarBV.widthAnchor),
            chevronbarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -styleStorebarBV.metricbarBV(14, minimumbarBV: 10, maximumbarBV: 16)),
            chevronbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(15, minimumbarBV: 12, maximumbarBV: 16)),
            chevronbarBV.heightAnchor.constraint(equalTo: chevronbarBV.widthAnchor),
            textStackbarBV.leadingAnchor.constraint(equalTo: iconWrapbarBV.trailingAnchor, constant: styleStorebarBV.metricbarBV(14, minimumbarBV: 10, maximumbarBV: 16)),
            textStackbarBV.trailingAnchor.constraint(equalTo: chevronbarBV.leadingAnchor, constant: -styleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            textStackbarBV.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

private final class deleteAccountSurfacebarBV: localSurfacebarBV {
    private let storebarBV: localStorebarBV
    private let headerBarbarBV = UIView()
    private let backButtonbarBV = UIButton(type: .system)
    private let titleLabelbarBV = UILabel()
    private let scrollViewbarBV = UIScrollView()
    private let contentViewbarBV = UIView()
    private let stackbarBV = UIStackView()
    private let buttonStackbarBV = UIStackView()
    private let deleteButtonbarBV = gradientPill(type: .system)
    private let cancelButtonbarBV = UIButton(type: .system)
    private let statusLabelbarBV = UILabel()
    private var statusWorkbarBV: DispatchWorkItem?

    init(storebarBV: localStorebarBV) {
        self.storebarBV = storebarBV
        super.init(nibName: nil, bundle: nil)
        title = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderbarBV()
        configureButtonsbarBV()
        configureScrollContentbarBV()
        configureStatusbarBV()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureHeaderbarBV() {
        backButtonbarBV.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButtonbarBV.tintColor = .black
        backButtonbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.36)
        backButtonbarBV.layer.cornerRadius = styleStorebarBV.controlbarBV(44) / 2
        backButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)

        titleLabelbarBV.text = "Delete Account"
        titleLabelbarBV.font = styleStorebarBV.fontbarBV(28, weight: .heavy)
        titleLabelbarBV.textColor = .black
        titleLabelbarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.58, linesbarBV: 1)

        view.addSubview(headerBarbarBV)
        [backButtonbarBV, titleLabelbarBV].forEach {
            headerBarbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        headerBarbarBV.translatesAutoresizingMaskIntoConstraints = false

        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)
        let buttonSizebarBV = styleStorebarBV.controlbarBV(44)
        NSLayoutConstraint.activate([
            headerBarbarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: styleStorebarBV.spacebarBV(10, minimumbarBV: 6, maximumbarBV: 14)),
            headerBarbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInsetbarBV),
            headerBarbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInsetbarBV),
            headerBarbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(54, minimumbarBV: 48, maximumbarBV: 58)),
            backButtonbarBV.leadingAnchor.constraint(equalTo: headerBarbarBV.leadingAnchor),
            backButtonbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            backButtonbarBV.widthAnchor.constraint(equalToConstant: buttonSizebarBV),
            backButtonbarBV.heightAnchor.constraint(equalToConstant: buttonSizebarBV),
            titleLabelbarBV.centerXAnchor.constraint(equalTo: headerBarbarBV.centerXAnchor),
            titleLabelbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            titleLabelbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: backButtonbarBV.trailingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            titleLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: headerBarbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(58, minimumbarBV: 48, maximumbarBV: 62))
        ])
    }

    private func configureButtonsbarBV() {
        buttonStackbarBV.axis = .vertical
        buttonStackbarBV.spacing = styleStorebarBV.spacebarBV(12, minimumbarBV: 8, maximumbarBV: 14)
        deleteButtonbarBV.setTitle("Permanently Delete", for: .normal)
        deleteButtonbarBV.setTitleColor(.black, for: .normal)
        deleteButtonbarBV.titleLabel?.font = styleStorebarBV.fontbarBV(20, weight: .heavy)
        deleteButtonbarBV.colorsbarBV = [
            UIColor(red: 1, green: 156 / 255, blue: 220 / 255, alpha: 1),
            UIColor(red: 1, green: 210 / 255, blue: 242 / 255, alpha: 1),
            UIColor(red: 143 / 255, green: 221 / 255, blue: 1, alpha: 1)
        ]
        deleteButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.confirmPermanentDeletebarBV()
        }, for: .touchUpInside)

        cancelButtonbarBV.setTitle("Cancel", for: .normal)
        cancelButtonbarBV.setTitleColor(.black, for: .normal)
        cancelButtonbarBV.titleLabel?.font = styleStorebarBV.fontbarBV(20, weight: .heavy)
        cancelButtonbarBV.backgroundColor = .white
        cancelButtonbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(28, minimumbarBV: 24, maximumbarBV: 30)
        cancelButtonbarBV.clipsToBounds = true
        cancelButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)
        [deleteButtonbarBV, cancelButtonbarBV].forEach {
            buttonStackbarBV.addArrangedSubview($0)
            $0.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(58, minimumbarBV: 52, maximumbarBV: 62)).isActive = true
        }
        view.addSubview(buttonStackbarBV)
        buttonStackbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)),
            buttonStackbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)),
            buttonStackbarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -styleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 18))
        ])
    }

    private func configureScrollContentbarBV() {
        scrollViewbarBV.showsVerticalScrollIndicator = false
        scrollViewbarBV.alwaysBounceVertical = true
        stackbarBV.axis = .vertical
        stackbarBV.alignment = .fill
        stackbarBV.spacing = styleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 18)
        view.addSubview(scrollViewbarBV)
        scrollViewbarBV.addSubview(contentViewbarBV)
        contentViewbarBV.addSubview(stackbarBV)
        [scrollViewbarBV, contentViewbarBV, stackbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)
        NSLayoutConstraint.activate([
            scrollViewbarBV.topAnchor.constraint(equalTo: headerBarbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(12, minimumbarBV: 8, maximumbarBV: 16)),
            scrollViewbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollViewbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewbarBV.bottomAnchor.constraint(equalTo: buttonStackbarBV.topAnchor, constant: -styleStorebarBV.spacebarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            contentViewbarBV.topAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.topAnchor),
            contentViewbarBV.leadingAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.leadingAnchor),
            contentViewbarBV.trailingAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.trailingAnchor),
            contentViewbarBV.bottomAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.bottomAnchor),
            contentViewbarBV.widthAnchor.constraint(equalTo: scrollViewbarBV.frameLayoutGuide.widthAnchor),
            stackbarBV.topAnchor.constraint(equalTo: contentViewbarBV.topAnchor),
            stackbarBV.leadingAnchor.constraint(equalTo: contentViewbarBV.leadingAnchor, constant: sideInsetbarBV),
            stackbarBV.trailingAnchor.constraint(equalTo: contentViewbarBV.trailingAnchor, constant: -sideInsetbarBV),
            stackbarBV.bottomAnchor.constraint(equalTo: contentViewbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 22))
        ])

        stackbarBV.addArrangedSubview(deleteHeroCardbarBV())
        stackbarBV.addArrangedSubview(sectionTitlebarBV("NOTIFICATIONS"))
        stackbarBV.addArrangedSubview(warningListCardbarBV())
    }

    private func deleteHeroCardbarBV() -> UIView {
        let wrapperbarBV = UIView()
        let iconWrapbarBV = UIView()
        let iconbarBV = UIImageView(image: UIImage(systemName: "trash.fill"))
        let titlebarBV = UILabel()
        let warningbarBV = UILabel()
        let copybarBV = UILabel()

        iconWrapbarBV.backgroundColor = UIColor.red.withAlphaComponent(0.12)
        iconWrapbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(36, minimumbarBV: 30, maximumbarBV: 39)
        iconbarBV.tintColor = .systemRed
        iconbarBV.contentMode = .scaleAspectFit
        titlebarBV.text = "Delete your account?"
        titlebarBV.font = styleStorebarBV.fontbarBV(25, weight: .heavy)
        titlebarBV.textColor = .black
        titlebarBV.textAlignment = .center
        warningbarBV.text = "⚠️This action cannot be undone"
        warningbarBV.font = styleStorebarBV.fontbarBV(16, weight: .heavy)
        warningbarBV.textColor = .systemRed
        warningbarBV.textAlignment = .center
        copybarBV.text = "All your data will be permanently deleted within 30 days."
        copybarBV.font = styleStorebarBV.fontbarBV(15, weight: .semibold)
        copybarBV.textColor = styleStorebarBV.mutedText
        copybarBV.textAlignment = .center
        copybarBV.numberOfLines = 0
        [titlebarBV, warningbarBV].forEach {
            styleStorebarBV.labelFitbarBV($0, factorbarBV: 0.58, linesbarBV: 1)
        }

        let stackbarBV = UIStackView(arrangedSubviews: [iconWrapbarBV, titlebarBV, warningbarBV, copybarBV])
        stackbarBV.axis = .vertical
        stackbarBV.alignment = .center
        stackbarBV.spacing = styleStorebarBV.spacebarBV(12, minimumbarBV: 8, maximumbarBV: 14)
        wrapperbarBV.addSubview(stackbarBV)
        iconWrapbarBV.addSubview(iconbarBV)
        [stackbarBV, iconWrapbarBV, iconbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        let iconSizebarBV = styleStorebarBV.metricbarBV(72, minimumbarBV: 60, maximumbarBV: 78)
        NSLayoutConstraint.activate([
            stackbarBV.topAnchor.constraint(equalTo: wrapperbarBV.topAnchor, constant: styleStorebarBV.spacebarBV(8, minimumbarBV: 4, maximumbarBV: 10)),
            stackbarBV.leadingAnchor.constraint(equalTo: wrapperbarBV.leadingAnchor),
            stackbarBV.trailingAnchor.constraint(equalTo: wrapperbarBV.trailingAnchor),
            stackbarBV.bottomAnchor.constraint(equalTo: wrapperbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(8, minimumbarBV: 4, maximumbarBV: 10)),
            iconWrapbarBV.widthAnchor.constraint(equalToConstant: iconSizebarBV),
            iconWrapbarBV.heightAnchor.constraint(equalTo: iconWrapbarBV.widthAnchor),
            iconbarBV.centerXAnchor.constraint(equalTo: iconWrapbarBV.centerXAnchor),
            iconbarBV.centerYAnchor.constraint(equalTo: iconWrapbarBV.centerYAnchor),
            iconbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(32, minimumbarBV: 26, maximumbarBV: 36)),
            iconbarBV.heightAnchor.constraint(equalTo: iconbarBV.widthAnchor),
            copybarBV.leadingAnchor.constraint(equalTo: stackbarBV.leadingAnchor),
            copybarBV.trailingAnchor.constraint(equalTo: stackbarBV.trailingAnchor)
        ])
        return wrapperbarBV
    }

    private func sectionTitlebarBV(_ textbarBV: String) -> UILabel {
        let labelbarBV = UILabel()
        labelbarBV.text = textbarBV
        labelbarBV.font = styleStorebarBV.fontbarBV(15, weight: .heavy)
        labelbarBV.textColor = UIColor.black.withAlphaComponent(0.78)
        labelbarBV.letterSpacingbarBV(1.4)
        styleStorebarBV.labelFitbarBV(labelbarBV, factorbarBV: 0.68, linesbarBV: 1)
        return labelbarBV
    }

    private func warningListCardbarBV() -> UIView {
        let cardbarBV = cardSurfacebarBV(cornerRadius: styleStorebarBV.metricbarBV(24, minimumbarBV: 20, maximumbarBV: 28))
        let listbarBV = UIStackView()
        listbarBV.axis = .vertical
        listbarBV.spacing = 0
        let coinTextbarBV = NumberFormatter.localizedString(from: NSNumber(value: storebarBV.coinBalance), number: .decimal)
        let rowsbarBV = [
            "All your messages and conversations",
            "Your contacts and group memberships",
            "Remaining \(coinTextbarBV) coins in wallet (non-refundable)",
            "All unlocked AI tones",
            "Profile, photo, and account settings"
        ]
        for (indexbarBV, rowbarBV) in rowsbarBV.enumerated() {
            listbarBV.addArrangedSubview(deleteWarningRowbarBV(textbarBV: rowbarBV))
            if indexbarBV < rowsbarBV.count - 1 {
                let dividerbarBV = UIView()
                dividerbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.06)
                listbarBV.addArrangedSubview(dividerbarBV)
                dividerbarBV.heightAnchor.constraint(equalToConstant: 1).isActive = true
            }
        }
        cardbarBV.addSubview(listbarBV)
        listbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listbarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor, constant: styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10)),
            listbarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            listbarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            listbarBV.bottomAnchor.constraint(equalTo: cardbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10))
        ])
        return cardbarBV
    }

    private func confirmPermanentDeletebarBV() {
        let alertbarBV = UIAlertController(
            title: "Permanently delete account?",
            message: "This local account deletion cannot be undone. Your current profile will be cleared and you will be signed out.",
            preferredStyle: .alert
        )
        alertbarBV.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertbarBV.addAction(UIAlertAction(title: "Permanently Delete", style: .destructive) { [weak self] _ in
            self?.showStatusbarBV("Account deleted.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                sessionStore.deleteLocalAccountbarBV()
            }
        })
        present(alertbarBV, animated: true)
    }

    private func configureStatusbarBV() {
        statusLabelbarBV.alpha = 0
        statusLabelbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.74)
        statusLabelbarBV.textColor = .white
        statusLabelbarBV.font = styleStorebarBV.fontbarBV(14, weight: .bold)
        statusLabelbarBV.textAlignment = .center
        statusLabelbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(17, minimumbarBV: 15, maximumbarBV: 18)
        statusLabelbarBV.layer.masksToBounds = true
        styleStorebarBV.labelFitbarBV(statusLabelbarBV, factorbarBV: 0.7, linesbarBV: 1)
        view.addSubview(statusLabelbarBV)
        statusLabelbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabelbarBV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabelbarBV.bottomAnchor.constraint(equalTo: buttonStackbarBV.topAnchor, constant: -styleStorebarBV.spacebarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            statusLabelbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: styleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 40)),
            statusLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -styleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 40)),
            statusLabelbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(34, minimumbarBV: 30, maximumbarBV: 36))
        ])
    }

    private func showStatusbarBV(_ textbarBV: String) {
        statusWorkbarBV?.cancel()
        statusLabelbarBV.text = "  \(textbarBV)  "
        UIView.animate(withDuration: 0.18) {
            self.statusLabelbarBV.alpha = 1
        }
        let workbarBV = DispatchWorkItem { [weak self] in
            UIView.animate(withDuration: 0.22) {
                self?.statusLabelbarBV.alpha = 0
            }
        }
        statusWorkbarBV = workbarBV
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25, execute: workbarBV)
    }
}

private final class deleteWarningRowbarBV: UIView {
    init(textbarBV: String) {
        super.init(frame: .zero)
        configurebarBV(textbarBV: textbarBV)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configurebarBV(textbarBV: String) {
        let markbarBV = UILabel()
        let labelbarBV = UILabel()
        markbarBV.text = "×"
        markbarBV.textColor = .systemRed
        markbarBV.textAlignment = .center
        markbarBV.font = styleStorebarBV.fontbarBV(24, weight: .heavy)
        labelbarBV.text = textbarBV
        labelbarBV.textColor = .black
        labelbarBV.font = styleStorebarBV.fontbarBV(16, weight: .heavy)
        labelbarBV.numberOfLines = 0
        styleStorebarBV.labelFitbarBV(labelbarBV, factorbarBV: 0.62, linesbarBV: 0)
        [markbarBV, labelbarBV].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: styleStorebarBV.metricbarBV(58, minimumbarBV: 50, maximumbarBV: 64)),
            markbarBV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: styleStorebarBV.metricbarBV(16, minimumbarBV: 12, maximumbarBV: 18)),
            markbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            markbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(26, minimumbarBV: 22, maximumbarBV: 28)),
            labelbarBV.leadingAnchor.constraint(equalTo: markbarBV.trailingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            labelbarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -styleStorebarBV.metricbarBV(16, minimumbarBV: 12, maximumbarBV: 18)),
            labelbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelbarBV.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: styleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            labelbarBV.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -styleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12))
        ])
    }
}

private final class accountActionSheetbarBV: UIControl {
    var dismissHandlerbarBV: (() -> Void)?
    var logOutHandlerbarBV: (() -> Void)?
    var deleteHandlerbarBV: (() -> Void)?
    private let panelbarBV = UIView()
    private let stackbarBV = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configurebarBV()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configurebarBV() {
        alpha = 0
        backgroundColor = UIColor.black.withAlphaComponent(0.36)
        addAction(UIAction { [weak self] _ in
            self?.dismissHandlerbarBV?()
        }, for: .touchUpInside)

        panelbarBV.backgroundColor = .clear
        stackbarBV.axis = .vertical
        stackbarBV.spacing = styleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 16)
        addSubview(panelbarBV)
        panelbarBV.addSubview(stackbarBV)
        [panelbarBV, stackbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        let logoutbarBV = sheetButtonbarBV(titlebarBV: "Log Out", gradientbarBV: false)
        let deletebarBV = sheetButtonbarBV(titlebarBV: "Cancel account", gradientbarBV: false)
        let cancelbarBV = sheetButtonbarBV(titlebarBV: "Cancel", gradientbarBV: true)
        logoutbarBV.addAction(UIAction { [weak self] _ in self?.logOutHandlerbarBV?() }, for: .touchUpInside)
        deletebarBV.addAction(UIAction { [weak self] _ in self?.deleteHandlerbarBV?() }, for: .touchUpInside)
        cancelbarBV.addAction(UIAction { [weak self] _ in self?.dismissHandlerbarBV?() }, for: .touchUpInside)
        [logoutbarBV, deletebarBV, cancelbarBV].forEach {
            stackbarBV.addArrangedSubview($0)
            $0.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(62, minimumbarBV: 54, maximumbarBV: 66)).isActive = true
        }

        NSLayoutConstraint.activate([
            panelbarBV.leadingAnchor.constraint(equalTo: leadingAnchor),
            panelbarBV.trailingAnchor.constraint(equalTo: trailingAnchor),
            panelbarBV.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 22)),
            stackbarBV.topAnchor.constraint(equalTo: panelbarBV.topAnchor),
            stackbarBV.leadingAnchor.constraint(equalTo: panelbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)),
            stackbarBV.trailingAnchor.constraint(equalTo: panelbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)),
            stackbarBV.bottomAnchor.constraint(equalTo: panelbarBV.bottomAnchor)
        ])
    }

    private func sheetButtonbarBV(titlebarBV: String, gradientbarBV: Bool) -> UIButton {
        let buttonbarBV: UIButton = gradientbarBV ? gradientPill(type: .system) : UIButton(type: .system)
        buttonbarBV.setTitle(titlebarBV, for: .normal)
        buttonbarBV.setTitleColor(.black, for: .normal)
        buttonbarBV.titleLabel?.font = styleStorebarBV.fontbarBV(22, weight: .heavy)
        styleStorebarBV.buttonFitbarBV(buttonbarBV, factorbarBV: 0.58)
        if let pillbarBV = buttonbarBV as? gradientPill {
            pillbarBV.colorsbarBV = [
                UIColor(red: 186 / 255, green: 241 / 255, blue: 1, alpha: 1),
                UIColor(red: 1, green: 211 / 255, blue: 250 / 255, alpha: 1),
                UIColor(red: 153 / 255, green: 226 / 255, blue: 248 / 255, alpha: 1)
            ]
        } else {
            buttonbarBV.backgroundColor = .white
            buttonbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(31, minimumbarBV: 27, maximumbarBV: 33)
            buttonbarBV.clipsToBounds = true
        }
        return buttonbarBV
    }

    func showbarBV() {
        layoutIfNeeded()
        panelbarBV.transform = CGAffineTransform(translationX: 0, y: panelbarBV.bounds.height + styleStorebarBV.spacebarBV(24, minimumbarBV: 18, maximumbarBV: 28))
        UIView.animate(withDuration: 0.24, delay: 0, options: [.curveEaseOut]) {
            self.alpha = 1
            self.panelbarBV.transform = .identity
        }
    }

    func dismissbarBV() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn]) {
            self.alpha = 0
            self.panelbarBV.transform = CGAffineTransform(translationX: 0, y: self.panelbarBV.bounds.height + styleStorebarBV.spacebarBV(24, minimumbarBV: 18, maximumbarBV: 28))
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}

private final class notificationsSurfacebarBV: localSurfacebarBV {
    private let storebarBV: localStorebarBV
    private let headerBarbarBV = UIView()
    private let backButtonbarBV = UIButton(type: .system)
    private let titleLabelbarBV = UILabel()
    private let scrollViewbarBV = UIScrollView()
    private let stackbarBV = UIStackView()
    private let statusLabelbarBV = UILabel()
    private var statusWorkbarBV: DispatchWorkItem?

    init(storebarBV: localStorebarBV) {
        self.storebarBV = storebarBV
        super.init(nibName: nil, bundle: nil)
        title = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderbarBV()
        configureScrollContentbarBV()
        configureStatusbarBV()
        renderSectionsbarBV()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        renderSectionsbarBV()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureHeaderbarBV() {
        backButtonbarBV.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButtonbarBV.tintColor = .black
        backButtonbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.36)
        backButtonbarBV.layer.cornerRadius = styleStorebarBV.controlbarBV(44) / 2
        backButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)

        titleLabelbarBV.text = "Notifications"
        titleLabelbarBV.font = styleStorebarBV.fontbarBV(28, weight: .heavy)
        titleLabelbarBV.textColor = .black
        titleLabelbarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.62, linesbarBV: 1)

        view.addSubview(headerBarbarBV)
        [backButtonbarBV, titleLabelbarBV].forEach {
            headerBarbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        headerBarbarBV.translatesAutoresizingMaskIntoConstraints = false

        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)
        let buttonSizebarBV = styleStorebarBV.controlbarBV(44)
        NSLayoutConstraint.activate([
            headerBarbarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: styleStorebarBV.spacebarBV(10, minimumbarBV: 6, maximumbarBV: 14)),
            headerBarbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInsetbarBV),
            headerBarbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInsetbarBV),
            headerBarbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(54, minimumbarBV: 48, maximumbarBV: 58)),
            backButtonbarBV.leadingAnchor.constraint(equalTo: headerBarbarBV.leadingAnchor),
            backButtonbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            backButtonbarBV.widthAnchor.constraint(equalToConstant: buttonSizebarBV),
            backButtonbarBV.heightAnchor.constraint(equalToConstant: buttonSizebarBV),
            titleLabelbarBV.centerXAnchor.constraint(equalTo: headerBarbarBV.centerXAnchor),
            titleLabelbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            titleLabelbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: backButtonbarBV.trailingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            titleLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: headerBarbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(58, minimumbarBV: 48, maximumbarBV: 62))
        ])
    }

    private func configureScrollContentbarBV() {
        scrollViewbarBV.showsVerticalScrollIndicator = false
        scrollViewbarBV.alwaysBounceVertical = true
        stackbarBV.axis = .vertical
        stackbarBV.spacing = styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 22)
        view.addSubview(scrollViewbarBV)
        scrollViewbarBV.addSubview(stackbarBV)
        [scrollViewbarBV, stackbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)
        NSLayoutConstraint.activate([
            scrollViewbarBV.topAnchor.constraint(equalTo: headerBarbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(22, minimumbarBV: 14, maximumbarBV: 28)),
            scrollViewbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollViewbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewbarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackbarBV.topAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.topAnchor),
            stackbarBV.leadingAnchor.constraint(equalTo: scrollViewbarBV.frameLayoutGuide.leadingAnchor, constant: sideInsetbarBV),
            stackbarBV.trailingAnchor.constraint(equalTo: scrollViewbarBV.frameLayoutGuide.trailingAnchor, constant: -sideInsetbarBV),
            stackbarBV.bottomAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.bottomAnchor, constant: -styleStorebarBV.spacebarBV(26, minimumbarBV: 20, maximumbarBV: 32))
        ])
    }

    private func renderSectionsbarBV() {
        stackbarBV.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let settingsbarBV = storebarBV.currentNotificationSettingsbarBV()
        stackbarBV.addArrangedSubview(sectionbarBV(
            titlebarBV: "PUSH NOTIFICATIONS",
            rowsbarBV: [
                notificationRowModelbarBV(titlebarBV: "Allow notifications", detailbarBV: "Master switch", valuebarBV: nil, switchStatebarBV: settingsbarBV.allowNotificationsbarBV, enabledbarBV: true, actionbarBV: { [weak self] valuebarBV in
                    self?.storebarBV.setAllowNotificationsbarBV(valuebarBV)
                    self?.renderSectionsbarBV()
                }),
                notificationRowModelbarBV(titlebarBV: "New messages", detailbarBV: nil, valuebarBV: nil, switchStatebarBV: settingsbarBV.newMessagesbarBV, enabledbarBV: settingsbarBV.allowNotificationsbarBV, actionbarBV: { [weak self] valuebarBV in
                    self?.storebarBV.setNewMessagesbarBV(valuebarBV)
                }),
                notificationRowModelbarBV(titlebarBV: "Friend requests", detailbarBV: nil, valuebarBV: nil, switchStatebarBV: settingsbarBV.friendRequestsbarBV, enabledbarBV: settingsbarBV.allowNotificationsbarBV, actionbarBV: { [weak self] valuebarBV in
                    self?.storebarBV.setFriendRequestsbarBV(valuebarBV)
                }),
                notificationRowModelbarBV(titlebarBV: "Group mentions only", detailbarBV: "Only when @-mentioned", valuebarBV: nil, switchStatebarBV: settingsbarBV.groupMentionsOnlybarBV, enabledbarBV: settingsbarBV.allowNotificationsbarBV, actionbarBV: { [weak self] valuebarBV in
                    self?.storebarBV.setGroupMentionsOnlybarBV(valuebarBV)
                })
            ]
        ))

        stackbarBV.addArrangedSubview(sectionbarBV(
            titlebarBV: "SOUND & HAPTICS",
            rowsbarBV: [
                notificationRowModelbarBV(titlebarBV: "Sound", detailbarBV: nil, valuebarBV: settingsbarBV.soundbarBV, switchStatebarBV: nil, enabledbarBV: true, actionbarBV: { [weak self] _ in
                    self?.showStatusbarBV("Sound options coming soon")
                }),
                notificationRowModelbarBV(titlebarBV: "Vibration", detailbarBV: nil, valuebarBV: nil, switchStatebarBV: settingsbarBV.vibrationbarBV, enabledbarBV: true, actionbarBV: { [weak self] valuebarBV in
                    self?.storebarBV.setVibrationbarBV(valuebarBV)
                }),
                notificationRowModelbarBV(titlebarBV: "In-app sound", detailbarBV: nil, valuebarBV: nil, switchStatebarBV: settingsbarBV.inAppSoundbarBV, enabledbarBV: true, actionbarBV: { [weak self] valuebarBV in
                    self?.storebarBV.setInAppSoundbarBV(valuebarBV)
                })
            ]
        ))

        let quietTextbarBV = "\(settingsbarBV.quietHoursStartbarBV) — \(settingsbarBV.quietHoursEndbarBV) daily"
        stackbarBV.addArrangedSubview(sectionbarBV(
            titlebarBV: "QUIET HOURS",
            rowsbarBV: [
                notificationRowModelbarBV(titlebarBV: "Enable quiet hours", detailbarBV: quietTextbarBV, valuebarBV: nil, switchStatebarBV: settingsbarBV.quietHoursEnabledbarBV, enabledbarBV: true, actionbarBV: { [weak self] valuebarBV in
                    self?.storebarBV.setQuietHoursEnabledbarBV(valuebarBV)
                })
            ]
        ))
    }

    private func sectionbarBV(titlebarBV: String, rowsbarBV: [notificationRowModelbarBV]) -> UIView {
        let wrapperbarBV = UIView()
        let titleLabelbarBV = UILabel()
        titleLabelbarBV.text = titlebarBV
        titleLabelbarBV.font = styleStorebarBV.fontbarBV(15, weight: .heavy)
        titleLabelbarBV.textColor = UIColor.black.withAlphaComponent(0.78)
        titleLabelbarBV.letterSpacingbarBV(1.4)
        styleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.68, linesbarBV: 1)

        let cardbarBV = cardSurfacebarBV(cornerRadius: styleStorebarBV.metricbarBV(24, minimumbarBV: 20, maximumbarBV: 28))
        let listbarBV = UIStackView()
        listbarBV.axis = .vertical
        listbarBV.spacing = 0

        for (indexbarBV, rowbarBV) in rowsbarBV.enumerated() {
            let rowViewbarBV = notificationSettingRowbarBV(modelbarBV: rowbarBV)
            if rowbarBV.valuebarBV != nil {
                rowViewbarBV.addAction(UIAction { _ in rowbarBV.actionbarBV(true) }, for: .touchUpInside)
            }
            listbarBV.addArrangedSubview(rowViewbarBV)
            if indexbarBV < rowsbarBV.count - 1 {
                let dividerbarBV = UIView()
                dividerbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.06)
                listbarBV.addArrangedSubview(dividerbarBV)
                dividerbarBV.heightAnchor.constraint(equalToConstant: 1).isActive = true
            }
        }

        wrapperbarBV.addSubview(titleLabelbarBV)
        wrapperbarBV.addSubview(cardbarBV)
        cardbarBV.addSubview(listbarBV)
        [titleLabelbarBV, cardbarBV, listbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            titleLabelbarBV.topAnchor.constraint(equalTo: wrapperbarBV.topAnchor),
            titleLabelbarBV.leadingAnchor.constraint(equalTo: wrapperbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(4, minimumbarBV: 0, maximumbarBV: 6)),
            titleLabelbarBV.trailingAnchor.constraint(equalTo: wrapperbarBV.trailingAnchor),
            titleLabelbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(28, minimumbarBV: 24, maximumbarBV: 30)),
            cardbarBV.topAnchor.constraint(equalTo: titleLabelbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(7, minimumbarBV: 5, maximumbarBV: 8)),
            cardbarBV.leadingAnchor.constraint(equalTo: wrapperbarBV.leadingAnchor),
            cardbarBV.trailingAnchor.constraint(equalTo: wrapperbarBV.trailingAnchor),
            cardbarBV.bottomAnchor.constraint(equalTo: wrapperbarBV.bottomAnchor),
            listbarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor, constant: styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10)),
            listbarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            listbarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            listbarBV.bottomAnchor.constraint(equalTo: cardbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10))
        ])
        return wrapperbarBV
    }

    private func configureStatusbarBV() {
        statusLabelbarBV.alpha = 0
        statusLabelbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.74)
        statusLabelbarBV.textColor = .white
        statusLabelbarBV.font = styleStorebarBV.fontbarBV(14, weight: .bold)
        statusLabelbarBV.textAlignment = .center
        statusLabelbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(17, minimumbarBV: 15, maximumbarBV: 18)
        statusLabelbarBV.layer.masksToBounds = true
        styleStorebarBV.labelFitbarBV(statusLabelbarBV, factorbarBV: 0.7, linesbarBV: 1)
        view.addSubview(statusLabelbarBV)
        statusLabelbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabelbarBV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabelbarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 22)),
            statusLabelbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: styleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 40)),
            statusLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -styleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 40)),
            statusLabelbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(34, minimumbarBV: 30, maximumbarBV: 36))
        ])
    }

    private func showStatusbarBV(_ textbarBV: String) {
        statusWorkbarBV?.cancel()
        statusLabelbarBV.text = "  \(textbarBV)  "
        UIView.animate(withDuration: 0.18) {
            self.statusLabelbarBV.alpha = 1
        }
        let workbarBV = DispatchWorkItem { [weak self] in
            UIView.animate(withDuration: 0.22) {
                self?.statusLabelbarBV.alpha = 0
            }
        }
        statusWorkbarBV = workbarBV
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25, execute: workbarBV)
    }
}

private struct notificationRowModelbarBV {
    var titlebarBV: String
    var detailbarBV: String?
    var valuebarBV: String?
    var switchStatebarBV: Bool?
    var enabledbarBV: Bool
    var actionbarBV: (Bool) -> Void
}

private final class notificationSettingRowbarBV: UIControl {
    private let modelbarBV: notificationRowModelbarBV
    private let titleLabelbarBV = UILabel()
    private let detailLabelbarBV = UILabel()
    private let valueLabelbarBV = UILabel()
    private let chevronbarBV = UIImageView(image: UIImage(systemName: "chevron.right"))
    private let togglebarBV = UISwitch()

    init(modelbarBV: notificationRowModelbarBV) {
        self.modelbarBV = modelbarBV
        super.init(frame: .zero)
        configurebarBV()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            guard modelbarBV.valuebarBV != nil else { return }
            UIView.animate(withDuration: 0.14) {
                self.alpha = self.isHighlighted ? 0.58 : 1
            }
        }
    }

    private func configurebarBV() {
        alpha = modelbarBV.enabledbarBV ? 1 : 0.45
        isEnabled = modelbarBV.enabledbarBV || modelbarBV.valuebarBV != nil

        titleLabelbarBV.text = modelbarBV.titlebarBV
        titleLabelbarBV.font = styleStorebarBV.fontbarBV(18, weight: .semibold)
        titleLabelbarBV.textColor = .black
        styleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.62, linesbarBV: 1)

        detailLabelbarBV.text = modelbarBV.detailbarBV
        detailLabelbarBV.font = styleStorebarBV.fontbarBV(13, weight: .medium)
        detailLabelbarBV.textColor = styleStorebarBV.mutedText
        detailLabelbarBV.isHidden = modelbarBV.detailbarBV == nil
        styleStorebarBV.labelFitbarBV(detailLabelbarBV, factorbarBV: 0.7, linesbarBV: 2)

        let textStackbarBV = UIStackView(arrangedSubviews: [titleLabelbarBV, detailLabelbarBV])
        textStackbarBV.axis = .vertical
        textStackbarBV.spacing = styleStorebarBV.spacebarBV(4, minimumbarBV: 2, maximumbarBV: 5)
        textStackbarBV.alignment = .leading

        addSubview(textStackbarBV)
        textStackbarBV.translatesAutoresizingMaskIntoConstraints = false

        if let switchStatebarBV = modelbarBV.switchStatebarBV {
            togglebarBV.isOn = switchStatebarBV
            togglebarBV.isEnabled = modelbarBV.enabledbarBV
            togglebarBV.onTintColor = styleStorebarBV.purple
            togglebarBV.thumbTintColor = .white
            togglebarBV.backgroundColor = UIColor.black.withAlphaComponent(0.13)
            togglebarBV.layer.cornerRadius = 16
            togglebarBV.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                self.modelbarBV.actionbarBV(self.togglebarBV.isOn)
            }, for: .valueChanged)
            addSubview(togglebarBV)
            togglebarBV.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                togglebarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -styleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
                togglebarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
                textStackbarBV.trailingAnchor.constraint(lessThanOrEqualTo: togglebarBV.leadingAnchor, constant: -styleStorebarBV.metricbarBV(14, minimumbarBV: 10, maximumbarBV: 16))
            ])
        } else {
            valueLabelbarBV.text = modelbarBV.valuebarBV
            valueLabelbarBV.font = styleStorebarBV.fontbarBV(16, weight: .semibold)
            valueLabelbarBV.textColor = styleStorebarBV.mutedText
            valueLabelbarBV.textAlignment = .right
            styleStorebarBV.labelFitbarBV(valueLabelbarBV, factorbarBV: 0.62, linesbarBV: 1)
            chevronbarBV.tintColor = UIColor.black.withAlphaComponent(0.32)
            chevronbarBV.contentMode = .scaleAspectFit
            addSubview(valueLabelbarBV)
            addSubview(chevronbarBV)
            [valueLabelbarBV, chevronbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
            NSLayoutConstraint.activate([
                chevronbarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -styleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
                chevronbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
                chevronbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(14, minimumbarBV: 12, maximumbarBV: 16)),
                chevronbarBV.heightAnchor.constraint(equalTo: chevronbarBV.widthAnchor),
                valueLabelbarBV.trailingAnchor.constraint(equalTo: chevronbarBV.leadingAnchor, constant: -styleStorebarBV.metricbarBV(8, minimumbarBV: 6, maximumbarBV: 10)),
                valueLabelbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
                valueLabelbarBV.widthAnchor.constraint(lessThanOrEqualToConstant: styleStorebarBV.metricbarBV(108, minimumbarBV: 88, maximumbarBV: 116)),
                textStackbarBV.trailingAnchor.constraint(lessThanOrEqualTo: valueLabelbarBV.leadingAnchor, constant: -styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14))
            ])
        }

        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: styleStorebarBV.metricbarBV(modelbarBV.detailbarBV == nil ? 62 : 72, minimumbarBV: modelbarBV.detailbarBV == nil ? 56 : 64, maximumbarBV: modelbarBV.detailbarBV == nil ? 68 : 78)),
            textStackbarBV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: styleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            textStackbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            textStackbarBV.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: styleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            textStackbarBV.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -styleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12))
        ])
    }
}

private final class privacySurfacebarBV: localSurfacebarBV {
    private let storebarBV: localStorebarBV
    private let headerBarbarBV = UIView()
    private let backButtonbarBV = UIButton(type: .system)
    private let titleLabelbarBV = UILabel()
    private let scrollViewbarBV = UIScrollView()
    private let stackbarBV = UIStackView()
    private let statusLabelbarBV = UILabel()
    private var statusWorkbarBV: DispatchWorkItem?

    init(storebarBV: localStorebarBV) {
        self.storebarBV = storebarBV
        super.init(nibName: nil, bundle: nil)
        title = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderbarBV()
        configureScrollContentbarBV()
        configureStatusbarBV()
        renderSectionsbarBV()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        renderSectionsbarBV()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureHeaderbarBV() {
        backButtonbarBV.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButtonbarBV.tintColor = .black
        backButtonbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.36)
        backButtonbarBV.layer.cornerRadius = styleStorebarBV.controlbarBV(44) / 2
        backButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)

        titleLabelbarBV.text = "Privacy"
        titleLabelbarBV.font = styleStorebarBV.fontbarBV(28, weight: .heavy)
        titleLabelbarBV.textColor = .black
        titleLabelbarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.62, linesbarBV: 1)

        view.addSubview(headerBarbarBV)
        [backButtonbarBV, titleLabelbarBV].forEach {
            headerBarbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        headerBarbarBV.translatesAutoresizingMaskIntoConstraints = false

        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)
        let buttonSizebarBV = styleStorebarBV.controlbarBV(44)
        NSLayoutConstraint.activate([
            headerBarbarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: styleStorebarBV.spacebarBV(10, minimumbarBV: 6, maximumbarBV: 14)),
            headerBarbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInsetbarBV),
            headerBarbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInsetbarBV),
            headerBarbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(54, minimumbarBV: 48, maximumbarBV: 58)),
            backButtonbarBV.leadingAnchor.constraint(equalTo: headerBarbarBV.leadingAnchor),
            backButtonbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            backButtonbarBV.widthAnchor.constraint(equalToConstant: buttonSizebarBV),
            backButtonbarBV.heightAnchor.constraint(equalToConstant: buttonSizebarBV),
            titleLabelbarBV.centerXAnchor.constraint(equalTo: headerBarbarBV.centerXAnchor),
            titleLabelbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            titleLabelbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: backButtonbarBV.trailingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            titleLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: headerBarbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(58, minimumbarBV: 48, maximumbarBV: 62))
        ])
    }

    private func configureScrollContentbarBV() {
        scrollViewbarBV.showsVerticalScrollIndicator = false
        scrollViewbarBV.alwaysBounceVertical = true
        stackbarBV.axis = .vertical
        stackbarBV.spacing = styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 22)
        view.addSubview(scrollViewbarBV)
        scrollViewbarBV.addSubview(stackbarBV)
        [scrollViewbarBV, stackbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)
        NSLayoutConstraint.activate([
            scrollViewbarBV.topAnchor.constraint(equalTo: headerBarbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(22, minimumbarBV: 14, maximumbarBV: 28)),
            scrollViewbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollViewbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewbarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackbarBV.topAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.topAnchor),
            stackbarBV.leadingAnchor.constraint(equalTo: scrollViewbarBV.frameLayoutGuide.leadingAnchor, constant: sideInsetbarBV),
            stackbarBV.trailingAnchor.constraint(equalTo: scrollViewbarBV.frameLayoutGuide.trailingAnchor, constant: -sideInsetbarBV),
            stackbarBV.bottomAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.bottomAnchor, constant: -styleStorebarBV.spacebarBV(26, minimumbarBV: 20, maximumbarBV: 32))
        ])
    }

    private func renderSectionsbarBV() {
        stackbarBV.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let settingsbarBV = storebarBV.currentPrivacySettingsbarBV()
        stackbarBV.addArrangedSubview(sectionbarBV(
            titlebarBV: "DISCOVERABILITY",
            rowsbarBV: [
                privacyRowModelbarBV(titlebarBV: "Search by phone", detailbarBV: "Let people find you by phone number", valuebarBV: nil, switchStatebarBV: settingsbarBV.searchByPhonebarBV, actionbarBV: { [weak self] valuebarBV in
                    self?.storebarBV.setSearchByPhonebarBV(valuebarBV)
                }),
                privacyRowModelbarBV(titlebarBV: "Search by email", detailbarBV: "Let people find you by email", valuebarBV: nil, switchStatebarBV: settingsbarBV.searchByEmailbarBV, actionbarBV: { [weak self] valuebarBV in
                    self?.storebarBV.setSearchByEmailbarBV(valuebarBV)
                }),
                privacyRowModelbarBV(titlebarBV: "Show \"Online\"", detailbarBV: "Display online status to contacts", valuebarBV: nil, switchStatebarBV: settingsbarBV.showOnlinebarBV, actionbarBV: { [weak self] valuebarBV in
                    self?.storebarBV.setShowOnlinebarBV(valuebarBV)
                })
            ]
        ))

        stackbarBV.addArrangedSubview(sectionbarBV(
            titlebarBV: "READING STATUS",
            rowsbarBV: [
                privacyRowModelbarBV(titlebarBV: "Read receipts", detailbarBV: "Let contacts know when you've read messages", valuebarBV: nil, switchStatebarBV: settingsbarBV.readReceiptsbarBV, actionbarBV: { [weak self] valuebarBV in
                    self?.storebarBV.setReadReceiptsbarBV(valuebarBV)
                }),
                privacyRowModelbarBV(titlebarBV: "Typing indicator", detailbarBV: "Show when you're typing", valuebarBV: nil, switchStatebarBV: settingsbarBV.typingIndicatorbarBV, actionbarBV: { [weak self] valuebarBV in
                    self?.storebarBV.setTypingIndicatorbarBV(valuebarBV)
                })
            ]
        ))

        stackbarBV.addArrangedSubview(sectionbarBV(
            titlebarBV: "AI & DATA",
            rowsbarBV: [
                privacyRowModelbarBV(titlebarBV: "Allow AI to learn from my replies", detailbarBV: "Improve suggestions using my chat style", valuebarBV: nil, switchStatebarBV: settingsbarBV.allowAILearningbarBV, actionbarBV: { [weak self] valuebarBV in
                    self?.storebarBV.setAllowAILearningbarBV(valuebarBV)
                }),
                privacyRowModelbarBV(titlebarBV: "Export my data", detailbarBV: nil, valuebarBV: "", switchStatebarBV: nil, actionbarBV: { [weak self] _ in
                    self?.showStatusbarBV("Data export coming soon")
                })
            ]
        ))
    }

    private func sectionbarBV(titlebarBV: String, rowsbarBV: [privacyRowModelbarBV]) -> UIView {
        let wrapperbarBV = UIView()
        let titleLabelbarBV = UILabel()
        titleLabelbarBV.text = titlebarBV
        titleLabelbarBV.font = styleStorebarBV.fontbarBV(15, weight: .heavy)
        titleLabelbarBV.textColor = UIColor.black.withAlphaComponent(0.78)
        titleLabelbarBV.letterSpacingbarBV(1.4)
        styleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.68, linesbarBV: 1)

        let cardbarBV = cardSurfacebarBV(cornerRadius: styleStorebarBV.metricbarBV(24, minimumbarBV: 20, maximumbarBV: 28))
        let listbarBV = UIStackView()
        listbarBV.axis = .vertical
        listbarBV.spacing = 0

        for (indexbarBV, rowbarBV) in rowsbarBV.enumerated() {
            let rowViewbarBV = privacySettingRowbarBV(modelbarBV: rowbarBV)
            if rowbarBV.switchStatebarBV == nil {
                rowViewbarBV.addAction(UIAction { _ in rowbarBV.actionbarBV(true) }, for: .touchUpInside)
            }
            listbarBV.addArrangedSubview(rowViewbarBV)
            if indexbarBV < rowsbarBV.count - 1 {
                let dividerbarBV = UIView()
                dividerbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.06)
                listbarBV.addArrangedSubview(dividerbarBV)
                dividerbarBV.heightAnchor.constraint(equalToConstant: 1).isActive = true
            }
        }

        wrapperbarBV.addSubview(titleLabelbarBV)
        wrapperbarBV.addSubview(cardbarBV)
        cardbarBV.addSubview(listbarBV)
        [titleLabelbarBV, cardbarBV, listbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            titleLabelbarBV.topAnchor.constraint(equalTo: wrapperbarBV.topAnchor),
            titleLabelbarBV.leadingAnchor.constraint(equalTo: wrapperbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(4, minimumbarBV: 0, maximumbarBV: 6)),
            titleLabelbarBV.trailingAnchor.constraint(equalTo: wrapperbarBV.trailingAnchor),
            titleLabelbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(28, minimumbarBV: 24, maximumbarBV: 30)),
            cardbarBV.topAnchor.constraint(equalTo: titleLabelbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(7, minimumbarBV: 5, maximumbarBV: 8)),
            cardbarBV.leadingAnchor.constraint(equalTo: wrapperbarBV.leadingAnchor),
            cardbarBV.trailingAnchor.constraint(equalTo: wrapperbarBV.trailingAnchor),
            cardbarBV.bottomAnchor.constraint(equalTo: wrapperbarBV.bottomAnchor),
            listbarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor, constant: styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10)),
            listbarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            listbarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            listbarBV.bottomAnchor.constraint(equalTo: cardbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10))
        ])
        return wrapperbarBV
    }

    private func configureStatusbarBV() {
        statusLabelbarBV.alpha = 0
        statusLabelbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.74)
        statusLabelbarBV.textColor = .white
        statusLabelbarBV.font = styleStorebarBV.fontbarBV(14, weight: .bold)
        statusLabelbarBV.textAlignment = .center
        statusLabelbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(17, minimumbarBV: 15, maximumbarBV: 18)
        statusLabelbarBV.layer.masksToBounds = true
        styleStorebarBV.labelFitbarBV(statusLabelbarBV, factorbarBV: 0.7, linesbarBV: 1)
        view.addSubview(statusLabelbarBV)
        statusLabelbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabelbarBV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabelbarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 22)),
            statusLabelbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: styleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 40)),
            statusLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -styleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 40)),
            statusLabelbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(34, minimumbarBV: 30, maximumbarBV: 36))
        ])
    }

    private func showStatusbarBV(_ textbarBV: String) {
        statusWorkbarBV?.cancel()
        statusLabelbarBV.text = "  \(textbarBV)  "
        UIView.animate(withDuration: 0.18) {
            self.statusLabelbarBV.alpha = 1
        }
        let workbarBV = DispatchWorkItem { [weak self] in
            UIView.animate(withDuration: 0.22) {
                self?.statusLabelbarBV.alpha = 0
            }
        }
        statusWorkbarBV = workbarBV
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25, execute: workbarBV)
    }
}

private struct privacyRowModelbarBV {
    var titlebarBV: String
    var detailbarBV: String?
    var valuebarBV: String?
    var switchStatebarBV: Bool?
    var actionbarBV: (Bool) -> Void
}

private final class privacySettingRowbarBV: UIControl {
    private let modelbarBV: privacyRowModelbarBV
    private let titleLabelbarBV = UILabel()
    private let detailLabelbarBV = UILabel()
    private let chevronbarBV = UIImageView(image: UIImage(systemName: "chevron.right"))
    private let togglebarBV = UISwitch()

    init(modelbarBV: privacyRowModelbarBV) {
        self.modelbarBV = modelbarBV
        super.init(frame: .zero)
        configurebarBV()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            guard modelbarBV.switchStatebarBV == nil else { return }
            UIView.animate(withDuration: 0.14) {
                self.alpha = self.isHighlighted ? 0.58 : 1
            }
        }
    }

    private func configurebarBV() {
        titleLabelbarBV.text = modelbarBV.titlebarBV
        titleLabelbarBV.font = styleStorebarBV.fontbarBV(18, weight: .semibold)
        titleLabelbarBV.textColor = .black
        styleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.62, linesbarBV: 1)

        detailLabelbarBV.text = modelbarBV.detailbarBV
        detailLabelbarBV.font = styleStorebarBV.fontbarBV(13, weight: .medium)
        detailLabelbarBV.textColor = styleStorebarBV.mutedText
        detailLabelbarBV.isHidden = modelbarBV.detailbarBV == nil
        styleStorebarBV.labelFitbarBV(detailLabelbarBV, factorbarBV: 0.7, linesbarBV: 2)

        let textStackbarBV = UIStackView(arrangedSubviews: [titleLabelbarBV, detailLabelbarBV])
        textStackbarBV.axis = .vertical
        textStackbarBV.spacing = styleStorebarBV.spacebarBV(4, minimumbarBV: 2, maximumbarBV: 5)
        textStackbarBV.alignment = .leading
        addSubview(textStackbarBV)
        textStackbarBV.translatesAutoresizingMaskIntoConstraints = false

        if let switchStatebarBV = modelbarBV.switchStatebarBV {
            togglebarBV.isOn = switchStatebarBV
            togglebarBV.onTintColor = styleStorebarBV.purple
            togglebarBV.thumbTintColor = .white
            togglebarBV.backgroundColor = UIColor.black.withAlphaComponent(0.13)
            togglebarBV.layer.cornerRadius = 16
            togglebarBV.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                self.modelbarBV.actionbarBV(self.togglebarBV.isOn)
            }, for: .valueChanged)
            addSubview(togglebarBV)
            togglebarBV.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                togglebarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -styleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
                togglebarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
                textStackbarBV.trailingAnchor.constraint(lessThanOrEqualTo: togglebarBV.leadingAnchor, constant: -styleStorebarBV.metricbarBV(14, minimumbarBV: 10, maximumbarBV: 16))
            ])
        } else {
            chevronbarBV.tintColor = UIColor.black.withAlphaComponent(0.32)
            chevronbarBV.contentMode = .scaleAspectFit
            addSubview(chevronbarBV)
            chevronbarBV.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                chevronbarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -styleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
                chevronbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
                chevronbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(14, minimumbarBV: 12, maximumbarBV: 16)),
                chevronbarBV.heightAnchor.constraint(equalTo: chevronbarBV.widthAnchor),
                textStackbarBV.trailingAnchor.constraint(lessThanOrEqualTo: chevronbarBV.leadingAnchor, constant: -styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14))
            ])
        }

        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: styleStorebarBV.metricbarBV(modelbarBV.detailbarBV == nil ? 62 : 72, minimumbarBV: modelbarBV.detailbarBV == nil ? 56 : 64, maximumbarBV: modelbarBV.detailbarBV == nil ? 68 : 78)),
            textStackbarBV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: styleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            textStackbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            textStackbarBV.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: styleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            textStackbarBV.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -styleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12))
        ])
    }
}

private struct setupRowModelbarBV {
    var titlebarBV: String
    var symbolbarBV: String
    var dangerbarBV: Bool
    var actionbarBV: () -> Void
}

private final class setupSettingRowbarBV: UIControl {
    private let modelbarBV: setupRowModelbarBV
    private let titleLabelbarBV = UILabel()
    private let iconWrapbarBV = UIView()
    private let iconViewbarBV = UIImageView()
    private let chevronbarBV = UIImageView(image: UIImage(systemName: "chevron.right"))

    init(modelbarBV: setupRowModelbarBV) {
        self.modelbarBV = modelbarBV
        super.init(frame: .zero)
        configurebarBV()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.14) {
                self.alpha = self.isHighlighted ? 0.58 : 1
            }
        }
    }

    private func configurebarBV() {
        let tintbarBV = modelbarBV.dangerbarBV ? UIColor.systemRed : UIColor.black
        titleLabelbarBV.text = modelbarBV.titlebarBV
        titleLabelbarBV.font = styleStorebarBV.fontbarBV(19, weight: .semibold)
        titleLabelbarBV.textColor = tintbarBV
        styleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.62, linesbarBV: 1)

        iconWrapbarBV.backgroundColor = modelbarBV.dangerbarBV ? UIColor.systemRed.withAlphaComponent(0.12) : UIColor.black.withAlphaComponent(0.04)
        iconWrapbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(14, minimumbarBV: 12, maximumbarBV: 16)
        iconViewbarBV.image = UIImage(systemName: modelbarBV.symbolbarBV)
        iconViewbarBV.tintColor = tintbarBV
        iconViewbarBV.contentMode = .scaleAspectFit
        chevronbarBV.tintColor = modelbarBV.dangerbarBV ? UIColor.systemRed.withAlphaComponent(0.8) : UIColor.black.withAlphaComponent(0.62)
        chevronbarBV.contentMode = .scaleAspectFit

        addSubview(iconWrapbarBV)
        iconWrapbarBV.addSubview(iconViewbarBV)
        addSubview(titleLabelbarBV)
        addSubview(chevronbarBV)
        [iconWrapbarBV, iconViewbarBV, titleLabelbarBV, chevronbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: styleStorebarBV.metricbarBV(76, minimumbarBV: 66, maximumbarBV: 82)),
            iconWrapbarBV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: styleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            iconWrapbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconWrapbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(42, minimumbarBV: 38, maximumbarBV: 46)),
            iconWrapbarBV.heightAnchor.constraint(equalTo: iconWrapbarBV.widthAnchor),
            iconViewbarBV.centerXAnchor.constraint(equalTo: iconWrapbarBV.centerXAnchor),
            iconViewbarBV.centerYAnchor.constraint(equalTo: iconWrapbarBV.centerYAnchor),
            iconViewbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(22, minimumbarBV: 20, maximumbarBV: 24)),
            iconViewbarBV.heightAnchor.constraint(equalTo: iconViewbarBV.widthAnchor),
            titleLabelbarBV.leadingAnchor.constraint(equalTo: iconWrapbarBV.trailingAnchor, constant: styleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            titleLabelbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: chevronbarBV.leadingAnchor, constant: -styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            chevronbarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -styleStorebarBV.metricbarBV(24, minimumbarBV: 18, maximumbarBV: 26)),
            chevronbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(16, minimumbarBV: 14, maximumbarBV: 18)),
            chevronbarBV.heightAnchor.constraint(equalTo: chevronbarBV.widthAnchor)
        ])
    }
}

private final class coinPackageCellbarBV: UIControl {
    private let packagebarBV: coinPackagebarBV
    private let priceLabelbarBV = UILabel()
    private let coinLabelbarBV = UILabel()
    private let amountLabelbarBV = UILabel()
    private let coinBoxbarBV = UIView()

    init(packagebarBV: coinPackagebarBV) {
        self.packagebarBV = packagebarBV
        super.init(frame: .zero)
        configurebarBV()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.14) {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.97, y: 0.97) : .identity
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.removeAll { $0.name == "coinPackageGradientbarBV" }
        layer.cornerRadius = styleStorebarBV.metricbarBV(18, minimumbarBV: 16, maximumbarBV: 20)
        if packagebarBV.selectedFlagbarBV {
            let gradientbarBV = styleStorebarBV.gradientLayer(
                bounds: bounds,
                cornerRadius: layer.cornerRadius,
                colorsbarBV: [
                    UIColor(red: 173 / 255, green: 241 / 255, blue: 1, alpha: 1),
                    UIColor(red: 1, green: 220 / 255, blue: 248 / 255, alpha: 1),
                    UIColor(red: 166 / 255, green: 232 / 255, blue: 249 / 255, alpha: 1)
                ],
                locationsbarBV: [0, 0.55, 1]
            )
            gradientbarBV.name = "coinPackageGradientbarBV"
            layer.insertSublayer(gradientbarBV, at: 0)
        }
    }

    private func configurebarBV() {
        isExclusiveTouch = true
        backgroundColor = packagebarBV.selectedFlagbarBV ? .clear : .white
        layer.borderWidth = packagebarBV.selectedFlagbarBV ? 0 : 1.2
        layer.borderColor = UIColor(red: 182 / 255, green: 231 / 255, blue: 1, alpha: 1).cgColor
        clipsToBounds = true

        priceLabelbarBV.text = packagebarBV.priceTextbarBV
        priceLabelbarBV.font = styleStorebarBV.fontbarBV(20, weight: .heavy)
        priceLabelbarBV.textAlignment = .center
        priceLabelbarBV.textColor = .black
        styleStorebarBV.labelFitbarBV(priceLabelbarBV, factorbarBV: 0.58, linesbarBV: 1)

        coinBoxbarBV.backgroundColor = UIColor.white.withAlphaComponent(packagebarBV.selectedFlagbarBV ? 0.92 : 0.55)
        coinBoxbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(14, minimumbarBV: 12, maximumbarBV: 16)
        coinBoxbarBV.layer.masksToBounds = true

        coinLabelbarBV.text = "🟡"
        coinLabelbarBV.font = styleStorebarBV.fontbarBV(22, weight: .heavy)
        coinLabelbarBV.textAlignment = .center

        amountLabelbarBV.text = "\(packagebarBV.coinAmountbarBV)"
        amountLabelbarBV.font = styleStorebarBV.fontbarBV(20, weight: .heavy)
        amountLabelbarBV.textAlignment = .center
        amountLabelbarBV.textColor = .black
        styleStorebarBV.labelFitbarBV(amountLabelbarBV, factorbarBV: 0.56, linesbarBV: 1)

        addSubview(priceLabelbarBV)
        addSubview(coinBoxbarBV)
        coinBoxbarBV.addSubview(coinLabelbarBV)
        coinBoxbarBV.addSubview(amountLabelbarBV)
        [priceLabelbarBV, coinBoxbarBV, coinLabelbarBV, amountLabelbarBV].forEach { $0.isUserInteractionEnabled = false }
        [priceLabelbarBV, coinBoxbarBV, coinLabelbarBV, amountLabelbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            priceLabelbarBV.topAnchor.constraint(equalTo: topAnchor, constant: styleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 16)),
            priceLabelbarBV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: styleStorebarBV.metricbarBV(8, minimumbarBV: 6, maximumbarBV: 10)),
            priceLabelbarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -styleStorebarBV.metricbarBV(8, minimumbarBV: 6, maximumbarBV: 10)),
            coinBoxbarBV.topAnchor.constraint(equalTo: priceLabelbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            coinBoxbarBV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            coinBoxbarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            coinBoxbarBV.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -styleStorebarBV.spacebarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            coinLabelbarBV.topAnchor.constraint(equalTo: coinBoxbarBV.topAnchor, constant: styleStorebarBV.spacebarBV(8, minimumbarBV: 5, maximumbarBV: 9)),
            coinLabelbarBV.centerXAnchor.constraint(equalTo: coinBoxbarBV.centerXAnchor),
            amountLabelbarBV.topAnchor.constraint(equalTo: coinLabelbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(2, minimumbarBV: 1, maximumbarBV: 3)),
            amountLabelbarBV.leadingAnchor.constraint(equalTo: coinBoxbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(6, minimumbarBV: 4, maximumbarBV: 8)),
            amountLabelbarBV.trailingAnchor.constraint(equalTo: coinBoxbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(6, minimumbarBV: 4, maximumbarBV: 8)),
            amountLabelbarBV.bottomAnchor.constraint(lessThanOrEqualTo: coinBoxbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(5, minimumbarBV: 3, maximumbarBV: 6))
        ])
    }
}

private final class personalIconButtonbarBV: UIButton {
    init(symbolbarBV: String) {
        super.init(frame: .zero)
        setImage(UIImage(systemName: symbolbarBV), for: .normal)
        tintColor = .black
        backgroundColor = UIColor.white.withAlphaComponent(0.78)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowRadius = 14
        imageView?.contentMode = .scaleAspectFit
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}

private final class personalGradientControlbarBV: UIControl {
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

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.14) {
                self.alpha = self.isHighlighted ? 0.68 : 1
            }
        }
    }

    private func configurebarBV() {
        guard let gradientbarBV = layer as? CAGradientLayer else { return }
        gradientbarBV.colors = [
            UIColor(red: 173 / 255, green: 241 / 255, blue: 1, alpha: 1).cgColor,
            UIColor(red: 1, green: 219 / 255, blue: 248 / 255, alpha: 1).cgColor,
            UIColor(red: 151 / 255, green: 229 / 255, blue: 249 / 255, alpha: 1).cgColor
        ]
        gradientbarBV.locations = [0, 0.52, 1]
        gradientbarBV.startPoint = CGPoint(x: 0, y: 0.5)
        gradientbarBV.endPoint = CGPoint(x: 1, y: 0.5)
    }
}

private final class aiStyleCardbarBV: UIControl {
    private let stylebarBV: aiStylebarBV

    init(stylebarBV: aiStylebarBV) {
        self.stylebarBV = stylebarBV
        super.init(frame: .zero)
        configurebarBV()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.14) {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.97, y: 0.97) : .identity
            }
        }
    }

    private func configurebarBV() {
        backgroundColor = backgroundColorbarBV()
        layer.cornerRadius = styleStorebarBV.metricbarBV(18, minimumbarBV: 16, maximumbarBV: 20)
        layer.borderWidth = stylebarBV.selectedFlagbarBV ? 1.5 : 0
        layer.borderColor = styleStorebarBV.pink.withAlphaComponent(0.72).cgColor
        clipsToBounds = true

        let titlebarBV = UILabel()
        titlebarBV.text = "\(stylebarBV.titlebarBV)\(stylebarBV.emojibarBV)"
        titlebarBV.font = styleStorebarBV.fontbarBV(17, weight: .heavy)
        titlebarBV.textColor = .black
        styleStorebarBV.labelFitbarBV(titlebarBV, factorbarBV: 0.54, linesbarBV: 1)

        let subtitlebarBV = UILabel()
        subtitlebarBV.text = stylebarBV.subtitlebarBV
        subtitlebarBV.font = styleStorebarBV.fontbarBV(13, weight: .semibold)
        subtitlebarBV.textColor = styleStorebarBV.mutedText
        styleStorebarBV.labelFitbarBV(subtitlebarBV, factorbarBV: 0.64, linesbarBV: 1)

        let checkbarBV = UILabel()
        checkbarBV.text = stylebarBV.selectedFlagbarBV ? "✓" : ""
        checkbarBV.textAlignment = .center
        checkbarBV.textColor = .white
        checkbarBV.font = styleStorebarBV.fontbarBV(12, weight: .heavy)
        checkbarBV.backgroundColor = stylebarBV.selectedFlagbarBV ? styleStorebarBV.purple : .clear
        checkbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(11, minimumbarBV: 10, maximumbarBV: 12)
        checkbarBV.layer.masksToBounds = true

        addSubview(titlebarBV)
        addSubview(subtitlebarBV)
        addSubview(checkbarBV)
        [titlebarBV, subtitlebarBV, checkbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            titlebarBV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: styleStorebarBV.metricbarBV(16, minimumbarBV: 12, maximumbarBV: 18)),
            titlebarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            titlebarBV.topAnchor.constraint(equalTo: topAnchor, constant: styleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 14)),
            subtitlebarBV.leadingAnchor.constraint(equalTo: titlebarBV.leadingAnchor),
            subtitlebarBV.trailingAnchor.constraint(equalTo: titlebarBV.trailingAnchor),
            subtitlebarBV.topAnchor.constraint(equalTo: titlebarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(5, minimumbarBV: 4, maximumbarBV: 6)),
            checkbarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -styleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            checkbarBV.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10)),
            checkbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(22, minimumbarBV: 20, maximumbarBV: 24)),
            checkbarBV.heightAnchor.constraint(equalTo: checkbarBV.widthAnchor)
        ])
    }

    private func backgroundColorbarBV() -> UIColor {
        switch stylebarBV.styleSeedbarBV {
        case "cheerful":
            return UIColor(red: 222 / 255, green: 249 / 255, blue: 250 / 255, alpha: 1)
        case "playful":
            return UIColor(red: 1, green: 245 / 255, blue: 233 / 255, alpha: 1)
        default:
            return UIColor(red: 1, green: 248 / 255, blue: 210 / 255, alpha: 1)
        }
    }
}

private final class aiToneRowbarBV: UIControl {
    private let stylebarBV: aiStylebarBV

    init(stylebarBV: aiStylebarBV) {
        self.stylebarBV = stylebarBV
        super.init(frame: .zero)
        configurebarBV()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.14) {
                self.alpha = self.isHighlighted ? 0.58 : 1
            }
        }
    }

    private func configurebarBV() {
        isExclusiveTouch = true
        let markerbarBV = gradientBadgebarBV()
        markerbarBV.colorsbarBV = stylebarBV.selectedFlagbarBV
            ? [styleStorebarBV.mint, styleStorebarBV.purple, styleStorebarBV.pink]
            : [UIColor.systemGray5, UIColor.systemGray5]
        markerbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(20, minimumbarBV: 18, maximumbarBV: 22)
        markerbarBV.clipsToBounds = true

        let markerTextbarBV = UILabel()
        markerTextbarBV.text = String(stylebarBV.titlebarBV.prefix(1)).uppercased()
        markerTextbarBV.textAlignment = .center
        markerTextbarBV.textColor = stylebarBV.selectedFlagbarBV ? .white : UIColor.black.withAlphaComponent(0.42)
        markerTextbarBV.font = styleStorebarBV.fontbarBV(18, weight: .heavy)
        markerbarBV.addSubview(markerTextbarBV)
        markerTextbarBV.translatesAutoresizingMaskIntoConstraints = false

        let titlebarBV = UILabel()
        titlebarBV.text = "\(stylebarBV.titlebarBV) \(stylebarBV.emojibarBV)"
        titlebarBV.font = styleStorebarBV.fontbarBV(19, weight: .heavy)
        titlebarBV.textColor = .black
        styleStorebarBV.labelFitbarBV(titlebarBV, factorbarBV: 0.62, linesbarBV: 1)

        let subtitlebarBV = UILabel()
        subtitlebarBV.text = stylebarBV.subtitlebarBV
        subtitlebarBV.font = styleStorebarBV.fontbarBV(14, weight: .medium)
        subtitlebarBV.textColor = styleStorebarBV.mutedText
        styleStorebarBV.labelFitbarBV(subtitlebarBV, factorbarBV: 0.72, linesbarBV: 2)

        let textStackbarBV = UIStackView(arrangedSubviews: [titlebarBV, subtitlebarBV])
        textStackbarBV.axis = .vertical
        textStackbarBV.spacing = styleStorebarBV.spacebarBV(4, minimumbarBV: 2, maximumbarBV: 5)

        let costbarBV = UILabel()
        costbarBV.text = stylebarBV.unlockFlagbarBV ? "" : "400 🟡"
        costbarBV.font = styleStorebarBV.fontbarBV(13, weight: .heavy)
        costbarBV.textColor = UIColor(red: 37 / 255, green: 15 / 255, blue: 73 / 255, alpha: 1)
        costbarBV.textAlignment = .right
        costbarBV.isHidden = stylebarBV.unlockFlagbarBV
        styleStorebarBV.labelFitbarBV(costbarBV, factorbarBV: 0.66, linesbarBV: 1)
        costbarBV.setContentHuggingPriority(.required, for: .horizontal)
        costbarBV.setContentCompressionResistancePriority(.required, for: .horizontal)

        let symbolbarBV = stylebarBV.unlockFlagbarBV
            ? (stylebarBV.selectedFlagbarBV ? "checkmark.circle.fill" : "circle")
            : "lock.fill"
        let checkbarBV = UIImageView(image: UIImage(systemName: symbolbarBV))
        checkbarBV.tintColor = stylebarBV.selectedFlagbarBV ? styleStorebarBV.purple : UIColor.black.withAlphaComponent(stylebarBV.unlockFlagbarBV ? 0.18 : 0.34)
        checkbarBV.contentMode = .scaleAspectFit
        checkbarBV.setContentHuggingPriority(.required, for: .horizontal)
        checkbarBV.setContentCompressionResistancePriority(.required, for: .horizontal)

        let rowbarBV = UIStackView(arrangedSubviews: [markerbarBV, textStackbarBV, costbarBV, checkbarBV])
        rowbarBV.axis = .horizontal
        rowbarBV.alignment = .center
        rowbarBV.spacing = styleStorebarBV.metricbarBV(14, minimumbarBV: 10, maximumbarBV: 16)
        rowbarBV.isUserInteractionEnabled = false
        addSubview(rowbarBV)
        rowbarBV.translatesAutoresizingMaskIntoConstraints = false

        let markerSizebarBV = styleStorebarBV.metricbarBV(44, minimumbarBV: 40, maximumbarBV: 48)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: styleStorebarBV.metricbarBV(76, minimumbarBV: 68, maximumbarBV: 84)),
            markerbarBV.widthAnchor.constraint(equalToConstant: markerSizebarBV),
            markerbarBV.heightAnchor.constraint(equalTo: markerbarBV.widthAnchor),
            markerTextbarBV.topAnchor.constraint(equalTo: markerbarBV.topAnchor),
            markerTextbarBV.leadingAnchor.constraint(equalTo: markerbarBV.leadingAnchor),
            markerTextbarBV.trailingAnchor.constraint(equalTo: markerbarBV.trailingAnchor),
            markerTextbarBV.bottomAnchor.constraint(equalTo: markerbarBV.bottomAnchor),
            checkbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(24, minimumbarBV: 22, maximumbarBV: 26)),
            checkbarBV.heightAnchor.constraint(equalTo: checkbarBV.widthAnchor),
            costbarBV.widthAnchor.constraint(greaterThanOrEqualToConstant: styleStorebarBV.metricbarBV(54, minimumbarBV: 48, maximumbarBV: 62)),
            rowbarBV.topAnchor.constraint(equalTo: topAnchor, constant: styleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            rowbarBV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: styleStorebarBV.metricbarBV(14, minimumbarBV: 10, maximumbarBV: 16)),
            rowbarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -styleStorebarBV.metricbarBV(14, minimumbarBV: 10, maximumbarBV: 16)),
            rowbarBV.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -styleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12))
        ])
    }
}

private final class profileSettingRowbarBV: UIControl {
    private let titleLabelbarBV = UILabel()
    private let chevronbarBV = UIImageView(image: UIImage(systemName: "chevron.right"))
    private let iconWrapbarBV = UIView()
    private let iconViewbarBV = UIImageView()

    init(titlebarBV: String, symbolbarBV: String) {
        super.init(frame: .zero)
        titleLabelbarBV.text = titlebarBV
        iconViewbarBV.image = UIImage(systemName: symbolbarBV)
        configurebarBV()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.14) {
                self.alpha = self.isHighlighted ? 0.58 : 1
            }
        }
    }

    private func configurebarBV() {
        titleLabelbarBV.font = styleStorebarBV.fontbarBV(20, weight: .semibold)
        titleLabelbarBV.textColor = .black
        styleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.68, linesbarBV: 1)
        iconWrapbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.04)
        iconWrapbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(14, minimumbarBV: 12, maximumbarBV: 16)
        iconViewbarBV.tintColor = .black
        iconViewbarBV.contentMode = .scaleAspectFit
        chevronbarBV.tintColor = UIColor.black.withAlphaComponent(0.32)
        chevronbarBV.contentMode = .scaleAspectFit
        iconWrapbarBV.addSubview(iconViewbarBV)
        [iconWrapbarBV, titleLabelbarBV, chevronbarBV].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        iconViewbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: styleStorebarBV.metricbarBV(64, minimumbarBV: 58, maximumbarBV: 68)),
            iconWrapbarBV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: styleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            iconWrapbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconWrapbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(42, minimumbarBV: 38, maximumbarBV: 44)),
            iconWrapbarBV.heightAnchor.constraint(equalTo: iconWrapbarBV.widthAnchor),
            iconViewbarBV.centerXAnchor.constraint(equalTo: iconWrapbarBV.centerXAnchor),
            iconViewbarBV.centerYAnchor.constraint(equalTo: iconWrapbarBV.centerYAnchor),
            iconViewbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(22, minimumbarBV: 20, maximumbarBV: 24)),
            iconViewbarBV.heightAnchor.constraint(equalTo: iconViewbarBV.widthAnchor),
            titleLabelbarBV.leadingAnchor.constraint(equalTo: iconWrapbarBV.trailingAnchor, constant: styleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            titleLabelbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: chevronbarBV.leadingAnchor, constant: -styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            chevronbarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -styleStorebarBV.metricbarBV(24, minimumbarBV: 18, maximumbarBV: 26)),
            chevronbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(16, minimumbarBV: 14, maximumbarBV: 18)),
            chevronbarBV.heightAnchor.constraint(equalTo: chevronbarBV.widthAnchor)
        ])
    }
}

private extension UILabel {
    func letterSpacingbarBV(_ valuebarBV: CGFloat) {
        guard let textbarBV = text else { return }
        attributedText = NSAttributedString(
            string: textbarBV,
            attributes: [
                .kern: valuebarBV,
                .font: font as Any,
                .foregroundColor: textColor as Any
            ]
        )
    }
}

private final class blockedListSurfacebarBV: localSurfacebarBV {
    private let storebarBV: localStorebarBV
    private let headerBarbarBV = UIView()
    private let backButtonbarBV = UIButton(type: .system)
    private let titleLabelbarBV = UILabel()
    private let scrollViewbarBV = UIScrollView()
    private let contentViewbarBV = UIView()
    private let stackbarBV = UIStackView()
    private let statusLabelbarBV = UILabel()
    private var statusWorkbarBV: DispatchWorkItem?

    init(store: localStorebarBV) {
        self.storebarBV = store
        super.init(nibName: nil, bundle: nil)
        title = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderbarBV()
        configureScrollbarBV()
        configureStatusbarBV()
        renderbarBV()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        renderbarBV()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureHeaderbarBV() {
        backButtonbarBV.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButtonbarBV.tintColor = .black
        backButtonbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.36)
        backButtonbarBV.layer.cornerRadius = styleStorebarBV.controlbarBV(44) / 2
        backButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)

        titleLabelbarBV.text = "Blacklist"
        titleLabelbarBV.font = styleStorebarBV.fontbarBV(28, weight: .heavy)
        titleLabelbarBV.textColor = .black
        titleLabelbarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.62, linesbarBV: 1)

        view.addSubview(headerBarbarBV)
        [backButtonbarBV, titleLabelbarBV].forEach {
            headerBarbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        headerBarbarBV.translatesAutoresizingMaskIntoConstraints = false

        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)
        let buttonSizebarBV = styleStorebarBV.controlbarBV(44)
        NSLayoutConstraint.activate([
            headerBarbarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: styleStorebarBV.spacebarBV(10, minimumbarBV: 6, maximumbarBV: 14)),
            headerBarbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInsetbarBV),
            headerBarbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInsetbarBV),
            headerBarbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(54, minimumbarBV: 48, maximumbarBV: 58)),
            backButtonbarBV.leadingAnchor.constraint(equalTo: headerBarbarBV.leadingAnchor),
            backButtonbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            backButtonbarBV.widthAnchor.constraint(equalToConstant: buttonSizebarBV),
            backButtonbarBV.heightAnchor.constraint(equalToConstant: buttonSizebarBV),
            titleLabelbarBV.centerXAnchor.constraint(equalTo: headerBarbarBV.centerXAnchor),
            titleLabelbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            titleLabelbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: backButtonbarBV.trailingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            titleLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: headerBarbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(58, minimumbarBV: 48, maximumbarBV: 62))
        ])
    }

    private func configureScrollbarBV() {
        scrollViewbarBV.showsVerticalScrollIndicator = false
        scrollViewbarBV.alwaysBounceVertical = true
        stackbarBV.axis = .vertical
        stackbarBV.alignment = .fill
        stackbarBV.spacing = styleStorebarBV.spacebarBV(16, minimumbarBV: 12, maximumbarBV: 20)
        view.addSubview(scrollViewbarBV)
        scrollViewbarBV.addSubview(contentViewbarBV)
        contentViewbarBV.addSubview(stackbarBV)
        [scrollViewbarBV, contentViewbarBV, stackbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 34)
        NSLayoutConstraint.activate([
            scrollViewbarBV.topAnchor.constraint(equalTo: headerBarbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 24)),
            scrollViewbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollViewbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewbarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentViewbarBV.topAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.topAnchor),
            contentViewbarBV.leadingAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.leadingAnchor),
            contentViewbarBV.trailingAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.trailingAnchor),
            contentViewbarBV.bottomAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.bottomAnchor),
            contentViewbarBV.widthAnchor.constraint(equalTo: scrollViewbarBV.frameLayoutGuide.widthAnchor),
            stackbarBV.topAnchor.constraint(equalTo: contentViewbarBV.topAnchor),
            stackbarBV.leadingAnchor.constraint(equalTo: contentViewbarBV.leadingAnchor, constant: sideInsetbarBV),
            stackbarBV.trailingAnchor.constraint(equalTo: contentViewbarBV.trailingAnchor, constant: -sideInsetbarBV),
            stackbarBV.bottomAnchor.constraint(equalTo: contentViewbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(30, minimumbarBV: 22, maximumbarBV: 36))
        ])
    }

    private func renderbarBV() {
        stackbarBV.arrangedSubviews.forEach {
            stackbarBV.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        stackbarBV.addArrangedSubview(descriptionLabelbarBV())
        stackbarBV.addArrangedSubview(sectionTitlebarBV("NOTIFICATIONS"))
        if storebarBV.blockedUsersbarBV.isEmpty {
            stackbarBV.addArrangedSubview(emptyCardbarBV())
        } else {
            stackbarBV.addArrangedSubview(blockedCardbarBV())
        }
        stackbarBV.addArrangedSubview(footerLabelbarBV())
    }

    private func descriptionLabelbarBV() -> UILabel {
        let labelbarBV = UILabel()
        labelbarBV.text = "Blocked contacts can't message you, see your profile, or send friend requests. Tap \"Unblock\" to restore."
        labelbarBV.font = styleStorebarBV.fontbarBV(15, weight: .semibold)
        labelbarBV.textColor = styleStorebarBV.mutedText
        labelbarBV.numberOfLines = 0
        labelbarBV.textAlignment = .left
        return labelbarBV
    }

    private func sectionTitlebarBV(_ textbarBV: String) -> UILabel {
        let labelbarBV = UILabel()
        labelbarBV.text = textbarBV
        labelbarBV.font = styleStorebarBV.fontbarBV(15, weight: .heavy)
        labelbarBV.textColor = UIColor.black.withAlphaComponent(0.78)
        labelbarBV.letterSpacingbarBV(1.4)
        styleStorebarBV.labelFitbarBV(labelbarBV, factorbarBV: 0.68, linesbarBV: 1)
        return labelbarBV
    }

    private func blockedCardbarBV() -> UIView {
        let cardbarBV = cardSurfacebarBV(cornerRadius: styleStorebarBV.metricbarBV(24, minimumbarBV: 20, maximumbarBV: 28))
        let listbarBV = UIStackView()
        listbarBV.axis = .vertical
        listbarBV.spacing = 0
        cardbarBV.addSubview(listbarBV)
        listbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listbarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor, constant: styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10)),
            listbarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            listbarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            listbarBV.bottomAnchor.constraint(equalTo: cardbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10))
        ])
        for (indexbarBV, blockedbarBV) in storebarBV.blockedUsersbarBV.enumerated() {
            let rowbarBV = blockedPanelbarBV(blockedbarBV: blockedbarBV)
            rowbarBV.unblockHandlerbarBV = { [weak self] blockedbarBV in
                self?.confirmUnblockbarBV(blockedbarBV)
            }
            listbarBV.addArrangedSubview(rowbarBV)
            if indexbarBV < storebarBV.blockedUsersbarBV.count - 1 {
                let dividerbarBV = UIView()
                dividerbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.06)
                listbarBV.addArrangedSubview(dividerbarBV)
                dividerbarBV.heightAnchor.constraint(equalToConstant: 1).isActive = true
            }
        }
        return cardbarBV
    }

    private func emptyCardbarBV() -> UIView {
        let cardbarBV = cardSurfacebarBV(cornerRadius: styleStorebarBV.metricbarBV(24, minimumbarBV: 20, maximumbarBV: 28))
        let titlebarBV = UILabel()
        titlebarBV.text = "No blocked contacts."
        titlebarBV.textColor = .black
        titlebarBV.textAlignment = .center
        titlebarBV.font = styleStorebarBV.fontbarBV(18, weight: .heavy)
        let subtitlebarBV = UILabel()
        subtitlebarBV.text = "People you block will appear here."
        subtitlebarBV.textColor = styleStorebarBV.mutedText
        subtitlebarBV.textAlignment = .center
        subtitlebarBV.font = styleStorebarBV.fontbarBV(14, weight: .semibold)
        subtitlebarBV.numberOfLines = 0
        let stackbarBV = UIStackView(arrangedSubviews: [titlebarBV, subtitlebarBV])
        stackbarBV.axis = .vertical
        stackbarBV.spacing = styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10)
        cardbarBV.addSubview(stackbarBV)
        stackbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardbarBV.heightAnchor.constraint(greaterThanOrEqualToConstant: styleStorebarBV.metricbarBV(150, minimumbarBV: 128, maximumbarBV: 170)),
            stackbarBV.centerYAnchor.constraint(equalTo: cardbarBV.centerYAnchor),
            stackbarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(22, minimumbarBV: 18, maximumbarBV: 26)),
            stackbarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(22, minimumbarBV: 18, maximumbarBV: 26))
        ])
        return cardbarBV
    }

    private func footerLabelbarBV() -> UILabel {
        let labelbarBV = UILabel()
        labelbarBV.text = "People you block won't be notified."
        labelbarBV.font = styleStorebarBV.fontbarBV(14, weight: .semibold)
        labelbarBV.textColor = styleStorebarBV.mutedText
        labelbarBV.textAlignment = .center
        labelbarBV.numberOfLines = 0
        return labelbarBV
    }

    private func confirmUnblockbarBV(_ blockedbarBV: blockedUserbarBV) {
        let alertbarBV = UIAlertController(
            title: "Unblock this contact?",
            message: "They will be able to message you and interact with you again.",
            preferredStyle: .alert
        )
        alertbarBV.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertbarBV.addAction(UIAlertAction(title: "Unblock", style: .default) { [weak self] _ in
            self?.storebarBV.unblockUserbarBV(blockedbarBV)
            self?.renderbarBV()
            self?.showStatusbarBV("User unblocked")
        })
        present(alertbarBV, animated: true)
    }

    private func configureStatusbarBV() {
        statusLabelbarBV.alpha = 0
        statusLabelbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.74)
        statusLabelbarBV.textColor = .white
        statusLabelbarBV.font = styleStorebarBV.fontbarBV(14, weight: .bold)
        statusLabelbarBV.textAlignment = .center
        statusLabelbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(17, minimumbarBV: 15, maximumbarBV: 18)
        statusLabelbarBV.layer.masksToBounds = true
        styleStorebarBV.labelFitbarBV(statusLabelbarBV, factorbarBV: 0.72, linesbarBV: 1)
        view.addSubview(statusLabelbarBV)
        statusLabelbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabelbarBV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabelbarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -styleStorebarBV.spacebarBV(24, minimumbarBV: 16, maximumbarBV: 28)),
            statusLabelbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: styleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 40)),
            statusLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -styleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 40)),
            statusLabelbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(34, minimumbarBV: 30, maximumbarBV: 36))
        ])
    }

    private func showStatusbarBV(_ textbarBV: String) {
        statusWorkbarBV?.cancel()
        statusLabelbarBV.text = "  \(textbarBV)  "
        UIView.animate(withDuration: 0.18) {
            self.statusLabelbarBV.alpha = 1
        }
        let workbarBV = DispatchWorkItem { [weak self] in
            UIView.animate(withDuration: 0.22) {
                self?.statusLabelbarBV.alpha = 0
            }
        }
        statusWorkbarBV = workbarBV
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25, execute: workbarBV)
    }
}

private final class blockedPanelbarBV: UIView {
    var unblockHandlerbarBV: ((blockedUserbarBV) -> Void)?
    private let blockedbarBV: blockedUserbarBV

    init(blockedbarBV: blockedUserbarBV) {
        self.blockedbarBV = blockedbarBV
        super.init(frame: .zero)
        configurebarBV()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configurebarBV() {
        let avatarbarBV = avatarSurfacebarBV(initial: blockedbarBV.avatarbarBV, color: styleStorebarBV.purple)
        let namebarBV = UILabel()
        let detailbarBV = UILabel()
        let unblockbarBV = UIButton(type: .system)
        namebarBV.text = blockedbarBV.namebarBV
        namebarBV.font = styleStorebarBV.fontbarBV(18, weight: .heavy)
        namebarBV.textColor = .black
        styleStorebarBV.labelFitbarBV(namebarBV, factorbarBV: 0.62, linesbarBV: 1)
        detailbarBV.text = blockedDateTextbarBV()
        detailbarBV.font = styleStorebarBV.fontbarBV(13, weight: .semibold)
        detailbarBV.textColor = styleStorebarBV.mutedText
        styleStorebarBV.labelFitbarBV(detailbarBV, factorbarBV: 0.68, linesbarBV: 1)
        unblockbarBV.setTitle("Unblock", for: .normal)
        unblockbarBV.setTitleColor(styleStorebarBV.purple, for: .normal)
        unblockbarBV.titleLabel?.font = styleStorebarBV.fontbarBV(14, weight: .heavy)
        styleStorebarBV.buttonFitbarBV(unblockbarBV, factorbarBV: 0.58)
        unblockbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        unblockbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(17, minimumbarBV: 15, maximumbarBV: 18)
        unblockbarBV.clipsToBounds = true
        unblockbarBV.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.unblockHandlerbarBV?(self.blockedbarBV)
        }, for: .touchUpInside)

        let textStackbarBV = UIStackView(arrangedSubviews: [namebarBV, detailbarBV])
        textStackbarBV.axis = .vertical
        textStackbarBV.spacing = styleStorebarBV.spacebarBV(4, minimumbarBV: 3, maximumbarBV: 5)
        [avatarbarBV, textStackbarBV, unblockbarBV].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let avatarSizebarBV = styleStorebarBV.metricbarBV(50, minimumbarBV: 44, maximumbarBV: 54)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: styleStorebarBV.metricbarBV(78, minimumbarBV: 70, maximumbarBV: 84)),
            avatarbarBV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: styleStorebarBV.metricbarBV(16, minimumbarBV: 12, maximumbarBV: 18)),
            avatarbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarbarBV.widthAnchor.constraint(equalToConstant: avatarSizebarBV),
            avatarbarBV.heightAnchor.constraint(equalTo: avatarbarBV.widthAnchor),
            unblockbarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -styleStorebarBV.metricbarBV(14, minimumbarBV: 10, maximumbarBV: 16)),
            unblockbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            unblockbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(88, minimumbarBV: 76, maximumbarBV: 94)),
            unblockbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(36, minimumbarBV: 32, maximumbarBV: 38)),
            textStackbarBV.leadingAnchor.constraint(equalTo: avatarbarBV.trailingAnchor, constant: styleStorebarBV.metricbarBV(14, minimumbarBV: 10, maximumbarBV: 16)),
            textStackbarBV.trailingAnchor.constraint(equalTo: unblockbarBV.leadingAnchor, constant: -styleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            textStackbarBV.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func blockedDateTextbarBV() -> String {
        let formatterbarBV = DateFormatter()
        formatterbarBV.locale = Locale(identifier: "en_US_POSIX")
        formatterbarBV.dateFormat = "MMM d"
        return "Blocked \(formatterbarBV.string(from: blockedbarBV.blockedAtbarBV))"
    }
}
