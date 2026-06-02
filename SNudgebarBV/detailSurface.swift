import UIKit

final class detailSurface: barbCanvasbarBV {
    private let storebarBV: barbVaultbarBV
    private var contactbarBV: trustedContact
    private let headerBarbarBV = UIView()
    private let backButtonbarBV = UIButton(type: .system)
    private let headerTitlebarBV = UILabel()
    private let scrollViewbarBV = UIScrollView()
    private let contentViewbarBV = UIView()
    private let stackbarBV = UIStackView()
    private let avatarbarBV = avatarSurfacebarBV(initial: "B")
    private let nameLabelbarBV = UILabel()
    private let idLabelbarBV = UILabel()
    private let messageButtonbarBV = gradientPill(type: .system)
    private let muteSwitchbarBV = UISwitch()
    private let pinSwitchbarBV = UISwitch()
    private let statusLabelbarBV = UILabel()
    private var statusWorkbarBV: DispatchWorkItem?

    init(contact: trustedContact, store: barbVaultbarBV = .shared) {
        self.contactbarBV = contact
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
        configureProfileCardbarBV()
        configureInfoSectionsbarBV()
        configureActionButtonsbarBV()
        configureStatusbarBV()
        refreshProfilebarBV()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        refreshProfilebarBV()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureHeaderbarBV() {
        backButtonbarBV.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButtonbarBV.tintColor = .black
        backButtonbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.38)
        backButtonbarBV.layer.cornerRadius = styleStorebarBV.controlbarBV(44) / 2
        backButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)

        headerTitlebarBV.text = "Profile"
        headerTitlebarBV.font = styleStorebarBV.fontbarBV(28, weight: .heavy)
        headerTitlebarBV.textColor = .black
        headerTitlebarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(headerTitlebarBV, factorbarBV: 0.72, linesbarBV: 1)

