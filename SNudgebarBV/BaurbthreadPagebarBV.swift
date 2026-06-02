import UIKit

final class BaurbthreadPagebarBV: barbCanvasbarBV, UITableViewDataSource, UITableViewDelegate {
    private let store: barbVaultbarBV
    private var thread: threadFixturebarBV
    private let headerBarbarBV = UIView()
    private let backButtonbarBV = UIButton(type: .system)
    private let moreButtonbarBV = UIButton(type: .system)
    private let headerAvatarbarBV = avatarSurfacebarBV(initial: "B")
    private let headerGroupAvatarbarBV = groupAvatarSurfacebarBV()
    private let headerTextStackbarBV = UIStackView()
    private let titleLabelbarBV = UILabel()
    private let statusLabelbarBV = UILabel()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let composerBarbarBV = UIView()
    private let composer = UITextField()
    private let sendTextButtonbarBV = gradientPill(type: .system)
    private let groupInviteButtonbarBV = gradientPill(type: .system)
    private var actionOverlaybarBV: UIControl?
    private var selectedMessagebarBV: messageFixturebarBV?
    private var aiReplyOverlaybarBV: UIView?
    private weak var aiReplySurfacebarBV: aiReplyDraftSurfacebarBV?
    private var moreOverlaybarBV: UIControl?
    private var blockOverlaybarBV: UIControl?
    private var coinOverlaybarBV: UIControl?

    init(store: barbVaultbarBV, thread: threadFixturebarBV) {
        self.store = store
        self.thread = thread
        super.init(nibName: nil, bundle: nil)
        title = nil
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderbarBV()
        configureComposerbarBV()
        configureTablebarBV()
        configureGroupInvitebarBV()
        configureDismissbarBV()
        refreshBlockedStatebarBV()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        refreshBlockedStatebarBV()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissActionMenubarBV()
        dismissAIReplybarBV()
        dismissMoreMenubarBV()
        dismissBlockAlertbarBV()
        dismissCoinShortagebarBV()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToBottombarBV(animated: false)
    }

    private func configureHeaderbarBV() {
        navigationItem.hidesBackButton = true
        [titleLabelbarBV, statusLabelbarBV].forEach {
            headerTextStackbarBV.addArrangedSubview($0)
        }

        backButtonbarBV.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButtonbarBV.tintColor = .black
        backButtonbarBV.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            if self.blockOverlaybarBV != nil {
                self.dismissBlockAlertbarBV()
                return
            }
            if self.coinOverlaybarBV != nil {
                self.dismissCoinShortagebarBV()
                return
            }
            if self.moreOverlaybarBV != nil {
                self.dismissMoreMenubarBV()
                return
            }
            if self.aiReplyOverlaybarBV != nil {
                self.dismissAIReplybarBV()
                return
            }
            self.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButtonbarBV)

