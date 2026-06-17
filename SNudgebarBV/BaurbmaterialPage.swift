import UIKit

final class BaurbmaterialPage: barbCanvasbarBV {
    private let emailEntry: String
    private let privacySeed: String
    private let nameEntrybarBV = UITextField()
    private let birthdayEntrybarBV = UITextField()
    private let avatarBadgebarBV = avatarSurfacebarBV(initial: "B", color: BaurbstyleStorebarBV.pink)
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
        stackSurfacebarBV.spacing = BaurbstyleStorebarBV.spacebarBV(16, minimumbarBV: 10, maximumbarBV: 18)
        scrollSurfacebarBV.addSubview(stackSurfacebarBV)
        stackSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false
        let sideInsetbarBV = BaurbstyleStorebarBV.metricbarBV(24, minimumbarBV: 16, maximumbarBV: 24)
        NSLayoutConstraint.activate([
            scrollSurfacebarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollSurfacebarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollSurfacebarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollSurfacebarBV.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            stackSurfacebarBV.topAnchor.constraint(equalTo: scrollSurfacebarBV.contentLayoutGuide.topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 24)),
            stackSurfacebarBV.leadingAnchor.constraint(equalTo: scrollSurfacebarBV.frameLayoutGuide.leadingAnchor, constant: sideInsetbarBV),
            stackSurfacebarBV.trailingAnchor.constraint(equalTo: scrollSurfacebarBV.frameLayoutGuide.trailingAnchor, constant: -sideInsetbarBV),
            stackSurfacebarBV.bottomAnchor.constraint(equalTo: scrollSurfacebarBV.contentLayoutGuide.bottomAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(28, minimumbarBV: 18, maximumbarBV: 32))
        ])
        let titleTextbarBV = UILabel()
        titleTextbarBV.text = "Complete the data"
        titleTextbarBV.font = BaurbstyleStorebarBV.titleFont(38)
        titleTextbarBV.numberOfLines = 0
        BaurbstyleStorebarBV.labelFitbarBV(titleTextbarBV, factorbarBV: 0.72, linesbarBV: 0)
        let subtitleTextbarBV = UILabel()
        subtitleTextbarBV.text = "Your friends will recognize you faster."
        subtitleTextbarBV.font = BaurbstyleStorebarBV.fontbarBV(20, weight: .regular)
        subtitleTextbarBV.textColor = .darkGray
        subtitleTextbarBV.numberOfLines = 0
        BaurbstyleStorebarBV.labelFitbarBV(subtitleTextbarBV, factorbarBV: 0.72, linesbarBV: 0)
        avatarBadgebarBV.font = BaurbstyleStorebarBV.fontbarBV(48, weight: .heavy)
        let avatarSizebarBV = BaurbstyleStorebarBV.metricbarBV(96, minimumbarBV: 82, maximumbarBV: 108)
        avatarBadgebarBV.widthAnchor.constraint(equalToConstant: avatarSizebarBV).isActive = true
        avatarBadgebarBV.heightAnchor.constraint(equalToConstant: avatarSizebarBV).isActive = true
        let avatarButtonbarBV = UIButton(type: .system)
        avatarButtonbarBV.setTitle("Choose Avatar", for: .normal)
        avatarButtonbarBV.titleLabel?.font = BaurbstyleStorebarBV.fontbarBV(17, weight: .bold)
        BaurbstyleStorebarBV.buttonFitbarBV(avatarButtonbarBV)
        avatarButtonbarBV.addAction(UIAction { [weak self] _ in self?.avatarUplexicalRetrievalbarBV() }, for: .touchUpInside)
        let avatarStackbarBV = UIStackView(arrangedSubviews: [avatarBadgebarBV, avatarButtonbarBV])
        avatarStackbarBV.axis = .vertical
        avatarStackbarBV.alignment = .center
        avatarStackbarBV.spacing = BaurbstyleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10)
        birthdayEntrybarBV.placeholder = "Birthday"
        birthdayEntrybarBV.keyboardType = .default
        let actionButtonbarBV = gradientPill(type: .system)
        actionButtonbarBV.setTitle("Enter Barb", for: .normal)
        actionButtonbarBV.setTitleColor(.black, for: .normal)
        actionButtonbarBV.titleLabel?.font = BaurbstyleStorebarBV.fontbarBV(22, weight: .heavy)
        BaurbstyleStorebarBV.buttonFitbarBV(actionButtonbarBV)
        actionButtonbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(54)).isActive = true
        actionButtonbarBV.addAction(UIAction { [weak self] _ in self?.profileCompletionbarBV() }, for: .touchUpInside)
        [titleTextbarBV, subtitleTextbarBV, avatarStackbarBV, inputPanelbarBV(nameEntrybarBV, "Name", "person.fill"), inputPanelbarBV(birthdayEntrybarBV, "Birthday", "birthday.cake.fill"), consentRowbarBV(termsMarkbarBV, "I agree to the User Agreement.", BaurbagreementPage()), consentRowbarBV(policyMarkbarBV, "I agree to the Privacy Policy.", BaurbpolicyPagebarBV()), actionButtonbarBV].forEach {
            stackSurfacebarBV.addArrangedSubview($0)
        }
        consentRefreshbarBV()
    }

    private func inputPanelbarBV(_ field: UITextField, _ placeholder: String, _ icon: String) -> UIView {
        let fieldHeightbarBV = BaurbstyleStorebarBV.controlbarBV(54)
        let card = cardSurfacebarBV(cornerRadius: fieldHeightbarBV / 2)
        let symbol = UIImageView(image: UIImage(systemName: icon))
        symbol.tintColor = .black
        field.placeholder = placeholder
        field.font = BaurbstyleStorebarBV.fontbarBV(18, weight: .semibold)
        field.adjustsFontSizeToFitWidth = true
        field.minimumFontSize = BaurbstyleStorebarBV.sizebarBV(12)
        card.addSubview(symbol)
        card.addSubview(field)
        symbol.translatesAutoresizingMaskIntoConstraints = false
        field.translatesAutoresizingMaskIntoConstraints = false
        let iconWidthbarBV = BaurbstyleStorebarBV.metricbarBV(22, minimumbarBV: 19, maximumbarBV: 24)
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: fieldHeightbarBV),
            symbol.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(20, minimumbarBV: 16, maximumbarBV: 22)),
            symbol.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            symbol.widthAnchor.constraint(equalToConstant: iconWidthbarBV),
            field.leadingAnchor.constraint(equalTo: symbol.trailingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 16)),
            field.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            field.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])
        return card
    }

    private func consentRowbarBV(_ button: UIButton, _ text: String, _ controller: UIViewController) -> UIView {
        let row = UIStackView()
        row.alignment = .center
        row.spacing = BaurbstyleStorebarBV.metricbarBV(8, minimumbarBV: 6, maximumbarBV: 10)
        let markSizebarBV = BaurbstyleStorebarBV.metricbarBV(24, minimumbarBV: 22, maximumbarBV: 28)
        button.widthAnchor.constraint(equalToConstant: markSizebarBV).isActive = true
        button.heightAnchor.constraint(equalToConstant: markSizebarBV).isActive = true
        button.addAction(UIAction { [weak self, weak button] _ in
            guard let self, let button else { return }
            if button === self.termsMarkbarBV { self.termsStatebarBV.toggle() } else { self.policyStatebarBV.toggle() }
            self.consentRefreshbarBV()
        }, for: .touchUpInside)
        let link = UIButton(type: .system)
        link.setTitle(text, for: .normal)
        link.titleLabel?.font = BaurbstyleStorebarBV.fontbarBV(15, weight: .semibold)
        link.titleLabel?.numberOfLines = 0
        BaurbstyleStorebarBV.buttonFitbarBV(link, factorbarBV: 0.68)
        link.titleLabel?.lineBreakMode = .byWordWrapping
        link.contentHorizontalAlignment = .left
        link.addAction(UIAction { [weak self] _ in self?.navigationController?.pushViewController(controller, animated: true) }, for: .touchUpInside)
        row.addArrangedSubview(button)
        row.addArrangedSubview(link)
        return row
    }

    private func consentRefreshbarBV() {
        termsMarkbarBV.setImage(UIImage(systemName: termsStatebarBV ? "checkmark.square.fill" : "square"), for: .normal)
        policyMarkbarBV.setImage(UIImage(systemName: policyStatebarBV ? "checkmark.square.fill" : "square"), for: .normal)
        termsMarkbarBV.tintColor = BaurbstyleStorebarBV.purple
        policyMarkbarBV.tintColor = BaurbstyleStorebarBV.purple
    }

    private func avatarUplexicalRetrievalbarBV() {
        let alert = UIAlertController(title: "Avatar", message: "Choose an avatar initial.", preferredStyle: .actionSheet)
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
        if let alertText = BaurbsessionStore.profileCompletionbarBV(emailEntry: emailEntry, privacySeed: privacySeed, placeholderNamebarBV: nameEntrybarBV.text ?? "", placeholderAvatar: avatarChoicebarBV, birthdayFieldbarBV: birthdayEntrybarBV.text ?? "", consentFixture: consentFixture) {
            let alert = UIAlertController(title: nil, message: alertText, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}
