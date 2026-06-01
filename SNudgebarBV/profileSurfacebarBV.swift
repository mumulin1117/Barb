import UIKit

final class profileSurfacebarBV: localSurfacebarBV {
    private let store: localStorebarBV
    private let stack = UIStackView()

    init(store: localStorebarBV) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        title = "Personal"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "qrcode"), style: .plain, target: nil, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: nil, action: nil)
        ]
        configure()
        reload()
    }

    private func configure() {
        let scroll = UIScrollView()
        view.addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 22
        scroll.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24)
        ])
    }

    private func reload() {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let localProfile = sessionStore.profileLocalbarBV
        let avatar = avatarSurfacebarBV(initial: localProfile?.placeholderAvatar ?? "B", color: styleStorebarBV.pink)
        avatar.font = .systemFont(ofSize: 56, weight: .bold)
        let name = UILabel()
        name.text = localProfile?.placeholderNamebarBV ?? "Test User"
        name.font = styleStorebarBV.titleFont(28)
        name.textAlignment = .center
        let email = UILabel()
        email.text = localProfile?.emailEntry ?? "a123456@gmail.com"
        email.font = .systemFont(ofSize: 16, weight: .semibold)
        email.textColor = styleStorebarBV.mutedText
        email.textAlignment = .center
        let birthday = UILabel()
        birthday.text = localProfile?.birthdayFieldbarBV.isEmpty == false ? localProfile?.birthdayFieldbarBV : "Birthday not set"
        birthday.font = .systemFont(ofSize: 15, weight: .regular)
        birthday.textColor = styleStorebarBV.mutedText
        birthday.textAlignment = .center
        let profileStack = UIStackView(arrangedSubviews: [avatar, name, email, birthday])
        profileStack.axis = .vertical
        profileStack.alignment = .center
        profileStack.spacing = 10
        avatar.widthAnchor.constraint(equalToConstant: 140).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 140).isActive = true
        stack.addArrangedSubview(profileStack)
        stack.addArrangedSubview(balanceCard())
        stack.addArrangedSubview(stylesCard())
        stack.addArrangedSubview(settingsCard())
        stack.addArrangedSubview(logoutPanelbarBV())
    }

    private func balanceCard() -> UIView {
        let card = cardSurfacebarBV(cornerRadius: 18)
        let label = UILabel()
        label.text = "🟡  Available coins"
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        let value = UILabel()
        value.text = "\(store.coinBalance)  ›"
        value.font = .systemFont(ofSize: 24, weight: .heavy)
        value.textAlignment = .right
        card.addSubview(label)
        card.addSubview(value)
        label.translatesAutoresizingMaskIntoConstraints = false
        value.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 74),
            label.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            value.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            value.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            value.leadingAnchor.constraint(greaterThanOrEqualTo: label.trailingAnchor, constant: 12)
        ])
        return card
    }

    private func stylesCard() -> UIView {
        let card = cardSurfacebarBV()
        let title = UILabel()
        title.text = "AI STYLE SETTINGS"
        title.font = .systemFont(ofSize: 18, weight: .heavy)
        let grid = UIStackView()
        grid.axis = .vertical
        grid.spacing = 10
        let rows = [[replyStylebarBV.replyToneWarm, .replyToneShortbarBV, .replyTonePolite], [.replyToneGentlebarBV, .replyToneCheerful, .replyToneProfessionalbarBV]]
        for row in rows {
            let rowStack = UIStackView()
            rowStack.spacing = 10
            rowStack.distribution = .fillEqually
            row.forEach { tone in
                let button = UIButton(type: .system)
                let unlocked = store.styleUnlock.contains(tone)
                button.setTitle(unlocked ? tone.rawValue : "\(tone.rawValue)\n400", for: .normal)
                button.titleLabel?.numberOfLines = 2
                button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
                button.backgroundColor = unlocked ? UIColor(red: 227 / 255, green: 251 / 255, blue: 252 / 255, alpha: 1) : UIColor(red: 255 / 255, green: 238 / 255, blue: 243 / 255, alpha: 1)
                button.layer.cornerRadius = 14
                button.addAction(UIAction { [weak self] _ in
                    _ = self?.store.toneUnlockbarBV(tone)
                    self?.reload()
                }, for: .touchUpInside)
                rowStack.addArrangedSubview(button)
            }
            grid.addArrangedSubview(rowStack)
        }
        let stack = UIStackView(arrangedSubviews: [title, grid])
        stack.axis = .vertical
        stack.spacing = 16
        card.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 218),
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -18),
            grid.heightAnchor.constraint(equalToConstant: 140)
        ])
        return card
    }

    private func settingsCard() -> UIView {
        let card = cardSurfacebarBV()
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 22
        ["Profile", "Notifications", "Privacy Settings", "Blocked Contacts"].forEach {
            let label = UILabel()
            label.text = "\($0)  ›"
            label.font = .systemFont(ofSize: 22, weight: .semibold)
            stack.addArrangedSubview(label)
        }
        card.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -24)
        ])
        return card
    }

    private func logoutPanelbarBV() -> UIView {
        let button = UIButton(type: .system)
        button.setTitle("Log out", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .heavy)
        button.backgroundColor = .white
        button.layer.cornerRadius = 24
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        button.addAction(UIAction { _ in sessionStore.logoutFlowbarBV() }, for: .touchUpInside)
        return button
    }
}