        moreButtonbarBV.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        moreButtonbarBV.tintColor = .black
        moreButtonbarBV.accessibilityLabel = "More"
        moreButtonbarBV.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            if self.thread.smallGroupFlag {
                self.presentGroupMoreMenubarBV()
            } else {
                self.presentMoreMenubarBV()
            }
        }, for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: moreButtonbarBV)

        titleLabelbarBV.font = BaurbstyleStorebarBV.fontbarBV(18, weight: .heavy)
        titleLabelbarBV.textColor = .black
        titleLabelbarBV.numberOfLines = 1
        titleLabelbarBV.lineBreakMode = .byTruncatingTail
        statusLabelbarBV.font = BaurbstyleStorebarBV.fontbarBV(13, weight: .semibold)
        statusLabelbarBV.numberOfLines = 1
        statusLabelbarBV.lineBreakMode = .byTruncatingTail
        BaurbstyleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.72, linesbarBV: 1)
        BaurbstyleStorebarBV.labelFitbarBV(statusLabelbarBV, factorbarBV: 0.72, linesbarBV: 1)
        titleLabelbarBV.lineBreakMode = .byTruncatingTail
        statusLabelbarBV.lineBreakMode = .byTruncatingTail
        titleLabelbarBV.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        statusLabelbarBV.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        headerTextStackbarBV.axis = .vertical
        headerTextStackbarBV.alignment = .fill
        headerTextStackbarBV.spacing = 2
        headerTextStackbarBV.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        headerTextStackbarBV.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let titleContainerbarBV = UIView()
        let titleStackbarBV = UIStackView(arrangedSubviews: [headerAvatarbarBV, headerGroupAvatarbarBV, headerTextStackbarBV])
        titleStackbarBV.axis = .horizontal
        titleStackbarBV.alignment = .center
        titleStackbarBV.spacing = BaurbstyleStorebarBV.metricbarBV(8, minimumbarBV: 6, maximumbarBV: 10)
        titleContainerbarBV.addSubview(titleStackbarBV)
        titleStackbarBV.translatesAutoresizingMaskIntoConstraints = false
        headerAvatarbarBV.translatesAutoresizingMaskIntoConstraints = false
        headerGroupAvatarbarBV.translatesAutoresizingMaskIntoConstraints = false
        headerTextStackbarBV.translatesAutoresizingMaskIntoConstraints = false

        let titleWidthbarBV = min(UIScreen.main.bounds.width - BaurbstyleStorebarBV.metricbarBV(144, minimumbarBV: 128, maximumbarBV: 156), BaurbstyleStorebarBV.metricbarBV(220, minimumbarBV: 176, maximumbarBV: 232))
        let avatarSizebarBV = BaurbstyleStorebarBV.metricbarBV(34, minimumbarBV: 30, maximumbarBV: 36)
        let buttonSizebarBV = BaurbstyleStorebarBV.controlbarBV(44)
        NSLayoutConstraint.activate([
            backButtonbarBV.widthAnchor.constraint(equalToConstant: buttonSizebarBV),
            backButtonbarBV.heightAnchor.constraint(equalToConstant: buttonSizebarBV),

            headerAvatarbarBV.widthAnchor.constraint(equalToConstant: avatarSizebarBV),
            headerAvatarbarBV.heightAnchor.constraint(equalToConstant: avatarSizebarBV),
            headerGroupAvatarbarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(54, minimumbarBV: 48, maximumbarBV: 58)),
            headerGroupAvatarbarBV.heightAnchor.constraint(equalToConstant: avatarSizebarBV),

            moreButtonbarBV.widthAnchor.constraint(equalToConstant: buttonSizebarBV),
            moreButtonbarBV.heightAnchor.constraint(equalToConstant: buttonSizebarBV),

            titleContainerbarBV.widthAnchor.constraint(equalToConstant: max(titleWidthbarBV, BaurbstyleStorebarBV.metricbarBV(148, minimumbarBV: 132, maximumbarBV: 164))),
            titleContainerbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(44, minimumbarBV: 40, maximumbarBV: 46)),
            titleStackbarBV.topAnchor.constraint(greaterThanOrEqualTo: titleContainerbarBV.topAnchor),
            titleStackbarBV.leadingAnchor.constraint(equalTo: titleContainerbarBV.leadingAnchor),
            titleStackbarBV.trailingAnchor.constraint(equalTo: titleContainerbarBV.trailingAnchor),
            titleStackbarBV.centerYAnchor.constraint(equalTo: titleContainerbarBV.centerYAnchor),
            titleStackbarBV.bottomAnchor.constraint(lessThanOrEqualTo: titleContainerbarBV.bottomAnchor)
        ])
        navigationItem.titleView = titleContainerbarBV
        refreshHeaderbarBV()
    }

    private func refreshHeaderbarBV() {
        titleLabelbarBV.text = thread.threadTitlebarBV
        if thread.smallGroupFlag {
            headerAvatarbarBV.isHidden = true
            headerGroupAvatarbarBV.isHidden = false
            let initialsbarBV = thread.personaPoolbarBV.compactMap {
                store.contactMatcherbarBV(contactSeed: $0)?.placeholderAvatar
            }
            headerGroupAvatarbarBV.configurebarBV(initialsbarBV: initialsbarBV)
            statusLabelbarBV.text = "\(store.groupMemberCountbarBV(for: thread)) members"
            statusLabelbarBV.textColor = BaurbstyleStorebarBV.mutedText
            return
        }
        headerAvatarbarBV.isHidden = false
        headerGroupAvatarbarBV.isHidden = true
        let contactbarBV = thread.personaPoolbarBV.first.flatMap { store.contactMatcherbarBV(contactSeed: $0) }
        headerAvatarbarBV.text = contactbarBV?.placeholderAvatar ?? thread.threadTitlebarBV.first.map(String.init) ?? "B"
        headerAvatarbarBV.backgroundColor = BaurbstyleStorebarBV.purple
        statusLabelbarBV.text = contactbarBV?.onlineFlagbarBV == true ? "● Online" : "Offline"
        statusLabelbarBV.textColor = contactbarBV?.onlineFlagbarBV == true ? .systemGreen : BaurbstyleStorebarBV.mutedText
    }

    private func refreshBlockedStatebarBV() {
        guard let contactbarBV = currentContactbarBV() else { return }
        let blockedbarBV = store.blockedFlagbarBV(contactSeedbarBV: contactbarBV.contactSeed) || contactbarBV.blockFlag
        if blockedbarBV {
            statusLabelbarBV.text = "Blocked"
            statusLabelbarBV.textColor = BaurbstyleStorebarBV.mutedText
            composer.text = nil
            composer.placeholder = "You blocked this user."
            composer.isEnabled = false
            sendTextButtonbarBV.isEnabled = false
            composer.alpha = 0.72
            sendTextButtonbarBV.alpha = 0.45
            return
        }
        composer.placeholder = "Type a message..."
        composer.isEnabled = true
        sendTextButtonbarBV.isEnabled = true
        composer.alpha = 1
        sendTextButtonbarBV.alpha = 1
    }

    private func configureTablebarBV() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = BaurbstyleStorebarBV.metricbarBV(72, minimumbarBV: 58, maximumbarBV: 86)
        tableView.keyboardDismissMode = .interactive
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(
            top: BaurbstyleStorebarBV.spacebarBV(6, minimumbarBV: 4, maximumbarBV: 8),
            left: 0,
            bottom: BaurbstyleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12),
            right: 0
        )
        tableView.register(messageDateSurfacebarBV.self, forCellReuseIdentifier: messageDateSurfacebarBV.reuseID)
        tableView.register(messageSurfacebarBV.self, forCellReuseIdentifier: messageSurfacebarBV.reuseID)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: composerBarbarBV.topAnchor)
        ])
        view.bringSubviewToFront(composerBarbarBV)
    }

    private func configureComposerbarBV() {
        composerBarbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.96)
        composerBarbarBV.layer.shadowColor = UIColor.black.cgColor
        composerBarbarBV.layer.shadowOpacity = 0.06
        composerBarbarBV.layer.shadowRadius = 10
        composerBarbarBV.layer.shadowOffset = CGSize(width: 0, height: -4)

        sendTextButtonbarBV.setTitle("Send", for: .normal)
        sendTextButtonbarBV.setTitleColor(.black, for: .normal)
        sendTextButtonbarBV.titleLabel?.font = BaurbstyleStorebarBV.fontbarBV(15, weight: .heavy)
        BaurbstyleStorebarBV.buttonFitbarBV(sendTextButtonbarBV)
        sendTextButtonbarBV.colorsbarBV = [BaurbstyleStorebarBV.mint, UIColor(red: 1, green: 215 / 255, blue: 251 / 255, alpha: 0.7), BaurbstyleStorebarBV.pink, BaurbstyleStorebarBV.mint]
        sendTextButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.sendTypedMessagebarBV()
        }, for: .touchUpInside)

        composer.placeholder = "Type a message..."
        composer.font = BaurbstyleStorebarBV.fontbarBV(16, weight: .regular)
        composer.textColor = .black
        composer.backgroundColor = UIColor.systemGray6
        let inputHeightbarBV = BaurbstyleStorebarBV.controlbarBV(46)
        composer.layer.cornerRadius = inputHeightbarBV / 2
        composer.leftView = UIView(frame: CGRect(x: 0, y: 0, width: BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 12, maximumbarBV: 18), height: 1))
        composer.leftViewMode = .always
        composer.rightView = UIView(frame: CGRect(x: 0, y: 0, width: BaurbstyleStorebarBV.metricbarBV(8, minimumbarBV: 6, maximumbarBV: 10), height: 1))
        composer.rightViewMode = .always
        composer.returnKeyType = .send
        composer.enablesReturnKeyAutomatically = true
        composer.addAction(UIAction { [weak self] _ in
            self?.sendTypedMessagebarBV()
        }, for: .primaryActionTriggered)

        view.addSubview(composerBarbarBV)
        [composer, sendTextButtonbarBV].forEach {
            composerBarbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        composerBarbarBV.translatesAutoresizingMaskIntoConstraints = false

        let composerHeightbarBV = BaurbstyleStorebarBV.metricbarBV(70, minimumbarBV: 62, maximumbarBV: 74)
        let sideInsetbarBV = BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 12, maximumbarBV: 18)
        let controlGapbarBV = BaurbstyleStorebarBV.metricbarBV(8, minimumbarBV: 6, maximumbarBV: 10)
        let sendWidthbarBV = BaurbstyleStorebarBV.metricbarBV(74, minimumbarBV: 66, maximumbarBV: 82)
        NSLayoutConstraint.activate([
            composerBarbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            composerBarbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            composerBarbarBV.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            composerBarbarBV.heightAnchor.constraint(equalToConstant: composerHeightbarBV),

            composer.leadingAnchor.constraint(equalTo: composerBarbarBV.leadingAnchor, constant: sideInsetbarBV),
            composer.trailingAnchor.constraint(equalTo: sendTextButtonbarBV.leadingAnchor, constant: -controlGapbarBV),
            composer.centerYAnchor.constraint(equalTo: composerBarbarBV.centerYAnchor),
            composer.heightAnchor.constraint(equalToConstant: inputHeightbarBV),

            sendTextButtonbarBV.trailingAnchor.constraint(equalTo: composerBarbarBV.trailingAnchor, constant: -sideInsetbarBV),
            sendTextButtonbarBV.centerYAnchor.constraint(equalTo: composerBarbarBV.centerYAnchor),
            sendTextButtonbarBV.widthAnchor.constraint(equalToConstant: sendWidthbarBV),
            sendTextButtonbarBV.heightAnchor.constraint(equalToConstant: inputHeightbarBV)
        ])
    }

    private func configureGroupInvitebarBV() {
        groupInviteButtonbarBV.setImage(UIImage(systemName: "person.2"), for: .normal)
        groupInviteButtonbarBV.tintColor = .black
        groupInviteButtonbarBV.backgroundColor = .clear
        groupInviteButtonbarBV.colorsbarBV = [
            UIColor(red: 210 / 255, green: 249 / 255, blue: 1, alpha: 1),
            UIColor(red: 1, green: 232 / 255, blue: 1, alpha: 1),
            UIColor(red: 161 / 255, green: 233 / 255, blue: 1, alpha: 1)
        ]
        groupInviteButtonbarBV.locationsbarBV = [0, 0.52, 1]
        groupInviteButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.openInviteGroupbarBV()
        }, for: .touchUpInside)
        groupInviteButtonbarBV.isHidden = !thread.smallGroupFlag
        view.addSubview(groupInviteButtonbarBV)
        groupInviteButtonbarBV.translatesAutoresizingMaskIntoConstraints = false
        let buttonSizebarBV = BaurbstyleStorebarBV.metricbarBV(62, minimumbarBV: 54, maximumbarBV: 66)
        NSLayoutConstraint.activate([
            groupInviteButtonbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(24, minimumbarBV: 18, maximumbarBV: 28)),
            groupInviteButtonbarBV.bottomAnchor.constraint(equalTo: composerBarbarBV.topAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(28, minimumbarBV: 18, maximumbarBV: 34)),
            groupInviteButtonbarBV.widthAnchor.constraint(equalToConstant: buttonSizebarBV),
            groupInviteButtonbarBV.heightAnchor.constraint(equalToConstant: buttonSizebarBV)
        ])
    }

    private func configureDismissbarBV() {
        let tapGesturebarBV = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardbarBV))
        tapGesturebarBV.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesturebarBV)
        let longPressbarBV = UILongPressGestureRecognizer(target: self, action: #selector(handleMessagePressbarBV(_:)))
        longPressbarBV.minimumPressDuration = 0.42
        tableView.addGestureRecognizer(longPressbarBV)
    }

    @objc private func dismissKeyboardbarBV() {
        view.endEditing(true)
    }

    @objc private func handleMessagePressbarBV(_ gesturebarBV: UILongPressGestureRecognizer) {
        guard gesturebarBV.state == .began else { return }
        let pointbarBV = gesturebarBV.location(in: tableView)
        guard let indexPathbarBV = tableView.indexPathForRow(at: pointbarBV), indexPathbarBV.row > 0 else { return }
        let messagebarBV = store.messagePool(for: thread)[indexPathbarBV.row - 1]
        let cellRectbarBV = tableView.rectForRow(at: indexPathbarBV)
        let convertedRectbarBV = tableView.convert(cellRectbarBV, to: view)
        view.endEditing(true)
        selectedMessagebarBV = messagebarBV
        presentActionMenubarBV(messagebarBV: messagebarBV, sourceRectbarBV: convertedRectbarBV)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        store.messagePool(for: thread).count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: messageDateSurfacebarBV.reuseID, for: indexPath) as! messageDateSurfacebarBV
            cell.configurebarBV(dateTextbarBV: dateTextbarBV())
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: messageSurfacebarBV.reuseID, for: indexPath) as! messageSurfacebarBV
        let messagebarBV = store.messagePool(for: thread)[indexPath.row - 1]
        cell.configurebarBV(messagebarBV: messagebarBV, storebarBV: store, groupFlagbarBV: thread.smallGroupFlag)
        return cell
    }

    private func sendTypedMessagebarBV() {
        if let contactbarBV = currentContactbarBV(), store.blockedFlagbarBV(contactSeedbarBV: contactbarBV.contactSeed) {
            presentNoticebarBV(titlebarBV: "Blocked", messagebarBV: "You blocked this user.")
            return
        }
        guard let textbarBV = composer.text?.trimmingCharacters(in: .whitespacesAndNewlines), !textbarBV.isEmpty else { return }
        composer.text = nil
        store.sendButton(textbarBV, in: thread)
        tableView.reloadData()
        scrollToBottombarBV(animated: true)
    }

    private func scrollToBottombarBV(animated: Bool) {
        let countbarBV = store.messagePool(for: thread).count
        guard countbarBV > 0 else { return }
        tableView.scrollToRow(at: IndexPath(row: countbarBV, section: 0), at: .bottom, animated: animated)
    }

    private func presentMoreMenubarBV(groupFlagbarBV: Bool = false) {
        dismissActionMenubarBV()
        dismissAIReplybarBV()
        dismissBlockAlertbarBV()
        view.endEditing(true)
        let containerbarBV: UIView = navigationController?.view ?? view
        let overlaybarBV = UIControl()
        overlaybarBV.backgroundColor = UIColor.black.withAlphaComponent(0.46)
        overlaybarBV.addAction(UIAction { [weak self] _ in
            self?.dismissMoreMenubarBV()
        }, for: .touchUpInside)
        containerbarBV.addSubview(overlaybarBV)
        overlaybarBV.translatesAutoresizingMaskIntoConstraints = false

        let menubarBV = moreMenuSurfacebarBV(groupFlagbarBV: groupFlagbarBV)
        menubarBV.onChoosebarBV = { [weak self] actionbarBV in
            self?.handleMoreActionbarBV(actionbarBV)
        }
        overlaybarBV.addSubview(menubarBV)
        menubarBV.translatesAutoresizingMaskIntoConstraints = false

        let sideInsetbarBV = BaurbstyleStorebarBV.metricbarBV(15, minimumbarBV: 14, maximumbarBV: 18)
        NSLayoutConstraint.activate([
            overlaybarBV.topAnchor.constraint(equalTo: containerbarBV.topAnchor),
            overlaybarBV.leadingAnchor.constraint(equalTo: containerbarBV.leadingAnchor),
            overlaybarBV.trailingAnchor.constraint(equalTo: containerbarBV.trailingAnchor),
            overlaybarBV.bottomAnchor.constraint(equalTo: containerbarBV.bottomAnchor),

            menubarBV.leadingAnchor.constraint(equalTo: overlaybarBV.leadingAnchor, constant: sideInsetbarBV),
            menubarBV.trailingAnchor.constraint(equalTo: overlaybarBV.trailingAnchor, constant: -sideInsetbarBV),
            menubarBV.bottomAnchor.constraint(equalTo: containerbarBV.safeAreaLayoutGuide.bottomAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(12, minimumbarBV: 10, maximumbarBV: 14))
        ])
        moreOverlaybarBV = overlaybarBV
    }

    private func presentGroupMoreMenubarBV() {
        presentMoreMenubarBV(groupFlagbarBV: true)
    }

    private func handleMoreActionbarBV(_ actionbarBV: moreActionbarBV) {
        switch actionbarBV {
        case .reportbarBV:
            dismissMoreMenubarBV()
            openReportPagebarBV()
        case .invitebarBV:
            dismissMoreMenubarBV()
            openInviteGroupbarBV()
        case .blockbarBV:
            dismissMoreMenubarBV()
            presentBlockAlertbarBV()
        case .cancelbarBV:
            dismissMoreMenubarBV()
        }
    }

    private func openReportPagebarBV() {
        if thread.smallGroupFlag {
            let reportbarBV = groupReportSurfacebarBV(
                storebarBV: store,
                threadbarBV: thread,
                messagebarBV: reportTargetMessagebarBV()
            )
            navigationController?.pushViewController(reportbarBV, animated: true)
            return
        }
        let reportbarBV = reportSurfacebarBV(
            storebarBV: store,
            threadbarBV: thread,
            contactbarBV: currentContactbarBV(),
            messagebarBV: reportTargetMessagebarBV()
        )
        navigationController?.pushViewController(reportbarBV, animated: true)
    }

    private func openInviteGroupbarBV() {
        guard thread.smallGroupFlag else { return }
        let invitebarBV = inviteGroupSurfacebarBV(storebarBV: store, threadbarBV: thread)
        navigationController?.pushViewController(invitebarBV, animated: true)
    }

    private func presentBlockAlertbarBV() {
        guard let contactbarBV = currentContactbarBV() else {
            presentNoticebarBV(titlebarBV: "Block User", messagebarBV: "This conversation has no single user to block.")
            return
        }
        let overlaybarBV = UIControl()
        overlaybarBV.backgroundColor = UIColor.black.withAlphaComponent(0.36)
        overlaybarBV.addAction(UIAction { [weak self] _ in
            self?.dismissBlockAlertbarBV()
        }, for: .touchUpInside)
        view.addSubview(overlaybarBV)
        overlaybarBV.translatesAutoresizingMaskIntoConstraints = false

        let alertbarBV = blockUserAlertSurfacebarBV(contactbarBV: contactbarBV)
        alertbarBV.onCancelbarBV = { [weak self] in
            self?.dismissBlockAlertbarBV()
        }
        alertbarBV.onBlockbarBV = { [weak self] in
            guard let self else { return }
            self.store.blockUserbarBV(contactbarBV: contactbarBV)
            self.dismissBlockAlertbarBV()
            self.navigationController?.popViewController(animated: true)
        }
        overlaybarBV.addSubview(alertbarBV)
        alertbarBV.translatesAutoresizingMaskIntoConstraints = false

        let sideInsetbarBV = BaurbstyleStorebarBV.metricbarBV(24, minimumbarBV: 18, maximumbarBV: 28)
        NSLayoutConstraint.activate([
            overlaybarBV.topAnchor.constraint(equalTo: view.topAnchor),
            overlaybarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlaybarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlaybarBV.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            alertbarBV.centerXAnchor.constraint(equalTo: overlaybarBV.centerXAnchor),
            alertbarBV.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            alertbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: overlaybarBV.leadingAnchor, constant: sideInsetbarBV),
            alertbarBV.trailingAnchor.constraint(lessThanOrEqualTo: overlaybarBV.trailingAnchor, constant: -sideInsetbarBV),
            alertbarBV.widthAnchor.constraint(lessThanOrEqualToConstant: BaurbstyleStorebarBV.metricbarBV(360, minimumbarBV: 300, maximumbarBV: 380))
        ])
        blockOverlaybarBV = overlaybarBV
    }

    private func dismissMoreMenubarBV() {
        moreOverlaybarBV?.removeFromSuperview()
        moreOverlaybarBV = nil
    }

    private func dismissBlockAlertbarBV() {
        blockOverlaybarBV?.removeFromSuperview()
        blockOverlaybarBV = nil
    }

    private func presentCoinShortagebarBV() {
        dismissCoinShortagebarBV()
        let overlaybarBV = UIControl()
        overlaybarBV.backgroundColor = UIColor.black.withAlphaComponent(0.36)
        overlaybarBV.addAction(UIAction { [weak self] _ in
            self?.dismissCoinShortagebarBV()
        }, for: .touchUpInside)
        view.addSubview(overlaybarBV)
        overlaybarBV.translatesAutoresizingMaskIntoConstraints = false

        let alertbarBV = coinShortageAlertSurfacebarBV()
        alertbarBV.onCancelbarBV = { [weak self] in
            self?.dismissCoinShortagebarBV()
        }
        alertbarBV.onBuybarBV = { [weak self] in
            guard let self else { return }
            self.dismissCoinShortagebarBV()
            self.dismissAIReplybarBV()
            let topUpbarBV = topUpSurfacebarBV(storebarBV: self.store)
            topUpbarBV.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(topUpbarBV, animated: true)
        }
        overlaybarBV.addSubview(alertbarBV)
        alertbarBV.translatesAutoresizingMaskIntoConstraints = false

        let sideInsetbarBV = BaurbstyleStorebarBV.metricbarBV(20, minimumbarBV: 16, maximumbarBV: 24)
        NSLayoutConstraint.activate([
            overlaybarBV.topAnchor.constraint(equalTo: view.topAnchor),
            overlaybarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlaybarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlaybarBV.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            alertbarBV.centerXAnchor.constraint(equalTo: overlaybarBV.centerXAnchor),
            alertbarBV.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            alertbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: overlaybarBV.leadingAnchor, constant: sideInsetbarBV),
            alertbarBV.trailingAnchor.constraint(lessThanOrEqualTo: overlaybarBV.trailingAnchor, constant: -sideInsetbarBV),
            alertbarBV.widthAnchor.constraint(lessThanOrEqualToConstant: BaurbstyleStorebarBV.metricbarBV(360, minimumbarBV: 300, maximumbarBV: 380))
        ])
        coinOverlaybarBV = overlaybarBV
    }

    private func dismissCoinShortagebarBV() {
        coinOverlaybarBV?.removeFromSuperview()
        coinOverlaybarBV = nil
    }

    private func showAITonesbarBV() {
        let tonesbarBV = aiTonesSurfacebarBV(storebarBV: store)
        tonesbarBV.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(tonesbarBV, animated: true)
    }

    private func currentContactbarBV() -> trustedContact? {
        guard !thread.smallGroupFlag, let contactSeedbarBV = thread.personaPoolbarBV.first else { return nil }
        return store.contactMatcherbarBV(contactSeed: contactSeedbarBV)
    }

    private func reportTargetMessagebarBV() -> messageFixturebarBV? {
        let messagesbarBV = store.messagePool(for: thread)
        if let incomingTextbarBV = messagesbarBV.last(where: { !$0.sentFlag }) {
            return incomingTextbarBV
        }
        return messagesbarBV.last
    }

    private func presentActionMenubarBV(messagebarBV: messageFixturebarBV, sourceRectbarBV: CGRect) {
        dismissActionMenubarBV()
        let overlaybarBV = UIControl()
        overlaybarBV.backgroundColor = UIColor.black.withAlphaComponent(0.34)
        overlaybarBV.addAction(UIAction { [weak self] _ in
            self?.dismissActionMenubarBV()
        }, for: .touchUpInside)
        let overlayPanbarBV = UIPanGestureRecognizer(target: self, action: #selector(handleActionOverlayPanbarBV(_:)))
        overlaybarBV.addGestureRecognizer(overlayPanbarBV)
        view.addSubview(overlaybarBV)
        overlaybarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlaybarBV.topAnchor.constraint(equalTo: view.topAnchor),
            overlaybarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlaybarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlaybarBV.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let menubarBV = messageMenuSurfacebarBV(
            previewTextbarBV: actionPreviewTextbarBV(messagebarBV: messagebarBV),
            copyEnabledbarBV: copyEnabledbarBV(messagebarBV: messagebarBV)
        )
        menubarBV.onChoosebarBV = { [weak self] actionbarBV in
            self?.handleActionMenubarBV(actionbarBV, messagebarBV: messagebarBV)
        }
        overlaybarBV.addSubview(menubarBV)
        menubarBV.translatesAutoresizingMaskIntoConstraints = false

        view.layoutIfNeeded()
        let safeFramebarBV = view.safeAreaLayoutGuide.layoutFrame
        let menuWidthbarBV = BaurbstyleStorebarBV.metricbarBV(300, minimumbarBV: 252, maximumbarBV: 320)
        let menuHeightbarBV = BaurbstyleStorebarBV.metricbarBV(250, minimumbarBV: 224, maximumbarBV: 268)
        let sideInsetbarBV = BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 12, maximumbarBV: 18)
        let targetXbarBV = messagebarBV.sentFlag ? view.bounds.width - menuWidthbarBV - sideInsetbarBV : sideInsetbarBV
        let targetYbarBV = sourceRectbarBV.midY - menuHeightbarBV / 2
        let maxXbarBV = max(sideInsetbarBV, view.bounds.width - menuWidthbarBV - sideInsetbarBV)
        let maxYbarBV = max(safeFramebarBV.minY + sideInsetbarBV, safeFramebarBV.maxY - menuHeightbarBV - sideInsetbarBV)
        let clampedXbarBV = min(max(targetXbarBV, sideInsetbarBV), maxXbarBV)
        let clampedYbarBV = min(max(targetYbarBV, safeFramebarBV.minY + sideInsetbarBV), maxYbarBV)
        NSLayoutConstraint.activate([
            menubarBV.leadingAnchor.constraint(equalTo: overlaybarBV.leadingAnchor, constant: clampedXbarBV),
            menubarBV.topAnchor.constraint(equalTo: overlaybarBV.topAnchor, constant: clampedYbarBV),
            menubarBV.widthAnchor.constraint(equalToConstant: menuWidthbarBV),
            menubarBV.heightAnchor.constraint(equalToConstant: menuHeightbarBV)
        ])
        actionOverlaybarBV = overlaybarBV
    }

    @objc private func handleActionOverlayPanbarBV(_ gesturebarBV: UIPanGestureRecognizer) {
        guard gesturebarBV.state == .began else { return }
        dismissActionMenubarBV()
    }

    private func handleActionMenubarBV(_ actionbarBV: messageActionbarBV, messagebarBV: messageFixturebarBV) {
        dismissActionMenubarBV()
        switch actionbarBV {
        case .aiReplybarBV:
            guard copyEnabledbarBV(messagebarBV: messagebarBV) else {
                presentNoticebarBV(titlebarBV: "AI Reply", messagebarBV: "AI Reply only supports text messages.")
                return
            }
            presentAIReplybarBV(messagebarBV: messagebarBV)
        case .regeneratebarBV:
            guard copyEnabledbarBV(messagebarBV: messagebarBV) else {
                presentNoticebarBV(titlebarBV: "Regenerate", messagebarBV: "Regenerate only supports text messages.")
                return
            }
            guard spendRegenerateCoinsbarBV() else { return }
            presentAIReplybarBV(messagebarBV: messagebarBV, startRegeneratedbarBV: true)
        case .copybarBV:
            guard copyEnabledbarBV(messagebarBV: messagebarBV) else {
                presentNoticebarBV(titlebarBV: "Copy", messagebarBV: "Only text messages can be copied.")
                return
            }
            UIPasteboard.general.string = messagebarBV.messageCopybarBV
            presentNoticebarBV(titlebarBV: "Copied", messagebarBV: "Message text copied.")
        }
    }

    private func spendRegenerateCoinsbarBV() -> Bool {
        guard store.spendCoinsbarBV(amountbarBV: 100, typebarBV: "aiReplyRegeneratebarBV") else {
            presentCoinShortagebarBV()
            return false
        }
        return true
    }

    private func presentAIReplybarBV(messagebarBV: messageFixturebarBV, startRegeneratedbarBV: Bool = false) {
        dismissAIReplybarBV()
        view.endEditing(true)

        let overlaybarBV = UIView()
        overlaybarBV.backgroundColor = UIColor.black.withAlphaComponent(0.36)
        overlaybarBV.isUserInteractionEnabled = true
        let tapbarBV = UITapGestureRecognizer(target: self, action: #selector(handleAIReplyBackgroundTapbarBV(_:)))
        tapbarBV.cancelsTouchesInView = false
        overlaybarBV.addGestureRecognizer(tapbarBV)
        view.addSubview(overlaybarBV)
        overlaybarBV.translatesAutoresizingMaskIntoConstraints = false

        let scrollbarBV = UIScrollView()
        scrollbarBV.backgroundColor = .clear
        scrollbarBV.showsVerticalScrollIndicator = false
        scrollbarBV.keyboardDismissMode = .interactive
        let contentbarBV = UIView()
        let surfacebarBV = aiReplyDraftSurfacebarBV(
            messagebarBV: messagebarBV,
            replyNamebarBV: replyNamebarBV(messagebarBV: messagebarBV),
            replyTimebarBV: replyTimebarBV(datebarBV: messagebarBV.messageMomentbarBV),
            initialTonebarBV: store.selectedReplyTonebarBV,
            startRegeneratedbarBV: startRegeneratedbarBV
        )
        surfacebarBV.onRegenerateSpendbarBV = { [weak self] in
            self?.spendRegenerateCoinsbarBV() ?? false
        }
        surfacebarBV.onToneEntrybarBV = { [weak self] in
            guard let self else { return }
            self.dismissAIReplybarBV()
            self.showAITonesbarBV()
        }
        surfacebarBV.onSendbarBV = { [weak self] textbarBV in
            guard let self else { return }
            self.store.sendButton(textbarBV, in: self.thread)
            self.dismissAIReplybarBV()
            self.tableView.reloadData()
            self.scrollToBottombarBV(animated: true)
        }
        surfacebarBV.onNoticebarBV = { [weak self] messagebarBV in
            self?.presentNoticebarBV(titlebarBV: "AI Reply", messagebarBV: messagebarBV)
        }

        overlaybarBV.addSubview(scrollbarBV)
        scrollbarBV.addSubview(contentbarBV)
        contentbarBV.addSubview(surfacebarBV)
        [scrollbarBV, contentbarBV, surfacebarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        let sideInsetbarBV = BaurbstyleStorebarBV.metricbarBV(15, minimumbarBV: 12, maximumbarBV: 18)
        let widthLockbarBV = surfacebarBV.widthAnchor.constraint(equalTo: contentbarBV.widthAnchor, constant: -sideInsetbarBV * 2)
        widthLockbarBV.priority = .defaultHigh
        let centerLockbarBV = surfacebarBV.centerYAnchor.constraint(equalTo: contentbarBV.centerYAnchor)
        centerLockbarBV.priority = .defaultHigh

        NSLayoutConstraint.activate([
            overlaybarBV.topAnchor.constraint(equalTo: view.topAnchor),
            overlaybarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlaybarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlaybarBV.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            scrollbarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10)),
            scrollbarBV.leadingAnchor.constraint(equalTo: overlaybarBV.leadingAnchor),
            scrollbarBV.trailingAnchor.constraint(equalTo: overlaybarBV.trailingAnchor),
            scrollbarBV.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10)),

            contentbarBV.topAnchor.constraint(equalTo: scrollbarBV.contentLayoutGuide.topAnchor),
            contentbarBV.leadingAnchor.constraint(equalTo: scrollbarBV.contentLayoutGuide.leadingAnchor),
            contentbarBV.trailingAnchor.constraint(equalTo: scrollbarBV.contentLayoutGuide.trailingAnchor),
            contentbarBV.bottomAnchor.constraint(equalTo: scrollbarBV.contentLayoutGuide.bottomAnchor),
            contentbarBV.widthAnchor.constraint(equalTo: scrollbarBV.frameLayoutGuide.widthAnchor),
            contentbarBV.heightAnchor.constraint(greaterThanOrEqualTo: scrollbarBV.frameLayoutGuide.heightAnchor),

            surfacebarBV.centerXAnchor.constraint(equalTo: contentbarBV.centerXAnchor),
            centerLockbarBV,
            surfacebarBV.topAnchor.constraint(greaterThanOrEqualTo: contentbarBV.topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            surfacebarBV.bottomAnchor.constraint(lessThanOrEqualTo: contentbarBV.bottomAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            surfacebarBV.widthAnchor.constraint(lessThanOrEqualToConstant: BaurbstyleStorebarBV.metricbarBV(540, minimumbarBV: 330, maximumbarBV: 560)),
            widthLockbarBV
        ])

        aiReplyOverlaybarBV = overlaybarBV
        aiReplySurfacebarBV = surfacebarBV
    }

    @objc private func handleAIReplyBackgroundTapbarBV(_ gesturebarBV: UITapGestureRecognizer) {
        guard gesturebarBV.state == .ended else { return }
        if let surfacebarBV = aiReplySurfacebarBV {
            let pointbarBV = gesturebarBV.location(in: surfacebarBV)
            if surfacebarBV.bounds.contains(pointbarBV) {
                return
            }
        }
        dismissAIReplybarBV()
    }

    private func dismissAIReplybarBV() {
        aiReplySurfacebarBV?.endEditing(true)
        aiReplyOverlaybarBV?.removeFromSuperview()
        aiReplyOverlaybarBV = nil
        aiReplySurfacebarBV = nil
    }

    private func replyNamebarBV(messagebarBV: messageFixturebarBV) -> String {
        if messagebarBV.sentFlag {
            return "YOU"
        }
        if let contactbarBV = store.contactMatcherbarBV(contactSeed: messagebarBV.personaSeed) {
            return contactbarBV.placeholderNamebarBV.uppercased()
        }
        return thread.threadTitlebarBV.uppercased()
    }

    private func replyTimebarBV(datebarBV: Date) -> String {
        let formatterbarBV = DateFormatter()
        formatterbarBV.locale = Locale(identifier: "en_US_POSIX")
        formatterbarBV.dateFormat = "HH:mm"
        return formatterbarBV.string(from: datebarBV)
    }

    private func copyEnabledbarBV(messagebarBV: messageFixturebarBV) -> Bool {
        true
    }

    private func actionPreviewTextbarBV(messagebarBV: messageFixturebarBV) -> String {
        messagebarBV.messageCopybarBV
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissActionMenubarBV()
    }

    private func dismissActionMenubarBV() {
        actionOverlaybarBV?.removeFromSuperview()
        actionOverlaybarBV = nil
        selectedMessagebarBV = nil
    }

    private func presentNoticebarBV(titlebarBV: String, messagebarBV: String) {
        let alertbarBV = UIAlertController(title: titlebarBV, message: messagebarBV, preferredStyle: .alert)
        alertbarBV.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertbarBV, animated: true)
    }

    private func dateTextbarBV() -> String {
        let messagebarBV = store.messagePool(for: thread).first
        let formatterbarBV = DateFormatter()
        formatterbarBV.locale = Locale(identifier: "en_US_POSIX")
        formatterbarBV.dateFormat = "EEEE, MMM d"
        return formatterbarBV.string(from: messagebarBV?.messageMomentbarBV ?? Date())
    }
}

