import UIKit

final class inboxSurfacebarBV: localSurfacebarBV, UITableViewDataSource, UITableViewDelegate {
    private let store: localStorebarBV
    private let headerBarbarBV = UIView()
    private let titleLabelbarBV = UILabel()
    private let addButtonbarBV = UIButton(type: .system)
    private let profileAvatarbarBV = avatarSurfacebarBV(initial: "B", color: styleStorebarBV.pink)
    private let tableView = UITableView(frame: .zero, style: .plain)

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
        configureHeaderbarBV()
        configureTablebarBV()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        reloadProfilebarBV()
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureHeaderbarBV() {
        titleLabelbarBV.text = "Message"
        titleLabelbarBV.font = styleStorebarBV.fontbarBV(34, weight: .heavy)
        titleLabelbarBV.textColor = .black
        styleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.72, linesbarBV: 1)

        addButtonbarBV.setImage(UIImage(systemName: "plus"), for: .normal)
        addButtonbarBV.tintColor = .black
        addButtonbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.94)
        addButtonbarBV.layer.cornerRadius = styleStorebarBV.controlbarBV(44) / 2
        addButtonbarBV.layer.shadowColor = UIColor.black.cgColor
        addButtonbarBV.layer.shadowOpacity = 0.06
        addButtonbarBV.layer.shadowRadius = 10
        addButtonbarBV.layer.shadowOffset = CGSize(width: 0, height: 4)
        addButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.presentNoticebarBV(titlebarBV: "Message", messagebarBV: "New conversation is a local placeholder.")
        }, for: .touchUpInside)

        view.addSubview(headerBarbarBV)
        [titleLabelbarBV, addButtonbarBV, profileAvatarbarBV].forEach {
            headerBarbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        headerBarbarBV.translatesAutoresizingMaskIntoConstraints = false

        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 32)
        let toolSizebarBV = styleStorebarBV.controlbarBV(44)
        NSLayoutConstraint.activate([
            headerBarbarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: styleStorebarBV.spacebarBV(22, minimumbarBV: 14, maximumbarBV: 28)),
            headerBarbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInsetbarBV),
            headerBarbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInsetbarBV),
            headerBarbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(54, minimumbarBV: 48, maximumbarBV: 58)),

            titleLabelbarBV.leadingAnchor.constraint(equalTo: headerBarbarBV.leadingAnchor),
            titleLabelbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            titleLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: addButtonbarBV.leadingAnchor, constant: -styleStorebarBV.metricbarBV(14, minimumbarBV: 10, maximumbarBV: 16)),

            addButtonbarBV.trailingAnchor.constraint(equalTo: profileAvatarbarBV.leadingAnchor, constant: -styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            addButtonbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            addButtonbarBV.widthAnchor.constraint(equalToConstant: toolSizebarBV),
            addButtonbarBV.heightAnchor.constraint(equalToConstant: toolSizebarBV),

            profileAvatarbarBV.trailingAnchor.constraint(equalTo: headerBarbarBV.trailingAnchor),
            profileAvatarbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            profileAvatarbarBV.widthAnchor.constraint(equalToConstant: toolSizebarBV),
            profileAvatarbarBV.heightAnchor.constraint(equalToConstant: toolSizebarBV)
        ])
        reloadProfilebarBV()
    }

    private func configureTablebarBV() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: styleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 18), right: 0)
        tableView.register(threadSurface.self, forCellReuseIdentifier: threadSurface.reuseID)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerBarbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 22)),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: styleStorebarBV.metricbarBV(28, minimumbarBV: 20, maximumbarBV: 30)),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -styleStorebarBV.metricbarBV(28, minimumbarBV: 20, maximumbarBV: 30)),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func reloadProfilebarBV() {
        profileAvatarbarBV.text = sessionStore.profileLocalbarBV?.placeholderAvatar ?? "B"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        store.threadPoolbarBV.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        styleStorebarBV.metricbarBV(94, minimumbarBV: 86, maximumbarBV: 102)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: threadSurface.reuseID, for: indexPath) as! threadSurface
        let thread = store.threadPoolbarBV[indexPath.row]
        cell.configure(thread: thread, latest: store.localThreadPreviewbarBV(for: thread), store: store)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(threadPagebarBV(store: store, thread: store.threadPoolbarBV[indexPath.row]), animated: true)
    }

    private func presentNoticebarBV(titlebarBV: String, messagebarBV: String) {
        let alertbarBV = UIAlertController(title: titlebarBV, message: messagebarBV, preferredStyle: .alert)
        alertbarBV.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertbarBV, animated: true)
    }
}