        view.addSubview(headerBarbarBV)
        [backButtonbarBV, headerTitlebarBV].forEach {
            headerBarbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        headerBarbarBV.translatesAutoresizingMaskIntoConstraints = false

        let sideInsetbarBV = styleStorebarBV.metricbarBV(26, minimumbarBV: 18, maximumbarBV: 30)
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

            headerTitlebarBV.centerXAnchor.constraint(equalTo: headerBarbarBV.centerXAnchor),
            headerTitlebarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            headerTitlebarBV.leadingAnchor.constraint(greaterThanOrEqualTo: backButtonbarBV.trailingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            headerTitlebarBV.trailingAnchor.constraint(lessThanOrEqualTo: headerBarbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(54, minimumbarBV: 48, maximumbarBV: 58))
        ])
    }

    private func configureScrollbarBV() {
        scrollViewbarBV.showsVerticalScrollIndicator = false
        scrollViewbarBV.alwaysBounceVertical = true
        stackbarBV.axis = .vertical
        stackbarBV.alignment = .fill
        stackbarBV.spacing = styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 22)

        view.addSubview(scrollViewbarBV)
        scrollViewbarBV.addSubview(contentViewbarBV)
        contentViewbarBV.addSubview(stackbarBV)
        [scrollViewbarBV, contentViewbarBV, stackbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 32)
        NSLayoutConstraint.activate([
            scrollViewbarBV.topAnchor.constraint(equalTo: headerBarbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(18, minimumbarBV: 10, maximumbarBV: 22)),
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
            stackbarBV.bottomAnchor.constraint(equalTo: contentViewbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(28, minimumbarBV: 20, maximumbarBV: 34))
        ])
    }

    private func configureProfileCardbarBV() {
        let cardbarBV = cardSurfacebarBV(cornerRadius: styleStorebarBV.metricbarBV(28, minimumbarBV: 24, maximumbarBV: 32))
        avatarbarBV.font = styleStorebarBV.fontbarBV(50, weight: .bold)
        nameLabelbarBV.font = styleStorebarBV.fontbarBV(28, weight: .heavy)
        nameLabelbarBV.textColor = .black
        nameLabelbarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(nameLabelbarBV, factorbarBV: 0.62, linesbarBV: 1)
        idLabelbarBV.font = styleStorebarBV.fontbarBV(15, weight: .semibold)
        idLabelbarBV.textColor = styleStorebarBV.mutedText
        idLabelbarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(idLabelbarBV, factorbarBV: 0.72, linesbarBV: 1)

        messageButtonbarBV.setTitle("Message", for: .normal)
        messageButtonbarBV.setTitleColor(.white, for: .normal)
        messageButtonbarBV.setImage(UIImage(systemName: "message.circle.fill"), for: .normal)
        messageButtonbarBV.tintColor = .white
        messageButtonbarBV.titleLabel?.font = styleStorebarBV.fontbarBV(18, weight: .heavy)
        messageButtonbarBV.colorsbarBV = styleStorebarBV.replyChoiceColorsbarBV
        messageButtonbarBV.locationsbarBV = styleStorebarBV.replyChoiceLocationsbarBV
        messageButtonbarBV.semanticContentAttribute = .forceLeftToRight
        messageButtonbarBV.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        messageButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.openMessagebarBV()
        }, for: .touchUpInside)

        stackbarBV.addArrangedSubview(cardbarBV)
        [avatarbarBV, nameLabelbarBV, idLabelbarBV, messageButtonbarBV].forEach {
            cardbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let avatarSizebarBV = styleStorebarBV.metricbarBV(94, minimumbarBV: 78, maximumbarBV: 100)
        NSLayoutConstraint.activate([
            cardbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(254, minimumbarBV: 226, maximumbarBV: 274)),
            avatarbarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor, constant: styleStorebarBV.spacebarBV(28, minimumbarBV: 20, maximumbarBV: 34)),
            avatarbarBV.centerXAnchor.constraint(equalTo: cardbarBV.centerXAnchor),
            avatarbarBV.widthAnchor.constraint(equalToConstant: avatarSizebarBV),
            avatarbarBV.heightAnchor.constraint(equalTo: avatarbarBV.widthAnchor),

            nameLabelbarBV.topAnchor.constraint(equalTo: avatarbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 20)),
            nameLabelbarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 22)),
            nameLabelbarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 22)),

            idLabelbarBV.topAnchor.constraint(equalTo: nameLabelbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(6, minimumbarBV: 4, maximumbarBV: 8)),
            idLabelbarBV.leadingAnchor.constraint(equalTo: nameLabelbarBV.leadingAnchor),
            idLabelbarBV.trailingAnchor.constraint(equalTo: nameLabelbarBV.trailingAnchor),

            messageButtonbarBV.topAnchor.constraint(equalTo: idLabelbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(16, minimumbarBV: 10, maximumbarBV: 18)),
            messageButtonbarBV.centerXAnchor.constraint(equalTo: cardbarBV.centerXAnchor),
            messageButtonbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(150, minimumbarBV: 132, maximumbarBV: 164)),
            messageButtonbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.controlbarBV(46))
        ])
    }

    private func configureInfoSectionsbarBV() {
        stackbarBV.addArrangedSubview(sectionTitlebarBV("NOTE & GROUP"))
        let infoCardbarBV = groupedCardbarBV([
            profileValueRowbarBV(titlebarBV: "Name", valuebarBV: contactbarBV.placeholderNotebarBV, chevronbarBV: true),
            profileValueRowbarBV(titlebarBV: "Group", valuebarBV: contactbarBV.groupFilter.rawValue, chevronbarBV: true),
            profileValueRowbarBV(titlebarBV: "Connected since", valuebarBV: storebarBV.connectedSincebarBV(for: contactbarBV), chevronbarBV: true)
        ])
        stackbarBV.addArrangedSubview(infoCardbarBV)

        stackbarBV.addArrangedSubview(sectionTitlebarBV("NOTIFICATIONS"))
        muteSwitchbarBV.onTintColor = styleStorebarBV.purple
        pinSwitchbarBV.onTintColor = styleStorebarBV.purple
        muteSwitchbarBV.addAction(UIAction { [weak self] _ in
            self?.toggleMutebarBV()
        }, for: .valueChanged)
        pinSwitchbarBV.addAction(UIAction { [weak self] _ in
            self?.togglePinbarBV()
        }, for: .valueChanged)
        let notificationCardbarBV = groupedCardbarBV([
            profileSwitchRowbarBV(titlebarBV: "Mute notifications", switchbarBV: muteSwitchbarBV),
            profileSwitchRowbarBV(titlebarBV: "Pin to top of Desk", switchbarBV: pinSwitchbarBV)
        ])
        stackbarBV.addArrangedSubview(notificationCardbarBV)
    }

    private func configureActionButtonsbarBV() {
        let removeButtonbarBV = gradientPill(type: .system)
        removeButtonbarBV.setTitle("Remove from contacts", for: .normal)
        removeButtonbarBV.setTitleColor(.black, for: .normal)
        removeButtonbarBV.titleLabel?.font = styleStorebarBV.fontbarBV(20, weight: .heavy)
        removeButtonbarBV.colorsbarBV = [
            UIColor(red: 183 / 255, green: 246 / 255, blue: 1, alpha: 1),
            UIColor(red: 1, green: 218 / 255, blue: 252 / 255, alpha: 1),
            UIColor(red: 157 / 255, green: 228 / 255, blue: 1, alpha: 1)
        ]
        removeButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.confirmRemovebarBV()
        }, for: .touchUpInside)

        let blockButtonbarBV = UIButton(type: .system)
        blockButtonbarBV.setTitle("Block this contact", for: .normal)
        blockButtonbarBV.setTitleColor(.red, for: .normal)
        blockButtonbarBV.titleLabel?.font = styleStorebarBV.fontbarBV(20, weight: .heavy)
        blockButtonbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.96)
        blockButtonbarBV.layer.cornerRadius = styleStorebarBV.controlbarBV(58) / 2
        blockButtonbarBV.clipsToBounds = true
        blockButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.confirmBlockbarBV()
        }, for: .touchUpInside)

        let spacerbarBV = UIView()
        spacerbarBV.translatesAutoresizingMaskIntoConstraints = false
        spacerbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.spacebarBV(4, minimumbarBV: 0, maximumbarBV: 8)).isActive = true
        stackbarBV.addArrangedSubview(spacerbarBV)
        stackbarBV.addArrangedSubview(removeButtonbarBV)
        stackbarBV.addArrangedSubview(blockButtonbarBV)
        removeButtonbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.controlbarBV(58)).isActive = true
        blockButtonbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.controlbarBV(58)).isActive = true
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

    private func refreshProfilebarBV() {
        contactbarBV = storebarBV.contactProfilebarBV(contactbarBV: contactbarBV)
        avatarbarBV.text = contactbarBV.placeholderAvatar
        avatarbarBV.backgroundColor = colorbarBV(for: contactbarBV)
        nameLabelbarBV.text = contactbarBV.placeholderNamebarBV
        idLabelbarBV.text = "BARB ID · \(storebarBV.contactIDbarBV(for: contactbarBV))"
        muteSwitchbarBV.setOn(storebarBV.mutedFlagbarBV(contactbarBV: contactbarBV), animated: false)
        pinSwitchbarBV.setOn(storebarBV.pinFlagbarBV(contactbarBV: contactbarBV), animated: false)
    }

    private func sectionTitlebarBV(_ textbarBV: String) -> UILabel {
        let labelbarBV = UILabel()
        labelbarBV.text = textbarBV
        labelbarBV.font = styleStorebarBV.fontbarBV(15, weight: .heavy)
        labelbarBV.textColor = .black
        labelbarBV.numberOfLines = 1
        labelbarBV.adjustsFontSizeToFitWidth = true
        labelbarBV.minimumScaleFactor = 0.62
        labelbarBV.letterSpacingbarBV(1.6)
        return labelbarBV
    }

    private func groupedCardbarBV(_ rowsbarBV: [UIView]) -> UIView {
        let cardbarBV = cardSurfacebarBV(cornerRadius: styleStorebarBV.metricbarBV(24, minimumbarBV: 20, maximumbarBV: 28))
        let stackbarBV = UIStackView()
        stackbarBV.axis = .vertical
        stackbarBV.spacing = 0
        cardbarBV.addSubview(stackbarBV)
        stackbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackbarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor),
            stackbarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor),
            stackbarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor),
            stackbarBV.bottomAnchor.constraint(equalTo: cardbarBV.bottomAnchor)
        ])
        for (indexbarBV, rowbarBV) in rowsbarBV.enumerated() {
            stackbarBV.addArrangedSubview(rowbarBV)
            rowbarBV.heightAnchor.constraint(greaterThanOrEqualToConstant: styleStorebarBV.metricbarBV(72, minimumbarBV: 62, maximumbarBV: 78)).isActive = true
            if indexbarBV < rowsbarBV.count - 1 {
                let dividerbarBV = UIView()
                dividerbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.06)
                stackbarBV.addArrangedSubview(dividerbarBV)
                dividerbarBV.heightAnchor.constraint(equalToConstant: 1).isActive = true
            }
        }
        return cardbarBV
    }

    private func openMessagebarBV() {
        guard !storebarBV.blockedFlagbarBV(contactSeedbarBV: contactbarBV.contactSeed), !contactbarBV.blockFlag else {
            showStatusbarBV("Contact is blocked")
            return
        }
        let threadbarBV = storebarBV.threadForContactbarBV(contactbarBV: contactbarBV)
        navigationController?.pushViewController(threadPagebarBV(store: storebarBV, thread: threadbarBV), animated: true)
    }

    private func toggleMutebarBV() {
        storebarBV.setMutedbarBV(muteSwitchbarBV.isOn, contactbarBV: contactbarBV)
        showStatusbarBV(muteSwitchbarBV.isOn ? "Notifications muted" : "Notifications on")
    }

    private func togglePinbarBV() {
        storebarBV.setPinnedbarBV(pinSwitchbarBV.isOn, contactbarBV: contactbarBV)
        showStatusbarBV(pinSwitchbarBV.isOn ? "Pinned to Desk" : "Removed from Desk pin")
    }

    private func confirmRemovebarBV() {
        let alertbarBV = UIAlertController(
            title: "Remove from contacts?",
            message: "This removes \(contactbarBV.placeholderNamebarBV) from your Partner list. Existing conversations stay in Barb unless you delete them separately.",
            preferredStyle: .alert
        )
        alertbarBV.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertbarBV.addAction(UIAlertAction(title: "Remove", style: .destructive) { [weak self] _ in
            self?.removeContactbarBV()
        })
        present(alertbarBV, animated: true)
    }

    private func confirmBlockbarBV() {
        let alertbarBV = UIAlertController(
            title: "Block \(contactbarBV.placeholderNamebarBV)?",
            message: "They will be added to Blacklist and removed from contacts and related conversations.",
            preferredStyle: .alert
        )
        alertbarBV.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertbarBV.addAction(UIAlertAction(title: "Block", style: .destructive) { [weak self] _ in
            self?.blockContactbarBV()
        })
        present(alertbarBV, animated: true)
    }

    private func removeContactbarBV() {
        _ = storebarBV.removeContactbarBV(contactbarBV: contactbarBV)
        showStatusbarBV("Contact removed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    private func blockContactbarBV() {
        _ = storebarBV.blockUserbarBV(contactbarBV: contactbarBV)
        showStatusbarBV("Contact blocked")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
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

    private func colorbarBV(for contactbarBV: trustedContact) -> UIColor {
        switch contactbarBV.groupFilter {
        case .familyFilterbarBV:
            return styleStorebarBV.pink
        case .friendFilter:
            return styleStorebarBV.purple
        case .workFilterbarBV:
            return styleStorebarBV.blue
        case .otherFilter:
            return styleStorebarBV.mint
        }
    }
}

private final class profileValueRowbarBV: UIView {
    init(titlebarBV: String, valuebarBV: String, chevronbarBV: Bool) {
        super.init(frame: .zero)
        let titleLabelbarBV = UILabel()
        let valueLabelbarBV = UILabel()
        let chevronViewbarBV = UIImageView(image: UIImage(systemName: "chevron.right"))
        titleLabelbarBV.text = titlebarBV
        titleLabelbarBV.font = styleStorebarBV.fontbarBV(18, weight: .semibold)
        titleLabelbarBV.textColor = .black
        valueLabelbarBV.text = valuebarBV
        valueLabelbarBV.font = styleStorebarBV.fontbarBV(16, weight: .regular)
        valueLabelbarBV.textColor = styleStorebarBV.mutedText
        valueLabelbarBV.textAlignment = .right
        chevronViewbarBV.tintColor = .black
        chevronViewbarBV.contentMode = .scaleAspectFit
        chevronViewbarBV.isHidden = !chevronbarBV
        styleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.68, linesbarBV: 1)
        styleStorebarBV.labelFitbarBV(valueLabelbarBV, factorbarBV: 0.62, linesbarBV: 1)
        [titleLabelbarBV, valueLabelbarBV, chevronViewbarBV].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            titleLabelbarBV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: styleStorebarBV.metricbarBV(28, minimumbarBV: 20, maximumbarBV: 30)),
            titleLabelbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: valueLabelbarBV.leadingAnchor, constant: -styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)),

            chevronViewbarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -styleStorebarBV.metricbarBV(28, minimumbarBV: 20, maximumbarBV: 30)),
            chevronViewbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronViewbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(16, minimumbarBV: 14, maximumbarBV: 18)),
            chevronViewbarBV.heightAnchor.constraint(equalTo: chevronViewbarBV.widthAnchor),

            valueLabelbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueLabelbarBV.trailingAnchor.constraint(equalTo: chevronbarBV ? chevronViewbarBV.leadingAnchor : trailingAnchor, constant: chevronbarBV ? -styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14) : -styleStorebarBV.metricbarBV(28, minimumbarBV: 20, maximumbarBV: 30)),
            valueLabelbarBV.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.48)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private final class profileSwitchRowbarBV: UIView {
    init(titlebarBV: String, switchbarBV: UISwitch) {
        super.init(frame: .zero)
        let labelbarBV = UILabel()
        labelbarBV.text = titlebarBV
        labelbarBV.font = styleStorebarBV.fontbarBV(18, weight: .semibold)
        labelbarBV.textColor = .black
        styleStorebarBV.labelFitbarBV(labelbarBV, factorbarBV: 0.68, linesbarBV: 1)
        addSubview(labelbarBV)
        addSubview(switchbarBV)
        labelbarBV.translatesAutoresizingMaskIntoConstraints = false
        switchbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelbarBV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: styleStorebarBV.metricbarBV(28, minimumbarBV: 20, maximumbarBV: 30)),
            labelbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: switchbarBV.leadingAnchor, constant: -styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            switchbarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -styleStorebarBV.metricbarBV(26, minimumbarBV: 20, maximumbarBV: 30)),
            switchbarBV.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension UILabel {
    func letterSpacingbarBV(_ valuebarBV: CGFloat) {
        guard let textbarBV = text else { return }
        attributedText = NSAttributedString(
            string: textbarBV,
            attributes: [.kern: valuebarBV]
        )
    }
}