final class messageDateSurfacebarBV: UITableViewCell {
    static let reuseID = "messageDateSurfacebarBV"
    private let pillLabelbarBV = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(pillLabelbarBV)
        pillLabelbarBV.translatesAutoresizingMaskIntoConstraints = false
        pillLabelbarBV.font = BaurbstyleStorebarBV.fontbarBV(13, weight: .semibold)
        pillLabelbarBV.textColor = BaurbstyleStorebarBV.mutedText
        pillLabelbarBV.textAlignment = .center
        pillLabelbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.78)
        pillLabelbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(14, minimumbarBV: 12, maximumbarBV: 15)
        pillLabelbarBV.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            pillLabelbarBV.topAnchor.constraint(equalTo: contentView.topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10)),
            pillLabelbarBV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            pillLabelbarBV.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pillLabelbarBV.heightAnchor.constraint(greaterThanOrEqualToConstant: BaurbstyleStorebarBV.metricbarBV(28, minimumbarBV: 24, maximumbarBV: 30)),
            pillLabelbarBV.widthAnchor.constraint(greaterThanOrEqualToConstant: BaurbstyleStorebarBV.metricbarBV(132, minimumbarBV: 112, maximumbarBV: 148))
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configurebarBV(dateTextbarBV: String) {
        pillLabelbarBV.text = "  \(dateTextbarBV)  "
    }
}

enum moreActionbarBV {
    case reportbarBV
    case invitebarBV
    case blockbarBV
    case cancelbarBV
}

final class moreMenuSurfacebarBV: UIView {
    var onChoosebarBV: ((moreActionbarBV) -> Void)?
    private let stackbarBV = UIStackView()
    private let groupFlagbarBV: Bool

    init(groupFlagbarBV: Bool = false) {
        self.groupFlagbarBV = groupFlagbarBV
        super.init(frame: .zero)
        configurebarBV()
    }

    override init(frame: CGRect) {
        self.groupFlagbarBV = false
        super.init(frame: frame)
        configurebarBV()
    }

    required init?(coder: NSCoder) {
        self.groupFlagbarBV = false
        super.init(coder: coder)
        configurebarBV()
    }

    private func configurebarBV() {
        backgroundColor = .clear
        stackbarBV.axis = .vertical
        stackbarBV.spacing = BaurbstyleStorebarBV.spacebarBV(12, minimumbarBV: 11, maximumbarBV: 14)
        addSubview(stackbarBV)
        stackbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackbarBV.topAnchor.constraint(equalTo: topAnchor),
            stackbarBV.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackbarBV.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackbarBV.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        if groupFlagbarBV {
            stackbarBV.addArrangedSubview(buttonbarBV(titlebarBV: "Report Message", actionbarBV: .reportbarBV, gradientbarBV: false))
            stackbarBV.addArrangedSubview(buttonbarBV(titlebarBV: "Invite Contacts", actionbarBV: .invitebarBV, gradientbarBV: false))
        } else {
            stackbarBV.addArrangedSubview(buttonbarBV(titlebarBV: "Report", actionbarBV: .reportbarBV, gradientbarBV: false))
            stackbarBV.addArrangedSubview(buttonbarBV(titlebarBV: "Block User", actionbarBV: .blockbarBV, gradientbarBV: false))
        }
        stackbarBV.addArrangedSubview(buttonbarBV(titlebarBV: "Cancel", actionbarBV: .cancelbarBV, gradientbarBV: true))
    }

    private func buttonbarBV(titlebarBV: String, actionbarBV: moreActionbarBV, gradientbarBV: Bool) -> UIButton {
        let buttonbarBV: UIButton = gradientbarBV ? gradientPill(type: .system) : UIButton(type: .system)
        buttonbarBV.setTitle(titlebarBV, for: .normal)
        buttonbarBV.setTitleColor(.black, for: .normal)
        buttonbarBV.titleLabel?.font = BaurbstyleStorebarBV.fontbarBV(18, weight: .heavy)
        buttonbarBV.backgroundColor = gradientbarBV ? .clear : UIColor.white.withAlphaComponent(0.98)
        let heightbarBV = BaurbstyleStorebarBV.controlbarBV(56)
        buttonbarBV.layer.cornerRadius = heightbarBV / 2
        buttonbarBV.layer.masksToBounds = false
        buttonbarBV.layer.shadowColor = UIColor.black.cgColor
        buttonbarBV.layer.shadowOpacity = gradientbarBV ? 0.14 : 0.04
        buttonbarBV.layer.shadowRadius = gradientbarBV ? 12 : 5
        buttonbarBV.layer.shadowOffset = CGSize(width: 0, height: gradientbarBV ? 6 : 2)
        if let pillbarBV = buttonbarBV as? gradientPill {
            pillbarBV.cornerRadiusbarBV = heightbarBV / 2
            pillbarBV.colorsbarBV = BaurbstyleStorebarBV.cardStripColorsbarBV
            pillbarBV.locationsbarBV = BaurbstyleStorebarBV.cardStripLocationsbarBV
        }
        buttonbarBV.addAction(UIAction { [weak self] _ in
            self?.onChoosebarBV?(actionbarBV)
        }, for: .touchUpInside)
        BaurbstyleStorebarBV.buttonFitbarBV(buttonbarBV)
        buttonbarBV.heightAnchor.constraint(equalToConstant: heightbarBV).isActive = true
        return buttonbarBV
    }
}

final class blockUserAlertSurfacebarBV: UIView {
    var onCancelbarBV: (() -> Void)?
    var onBlockbarBV: (() -> Void)?
    private let contactbarBV: trustedContact

    init(contactbarBV: trustedContact) {
        self.contactbarBV = contactbarBV
        super.init(frame: .zero)
        configurebarBV()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configurebarBV() {
        backgroundColor = .white
        layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(24, minimumbarBV: 20, maximumbarBV: 26)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.18
        layer.shadowRadius = 18
        layer.shadowOffset = CGSize(width: 0, height: 8)

        let avatarbarBV = avatarSurfacebarBV(initial: contactbarBV.placeholderAvatar, color: BaurbstyleStorebarBV.pink)
        let titlebarBV = UILabel()
        titlebarBV.text = "Block \(contactbarBV.placeholderNamebarBV)?"
        titlebarBV.font = BaurbstyleStorebarBV.fontbarBV(22, weight: .heavy)
        titlebarBV.textColor = .black
        titlebarBV.textAlignment = .center
        titlebarBV.numberOfLines = 2
        BaurbstyleStorebarBV.labelFitbarBV(titlebarBV, factorbarBV: 0.68, linesbarBV: 2)

        let bodybarBV = UILabel()
        bodybarBV.text = "They won't be able to message you, see your profile, or add you again. You can unblock anytime in Privacy -> Blocked List."
        bodybarBV.font = BaurbstyleStorebarBV.fontbarBV(14, weight: .regular)
        bodybarBV.textColor = BaurbstyleStorebarBV.mutedText
        bodybarBV.textAlignment = .center
        bodybarBV.numberOfLines = 0

        let cancelbarBV = UIButton(type: .system)
        cancelbarBV.setTitle("Cancel", for: .normal)
        cancelbarBV.setTitleColor(UIColor(red: 37 / 255, green: 15 / 255, blue: 73 / 255, alpha: 1), for: .normal)
        cancelbarBV.titleLabel?.font = BaurbstyleStorebarBV.fontbarBV(16, weight: .heavy)
        cancelbarBV.backgroundColor = UIColor.systemGray6
        cancelbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 13, maximumbarBV: 18)
        cancelbarBV.addAction(UIAction { [weak self] _ in
            self?.onCancelbarBV?()
        }, for: .touchUpInside)

        let blockbarBV = gradientPill(type: .system)
        blockbarBV.setTitle("Block", for: .normal)
        blockbarBV.setTitleColor(.black, for: .normal)
        blockbarBV.titleLabel?.font = BaurbstyleStorebarBV.fontbarBV(16, weight: .heavy)
        blockbarBV.addAction(UIAction { [weak self] _ in
            self?.onBlockbarBV?()
        }, for: .touchUpInside)

        let actionsbarBV = UIStackView(arrangedSubviews: [cancelbarBV, blockbarBV])
        actionsbarBV.axis = .horizontal
        actionsbarBV.spacing = BaurbstyleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 12)
        actionsbarBV.distribution = .fillEqually

        let stackbarBV = UIStackView(arrangedSubviews: [avatarbarBV, titlebarBV, bodybarBV, actionsbarBV])
        stackbarBV.axis = .vertical
        stackbarBV.alignment = .center
        stackbarBV.spacing = BaurbstyleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 16)
        addSubview(stackbarBV)
        stackbarBV.translatesAutoresizingMaskIntoConstraints = false
        avatarbarBV.translatesAutoresizingMaskIntoConstraints = false
        actionsbarBV.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackbarBV.topAnchor.constraint(equalTo: topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(22, minimumbarBV: 18, maximumbarBV: 24)),
            stackbarBV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 22)),
            stackbarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 22)),
            stackbarBV.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(18, minimumbarBV: 14, maximumbarBV: 22)),
            avatarbarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(62, minimumbarBV: 52, maximumbarBV: 68)),
            avatarbarBV.heightAnchor.constraint(equalTo: avatarbarBV.widthAnchor),
            titlebarBV.widthAnchor.constraint(equalTo: stackbarBV.widthAnchor),
            bodybarBV.widthAnchor.constraint(equalTo: stackbarBV.widthAnchor),
            actionsbarBV.widthAnchor.constraint(equalTo: stackbarBV.widthAnchor),
            actionsbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(50))
        ])
    }
}