final class threadSurface: UITableViewCell {
    static let reuseID = "threadSurface"
    private let card = cardSurfacebarBV(cornerRadius: 20)
    private let avatar = avatarSurfacebarBV(initial: "B")
    private let groupAvatarbarBV = groupAvatarSurfacebarBV()
    private let titleLabel = UILabel()
    private let previewLabel = UILabel()
    private let statusLabel = UILabel()
    private let messageButtonbarBV = gradientPill(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        [avatar, groupAvatarbarBV, titleLabel, previewLabel, statusLabel, messageButtonbarBV].forEach {
            card.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        card.layer.cornerRadius = styleStorebarBV.metricbarBV(24, minimumbarBV: 20, maximumbarBV: 26)
        titleLabel.font = styleStorebarBV.fontbarBV(18, weight: .heavy)
        styleStorebarBV.labelFitbarBV(titleLabel, factorbarBV: 0.68, linesbarBV: 1)
        previewLabel.font = styleStorebarBV.fontbarBV(14, weight: .regular)
        previewLabel.textColor = .darkGray
        styleStorebarBV.labelFitbarBV(previewLabel, factorbarBV: 0.72, linesbarBV: 1)
        statusLabel.font = styleStorebarBV.fontbarBV(12, weight: .semibold)
        statusLabel.textColor = .systemGreen
        styleStorebarBV.labelFitbarBV(statusLabel, factorbarBV: 0.64, linesbarBV: 1)
        messageButtonbarBV.setImage(UIImage(systemName: "message.fill"), for: .normal)
        messageButtonbarBV.tintColor = .white
        messageButtonbarBV.isUserInteractionEnabled = false
        messageButtonbarBV.colorsbarBV = styleStorebarBV.replyChoiceColorsbarBV
        messageButtonbarBV.locationsbarBV = styleStorebarBV.replyChoiceLocationsbarBV
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: styleStorebarBV.spacebarBV(6, minimumbarBV: 5, maximumbarBV: 8)),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -styleStorebarBV.spacebarBV(6, minimumbarBV: 5, maximumbarBV: 8)),
            avatar.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: styleStorebarBV.metricbarBV(16, minimumbarBV: 13, maximumbarBV: 18)),
            avatar.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            avatar.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(54, minimumbarBV: 48, maximumbarBV: 56)),
            avatar.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(54, minimumbarBV: 48, maximumbarBV: 56)),
            groupAvatarbarBV.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            groupAvatarbarBV.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            groupAvatarbarBV.widthAnchor.constraint(equalTo: avatar.widthAnchor),
            groupAvatarbarBV.heightAnchor.constraint(equalTo: avatar.heightAnchor),

            messageButtonbarBV.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -styleStorebarBV.metricbarBV(16, minimumbarBV: 13, maximumbarBV: 18)),
            messageButtonbarBV.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            messageButtonbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.controlbarBV(42)),
            messageButtonbarBV.heightAnchor.constraint(equalTo: messageButtonbarBV.widthAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: styleStorebarBV.metricbarBV(13, minimumbarBV: 10, maximumbarBV: 15)),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusLabel.leadingAnchor, constant: -styleStorebarBV.metricbarBV(8, minimumbarBV: 6, maximumbarBV: 10)),
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: styleStorebarBV.spacebarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            previewLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            previewLabel.trailingAnchor.constraint(equalTo: messageButtonbarBV.leadingAnchor, constant: -styleStorebarBV.metricbarBV(14, minimumbarBV: 10, maximumbarBV: 16)),
            previewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: styleStorebarBV.spacebarBV(5, minimumbarBV: 4, maximumbarBV: 6)),
            previewLabel.bottomAnchor.constraint(lessThanOrEqualTo: card.bottomAnchor, constant: -styleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 16)),

            statusLabel.trailingAnchor.constraint(equalTo: messageButtonbarBV.leadingAnchor, constant: -styleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            statusLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(thread: threadFixturebarBV, latest: messageFixturebarBV?, store: localStorebarBV) {
        titleLabel.text = thread.localThreadTitle
        previewLabel.text = store.previewTextbarBV(for: thread)
        if thread.smallGroupFlag {
            statusLabel.text = "\(store.groupMemberCountbarBV(for: thread)) members"
            statusLabel.textColor = styleStorebarBV.mutedText
            avatar.isHidden = true
            groupAvatarbarBV.isHidden = false
            let initialsbarBV = thread.personaPoolbarBV.compactMap {
                store.contactMatcherbarBV(contactSeed: $0)?.placeholderAvatar
            }
            groupAvatarbarBV.configurebarBV(initialsbarBV: initialsbarBV)
        } else {
            statusLabel.text = thread.unreadCounter > 0 ? "\(thread.unreadCounter) waiting" : "● Online"
            statusLabel.textColor = thread.unreadCounter > 0 ? styleStorebarBV.pink : .systemGreen
            avatar.isHidden = false
            groupAvatarbarBV.isHidden = true
            let initial = thread.localThreadTitle.first.map(String.init) ?? "B"
            avatar.text = initial
            avatar.backgroundColor = styleStorebarBV.purple
        }
    }
}
