import UIKit

final class detailSurface: localSurfacebarBV {
    private let contact: trustedContact

    init(contact: trustedContact) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
        title = "Profile"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let avatar = avatarSurfacebarBV(initial: contact.placeholderAvatar)
        avatar.font = .systemFont(ofSize: 48, weight: .bold)
        let name = UILabel()
        name.text = contact.placeholderNamebarBV
        name.font = styleStorebarBV.titleFont(30)
        name.textAlignment = .center
        let id = UILabel()
        id.text = "BARB ID · \(contact.placeholderNamebarBV.prefix(2).uppercased())\(contact.placeholderAvatar)B"
        id.textColor = styleStorebarBV.mutedText
        id.textAlignment = .center
        let message = gradientPill(type: .system)
        message.setTitle("Message", for: .normal)
        message.setTitleColor(.white, for: .normal)
        message.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        let profileCard = cardSurfacebarBV()
        [avatar, name, id, message].forEach {
            profileCard.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let actions = settingsCard()
        view.addSubview(profileCard)
        view.addSubview(actions)
        profileCard.translatesAutoresizingMaskIntoConstraints = false
        actions.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            profileCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            profileCard.heightAnchor.constraint(equalToConstant: 270),
            avatar.topAnchor.constraint(equalTo: profileCard.topAnchor, constant: 36),
            avatar.centerXAnchor.constraint(equalTo: profileCard.centerXAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 100),
            avatar.heightAnchor.constraint(equalToConstant: 100),
            name.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 22),
            name.centerXAnchor.constraint(equalTo: profileCard.centerXAnchor),
            id.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
            id.centerXAnchor.constraint(equalTo: profileCard.centerXAnchor),
            message.topAnchor.constraint(equalTo: id.bottomAnchor, constant: 18),
            message.centerXAnchor.constraint(equalTo: profileCard.centerXAnchor),
            message.widthAnchor.constraint(equalToConstant: 160),
            message.heightAnchor.constraint(equalToConstant: 48),
            actions.topAnchor.constraint(equalTo: profileCard.bottomAnchor, constant: 24),
            actions.leadingAnchor.constraint(equalTo: profileCard.leadingAnchor),
            actions.trailingAnchor.constraint(equalTo: profileCard.trailingAnchor)
        ])
    }

    private func settingsCard() -> UIView {
        let card = cardSurfacebarBV()
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 14
        ["Name  \(contact.placeholderNotebarBV)", "Group  \(contact.groupFilter.rawValue)", "Connected since  Sep 2024", "Mute notifications", "Pin to top of Desk", "Remove from contacts", "Block this contact"].forEach { text in
            let label = UILabel()
            label.text = text
            label.font = .systemFont(ofSize: 20, weight: text.contains("Block") ? .heavy : .regular)
            label.textColor = text.contains("Block") ? .red : .black
            stack.addArrangedSubview(label)
        }
        card.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 22),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 22),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -22),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -22)
        ])
        return card
    }
}