final class coinShortageAlertSurfacebarBV: UIView {
    var onCancelbarBV: (() -> Void)?
    var onBuybarBV: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configurebarBV()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configurebarBV()
    }

    private func configurebarBV() {
        backgroundColor = .white
        layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(26, minimumbarBV: 22, maximumbarBV: 28)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.18
        layer.shadowRadius = 18
        layer.shadowOffset = CGSize(width: 0, height: 8)

        let titlebarBV = UILabel()
        titlebarBV.text = "Not enough coins"
        titlebarBV.font = BaurbstyleStorebarBV.fontbarBV(24, weight: .heavy)
        titlebarBV.textColor = .black
        titlebarBV.textAlignment = .center
        BaurbstyleStorebarBV.labelFitbarBV(titlebarBV, factorbarBV: 0.62, linesbarBV: 1)

        let messagebarBV = UILabel()
        messagebarBV.text = "Sorry, you don't have enough coins to pay, please go to recharge"
        messagebarBV.font = BaurbstyleStorebarBV.fontbarBV(17, weight: .regular)
        messagebarBV.textColor = BaurbstyleStorebarBV.mutedText
        messagebarBV.textAlignment = .center
        messagebarBV.numberOfLines = 0
        BaurbstyleStorebarBV.labelFitbarBV(messagebarBV, factorbarBV: 0.72, linesbarBV: 0)

        let cancelbarBV = UIButton(type: .system)
        cancelbarBV.setTitle("Cancel", for: .normal)
        cancelbarBV.setTitleColor(.black, for: .normal)
        cancelbarBV.titleLabel?.font = BaurbstyleStorebarBV.fontbarBV(18, weight: .heavy)
        cancelbarBV.backgroundColor = UIColor.systemGray6
        cancelbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 14, maximumbarBV: 18)
        cancelbarBV.layer.masksToBounds = true
        cancelbarBV.addAction(UIAction { [weak self] _ in
            self?.onCancelbarBV?()
        }, for: .touchUpInside)

        let buybarBV = gradientPill(type: .system)
        buybarBV.setTitle("🟡 Buy", for: .normal)
        buybarBV.setTitleColor(.black, for: .normal)
        buybarBV.titleLabel?.font = BaurbstyleStorebarBV.fontbarBV(18, weight: .heavy)
        buybarBV.colorsbarBV = [BaurbstyleStorebarBV.mint, UIColor(red: 1, green: 215 / 255, blue: 251 / 255, alpha: 0.58), BaurbstyleStorebarBV.pink, BaurbstyleStorebarBV.mint]
        buybarBV.addAction(UIAction { [weak self] _ in
            self?.onBuybarBV?()
        }, for: .touchUpInside)

        let actionsbarBV = UIStackView(arrangedSubviews: [cancelbarBV, buybarBV])
        actionsbarBV.axis = .horizontal
        actionsbarBV.distribution = .fillEqually
        actionsbarBV.spacing = BaurbstyleStorebarBV.metricbarBV(12, minimumbarBV: 9, maximumbarBV: 14)

        let stackbarBV = UIStackView(arrangedSubviews: [titlebarBV, messagebarBV, actionsbarBV])
        stackbarBV.axis = .vertical
        stackbarBV.alignment = .fill
        stackbarBV.spacing = BaurbstyleStorebarBV.spacebarBV(20, minimumbarBV: 16, maximumbarBV: 24)
        addSubview(stackbarBV)
        stackbarBV.translatesAutoresizingMaskIntoConstraints = false
        actionsbarBV.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackbarBV.topAnchor.constraint(equalTo: topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(30, minimumbarBV: 24, maximumbarBV: 34)),
            stackbarBV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(26, minimumbarBV: 20, maximumbarBV: 30)),
            stackbarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(26, minimumbarBV: 20, maximumbarBV: 30)),
            stackbarBV.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(24, minimumbarBV: 20, maximumbarBV: 28)),
            actionsbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(54))
        ])
    }
}

final class reportSurfacebarBV: barbCanvasbarBV, UITextViewDelegate {
    private let storebarBV: barbVaultbarBV
    private let threadbarBV: threadFixturebarBV
    private let contactbarBV: trustedContact?
    private let messagebarBV: messageFixturebarBV?
    private let scrollSurfacebarBV = UIScrollView()
    private let stackSurfacebarBV = UIStackView()
    private let detailEntrybarBV = UITextView()
    private let detailPlaceholderbarBV = UILabel()
    private var reasonRowsbarBV: [reportReasonRowbarBV] = []
    private var selectedReasonbarBV: reportReasonbarBV? = .somethingElsebarBV

    init(storebarBV: barbVaultbarBV, threadbarBV: threadFixturebarBV, contactbarBV: trustedContact?, messagebarBV: messageFixturebarBV?) {
        self.storebarBV = storebarBV
        self.threadbarBV = threadbarBV
        self.contactbarBV = contactbarBV
        self.messagebarBV = messagebarBV
        super.init(nibName: nil, bundle: nil)
        title = "Report"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderbarBV()
        configureLayoutbarBV()
    }

    private func configureHeaderbarBV() {
        navigationItem.hidesBackButton = true
        let backbarBV = UIButton(type: .system)
        backbarBV.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backbarBV.tintColor = .black
        backbarBV.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)
        NSLayoutConstraint.activate([
            backbarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(44)),
            backbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(44))
        ])
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbarBV)
    }

    private func configureLayoutbarBV() {
        scrollSurfacebarBV.keyboardDismissMode = .interactive
        scrollSurfacebarBV.showsVerticalScrollIndicator = false
        view.addSubview(scrollSurfacebarBV)
        scrollSurfacebarBV.addSubview(stackSurfacebarBV)
        scrollSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false
        stackSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false

        stackSurfacebarBV.axis = .vertical
        stackSurfacebarBV.spacing = BaurbstyleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 16)

        let titlebarBV = UILabel()
        titlebarBV.text = "What's the issue?"
        titlebarBV.font = BaurbstyleStorebarBV.fontbarBV(31, weight: .heavy)
        titlebarBV.textColor = .black
        titlebarBV.numberOfLines = 2
        BaurbstyleStorebarBV.labelFitbarBV(titlebarBV, factorbarBV: 0.66, linesbarBV: 2)

        let subtitlebarBV = UILabel()
        subtitlebarBV.text = "Your report stays anonymous. We review every one."
        subtitlebarBV.font = BaurbstyleStorebarBV.fontbarBV(15, weight: .regular)
        subtitlebarBV.textColor = UIColor.darkGray
        subtitlebarBV.numberOfLines = 2

        [titlebarBV, subtitlebarBV, targetCardbarBV(), reasonCardbarBV(), detailCardbarBV(), submitButtonbarBV()].forEach {
            stackSurfacebarBV.addArrangedSubview($0)
        }

        let sideInsetbarBV = BaurbstyleStorebarBV.metricbarBV(20, minimumbarBV: 16, maximumbarBV: 22)
        NSLayoutConstraint.activate([
            scrollSurfacebarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollSurfacebarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollSurfacebarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollSurfacebarBV.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),

            stackSurfacebarBV.topAnchor.constraint(equalTo: scrollSurfacebarBV.contentLayoutGuide.topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(22, minimumbarBV: 16, maximumbarBV: 24)),
            stackSurfacebarBV.leadingAnchor.constraint(equalTo: scrollSurfacebarBV.contentLayoutGuide.leadingAnchor, constant: sideInsetbarBV),
            stackSurfacebarBV.trailingAnchor.constraint(equalTo: scrollSurfacebarBV.contentLayoutGuide.trailingAnchor, constant: -sideInsetbarBV),
            stackSurfacebarBV.bottomAnchor.constraint(equalTo: scrollSurfacebarBV.contentLayoutGuide.bottomAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(24, minimumbarBV: 16, maximumbarBV: 28)),
            stackSurfacebarBV.widthAnchor.constraint(equalTo: scrollSurfacebarBV.frameLayoutGuide.widthAnchor, constant: -sideInsetbarBV * 2)
        ])
    }

    private func targetCardbarBV() -> UIView {
        let cardbarBV = UIView()
        cardbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.96)
        cardbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(14, minimumbarBV: 12, maximumbarBV: 16)
        cardbarBV.layer.masksToBounds = true
        let linebarBV = UIView()
        linebarBV.backgroundColor = BaurbstyleStorebarBV.blue
        let metabarBV = UILabel()
        metabarBV.text = "\(targetLabelbarBV()) · \(targetTimebarBV())"
        metabarBV.font = BaurbstyleStorebarBV.fontbarBV(13, weight: .heavy)
        metabarBV.textColor = BaurbstyleStorebarBV.blue
        metabarBV.numberOfLines = 1
        BaurbstyleStorebarBV.labelFitbarBV(metabarBV, factorbarBV: 0.68, linesbarBV: 1)
        let contentbarBV = UILabel()
        contentbarBV.text = "\"\(messagebarBV?.messageCopybarBV ?? "Report this conversation.")\""
        contentbarBV.font = BaurbstyleStorebarBV.fontbarBV(16, weight: .regular)
        contentbarBV.textColor = .black
        contentbarBV.numberOfLines = 3
        [linebarBV, metabarBV, contentbarBV].forEach {
            cardbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            linebarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor),
            linebarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor),
            linebarBV.bottomAnchor.constraint(equalTo: cardbarBV.bottomAnchor),
            linebarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(3, minimumbarBV: 2, maximumbarBV: 3)),
            metabarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(16, minimumbarBV: 12, maximumbarBV: 18)),
            metabarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            metabarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            contentbarBV.topAnchor.constraint(equalTo: metabarBV.bottomAnchor, constant: BaurbstyleStorebarBV.spacebarBV(10, minimumbarBV: 7, maximumbarBV: 12)),
            contentbarBV.leadingAnchor.constraint(equalTo: metabarBV.leadingAnchor),
            contentbarBV.trailingAnchor.constraint(equalTo: metabarBV.trailingAnchor),
            contentbarBV.bottomAnchor.constraint(equalTo: cardbarBV.bottomAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(16, minimumbarBV: 12, maximumbarBV: 18))
        ])
        return cardbarBV
    }

    private func reasonCardbarBV() -> UIView {
        let cardbarBV = UIView()
        cardbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.96)
        cardbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 13, maximumbarBV: 18)
        cardbarBV.layer.masksToBounds = true
        let stackbarBV = UIStackView()
        stackbarBV.axis = .vertical
        stackbarBV.alignment = .fill
        cardbarBV.addSubview(stackbarBV)
        stackbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackbarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor),
            stackbarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor),
            stackbarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor),
            stackbarBV.bottomAnchor.constraint(equalTo: cardbarBV.bottomAnchor)
        ])
        for reasonbarBV in reportReasonbarBV.allCases {
            let rowbarBV = reportReasonRowbarBV(reasonbarBV: reasonbarBV)
            rowbarBV.selectedFlagbarBV = reasonbarBV == selectedReasonbarBV
            rowbarBV.addAction(UIAction { [weak self] _ in
                self?.selectReasonbarBV(reasonbarBV)
            }, for: .touchUpInside)
            rowbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(56)).isActive = true
            reasonRowsbarBV.append(rowbarBV)
            stackbarBV.addArrangedSubview(rowbarBV)
        }
        return cardbarBV
    }

    private func detailCardbarBV() -> UIView {
        let cardbarBV = UIView()
        cardbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.96)
        cardbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 13, maximumbarBV: 18)
        cardbarBV.layer.masksToBounds = true
        detailEntrybarBV.backgroundColor = .clear
        detailEntrybarBV.font = BaurbstyleStorebarBV.fontbarBV(17, weight: .regular)
        detailEntrybarBV.textColor = .black
        detailEntrybarBV.delegate = self
        detailEntrybarBV.textContainerInset = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        detailPlaceholderbarBV.text = "Add details (optional)..."
        detailPlaceholderbarBV.font = BaurbstyleStorebarBV.fontbarBV(17, weight: .regular)
        detailPlaceholderbarBV.textColor = BaurbstyleStorebarBV.mutedText
        cardbarBV.addSubview(detailEntrybarBV)
        detailEntrybarBV.addSubview(detailPlaceholderbarBV)
        detailEntrybarBV.translatesAutoresizingMaskIntoConstraints = false
        detailPlaceholderbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(112, minimumbarBV: 96, maximumbarBV: 124)),
            detailEntrybarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor),
            detailEntrybarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor),
            detailEntrybarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor),
            detailEntrybarBV.bottomAnchor.constraint(equalTo: cardbarBV.bottomAnchor),
            detailPlaceholderbarBV.topAnchor.constraint(equalTo: detailEntrybarBV.topAnchor, constant: detailEntrybarBV.textContainerInset.top + 1),
            detailPlaceholderbarBV.leadingAnchor.constraint(equalTo: detailEntrybarBV.leadingAnchor, constant: detailEntrybarBV.textContainerInset.left + 5),
            detailPlaceholderbarBV.trailingAnchor.constraint(lessThanOrEqualTo: detailEntrybarBV.trailingAnchor, constant: -detailEntrybarBV.textContainerInset.right)
        ])
        return cardbarBV
    }

    private func submitButtonbarBV() -> UIButton {
        let buttonbarBV = gradientPill(type: .system)
        buttonbarBV.setTitle("Submit Report", for: .normal)
        buttonbarBV.setTitleColor(.black, for: .normal)
        buttonbarBV.titleLabel?.font = BaurbstyleStorebarBV.fontbarBV(18, weight: .heavy)
        buttonbarBV.addAction(UIAction { [weak self] _ in
            self?.submitReportbarBV()
        }, for: .touchUpInside)
        BaurbstyleStorebarBV.buttonFitbarBV(buttonbarBV)
        buttonbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(56)).isActive = true
        return buttonbarBV
    }

    private func selectReasonbarBV(_ reasonbarBV: reportReasonbarBV) {
        selectedReasonbarBV = reasonbarBV
        reasonRowsbarBV.forEach { rowbarBV in
            rowbarBV.selectedFlagbarBV = rowbarBV.reasonbarBV == reasonbarBV
        }
    }

    private func submitReportbarBV() {
        guard let selectedReasonbarBV else {
            presentNoticebarBV(titlebarBV: "Report", messagebarBV: "Please choose a reason.")
            return
        }
        storebarBV.submitReportbarBV(
            threadbarBV: threadbarBV,
            messagebarBV: messagebarBV,
            contactbarBV: contactbarBV,
            reasonbarBV: selectedReasonbarBV,
            detailsbarBV: detailEntrybarBV.text.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        let alertbarBV = UIAlertController(title: "Report submitted", message: "Thank you. We will process your request within 24 hours.", preferredStyle: .alert)
        alertbarBV.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alertbarBV, animated: true)
    }

    private func presentNoticebarBV(titlebarBV: String, messagebarBV: String) {
        let alertbarBV = UIAlertController(title: titlebarBV, message: messagebarBV, preferredStyle: .alert)
        alertbarBV.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertbarBV, animated: true)
    }

    private func targetLabelbarBV() -> String {
        if let messagebarBV, messagebarBV.sentFlag {
            return "FROM YOU"
        }
        let namebarBV = contactbarBV?.placeholderNamebarBV.components(separatedBy: " ").first?.uppercased() ?? threadbarBV.threadTitlebarBV.uppercased()
        return "FROM \(namebarBV)"
    }

    private func targetTimebarBV() -> String {
        guard let datebarBV = messagebarBV?.messageMomentbarBV else { return "Conversation" }
        let formatterbarBV = DateFormatter()
        formatterbarBV.locale = Locale(identifier: "en_US_POSIX")
        formatterbarBV.dateFormat = "HH:mm"
        return formatterbarBV.string(from: datebarBV)
    }

    func textViewDidChange(_ textView: UITextView) {
        detailPlaceholderbarBV.isHidden = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

final class reportReasonRowbarBV: UIControl {
    let reasonbarBV: reportReasonbarBV
    var selectedFlagbarBV: Bool = false {
        didSet {
            choicebarBV.selectedFlagbarBV = selectedFlagbarBV
        }
    }
    private let choicebarBV = reportChoiceMarkbarBV()

    init(reasonbarBV: reportReasonbarBV) {
        self.reasonbarBV = reasonbarBV
        super.init(frame: .zero)
        configurebarBV()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configurebarBV() {
        let labelbarBV = UILabel()
        labelbarBV.text = reasonbarBV.rawValue
        labelbarBV.font = BaurbstyleStorebarBV.fontbarBV(16, weight: .regular)
        labelbarBV.textColor = .black
        labelbarBV.isUserInteractionEnabled = false
        BaurbstyleStorebarBV.labelFitbarBV(labelbarBV, factorbarBV: 0.72, linesbarBV: 1)
        let dividerbarBV = UIView()
        dividerbarBV.backgroundColor = UIColor.systemGray5.withAlphaComponent(0.75)
        dividerbarBV.isUserInteractionEnabled = false
        choicebarBV.isUserInteractionEnabled = false
        [labelbarBV, choicebarBV, dividerbarBV].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            labelbarBV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 12, maximumbarBV: 18)),
            labelbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: choicebarBV.leadingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            choicebarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 12, maximumbarBV: 18)),
            choicebarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            choicebarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(24, minimumbarBV: 22, maximumbarBV: 26)),
            choicebarBV.heightAnchor.constraint(equalTo: choicebarBV.widthAnchor),
            dividerbarBV.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerbarBV.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerbarBV.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerbarBV.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])
    }
}

