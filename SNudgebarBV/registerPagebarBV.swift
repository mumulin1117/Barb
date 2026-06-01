import UIKit

final class registerPagebarBV: localSurfacebarBV {
    private let emailEntrybarBV = UITextField()
    private let privacySeed = UITextField()
    private let stackSurfacebarBV = UIStackView()
    private var firstAgreementbarBV = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        layoutFlowbarBV()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !sessionStore.agreementAcceptedbarBV, !firstAgreementbarBV else { return }
        firstAgreementbarBV = true
        agreementAlertbarBV()
    }

    private func layoutFlowbarBV() {
        let tapSurfacebarBV = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapSurfacebarBV.cancelsTouchesInView = false
        view.addGestureRecognizer(tapSurfacebarBV)
        let scrollSurfacebarBV = UIScrollView()
        view.addSubview(scrollSurfacebarBV)
        scrollSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false
        scrollSurfacebarBV.showsVerticalScrollIndicator = false
        scrollSurfacebarBV.backgroundColor = .clear
        stackSurfacebarBV.axis = .vertical
        stackSurfacebarBV.spacing = 0
        scrollSurfacebarBV.addSubview(stackSurfacebarBV)
        stackSurfacebarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollSurfacebarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollSurfacebarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollSurfacebarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollSurfacebarBV.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            stackSurfacebarBV.topAnchor.constraint(equalTo: scrollSurfacebarBV.contentLayoutGuide.topAnchor, constant: 70),
            stackSurfacebarBV.leadingAnchor.constraint(equalTo: scrollSurfacebarBV.frameLayoutGuide.leadingAnchor, constant: 20),
            stackSurfacebarBV.trailingAnchor.constraint(equalTo: scrollSurfacebarBV.frameLayoutGuide.trailingAnchor, constant: -20),
            stackSurfacebarBV.bottomAnchor.constraint(equalTo: scrollSurfacebarBV.contentLayoutGuide.bottomAnchor, constant: -28)
        ])
        let titleTextbarBV = UILabel()
        titleTextbarBV.text = "Create an account"
        titleTextbarBV.font = styleStorebarBV.titleFont(34)
        titleTextbarBV.textAlignment = .center
        titleTextbarBV.numberOfLines = 0
        titleTextbarBV.adjustsFontSizeToFitWidth = true
        titleTextbarBV.minimumScaleFactor = 0.78
        let subtitleTextbarBV = UILabel()
        subtitleTextbarBV.text = "Create a new account for you"
        subtitleTextbarBV.font = .systemFont(ofSize: 20, weight: .regular)
        subtitleTextbarBV.textColor = UIColor.black.withAlphaComponent(0.65)
        subtitleTextbarBV.textAlignment = .center
        subtitleTextbarBV.numberOfLines = 0
        emailEntrybarBV.keyboardType = .emailAddress
        emailEntrybarBV.autocapitalizationType = .none
        privacySeed.isSecureTextEntry = true
        let actionButtonbarBV = gradientPill(type: .system)
        actionButtonbarBV.setTitle("Next", for: .normal)
        actionButtonbarBV.setTitleColor(UIColor.black.withAlphaComponent(0.62), for: .normal)
        actionButtonbarBV.titleLabel?.font = .systemFont(ofSize: 22, weight: .heavy)
        actionButtonbarBV.heightAnchor.constraint(equalToConstant: 64).isActive = true
        actionButtonbarBV.addAction(UIAction { [weak self] _ in self?.registerFlowbarBV() }, for: .touchUpInside)
        stackSurfacebarBV.addArrangedSubview(titleTextbarBV)
        stackSurfacebarBV.setCustomSpacing(28, after: titleTextbarBV)
        stackSurfacebarBV.addArrangedSubview(subtitleTextbarBV)
        stackSurfacebarBV.setCustomSpacing(78, after: subtitleTextbarBV)
        stackSurfacebarBV.addArrangedSubview(sectionTitlebarBV("Email"))
        stackSurfacebarBV.setCustomSpacing(24, after: stackSurfacebarBV.arrangedSubviews.last!)
        stackSurfacebarBV.addArrangedSubview(inputPanelbarBV(emailEntrybarBV, "Please enter your email address.", "envelope.fill"))
        stackSurfacebarBV.setCustomSpacing(68, after: stackSurfacebarBV.arrangedSubviews.last!)
        stackSurfacebarBV.addArrangedSubview(sectionTitlebarBV("Password"))
        stackSurfacebarBV.setCustomSpacing(24, after: stackSurfacebarBV.arrangedSubviews.last!)
        stackSurfacebarBV.addArrangedSubview(inputPanelbarBV(privacySeed, "Please enter your password.", "lock.fill"))
        stackSurfacebarBV.setCustomSpacing(180, after: stackSurfacebarBV.arrangedSubviews.last!)
        stackSurfacebarBV.addArrangedSubview(actionButtonbarBV)
    }

    private func inputPanelbarBV(_ field: UITextField, _ placeholder: String, _ icon: String) -> UIView {
        let card = cardSurfacebarBV(cornerRadius: 34)
        let symbol = UIImageView(image: UIImage(systemName: icon))
        symbol.tintColor = .black
        field.placeholder = placeholder
        field.font = .systemFont(ofSize: 18, weight: .regular)
        field.textColor = .black
        card.addSubview(symbol)
        card.addSubview(field)
        symbol.translatesAutoresizingMaskIntoConstraints = false
        field.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 60),
            symbol.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 36),
            symbol.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            symbol.widthAnchor.constraint(equalToConstant: 24),
            field.leadingAnchor.constraint(equalTo: symbol.trailingAnchor, constant: 16),
            field.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            field.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])
        return card
    }

    private func sectionTitlebarBV(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.textColor = .black
        return label
    }

    private func registerFlowbarBV() {
        guard sessionStore.agreementAcceptedbarBV else {
            agreementAlertbarBV()
            return
        }
        let emailEntry = emailEntrybarBV.text ?? ""
        let privacySeed = privacySeed.text ?? ""
        if let alertText = sessionStore.registerFlowbarBV(emailEntry: emailEntry, privacySeed: privacySeed) {
            alertSurfacebarBV(alertText)
            return
        }
        navigationController?.pushViewController(materialPage(emailEntry: emailEntry, privacySeed: privacySeed), animated: true)
    }

    private func alertSurfacebarBV(_ text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func agreementAlertbarBV() {
        let alert = UIAlertController(title: "End User License Agreement", message: sessionStore.agreementCopybarBV(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Decline", style: .cancel))
        alert.addAction(UIAlertAction(title: "Agree", style: .default) { _ in
            sessionStore.agreementFlowbarBV(true)
        })
        present(alert, animated: true)
    }
}
