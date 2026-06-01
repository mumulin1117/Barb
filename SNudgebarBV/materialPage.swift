import UIKit

final class materialPage: localSurfacebarBV {
    private let emailEntry: String
    private let privacySeed: String
    private let nameEntrybarBV = UITextField()
    private let birthdayEntrybarBV = UITextField()
    private let avatarBadgebarBV = avatarSurfacebarBV(initial: "B", color: styleStorebarBV.pink)
    private var avatarChoicebarBV = "B"
    private var termsStatebarBV = false
    private var policyStatebarBV = false
    private let termsMarkbarBV = UIButton(type: .system)
    private let policyMarkbarBV = UIButton(type: .system)

    init(emailEntry: String, privacySeed: String) {
        self.emailEntry = emailEntry
        self.privacySeed = privacySeed
        super.init(nibName: nil, bundle: nil)
        title = "Material"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutFlowbarBV()
    }

    private func layoutFlowbarBV() {
        let tapSurfacebarBV = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapSurfacebarBV.cancelsTouchesInView = false
        view.addGestureRecognizer(tapSurfacebarBV)
        let scrollSurfacebarBV = UIScrollView()
        let stackSurfacebarBV = UIStackView()
        view.addSubview(scrollSurfacebarBV)
        scrollSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false
        stackSurfacebarBV.axis = .vertical
        stackSurfacebarBV.spacing = 18
        scrollSurfacebarBV.addSubview(stackSurfacebarBV)
        stackSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollSurfacebarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollSurfacebarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollSurfacebarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollSurfacebarBV.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            stackSurfacebarBV.topAnchor.constraint(equalTo: scrollSurfacebarBV.contentLayoutGuide.topAnchor, constant: 20),
            stackSurfacebarBV.leadingAnchor.constraint(equalTo: scrollSurfacebarBV.frameLayoutGuide.leadingAnchor, constant: 24),
            stackSurfacebarBV.trailingAnchor.constraint(equalTo: scrollSurfacebarBV.frameLayoutGuide.trailingAnchor, constant: -24),
            stackSurfacebarBV.bottomAnchor.constraint(equalTo: scrollSurfacebarBV.contentLayoutGuide.bottomAnchor, constant: -32)
        ])
        let titleTextbarBV = UILabel()
        titleTextbarBV.text = "Complete the data"
        titleTextbarBV.font = styleStorebarBV.titleFont(38)
        titleTextbarBV.numberOfLines = 0
        let subtitleTextbarBV = UILabel()
        subtitleTextbarBV.text = "Your friends will recognize you faster."
        subtitleTextbarBV.font = .systemFont(ofSize: 20, weight: .regular)
        subtitleTextbarBV.textColor = .darkGray
        subtitleTextbarBV.numberOfLines = 0
        avatarBadgebarBV.font = .systemFont(ofSize: 48, weight: .heavy)
        avatarBadgebarBV.widthAnchor.constraint(equalToConstant: 116).isActive = true
        avatarBadgebarBV.heightAnchor.constraint(equalToConstant: 116).isActive = true
        let avatarButtonbarBV = UIButton(type: .system)
        avatarButtonbarBV.setTitle("Choose Avatar", for: .normal)
        avatarButtonbarBV.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        avatarButtonbarBV.addAction(UIAction { [weak self] _ in self?.avatarUploadbarBV() }, for: .touchUpInside)
        let avatarStackbarBV = UIStackView(arrangedSubviews: [avatarBadgebarBV, avatarButtonbarBV])
        avatarStackbarBV.axis = .vertical
        avatarStackbarBV.alignment = .center
        avatarStackbarBV.spacing = 10
        birthdayEntrybarBV.placeholder = "yyyy-MM-dd"
        birthdayEntrybarBV.keyboardType = .numbersAndPunctuation
        let actionButtonbarBV = gradientPill(type: .system)
        actionButtonbarBV.setTitle("Enter Barb", for: .normal)
        actionButtonbarBV.setTitleColor(.black, for: .normal)
        actionButtonbarBV.titleLabel?.font = .systemFont(ofSize: 22, weight: .heavy)
        actionButtonbarBV.heightAnchor.constraint(equalToConstant: 58).isActive = true
        actionButtonbarBV.addAction(UIAction { [weak self] _ in self?.profileCompletionbarBV() }, for: .touchUpInside)
        [titleTextbarBV, subtitleTextbarBV, avatarStackbarBV, inputPanelbarBV(nameEntrybarBV, "Name", "person.fill"), inputPanelbarBV(birthdayEntrybarBV, "Birthday", "birthday.cake.fill"), consentRowbarBV(termsMarkbarBV, "I agree to the User Agreement.", agreementPage()), consentRowbarBV(policyMarkbarBV, "I agree to the Privacy Policy.", policyPagebarBV()), actionButtonbarBV].forEach {
            stackSurfacebarBV.addArrangedSubview($0)
        }
        consentRefreshbarBV()
    }

    private func inputPanelbarBV(_ field: UITextField, _ placeholder: String, _ icon: String) -> UIView {
        let card = cardSurfacebarBV(cornerRadius: 30)
        let symbol = UIImageView(image: UIImage(systemName: icon))
        symbol.tintColor = .black
        field.placeholder = placeholder
        field.font = .systemFont(ofSize: 18, weight: .semibold)
        card.addSubview(symbol)
        card.addSubview(field)
        symbol.translatesAutoresizingMaskIntoConstraints = false
        field.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 62),
            symbol.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 22),
            symbol.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            symbol.widthAnchor.constraint(equalToConstant: 24),
            field.leadingAnchor.constraint(equalTo: symbol.trailingAnchor, constant: 16),
            field.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            field.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])
        return card
    }

    private func consentRowbarBV(_ button: UIButton, _ text: String, _ controller: UIViewController) -> UIView {
        let row = UIStackView()
        row.alignment = .center
        row.spacing = 8
        button.widthAnchor.constraint(equalToConstant: 28).isActive = true
        button.heightAnchor.constraint(equalToConstant: 28).isActive = true
        button.addAction(UIAction { [weak self, weak button] _ in
            guard let self, let button else { return }
            if button === self.termsMarkbarBV { self.termsStatebarBV.toggle() } else { self.policyStatebarBV.toggle() }
            self.consentRefreshbarBV()
        }, for: .touchUpInside)
        let link = UIButton(type: .system)
        link.setTitle(text, for: .normal)
        link.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        link.titleLabel?.numberOfLines = 0
        link.contentHorizontalAlignment = .left
        link.addAction(UIAction { [weak self] _ in self?.navigationController?.pushViewController(controller, animated: true) }, for: .touchUpInside)
        row.addArrangedSubview(button)
        row.addArrangedSubview(link)
        return row
    }

    private func consentRefreshbarBV() {
        termsMarkbarBV.setImage(UIImage(systemName: termsStatebarBV ? "checkmark.square.fill" : "square"), for: .normal)
        policyMarkbarBV.setImage(UIImage(systemName: policyStatebarBV ? "checkmark.square.fill" : "square"), for: .normal)
        termsMarkbarBV.tintColor = styleStorebarBV.purple
        policyMarkbarBV.tintColor = styleStorebarBV.purple
    }

    private func avatarUploadbarBV() {
        let alert = UIAlertController(title: "Avatar", message: "Choose a local avatar initial.", preferredStyle: .actionSheet)
        ["B", "M", "T", "A"].forEach { value in
            alert.addAction(UIAlertAction(title: value, style: .default) { [weak self] _ in
                self?.avatarChoicebarBV = value
                self?.avatarBadgebarBV.text = value
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func profileCompletionbarBV() {
        let consentFixture = consentFixturebarBV(termsFlag: termsStatebarBV, policyFlag: policyStatebarBV)
        if let alertText = sessionStore.profileCompletionbarBV(emailEntry: emailEntry, privacySeed: privacySeed, placeholderNamebarBV: nameEntrybarBV.text ?? "", placeholderAvatar: avatarChoicebarBV, birthdayFieldbarBV: birthdayEntrybarBV.text ?? "", consentFixture: consentFixture) {
            let alert = UIAlertController(title: nil, message: alertText, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}