final class reportChoiceMarkbarBV: UIView {
    var selectedFlagbarBV: Bool = false {
        didSet {
            setNeedsLayout()
            refreshbarBV()
        }
    }
    private let checkbarBV = UIImageView(image: UIImage(systemName: "checkmark"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        configurebarBV()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configurebarBV()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        layer.sublayers?.first(where: { $0.name == "reportChoiceGradientbarBV" })?.frame = bounds
    }

    private func configurebarBV() {
        addSubview(checkbarBV)
        checkbarBV.translatesAutoresizingMaskIntoConstraints = false
        checkbarBV.tintColor = .white
        checkbarBV.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            checkbarBV.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkbarBV.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.58),
            checkbarBV.heightAnchor.constraint(equalTo: checkbarBV.widthAnchor)
        ])
        refreshbarBV()
    }

    private func refreshbarBV() {
        layer.sublayers?.removeAll { $0.name == "reportChoiceGradientbarBV" }
        layer.borderWidth = selectedFlagbarBV ? 0 : 1.6
        layer.borderColor = UIColor.systemGray4.cgColor
        checkbarBV.isHidden = !selectedFlagbarBV
        backgroundColor = .clear
        guard selectedFlagbarBV else { return }
        let gradientbarBV = BaurbstyleStorebarBV.gradientLayer(
            bounds: bounds,
            cornerRadius: min(bounds.width, bounds.height) / 2,
            colorsbarBV: [BaurbstyleStorebarBV.mint, BaurbstyleStorebarBV.purple, BaurbstyleStorebarBV.pink],
            locationsbarBV: nil
        )
        gradientbarBV.name = "reportChoiceGradientbarBV"
        layer.insertSublayer(gradientbarBV, at: 0)
    }
}

final class inviteGroupSurfacebarBV: barbCanvasbarBV, UITableViewDataSource, UITableViewDelegate {
    private let storebarBV: barbVaultbarBV
    private let threadbarBV: threadFixturebarBV
    private let tableViewbarBV = UITableView(frame: .zero, style: .plain)
    private var selectedContactsbarBV: Set<UUID> = []

    private var contactListbarBV: [trustedContact] {
        storebarBV.contactPoolbarBV.filter { !threadbarBV.personaPoolbarBV.contains($0.contactSeed) }
    }

    init(storebarBV: barbVaultbarBV, threadbarBV: threadFixturebarBV) {
        self.storebarBV = storebarBV
        self.threadbarBV = threadbarBV
        super.init(nibName: nil, bundle: nil)
        title = "Invite to Group"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderbarBV()
        configureLayoutbarBV()
    }

    private func configureHeaderbarBV() {
        navigationItem.hidesBackButton = true
        let backbarBV = UIButton(type: .system)
        backbarBV.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backbarBV.tintColor = .black
        backbarBV.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)
        NSLayoutConstraint.activate([
            backbarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(44)),
            backbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(44))
        ])
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbarBV)
    }

    private func configureLayoutbarBV() {
        let topCardbarBV = inviteCardbarBV()
        let titlebarBV = UILabel()
        titlebarBV.attributedText = NSAttributedString(
            string: "INVITE FROM CONTACTS (\(contactListbarBV.count))",
            attributes: [
                .kern: 2,
                .font: BaurbstyleStorebarBV.fontbarBV(17, weight: .heavy),
                .foregroundColor: UIColor.black
            ]
        )
        tableViewbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.96)
        tableViewbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)
        tableViewbarBV.layer.masksToBounds = true
        tableViewbarBV.separatorStyle = .singleLine
        tableViewbarBV.separatorColor = UIColor.systemGray5
        tableViewbarBV.dataSource = self
        tableViewbarBV.delegate = self
        tableViewbarBV.register(inviteContactCellbarBV.self, forCellReuseIdentifier: inviteContactCellbarBV.reuseID)

        let donebarBV = gradientPill(type: .system)
        donebarBV.setTitle("Done", for: .normal)
        donebarBV.setTitleColor(.black, for: .normal)
        donebarBV.titleLabel?.font = BaurbstyleStorebarBV.fontbarBV(22, weight: .heavy)
        donebarBV.addAction(UIAction { [weak self] _ in
            self?.finishInvitebarBV()
        }, for: .touchUpInside)

        [topCardbarBV, titlebarBV, tableViewbarBV, donebarBV].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let sidebarBV = BaurbstyleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 22)
        NSLayoutConstraint.activate([
            topCardbarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(22, minimumbarBV: 14, maximumbarBV: 26)),
            topCardbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidebarBV),
            topCardbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidebarBV),
            topCardbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(230, minimumbarBV: 190, maximumbarBV: 244)),

            titlebarBV.topAnchor.constraint(equalTo: topCardbarBV.bottomAnchor, constant: BaurbstyleStorebarBV.spacebarBV(24, minimumbarBV: 16, maximumbarBV: 28)),
            titlebarBV.leadingAnchor.constraint(equalTo: topCardbarBV.leadingAnchor),
            titlebarBV.trailingAnchor.constraint(equalTo: topCardbarBV.trailingAnchor),

            tableViewbarBV.topAnchor.constraint(equalTo: titlebarBV.bottomAnchor, constant: BaurbstyleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 16)),
            tableViewbarBV.leadingAnchor.constraint(equalTo: topCardbarBV.leadingAnchor),
            tableViewbarBV.trailingAnchor.constraint(equalTo: topCardbarBV.trailingAnchor),
            tableViewbarBV.bottomAnchor.constraint(equalTo: donebarBV.topAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 16)),

            donebarBV.leadingAnchor.constraint(equalTo: topCardbarBV.leadingAnchor),
            donebarBV.trailingAnchor.constraint(equalTo: topCardbarBV.trailingAnchor),
            donebarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            donebarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(58))
        ])
    }

    private func inviteCardbarBV() -> UIView {
        let cardbarBV = UIView()
        cardbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.96)
        cardbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)
        cardbarBV.layer.masksToBounds = true

        let iconShellbarBV = UIView()
        iconShellbarBV.backgroundColor = UIColor(red: 232 / 255, green: 241 / 255, blue: 1, alpha: 1)
        iconShellbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)
        let iconbarBV = UIImageView(image: UIImage(systemName: "person.2"))
        iconbarBV.tintColor = BaurbstyleStorebarBV.purple
        iconbarBV.contentMode = .scaleAspectFit
        iconShellbarBV.addSubview(iconbarBV)
        iconbarBV.translatesAutoresizingMaskIntoConstraints = false

        let namebarBV = UILabel()
        namebarBV.text = threadbarBV.threadTitlebarBV
        namebarBV.font = BaurbstyleStorebarBV.fontbarBV(22, weight: .heavy)
        namebarBV.textAlignment = .center
        BaurbstyleStorebarBV.labelFitbarBV(namebarBV, factorbarBV: 0.68, linesbarBV: 1)
        let metabarBV = UILabel()
        metabarBV.text = "\(storebarBV.groupMemberCountbarBV(for: threadbarBV)) members · Invite-only"
        metabarBV.font = BaurbstyleStorebarBV.fontbarBV(16, weight: .regular)
        metabarBV.textColor = BaurbstyleStorebarBV.mutedText
        metabarBV.textAlignment = .center

        let linkRowbarBV = UIControl()
        linkRowbarBV.backgroundColor = UIColor.systemGray6
        linkRowbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(14, minimumbarBV: 12, maximumbarBV: 16)
        linkRowbarBV.addAction(UIAction { [weak self] _ in
            UIPasteboard.general.string = self?.inviteLinkbarBV()
            self?.noticebarBV(titlebarBV: "Copied", messagebarBV: "Invite link copied .")
        }, for: .touchUpInside)
        let linkbarBV = UILabel()
        linkbarBV.text = inviteLinkbarBV()
        linkbarBV.font = BaurbstyleStorebarBV.fontbarBV(15, weight: .regular)
        linkbarBV.textColor = UIColor.darkGray
        linkbarBV.lineBreakMode = .byTruncatingMiddle
        let copybarBV = UILabel()
        copybarBV.text = "COPY"
        copybarBV.font = BaurbstyleStorebarBV.fontbarBV(14, weight: .heavy)
        copybarBV.textColor = UIColor(red: 50 / 255, green: 82 / 255, blue: 1, alpha: 1)
        [linkbarBV, copybarBV].forEach {
            linkRowbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isUserInteractionEnabled = false
        }

        let hintbarBV = UILabel()
        hintbarBV.text = "Anyone with this link must request to join."
        hintbarBV.font = BaurbstyleStorebarBV.fontbarBV(14, weight: .regular)
        hintbarBV.textColor = BaurbstyleStorebarBV.mutedText
        hintbarBV.textAlignment = .center

        let stackbarBV = UIStackView(arrangedSubviews: [iconShellbarBV, namebarBV, metabarBV, linkRowbarBV, hintbarBV])
        stackbarBV.axis = .vertical
        stackbarBV.alignment = .center
        stackbarBV.spacing = BaurbstyleStorebarBV.spacebarBV(10, minimumbarBV: 7, maximumbarBV: 12)
        cardbarBV.addSubview(stackbarBV)
        stackbarBV.translatesAutoresizingMaskIntoConstraints = false
        iconShellbarBV.translatesAutoresizingMaskIntoConstraints = false
        linkRowbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackbarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(20, minimumbarBV: 14, maximumbarBV: 22)),
            stackbarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(20, minimumbarBV: 14, maximumbarBV: 24)),
            stackbarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(20, minimumbarBV: 14, maximumbarBV: 24)),
            stackbarBV.bottomAnchor.constraint(lessThanOrEqualTo: cardbarBV.bottomAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 18)),
            iconShellbarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(64, minimumbarBV: 54, maximumbarBV: 70)),
            iconShellbarBV.heightAnchor.constraint(equalTo: iconShellbarBV.widthAnchor),
            iconbarBV.centerXAnchor.constraint(equalTo: iconShellbarBV.centerXAnchor),
            iconbarBV.centerYAnchor.constraint(equalTo: iconShellbarBV.centerYAnchor),
            iconbarBV.widthAnchor.constraint(equalTo: iconShellbarBV.widthAnchor, multiplier: 0.58),
            iconbarBV.heightAnchor.constraint(equalTo: iconbarBV.widthAnchor),
            linkRowbarBV.widthAnchor.constraint(equalTo: stackbarBV.widthAnchor),
            linkRowbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(52)),
            linkbarBV.leadingAnchor.constraint(equalTo: linkRowbarBV.leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 12, maximumbarBV: 18)),
            linkbarBV.centerYAnchor.constraint(equalTo: linkRowbarBV.centerYAnchor),
            linkbarBV.trailingAnchor.constraint(equalTo: copybarBV.leadingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            copybarBV.trailingAnchor.constraint(equalTo: linkRowbarBV.trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 12, maximumbarBV: 18)),
            copybarBV.centerYAnchor.constraint(equalTo: linkRowbarBV.centerYAnchor)
        ])
        return cardbarBV
    }

    private func inviteLinkbarBV() -> String {
        let slugbarBV = threadbarBV.threadTitlebarBV.lowercased().replacingOccurrences(of: " ", with: "-")
        return "barb.im/g/\(slugbarBV)-9k2"
    }

    private func finishInvitebarBV() {
        let countbarBV = selectedContactsbarBV.count
        let messagebarBV = countbarBV == 0 ? "No contact selected. Invite flow closed." : "\(countbarBV) invite request\(countbarBV == 1 ? "" : "s") prepared ."
        let alertbarBV = UIAlertController(title: "Invite to Group", message: messagebarBV, preferredStyle: .alert)
        alertbarBV.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alertbarBV, animated: true)
    }

    private func noticebarBV(titlebarBV: String, messagebarBV: String) {
        let alertbarBV = UIAlertController(title: titlebarBV, message: messagebarBV, preferredStyle: .alert)
        alertbarBV.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertbarBV, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactListbarBV.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        BaurbstyleStorebarBV.metricbarBV(74, minimumbarBV: 64, maximumbarBV: 80)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellbarBV = tableView.dequeueReusableCell(withIdentifier: inviteContactCellbarBV.reuseID, for: indexPath) as! inviteContactCellbarBV
        let contactbarBV = contactListbarBV[indexPath.row]
        cellbarBV.configurebarBV(contactbarBV: contactbarBV, selectedbarBV: selectedContactsbarBV.contains(contactbarBV.contactSeed))
        return cellbarBV
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contactbarBV = contactListbarBV[indexPath.row]
        if selectedContactsbarBV.contains(contactbarBV.contactSeed) {
            selectedContactsbarBV.remove(contactbarBV.contactSeed)
        } else {
            selectedContactsbarBV.insert(contactbarBV.contactSeed)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

final class inviteContactCellbarBV: UITableViewCell {
    static let reuseID = "inviteContactCellbarBV"
    private let avatarbarBV = avatarSurfacebarBV(initial: "B")
    private let namebarBV = UILabel()
    private let groupbarBV = UILabel()
    private let choicebarBV = reportChoiceMarkbarBV()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        [avatarbarBV, namebarBV, groupbarBV, choicebarBV].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        namebarBV.font = BaurbstyleStorebarBV.fontbarBV(17, weight: .heavy)
        namebarBV.textColor = UIColor(red: 37 / 255, green: 15 / 255, blue: 73 / 255, alpha: 1)
        groupbarBV.font = BaurbstyleStorebarBV.fontbarBV(14, weight: .regular)
        groupbarBV.textColor = UIColor.darkGray
        choicebarBV.isUserInteractionEnabled = false
        NSLayoutConstraint.activate([
            avatarbarBV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 12, maximumbarBV: 18)),
            avatarbarBV.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarbarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(48, minimumbarBV: 42, maximumbarBV: 52)),
            avatarbarBV.heightAnchor.constraint(equalTo: avatarbarBV.widthAnchor),
            namebarBV.leadingAnchor.constraint(equalTo: avatarbarBV.trailingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(14, minimumbarBV: 10, maximumbarBV: 16)),
            namebarBV.trailingAnchor.constraint(lessThanOrEqualTo: choicebarBV.leadingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            namebarBV.topAnchor.constraint(equalTo: contentView.topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(15, minimumbarBV: 10, maximumbarBV: 17)),
            groupbarBV.leadingAnchor.constraint(equalTo: namebarBV.leadingAnchor),
            groupbarBV.trailingAnchor.constraint(equalTo: namebarBV.trailingAnchor),
            groupbarBV.topAnchor.constraint(equalTo: namebarBV.bottomAnchor, constant: 3),
            choicebarBV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 12, maximumbarBV: 18)),
            choicebarBV.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            choicebarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(26, minimumbarBV: 22, maximumbarBV: 28)),
            choicebarBV.heightAnchor.constraint(equalTo: choicebarBV.widthAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configurebarBV(contactbarBV: trustedContact, selectedbarBV: Bool) {
        avatarbarBV.text = contactbarBV.placeholderAvatar
        avatarbarBV.backgroundColor = contactbarBV.groupFilter == .familyFilterbarBV ? BaurbstyleStorebarBV.pink : BaurbstyleStorebarBV.blue
        namebarBV.text = contactbarBV.placeholderNamebarBV
        groupbarBV.text = contactbarBV.groupFilter.rawValue
        choicebarBV.selectedFlagbarBV = selectedbarBV
    }
}

final class groupReportSurfacebarBV: barbCanvasbarBV {
    private let storebarBV: barbVaultbarBV
    private let threadbarBV: threadFixturebarBV
    private let messagebarBV: messageFixturebarBV?
    private let stackbarBV = UIStackView()
    private let scrollbarBV = UIScrollView()
    private let visibilitySwitchbarBV = UISwitch()
    private var reasonRowsbarBV: [groupReportReasonRowbarBV] = []
    private var selectedReasonbarBV: groupReportReasonbarBV? = .otherGroupbarBV

    init(storebarBV: barbVaultbarBV, threadbarBV: threadFixturebarBV, messagebarBV: messageFixturebarBV?) {
        self.storebarBV = storebarBV
        self.threadbarBV = threadbarBV
        self.messagebarBV = messagebarBV
        super.init(nibName: nil, bundle: nil)
        title = "Report Message"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderbarBV()
        configureLayoutbarBV()
    }

    private func configureHeaderbarBV() {
        navigationItem.hidesBackButton = true
        let backbarBV = UIButton(type: .system)
        backbarBV.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backbarBV.tintColor = .black
        backbarBV.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)
        NSLayoutConstraint.activate([
            backbarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(44)),
            backbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(44))
        ])
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbarBV)
    }

    private func configureLayoutbarBV() {
        scrollbarBV.showsVerticalScrollIndicator = false
        view.addSubview(scrollbarBV)
        scrollbarBV.addSubview(stackbarBV)
        scrollbarBV.translatesAutoresizingMaskIntoConstraints = false
        stackbarBV.translatesAutoresizingMaskIntoConstraints = false
        stackbarBV.axis = .vertical
        stackbarBV.spacing = BaurbstyleStorebarBV.spacebarBV(16, minimumbarBV: 12, maximumbarBV: 18)

        let bannerbarBV = UILabel()
        bannerbarBV.text = "  ↑ Reporting in group: \(threadbarBV.threadTitlebarBV)"
        bannerbarBV.font = BaurbstyleStorebarBV.fontbarBV(15, weight: .regular)
        bannerbarBV.textColor = UIColor(red: 18 / 255, green: 154 / 255, blue: 77 / 255, alpha: 1)
        bannerbarBV.backgroundColor = UIColor(red: 225 / 255, green: 1, blue: 236 / 255, alpha: 0.95)
        bannerbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)
        bannerbarBV.layer.masksToBounds = true

        let titlebarBV = UILabel()
        titlebarBV.text = "What's the issue?"
        titlebarBV.font = BaurbstyleStorebarBV.fontbarBV(31, weight: .heavy)
        titlebarBV.textColor = .black
        titlebarBV.numberOfLines = 2
        BaurbstyleStorebarBV.labelFitbarBV(titlebarBV, factorbarBV: 0.64, linesbarBV: 2)
        let subtitlebarBV = UILabel()
        subtitlebarBV.text = "Group admins and Barb safety team will review."
        subtitlebarBV.font = BaurbstyleStorebarBV.fontbarBV(15, weight: .regular)
        subtitlebarBV.textColor = UIColor.darkGray
        subtitlebarBV.numberOfLines = 2

        [bannerbarBV, titlebarBV, subtitlebarBV, targetCardbarBV(), visibilityCardbarBV(), reasonCardbarBV(), submitButtonbarBV()].forEach {
            stackbarBV.addArrangedSubview($0)
        }

        let sidebarBV = BaurbstyleStorebarBV.metricbarBV(20, minimumbarBV: 16, maximumbarBV: 22)
        NSLayoutConstraint.activate([
            scrollbarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollbarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackbarBV.topAnchor.constraint(equalTo: scrollbarBV.contentLayoutGuide.topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 22)),
            stackbarBV.leadingAnchor.constraint(equalTo: scrollbarBV.contentLayoutGuide.leadingAnchor, constant: sidebarBV),
            stackbarBV.trailingAnchor.constraint(equalTo: scrollbarBV.contentLayoutGuide.trailingAnchor, constant: -sidebarBV),
            stackbarBV.bottomAnchor.constraint(equalTo: scrollbarBV.contentLayoutGuide.bottomAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(22, minimumbarBV: 16, maximumbarBV: 24)),
            stackbarBV.widthAnchor.constraint(equalTo: scrollbarBV.frameLayoutGuide.widthAnchor, constant: -sidebarBV * 2),
            bannerbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(48))
        ])
    }

    private func targetCardbarBV() -> UIView {
        let cardbarBV = UIView()
        cardbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.96)
        cardbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(14, minimumbarBV: 12, maximumbarBV: 16)
        cardbarBV.layer.masksToBounds = true
        let linebarBV = UIView()
        linebarBV.backgroundColor = UIColor(red: 50 / 255, green: 82 / 255, blue: 1, alpha: 1)
        let metabarBV = UILabel()
        metabarBV.text = "FROM \(senderNamebarBV().uppercased()) · \(targetTimebarBV()) · GROUP MEMBER"
        metabarBV.font = BaurbstyleStorebarBV.fontbarBV(13, weight: .heavy)
        metabarBV.textColor = UIColor(red: 50 / 255, green: 82 / 255, blue: 1, alpha: 1)
        BaurbstyleStorebarBV.labelFitbarBV(metabarBV, factorbarBV: 0.6, linesbarBV: 1)
        let contentbarBV = UILabel()
        contentbarBV.text = "\"\(messagebarBV?.messageCopybarBV ?? "Report this group conversation.")\""
        contentbarBV.font = BaurbstyleStorebarBV.fontbarBV(16, weight: .regular)
        contentbarBV.textColor = .black
        contentbarBV.numberOfLines = 3
        [linebarBV, metabarBV, contentbarBV].forEach {
            cardbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            linebarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor),
            linebarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor),
            linebarBV.bottomAnchor.constraint(equalTo: cardbarBV.bottomAnchor),
            linebarBV.widthAnchor.constraint(equalToConstant: 3),
            metabarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(15, minimumbarBV: 12, maximumbarBV: 18)),
            metabarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            metabarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 12, maximumbarBV: 18)),
            contentbarBV.topAnchor.constraint(equalTo: metabarBV.bottomAnchor, constant: BaurbstyleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            contentbarBV.leadingAnchor.constraint(equalTo: metabarBV.leadingAnchor),
            contentbarBV.trailingAnchor.constraint(equalTo: metabarBV.trailingAnchor),
            contentbarBV.bottomAnchor.constraint(equalTo: cardbarBV.bottomAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(15, minimumbarBV: 12, maximumbarBV: 18))
        ])
        return cardbarBV
    }

    private func visibilityCardbarBV() -> UIView {
        let cardbarBV = UIView()
        cardbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.96)
        cardbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 13, maximumbarBV: 18)
        let titlebarBV = UILabel()
        titlebarBV.text = "Hide my name from member"
        titlebarBV.font = BaurbstyleStorebarBV.fontbarBV(17, weight: .regular)
        titlebarBV.textColor = .black
        let hintbarBV = UILabel()
        hintbarBV.text = "Only Barb safety team will see who reported"
        hintbarBV.font = BaurbstyleStorebarBV.fontbarBV(12, weight: .regular)
        hintbarBV.textColor = BaurbstyleStorebarBV.mutedText
        visibilitySwitchbarBV.isOn = true
        visibilitySwitchbarBV.onTintColor = BaurbstyleStorebarBV.purple
        [titlebarBV, hintbarBV, visibilitySwitchbarBV].forEach {
            cardbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            cardbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(84, minimumbarBV: 72, maximumbarBV: 92)),
            titlebarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 12, maximumbarBV: 18)),
            titlebarBV.trailingAnchor.constraint(lessThanOrEqualTo: visibilitySwitchbarBV.leadingAnchor, constant: -12),
            titlebarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(18, minimumbarBV: 13, maximumbarBV: 20)),
            hintbarBV.leadingAnchor.constraint(equalTo: titlebarBV.leadingAnchor),
            hintbarBV.trailingAnchor.constraint(lessThanOrEqualTo: visibilitySwitchbarBV.leadingAnchor, constant: -12),
            hintbarBV.topAnchor.constraint(equalTo: titlebarBV.bottomAnchor, constant: 4),
            visibilitySwitchbarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 12, maximumbarBV: 18)),
            visibilitySwitchbarBV.centerYAnchor.constraint(equalTo: cardbarBV.centerYAnchor)
        ])
        return cardbarBV
    }

    private func reasonCardbarBV() -> UIView {
        let cardbarBV = UIView()
        cardbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.96)
        cardbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 13, maximumbarBV: 18)
        cardbarBV.layer.masksToBounds = true
        let stackbarBV = UIStackView()
        stackbarBV.axis = .vertical
        cardbarBV.addSubview(stackbarBV)
        stackbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackbarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor),
            stackbarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor),
            stackbarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor),
            stackbarBV.bottomAnchor.constraint(equalTo: cardbarBV.bottomAnchor)
        ])
        for reasonbarBV in groupReportReasonbarBV.allCases {
            let rowbarBV = groupReportReasonRowbarBV(reasonbarBV: reasonbarBV)
            rowbarBV.selectedFlagbarBV = reasonbarBV == selectedReasonbarBV
            rowbarBV.addAction(UIAction { [weak self] _ in
                self?.selectReasonbarBV(reasonbarBV)
            }, for: .touchUpInside)
            rowbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(58)).isActive = true
            reasonRowsbarBV.append(rowbarBV)
            stackbarBV.addArrangedSubview(rowbarBV)
        }
        return cardbarBV
    }

    private func submitButtonbarBV() -> UIButton {
        let buttonbarBV = gradientPill(type: .system)
        buttonbarBV.setTitle("Submit Report", for: .normal)
        buttonbarBV.setTitleColor(.black, for: .normal)
        buttonbarBV.titleLabel?.font = BaurbstyleStorebarBV.fontbarBV(20, weight: .heavy)
        buttonbarBV.addAction(UIAction { [weak self] _ in
            self?.submitbarBV()
        }, for: .touchUpInside)
        buttonbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(58)).isActive = true
        return buttonbarBV
    }

    private func selectReasonbarBV(_ reasonbarBV: groupReportReasonbarBV) {
        selectedReasonbarBV = reasonbarBV
        reasonRowsbarBV.forEach { $0.selectedFlagbarBV = $0.reasonbarBV == reasonbarBV }
    }

    private func submitbarBV() {
        guard let selectedReasonbarBV else { return }
        storebarBV.submitGroupReportbarBV(
            threadbarBV: threadbarBV,
            messagebarBV: messagebarBV,
            reasonbarBV: selectedReasonbarBV,
            hiddenNamebarBV: visibilitySwitchbarBV.isOn
        )
        let alertbarBV = UIAlertController(title: "Report submitted", message: "This group report was saved.", preferredStyle: .alert)
        alertbarBV.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alertbarBV, animated: true)
    }

    private func senderNamebarBV() -> String {
        guard let messagebarBV else { return "Member" }
        if messagebarBV.sentFlag { return "You" }
        return storebarBV.contactMatcherbarBV(contactSeed: messagebarBV.personaSeed)?.placeholderNamebarBV.components(separatedBy: " ").first ?? "Member"
    }

    private func targetTimebarBV() -> String {
        guard let datebarBV = messagebarBV?.messageMomentbarBV else { return "Now" }
        let formatterbarBV = DateFormatter()
        formatterbarBV.locale = Locale(identifier: "en_US_POSIX")
        formatterbarBV.dateFormat = "HH:mm"
        return formatterbarBV.string(from: datebarBV)
    }
}

final class groupReportReasonRowbarBV: UIControl {
    let reasonbarBV: groupReportReasonbarBV
    var selectedFlagbarBV: Bool = false {
        didSet {
            choicebarBV.selectedFlagbarBV = selectedFlagbarBV
        }
    }
    private let choicebarBV = reportChoiceMarkbarBV()

    init(reasonbarBV: groupReportReasonbarBV) {
        self.reasonbarBV = reasonbarBV
        super.init(frame: .zero)
        configurebarBV()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configurebarBV() {
        let labelbarBV = UILabel()
        labelbarBV.text = reasonbarBV.rawValue
        labelbarBV.font = BaurbstyleStorebarBV.fontbarBV(16, weight: .regular)
        labelbarBV.textColor = .black
        labelbarBV.isUserInteractionEnabled = false
        let dividerbarBV = UIView()
        dividerbarBV.backgroundColor = UIColor.systemGray5.withAlphaComponent(0.75)
        dividerbarBV.isUserInteractionEnabled = false
        choicebarBV.isUserInteractionEnabled = false
        [labelbarBV, choicebarBV, dividerbarBV].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            labelbarBV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 12, maximumbarBV: 18)),
            labelbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: choicebarBV.leadingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            choicebarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 12, maximumbarBV: 18)),
            choicebarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            choicebarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(24, minimumbarBV: 22, maximumbarBV: 26)),
            choicebarBV.heightAnchor.constraint(equalTo: choicebarBV.widthAnchor),
            dividerbarBV.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerbarBV.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerbarBV.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerbarBV.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])
    }
}

enum messageActionbarBV {
    case aiReplybarBV
    case regeneratebarBV
    case copybarBV
}

final class messageMenuSurfacebarBV: UIView {
    var onChoosebarBV: ((messageActionbarBV) -> Void)?
    private let stackbarBV = UIStackView()
    private let previewLabelbarBV = UILabel()
    private let previewTextbarBV: String
    private let copyEnabledbarBV: Bool

    init(previewTextbarBV: String, copyEnabledbarBV: Bool = true) {
        self.previewTextbarBV = previewTextbarBV
        self.copyEnabledbarBV = copyEnabledbarBV
        super.init(frame: .zero)
        configurebarBV()
    }

    required init?(coder: NSCoder) {
        previewTextbarBV = ""
        copyEnabledbarBV = true
        super.init(coder: coder)
        configurebarBV()
    }

    private func configurebarBV() {
        backgroundColor = UIColor.white.withAlphaComponent(0.98)
        layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(22, minimumbarBV: 18, maximumbarBV: 24)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.16
        layer.shadowRadius = 18
        layer.shadowOffset = CGSize(width: 0, height: 8)

        previewLabelbarBV.text = previewTextbarBV
        previewLabelbarBV.font = BaurbstyleStorebarBV.fontbarBV(20, weight: .regular)
        previewLabelbarBV.textColor = .black
        previewLabelbarBV.numberOfLines = 2
        previewLabelbarBV.lineBreakMode = .byTruncatingTail
        BaurbstyleStorebarBV.labelFitbarBV(previewLabelbarBV, factorbarBV: 0.62, linesbarBV: 2)

        let actionPanelbarBV = UIView()
        actionPanelbarBV.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.92)
        actionPanelbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(22, minimumbarBV: 18, maximumbarBV: 24)
        actionPanelbarBV.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        actionPanelbarBV.layer.masksToBounds = true
        stackbarBV.axis = .vertical
        stackbarBV.alignment = .fill
        stackbarBV.distribution = .fillEqually
        addSubview(previewLabelbarBV)
        addSubview(actionPanelbarBV)
        actionPanelbarBV.addSubview(stackbarBV)
        [previewLabelbarBV, actionPanelbarBV, stackbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            previewLabelbarBV.topAnchor.constraint(equalTo: topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 16)),
            previewLabelbarBV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            previewLabelbarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            previewLabelbarBV.bottomAnchor.constraint(equalTo: actionPanelbarBV.topAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 16)),

            actionPanelbarBV.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionPanelbarBV.trailingAnchor.constraint(equalTo: trailingAnchor),
            actionPanelbarBV.bottomAnchor.constraint(equalTo: bottomAnchor),
            actionPanelbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(168, minimumbarBV: 154, maximumbarBV: 178)),

            stackbarBV.topAnchor.constraint(equalTo: actionPanelbarBV.topAnchor),
            stackbarBV.leadingAnchor.constraint(equalTo: actionPanelbarBV.leadingAnchor),
            stackbarBV.trailingAnchor.constraint(equalTo: actionPanelbarBV.trailingAnchor),
            stackbarBV.bottomAnchor.constraint(equalTo: actionPanelbarBV.bottomAnchor)
        ])

        stackbarBV.addArrangedSubview(actionRowbarBV(
            titlebarBV: "AI Reply",
            iconbarBV: "sparkles",
            emphasizedbarBV: true,
            showsDividerbarBV: true,
            actionbarBV: .aiReplybarBV
        ))
        stackbarBV.addArrangedSubview(actionRowbarBV(
            titlebarBV: "Regenerate",
            iconbarBV: "arrow.clockwise",
            valuebarBV: "-100",
            showsDividerbarBV: true,
            actionbarBV: .regeneratebarBV
        ))
        stackbarBV.addArrangedSubview(actionRowbarBV(
            titlebarBV: "Copy",
            iconbarBV: "doc.on.doc",
            enabledbarBV: copyEnabledbarBV,
            actionbarBV: .copybarBV
        ))
    }

    private func actionRowbarBV(
        titlebarBV: String,
        iconbarBV: String,
        valuebarBV: String? = nil,
        emphasizedbarBV: Bool = false,
        enabledbarBV: Bool = true,
        showsDividerbarBV: Bool = false,
        actionbarBV: messageActionbarBV
    ) -> UIControl {
        let rowbarBV = UIControl()
        let iconViewbarBV = UIImageView(image: UIImage(systemName: iconbarBV))
        let titleLabelbarBV = UILabel()
        let costPillbarBV = messageCostPillbarBV()
        let dividerbarBV = UIView()

        rowbarBV.isEnabled = enabledbarBV
        let mainColorbarBV = enabledbarBV ? (emphasizedbarBV ? BaurbstyleStorebarBV.purple : UIColor(red: 37 / 255, green: 15 / 255, blue: 73 / 255, alpha: 1)) : UIColor.systemGray3
        iconViewbarBV.tintColor = mainColorbarBV
        iconViewbarBV.contentMode = .scaleAspectFit
        titleLabelbarBV.text = titlebarBV
        titleLabelbarBV.font = BaurbstyleStorebarBV.fontbarBV(20, weight: .heavy)
        titleLabelbarBV.textColor = mainColorbarBV
        BaurbstyleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.72, linesbarBV: 1)
        costPillbarBV.isHidden = valuebarBV == nil
        costPillbarBV.configurebarBV(valuebarBV: valuebarBV ?? "")
        dividerbarBV.backgroundColor = UIColor.systemGray5.withAlphaComponent(0.9)
        dividerbarBV.isHidden = !showsDividerbarBV

        [iconViewbarBV, titleLabelbarBV, costPillbarBV, dividerbarBV].forEach {
            rowbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        rowbarBV.addAction(UIAction { [weak self] _ in
            self?.onChoosebarBV?(actionbarBV)
        }, for: .touchUpInside)

        NSLayoutConstraint.activate([
            iconViewbarBV.leadingAnchor.constraint(equalTo: rowbarBV.leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            iconViewbarBV.centerYAnchor.constraint(equalTo: rowbarBV.centerYAnchor),
            iconViewbarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(25, minimumbarBV: 22, maximumbarBV: 27)),
            iconViewbarBV.heightAnchor.constraint(equalTo: iconViewbarBV.widthAnchor),

            titleLabelbarBV.leadingAnchor.constraint(equalTo: iconViewbarBV.trailingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            titleLabelbarBV.centerYAnchor.constraint(equalTo: rowbarBV.centerYAnchor),
            titleLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: costPillbarBV.leadingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(8, minimumbarBV: 6, maximumbarBV: 10)),

            costPillbarBV.trailingAnchor.constraint(equalTo: rowbarBV.trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            costPillbarBV.centerYAnchor.constraint(equalTo: rowbarBV.centerYAnchor),
            costPillbarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(86, minimumbarBV: 74, maximumbarBV: 92)),
            costPillbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(32, minimumbarBV: 28, maximumbarBV: 34)),

            dividerbarBV.leadingAnchor.constraint(equalTo: rowbarBV.leadingAnchor),
            dividerbarBV.trailingAnchor.constraint(equalTo: rowbarBV.trailingAnchor),
            dividerbarBV.bottomAnchor.constraint(equalTo: rowbarBV.bottomAnchor),
            dividerbarBV.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])
        return rowbarBV
    }
}

final class messageCostPillbarBV: UIView {
    private let gradientbarBV = CAGradientLayer()
    private let valueLabelbarBV = UILabel()
    private let coinIconbarBV = UIImageView(image: UIImage(systemName: "circle.fill"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        configurebarBV()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configurebarBV()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientbarBV.frame = bounds
        gradientbarBV.cornerRadius = bounds.height / 2
        layer.cornerRadius = bounds.height / 2
    }

    func configurebarBV(valuebarBV: String) {
        valueLabelbarBV.text = valuebarBV
    }

    private func configurebarBV() {
        clipsToBounds = true
        gradientbarBV.colors = [BaurbstyleStorebarBV.mint.cgColor, BaurbstyleStorebarBV.purple.cgColor, BaurbstyleStorebarBV.pink.cgColor]
        gradientbarBV.startPoint = CGPoint(x: 0, y: 0.5)
        gradientbarBV.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientbarBV, at: 0)

        valueLabelbarBV.font = BaurbstyleStorebarBV.fontbarBV(14, weight: .bold)
        valueLabelbarBV.textColor = .white
        valueLabelbarBV.textAlignment = .right
        BaurbstyleStorebarBV.labelFitbarBV(valueLabelbarBV, factorbarBV: 0.72, linesbarBV: 1)
        coinIconbarBV.tintColor = UIColor(red: 1, green: 210 / 255, blue: 64 / 255, alpha: 1)
        coinIconbarBV.contentMode = .scaleAspectFit

        [valueLabelbarBV, coinIconbarBV].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            valueLabelbarBV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 11)),
            valueLabelbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueLabelbarBV.trailingAnchor.constraint(equalTo: coinIconbarBV.leadingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(4, minimumbarBV: 3, maximumbarBV: 5)),

            coinIconbarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 11)),
            coinIconbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            coinIconbarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(13, minimumbarBV: 11, maximumbarBV: 14)),
            coinIconbarBV.heightAnchor.constraint(equalTo: coinIconbarBV.widthAnchor)
        ])
    }
}

final class aiReplyDraftSurfacebarBV: UIView, UITextViewDelegate {
    var onSendbarBV: ((String) -> Void)?
    var onNoticebarBV: ((String) -> Void)?
    var onRegenerateSpendbarBV: (() -> Bool)?
    var onToneEntrybarBV: (() -> Void)?

    private let messagebarBV: messageFixturebarBV
    private let replyNamebarBV: String
    private let replyTimebarBV: String
    private let startRegeneratedbarBV: Bool
    private var selectedTonebarBV: replyStylebarBV = .replyToneWarm
    private var regenCursorbarBV = 0

    private let stackbarBV = UIStackView()
    private let cardbarBV = UIView()
    private let stripbarBV = gradientBadgebarBV()
    private let cardStackbarBV = UIStackView()
    private let quoteCardbarBV = UIView()
    private let quoteLinebarBV = UIView()
    private let quoteMetabarBV = UILabel()
    private let quoteTextbarBV = UILabel()
    private let draftBadgebarBV = gradientPill(type: .system)
    private let tonePillbarBV = UILabel()
    private let freeLabelbarBV = UILabel()
    private let draftBoxbarBV = UIView()
    private let draftTextViewbarBV = UITextView()
    private let draftPlaceholderbarBV = UILabel()
    private let regenButtonbarBV = UIButton(type: .system)
    private let editButtonbarBV = UIButton(type: .system)
    private let sendButtonbarBV = gradientPill(type: .system)
    private let styleCardbarBV = UIView()
    private let styleOptionsbarBV = UIStackView()

    init(messagebarBV: messageFixturebarBV, replyNamebarBV: String, replyTimebarBV: String, initialTonebarBV: replyStylebarBV = .replyToneWarm, startRegeneratedbarBV: Bool = false) {
        self.messagebarBV = messagebarBV
        self.replyNamebarBV = replyNamebarBV
        self.replyTimebarBV = replyTimebarBV
        self.startRegeneratedbarBV = startRegeneratedbarBV
        self.selectedTonebarBV = initialTonebarBV
        super.init(frame: .zero)
        configurebarBV()
        if startRegeneratedbarBV {
            regenCursorbarBV = 1
            applyTonebarBV(regenbarBV: true)
        } else {
            applyTonebarBV(regenbarBV: false)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configurebarBV() {
        stackbarBV.axis = .vertical
        stackbarBV.spacing = BaurbstyleStorebarBV.spacebarBV(12, minimumbarBV: 10, maximumbarBV: 14)
        addSubview(stackbarBV)
        stackbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackbarBV.topAnchor.constraint(equalTo: topAnchor),
            stackbarBV.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackbarBV.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackbarBV.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        configureDraftCardbarBV()
        configureStyleCardbarBV()
        stackbarBV.addArrangedSubview(cardbarBV)
        stackbarBV.addArrangedSubview(styleCardbarBV)
    }

    private func configureDraftCardbarBV() {
        cardbarBV.backgroundColor = .white
        cardbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(28, minimumbarBV: 22, maximumbarBV: 31)
        cardbarBV.layer.masksToBounds = true
        cardbarBV.addSubview(stripbarBV)
        cardbarBV.addSubview(cardStackbarBV)
        [stripbarBV, cardStackbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        stripbarBV.colorsbarBV = BaurbstyleStorebarBV.cardStripColorsbarBV
        stripbarBV.locationsbarBV = BaurbstyleStorebarBV.cardStripLocationsbarBV
        stripbarBV.alpha = 0.9

        cardStackbarBV.axis = .vertical
        cardStackbarBV.spacing = BaurbstyleStorebarBV.spacebarBV(13, minimumbarBV: 10, maximumbarBV: 15)
        cardStackbarBV.alignment = .fill

        configureQuoteCardbarBV()
        configureToneRowbarBV()
        configureDraftBoxbarBV()
        configureActionRowbarBV()

        let toneRowbarBV = UIStackView(arrangedSubviews: [tonePillbarBV, freeLabelbarBV])
        toneRowbarBV.axis = .horizontal
        toneRowbarBV.alignment = .center
        toneRowbarBV.distribution = .equalSpacing

        let actionRowbarBV = UIStackView(arrangedSubviews: [regenButtonbarBV, editButtonbarBV, sendButtonbarBV])
        actionRowbarBV.axis = .horizontal
        actionRowbarBV.spacing = BaurbstyleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 12)
        actionRowbarBV.distribution = .fillEqually

        [quoteCardbarBV, toneRowbarBV, draftBoxbarBV, actionRowbarBV].forEach {
            cardStackbarBV.addArrangedSubview($0)
        }

        let draftHeightbarBV = BaurbstyleStorebarBV.metricbarBV(BaurbstyleStorebarBV.compactHeightbarBV ? 104 : 118, minimumbarBV: 96, maximumbarBV: 132)
        NSLayoutConstraint.activate([
            stripbarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor),
            stripbarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor),
            stripbarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor),
            stripbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(112, minimumbarBV: 92, maximumbarBV: 120)),

            cardStackbarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            cardStackbarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            cardStackbarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            cardStackbarBV.bottomAnchor.constraint(equalTo: cardbarBV.bottomAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(20, minimumbarBV: 16, maximumbarBV: 22)),

            quoteCardbarBV.heightAnchor.constraint(greaterThanOrEqualToConstant: BaurbstyleStorebarBV.metricbarBV(92, minimumbarBV: 78, maximumbarBV: 98)),
            tonePillbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(36)),
            tonePillbarBV.widthAnchor.constraint(greaterThanOrEqualToConstant: BaurbstyleStorebarBV.metricbarBV(100, minimumbarBV: 88, maximumbarBV: 112)),
            draftBoxbarBV.heightAnchor.constraint(equalToConstant: draftHeightbarBV),
            actionRowbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(48))
        ])
    }

    private func configureQuoteCardbarBV() {
        quoteCardbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.98)
        quoteCardbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(14, minimumbarBV: 12, maximumbarBV: 16)
        quoteCardbarBV.layer.masksToBounds = true
        quoteCardbarBV.addSubview(quoteLinebarBV)
        quoteCardbarBV.addSubview(quoteMetabarBV)
        quoteCardbarBV.addSubview(quoteTextbarBV)
        quoteCardbarBV.addSubview(draftBadgebarBV)
        [quoteLinebarBV, quoteMetabarBV, quoteTextbarBV, draftBadgebarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        quoteLinebarBV.backgroundColor = BaurbstyleStorebarBV.blue
        quoteMetabarBV.text = "↳ REPLYING TO \(replyNamebarBV) · \(replyTimebarBV)"
        quoteMetabarBV.font = BaurbstyleStorebarBV.fontbarBV(11, weight: .heavy)
        quoteMetabarBV.textColor = BaurbstyleStorebarBV.blue
        quoteMetabarBV.numberOfLines = 1
        BaurbstyleStorebarBV.labelFitbarBV(quoteMetabarBV, factorbarBV: 0.68, linesbarBV: 1)

        quoteTextbarBV.text = "\"\(messagebarBV.messageCopybarBV)\""
        quoteTextbarBV.font = BaurbstyleStorebarBV.fontbarBV(14, weight: .regular)
        quoteTextbarBV.textColor = UIColor(red: 37 / 255, green: 15 / 255, blue: 73 / 255, alpha: 1)
        quoteTextbarBV.numberOfLines = 2
        quoteTextbarBV.lineBreakMode = .byTruncatingTail

        draftBadgebarBV.setTitle("AI DRAFT", for: .normal)
        draftBadgebarBV.setTitleColor(.white, for: .normal)
        draftBadgebarBV.titleLabel?.font = BaurbstyleStorebarBV.fontbarBV(13, weight: .heavy)
        draftBadgebarBV.isUserInteractionEnabled = false

        NSLayoutConstraint.activate([
            quoteLinebarBV.leadingAnchor.constraint(equalTo: quoteCardbarBV.leadingAnchor),
            quoteLinebarBV.topAnchor.constraint(equalTo: quoteCardbarBV.topAnchor),
            quoteLinebarBV.bottomAnchor.constraint(equalTo: quoteCardbarBV.bottomAnchor),
            quoteLinebarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(3, minimumbarBV: 2, maximumbarBV: 3)),

            quoteMetabarBV.leadingAnchor.constraint(equalTo: quoteCardbarBV.leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            quoteMetabarBV.trailingAnchor.constraint(lessThanOrEqualTo: draftBadgebarBV.leadingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(8, minimumbarBV: 6, maximumbarBV: 10)),
            quoteMetabarBV.topAnchor.constraint(equalTo: quoteCardbarBV.topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(16, minimumbarBV: 12, maximumbarBV: 18)),

            quoteTextbarBV.leadingAnchor.constraint(equalTo: quoteMetabarBV.leadingAnchor),
            quoteTextbarBV.trailingAnchor.constraint(equalTo: quoteCardbarBV.trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 12, maximumbarBV: 18)),
            quoteTextbarBV.topAnchor.constraint(equalTo: quoteMetabarBV.bottomAnchor, constant: BaurbstyleStorebarBV.spacebarBV(7, minimumbarBV: 5, maximumbarBV: 8)),
            quoteTextbarBV.bottomAnchor.constraint(lessThanOrEqualTo: quoteCardbarBV.bottomAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(12, minimumbarBV: 10, maximumbarBV: 14)),

            draftBadgebarBV.trailingAnchor.constraint(equalTo: quoteCardbarBV.trailingAnchor),
            draftBadgebarBV.topAnchor.constraint(equalTo: quoteCardbarBV.topAnchor),
            draftBadgebarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(122, minimumbarBV: 104, maximumbarBV: 128)),
            draftBadgebarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(38))
        ])
    }

    private func configureToneRowbarBV() {
        tonePillbarBV.backgroundColor = UIColor(red: 247 / 255, green: 45 / 255, blue: 155 / 255, alpha: 1)
        tonePillbarBV.textColor = .white
        tonePillbarBV.textAlignment = .center
        tonePillbarBV.font = BaurbstyleStorebarBV.fontbarBV(15, weight: .heavy)
        tonePillbarBV.layer.cornerRadius = BaurbstyleStorebarBV.controlbarBV(36) / 2
        tonePillbarBV.layer.masksToBounds = true
        BaurbstyleStorebarBV.labelFitbarBV(tonePillbarBV, factorbarBV: 0.72, linesbarBV: 1)

        freeLabelbarBV.text = "FREE THIS DRAFT"
        freeLabelbarBV.font = BaurbstyleStorebarBV.fontbarBV(12, weight: .heavy)
        freeLabelbarBV.textColor = UIColor(red: 37 / 255, green: 15 / 255, blue: 73 / 255, alpha: 1)
        freeLabelbarBV.textAlignment = .right
        BaurbstyleStorebarBV.labelFitbarBV(freeLabelbarBV, factorbarBV: 0.68, linesbarBV: 1)
    }

    private func configureDraftBoxbarBV() {
        draftBoxbarBV.backgroundColor = .white
        draftBoxbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(14, minimumbarBV: 12, maximumbarBV: 16)
        draftBoxbarBV.layer.borderWidth = 1
        draftBoxbarBV.layer.borderColor = UIColor(red: 192 / 255, green: 235 / 255, blue: 1, alpha: 1).cgColor
        draftBoxbarBV.addSubview(draftTextViewbarBV)
        draftTextViewbarBV.translatesAutoresizingMaskIntoConstraints = false

        draftTextViewbarBV.backgroundColor = .clear
        draftTextViewbarBV.font = BaurbstyleStorebarBV.fontbarBV(17, weight: .regular)
        draftTextViewbarBV.textColor = .black
        draftTextViewbarBV.isEditable = false
        draftTextViewbarBV.isScrollEnabled = true
        draftTextViewbarBV.delegate = self
        draftTextViewbarBV.textContainerInset = UIEdgeInsets(
            top: BaurbstyleStorebarBV.spacebarBV(12, minimumbarBV: 9, maximumbarBV: 14),
            left: BaurbstyleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 12),
            bottom: BaurbstyleStorebarBV.spacebarBV(10, minimumbarBV: 8, maximumbarBV: 12),
            right: BaurbstyleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 12)
        )

        draftPlaceholderbarBV.text = "Please enter your reply..."
        draftPlaceholderbarBV.font = BaurbstyleStorebarBV.fontbarBV(17, weight: .regular)
        draftPlaceholderbarBV.textColor = BaurbstyleStorebarBV.mutedText
        draftTextViewbarBV.addSubview(draftPlaceholderbarBV)
        draftPlaceholderbarBV.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            draftTextViewbarBV.topAnchor.constraint(equalTo: draftBoxbarBV.topAnchor),
            draftTextViewbarBV.leadingAnchor.constraint(equalTo: draftBoxbarBV.leadingAnchor),
            draftTextViewbarBV.trailingAnchor.constraint(equalTo: draftBoxbarBV.trailingAnchor),
            draftTextViewbarBV.bottomAnchor.constraint(equalTo: draftBoxbarBV.bottomAnchor),

            draftPlaceholderbarBV.topAnchor.constraint(equalTo: draftTextViewbarBV.topAnchor, constant: draftTextViewbarBV.textContainerInset.top + 1),
            draftPlaceholderbarBV.leadingAnchor.constraint(equalTo: draftTextViewbarBV.leadingAnchor, constant: draftTextViewbarBV.textContainerInset.left + 5),
            draftPlaceholderbarBV.trailingAnchor.constraint(lessThanOrEqualTo: draftTextViewbarBV.trailingAnchor, constant: -draftTextViewbarBV.textContainerInset.right)
        ])
    }

    private func configureActionRowbarBV() {
        configureActionButtonbarBV(regenButtonbarBV, titlebarBV: "Regen", backgroundbarBV: .white)
        regenButtonbarBV.layer.borderWidth = 1
        regenButtonbarBV.layer.borderColor = UIColor.systemGray4.cgColor
        regenButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.regeneratebarBV()
        }, for: .touchUpInside)

        configureActionButtonbarBV(editButtonbarBV, titlebarBV: "Edit", backgroundbarBV: UIColor.systemGray6)
        editButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.beginEditingbarBV()
        }, for: .touchUpInside)

        sendButtonbarBV.setTitle("Send", for: .normal)
        sendButtonbarBV.setTitleColor(.black, for: .normal)
        sendButtonbarBV.titleLabel?.font = BaurbstyleStorebarBV.fontbarBV(16, weight: .heavy)
        sendButtonbarBV.colorsbarBV = [BaurbstyleStorebarBV.mint, UIColor(red: 1, green: 215 / 255, blue: 251 / 255, alpha: 0.6), BaurbstyleStorebarBV.pink, BaurbstyleStorebarBV.mint]
        sendButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.sendDraftbarBV()
        }, for: .touchUpInside)
    }

    private func configureActionButtonbarBV(_ buttonbarBV: UIButton, titlebarBV: String, backgroundbarBV: UIColor) {
        buttonbarBV.setTitle(titlebarBV, for: .normal)
        buttonbarBV.setTitleColor(UIColor(red: 37 / 255, green: 15 / 255, blue: 73 / 255, alpha: 1), for: .normal)
        buttonbarBV.titleLabel?.font = BaurbstyleStorebarBV.fontbarBV(16, weight: .bold)
        buttonbarBV.backgroundColor = backgroundbarBV
        buttonbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(14, minimumbarBV: 12, maximumbarBV: 16)
        buttonbarBV.layer.masksToBounds = true
        BaurbstyleStorebarBV.buttonFitbarBV(buttonbarBV)
    }

    private func configureStyleCardbarBV() {
        styleCardbarBV.backgroundColor = .white
        styleCardbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(16, minimumbarBV: 14, maximumbarBV: 18)
        styleCardbarBV.layer.masksToBounds = true

        let titleIconbarBV = UIImageView(image: UIImage(systemName: "sparkles"))
        titleIconbarBV.tintColor = BaurbstyleStorebarBV.purple
        titleIconbarBV.contentMode = .scaleAspectFit
        let titlebarBV = UILabel()
        titlebarBV.text = "AI REPLY STYLE"
        titlebarBV.font = BaurbstyleStorebarBV.fontbarBV(13, weight: .heavy)
        titlebarBV.textColor = .black
        BaurbstyleStorebarBV.labelFitbarBV(titlebarBV, factorbarBV: 0.72, linesbarBV: 1)
        let robotbarBV = UIImageView(image: UIImage(named: "AIIconbarBV") ?? UIImage(systemName: "sparkles"))
        robotbarBV.contentMode = .scaleAspectFit
        let entrybarBV = UIButton(type: .system)
        entrybarBV.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        entrybarBV.tintColor = UIColor.black.withAlphaComponent(0.38)
        entrybarBV.accessibilityLabel = "AI Tones"
        entrybarBV.addAction(UIAction { [weak self] _ in
            self?.onToneEntrybarBV?()
        }, for: .touchUpInside)

        let headerbarBV = UIStackView(arrangedSubviews: [titleIconbarBV, titlebarBV, UIView(), robotbarBV, entrybarBV])
        headerbarBV.axis = .horizontal
        headerbarBV.alignment = .center
        headerbarBV.spacing = BaurbstyleStorebarBV.metricbarBV(8, minimumbarBV: 6, maximumbarBV: 10)

        styleOptionsbarBV.axis = .horizontal
        styleOptionsbarBV.alignment = .fill
        styleOptionsbarBV.distribution = .fillEqually
        styleOptionsbarBV.spacing = BaurbstyleStorebarBV.metricbarBV(9, minimumbarBV: 7, maximumbarBV: 11)

        let styleStackbarBV = UIStackView(arrangedSubviews: [headerbarBV, styleOptionsbarBV])
        styleStackbarBV.axis = .vertical
        styleStackbarBV.spacing = BaurbstyleStorebarBV.spacebarBV(12, minimumbarBV: 10, maximumbarBV: 14)
        styleCardbarBV.addSubview(styleStackbarBV)
        styleStackbarBV.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            styleStackbarBV.topAnchor.constraint(equalTo: styleCardbarBV.topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(14, minimumbarBV: 12, maximumbarBV: 16)),
            styleStackbarBV.leadingAnchor.constraint(equalTo: styleCardbarBV.leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(15, minimumbarBV: 12, maximumbarBV: 18)),
            styleStackbarBV.trailingAnchor.constraint(equalTo: styleCardbarBV.trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(15, minimumbarBV: 12, maximumbarBV: 18)),
            styleStackbarBV.bottomAnchor.constraint(equalTo: styleCardbarBV.bottomAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(14, minimumbarBV: 12, maximumbarBV: 16)),
            titleIconbarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(18, minimumbarBV: 16, maximumbarBV: 20)),
            titleIconbarBV.heightAnchor.constraint(equalTo: titleIconbarBV.widthAnchor),
            robotbarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(38, minimumbarBV: 32, maximumbarBV: 42)),
            robotbarBV.heightAnchor.constraint(equalTo: robotbarBV.widthAnchor),
            entrybarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(30, minimumbarBV: 28, maximumbarBV: 32)),
            entrybarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(30, minimumbarBV: 28, maximumbarBV: 32)),
            styleOptionsbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(48))
        ])
        renderStyleButtonsbarBV()
    }

    private func renderStyleButtonsbarBV() {
        styleOptionsbarBV.arrangedSubviews.forEach {
            styleOptionsbarBV.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        var tonesbarBV: [replyStylebarBV] = [.replyToneWarm, .replyToneShortbarBV, .replyTonePolite]
        if !tonesbarBV.contains(selectedTonebarBV) {
            tonesbarBV.append(selectedTonebarBV)
        }
        for tonebarBV in tonesbarBV {
            let selectedbarBV = tonebarBV == selectedTonebarBV
            let buttonbarBV: UIButton = selectedbarBV ? gradientPill(type: .system) : UIButton(type: .system)
            if let gradientbarBV = buttonbarBV as? gradientPill {
                gradientbarBV.colorsbarBV = BaurbstyleStorebarBV.replyChoiceColorsbarBV
                gradientbarBV.locationsbarBV = BaurbstyleStorebarBV.replyChoiceLocationsbarBV
            }
            buttonbarBV.setTitle(tonebarBV.rawValue, for: .normal)
            buttonbarBV.setTitleColor(selectedbarBV ? .white : .darkGray, for: .normal)
            buttonbarBV.titleLabel?.font = BaurbstyleStorebarBV.fontbarBV(tonesbarBV.count > 3 ? 13 : 15, weight: .heavy)
            buttonbarBV.backgroundColor = selectedbarBV ? .clear : UIColor.systemGray6
            buttonbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)
            buttonbarBV.layer.masksToBounds = true
            BaurbstyleStorebarBV.buttonFitbarBV(buttonbarBV)
            buttonbarBV.addAction(UIAction { [weak self] _ in
                self?.selectTonebarBV(tonebarBV)
            }, for: .touchUpInside)
            styleOptionsbarBV.addArrangedSubview(buttonbarBV)
        }
    }

    private func selectTonebarBV(_ tonebarBV: replyStylebarBV) {
        selectedTonebarBV = tonebarBV
        regenCursorbarBV = 0
        draftTextViewbarBV.resignFirstResponder()
        draftTextViewbarBV.isEditable = false
        applyTonebarBV(regenbarBV: false)
    }

    private func regeneratebarBV() {
        guard onRegenerateSpendbarBV?() ?? true else { return }
        draftTextViewbarBV.resignFirstResponder()
        draftTextViewbarBV.isEditable = false
        regenCursorbarBV += 1
        applyTonebarBV(regenbarBV: true)
    }

    private func beginEditingbarBV() {
        draftTextViewbarBV.isEditable = true
        draftTextViewbarBV.becomeFirstResponder()
        updatePlaceholderbarBV()
    }

    private func sendDraftbarBV() {
        let textbarBV = draftTextViewbarBV.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !textbarBV.isEmpty else {
            onNoticebarBV?("Please enter your reply.")
            return
        }
        onSendbarBV?(textbarBV)
    }

    private func applyTonebarBV(regenbarBV: Bool) {
        tonePillbarBV.text = " •  \(selectedTonebarBV.rawValue) "
        draftTextViewbarBV.text = generateBarbAIReplybarBV(tonebarBV: selectedTonebarBV, regenbarBV: regenbarBV)
        updatePlaceholderbarBV()
        renderStyleButtonsbarBV()
    }

    private func generateBarbAIReplybarBV(tonebarBV: replyStylebarBV, regenbarBV: Bool) -> String {
        barbVaultbarBV.shared.generatedDraftbarBV(
            for: messagebarBV,
            tone: tonebarBV,
            variantbarBV: regenbarBV ? regenCursorbarBV : nil
        )
    }

    private func updatePlaceholderbarBV() {
        draftPlaceholderbarBV.isHidden = !draftTextViewbarBV.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderbarBV()
    }
}

final class messageSurfacebarBV: UITableViewCell {
    static let reuseID = "messageSurfacebarBV"
    private let avatarbarBV = avatarSurfacebarBV(initial: "B")
    private let bubblebarBV = UIView()
    private let contentStackbarBV = UIStackView()
    private let senderLabelbarBV = UILabel()
    private let textLabelbarBV = UILabel()
    private var layoutConstraintsbarBV: [NSLayoutConstraint] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        configureBubblebarBV()
        configureLayoutbarBV()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configurebarBV(messagebarBV: messageFixturebarBV, storebarBV: barbVaultbarBV, groupFlagbarBV: Bool = false) {
        let sentbarBV = messagebarBV.sentFlag
        avatarbarBV.text = avatarTextbarBV(messagebarBV: messagebarBV, storebarBV: storebarBV)
        avatarbarBV.backgroundColor = sentbarBV ? BaurbstyleStorebarBV.purple : BaurbstyleStorebarBV.pink
        bubblebarBV.backgroundColor = sentbarBV ? BaurbstyleStorebarBV.blue : UIColor.white.withAlphaComponent(0.96)
        bubblebarBV.layer.borderWidth = sentbarBV ? 0 : 1
        bubblebarBV.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        textLabelbarBV.textColor = sentbarBV ? .white : .black

        textLabelbarBV.isHidden = true
        senderLabelbarBV.isHidden = true
        bubblebarBV.backgroundColor = sentbarBV ? BaurbstyleStorebarBV.blue : UIColor.white.withAlphaComponent(0.96)
        if groupFlagbarBV && !sentbarBV {
            senderLabelbarBV.text = senderNamebarBV(messagebarBV: messagebarBV, storebarBV: storebarBV)
            senderLabelbarBV.isHidden = false
        }

        textLabelbarBV.text = messagebarBV.messageCopybarBV
        textLabelbarBV.isHidden = false
        updateAlignmentbarBV(sentbarBV: sentbarBV)
    }

    private func configureBubblebarBV() {
        contentView.addSubview(avatarbarBV)
        contentView.addSubview(bubblebarBV)
        avatarbarBV.translatesAutoresizingMaskIntoConstraints = false
        bubblebarBV.translatesAutoresizingMaskIntoConstraints = false
        bubblebarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(20, minimumbarBV: 17, maximumbarBV: 22)
        bubblebarBV.layer.masksToBounds = true

        contentStackbarBV.axis = .vertical
        contentStackbarBV.alignment = .fill
        contentStackbarBV.spacing = BaurbstyleStorebarBV.metricbarBV(6, minimumbarBV: 4, maximumbarBV: 7)
        bubblebarBV.addSubview(contentStackbarBV)
        contentStackbarBV.translatesAutoresizingMaskIntoConstraints = false

        textLabelbarBV.font = BaurbstyleStorebarBV.fontbarBV(16, weight: .regular)
        textLabelbarBV.numberOfLines = 0
        textLabelbarBV.lineBreakMode = .byWordWrapping
        senderLabelbarBV.font = BaurbstyleStorebarBV.fontbarBV(12, weight: .heavy)
        senderLabelbarBV.textColor = BaurbstyleStorebarBV.purple
        senderLabelbarBV.numberOfLines = 1
        senderLabelbarBV.lineBreakMode = .byTruncatingTail
        contentStackbarBV.addArrangedSubview(senderLabelbarBV)
        contentStackbarBV.addArrangedSubview(textLabelbarBV)

        NSLayoutConstraint.activate([
            avatarbarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(34, minimumbarBV: 30, maximumbarBV: 36)),
            avatarbarBV.heightAnchor.constraint(equalTo: avatarbarBV.widthAnchor),
            bubblebarBV.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.72),
            contentStackbarBV.topAnchor.constraint(equalTo: bubblebarBV.topAnchor, constant: BaurbstyleStorebarBV.metricbarBV(11, minimumbarBV: 9, maximumbarBV: 12)),
            contentStackbarBV.leadingAnchor.constraint(equalTo: bubblebarBV.leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(14, minimumbarBV: 12, maximumbarBV: 16)),
            contentStackbarBV.trailingAnchor.constraint(equalTo: bubblebarBV.trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(14, minimumbarBV: 12, maximumbarBV: 16)),
            contentStackbarBV.bottomAnchor.constraint(equalTo: bubblebarBV.bottomAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(11, minimumbarBV: 9, maximumbarBV: 12))
        ])
    }

    private func configureLayoutbarBV() {
        NSLayoutConstraint.activate([
            bubblebarBV.topAnchor.constraint(equalTo: contentView.topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(5, minimumbarBV: 4, maximumbarBV: 7)),
            bubblebarBV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(5, minimumbarBV: 4, maximumbarBV: 7))
        ])
    }

    private func updateAlignmentbarBV(sentbarBV: Bool) {
        NSLayoutConstraint.deactivate(layoutConstraintsbarBV)
        let sideInsetbarBV = BaurbstyleStorebarBV.metricbarBV(14, minimumbarBV: 12, maximumbarBV: 18)
        let avatarGapbarBV = BaurbstyleStorebarBV.metricbarBV(8, minimumbarBV: 6, maximumbarBV: 10)
        if sentbarBV {
            layoutConstraintsbarBV = [
                avatarbarBV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sideInsetbarBV),
                avatarbarBV.bottomAnchor.constraint(equalTo: bubblebarBV.bottomAnchor),
                bubblebarBV.trailingAnchor.constraint(equalTo: avatarbarBV.leadingAnchor, constant: -avatarGapbarBV),
                bubblebarBV.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(72, minimumbarBV: 58, maximumbarBV: 82))
            ]
        } else {
            layoutConstraintsbarBV = [
                avatarbarBV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideInsetbarBV),
                avatarbarBV.bottomAnchor.constraint(equalTo: bubblebarBV.bottomAnchor),
                bubblebarBV.leadingAnchor.constraint(equalTo: avatarbarBV.trailingAnchor, constant: avatarGapbarBV),
                bubblebarBV.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(72, minimumbarBV: 58, maximumbarBV: 82))
            ]
        }
        NSLayoutConstraint.activate(layoutConstraintsbarBV)
    }

    private func avatarTextbarBV(messagebarBV: messageFixturebarBV, storebarBV: barbVaultbarBV) -> String {
        if messagebarBV.sentFlag {
            if let profilebarBV = BaurbsessionStore.profileSnapshotbarBV {
                if !profilebarBV.placeholderAvatar.isEmpty {
                    return profilebarBV.placeholderAvatar
                }
                return profilebarBV.placeholderNamebarBV.first.map(String.init) ?? "B"
            }
            return "B"
        }
        return storebarBV.contactMatcherbarBV(contactSeed: messagebarBV.personaSeed)?.placeholderAvatar ?? "M"
    }

    private func senderNamebarBV(messagebarBV: messageFixturebarBV, storebarBV: barbVaultbarBV) -> String {
        storebarBV.contactMatcherbarBV(contactSeed: messagebarBV.personaSeed)?.placeholderNamebarBV ?? "Group member"
    }
}
