import UIKit

final class loginPagebarBV: localSurfacebarBV {
    private let emailEntrybarBV = UITextField()
    private let privacySeed = UITextField()
    private let consentMarkbarBV = UIButton(type: .system)
    private let scrollSurfacebarBV = UIScrollView()
    private let stackSurfacebarBV = UIStackView()
    private var agreementSignalbarBV: NSObjectProtocol?
    private var firstAgreementbarBV = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log in"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: nil, action: nil)
        layoutFlowbarBV()
        agreementSignalbarBV = NotificationCenter.default.addObserver(forName: sessionStore.agreementSignalbarBV, object: nil, queue: .main) { [weak self] _ in
            self?.agreementRefreshbarBV()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        agreementRefreshbarBV()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !sessionStore.agreementAcceptedbarBV, !firstAgreementbarBV else { return }
        firstAgreementbarBV = true
        agreementAlertbarBV()
    }

    deinit {
        if let agreementSignalbarBV {
            NotificationCenter.default.removeObserver(agreementSignalbarBV)
        }
    }

    private func layoutFlowbarBV() {
        let tapSurfacebarBV = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapSurfacebarBV.cancelsTouchesInView = false
        view.addGestureRecognizer(tapSurfacebarBV)
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
        titleTextbarBV.text = "Sign in with email"
        titleTextbarBV.font = styleStorebarBV.titleFont(34)
        titleTextbarBV.textAlignment = .center
        titleTextbarBV.numberOfLines = 0
        titleTextbarBV.adjustsFontSizeToFitWidth = true
        titleTextbarBV.minimumScaleFactor = 0.78
        let subtitleTextbarBV = UILabel()
        subtitleTextbarBV.text = "We'll send you a code to verify it's you."
        subtitleTextbarBV.font = .systemFont(ofSize: 20, weight: .regular)
        subtitleTextbarBV.textColor = UIColor.black.withAlphaComponent(0.65)
        subtitleTextbarBV.textAlignment = .center
        subtitleTextbarBV.numberOfLines = 0
        emailEntrybarBV.keyboardType = .emailAddress
        emailEntrybarBV.autocapitalizationType = .none
        emailEntrybarBV.textContentType = .username
        privacySeed.isSecureTextEntry = true
        privacySeed.textContentType = .password
        let actionButtonbarBV = gradientPill(type: .system)
        actionButtonbarBV.setTitle("Log in", for: .normal)
        actionButtonbarBV.setTitleColor(UIColor.black.withAlphaComponent(0.62), for: .normal)
        actionButtonbarBV.titleLabel?.font = .systemFont(ofSize: 22, weight: .heavy)
        actionButtonbarBV.heightAnchor.constraint(equalToConstant: 64).isActive = true
        actionButtonbarBV.addAction(UIAction { [weak self] _ in self?.loginFlowbarBV() }, for: .touchUpInside)
        stackSurfacebarBV.addArrangedSubview(titleTextbarBV)
        stackSurfacebarBV.setCustomSpacing(16, after: titleTextbarBV)
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
        stackSurfacebarBV.setCustomSpacing(46, after: actionButtonbarBV)
        stackSurfacebarBV.addArrangedSubview(switcherbarBV())
        stackSurfacebarBV.setCustomSpacing(88, after: stackSurfacebarBV.arrangedSubviews.last!)
        stackSurfacebarBV.addArrangedSubview(consentbarBV())
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

    private func switcherbarBV() -> UIView {
        let row = UIStackView()
        row.axis = .horizontal
        row.alignment = .center
        row.distribution = .fill
        let spacerA = UIView()
        let spacerB = UIView()
        let text = UILabel()
        text.text = "No account?"
        text.font = .systemFont(ofSize: 18, weight: .regular)
        let action = UIButton(type: .system)
        action.setTitle("Sign up", for: .normal)
        action.titleLabel?.font = .systemFont(ofSize: 18, weight: .heavy)
        action.addAction(UIAction { [weak self] _ in
            self?.navigationController?.pushViewController(registerPagebarBV(), animated: true)
        }, for: .touchUpInside)
        row.addArrangedSubview(spacerA)
        row.addArrangedSubview(text)
        row.setCustomSpacing(6, after: text)
        row.addArrangedSubview(action)
        row.addArrangedSubview(spacerB)
        spacerA.widthAnchor.constraint(equalTo: spacerB.widthAnchor).isActive = true
        return row
    }

    private func consentbarBV() -> UIView {
        consentMarkbarBV.addAction(UIAction { _ in
            sessionStore.agreementFlowbarBV(!sessionStore.agreementAcceptedbarBV)
        }, for: .touchUpInside)
        let text = UITextView()
        text.delegate = self
        text.isEditable = false
        text.isScrollEnabled = false
        text.backgroundColor = .clear
        text.textContainerInset = .zero
        text.textContainer.lineFragmentPadding = 0
        text.textAlignment = .center
        text.linkTextAttributes = [
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let copy = "By continuing, you agree to our Terms\n& PrivacyPolicy."
        let format = NSMutableAttributedString(
            string: copy,
            attributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .regular),
                .foregroundColor: UIColor.black.withAlphaComponent(0.5)
            ]
        )
        if let range = copy.range(of: "Terms") {
            format.addAttribute(.link, value: "barb://terms", range: NSRange(range, in: copy))
        }
        if let range = copy.range(of: "PrivacyPolicy") {
            format.addAttribute(.link, value: "barb://privacy", range: NSRange(range, in: copy))
        }
        text.attributedText = format
        let row = UIStackView(arrangedSubviews: [consentMarkbarBV, text])
        row.axis = .horizontal
        row.alignment = .top
        row.spacing = 10
        row.isLayoutMarginsRelativeArrangement = true
        row.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 42, bottom: 0, trailing: 22)
        consentMarkbarBV.widthAnchor.constraint(equalToConstant: 28).isActive = true
        agreementRefreshbarBV()
        return row
    }

    private func loginFlowbarBV() {
        guard sessionStore.agreementAcceptedbarBV else {
            agreementAlertbarBV()
            return
        }
        if let alertText = sessionStore.loginFlowbarBV(emailEntry: emailEntrybarBV.text ?? "", privacySeed: privacySeed.text ?? "") {
            alertSurfacebarBV(alertText)
        }
    }

    private func agreementRefreshbarBV() {
        let icon = sessionStore.agreementAcceptedbarBV ? "checkmark.square.fill" : "square"
        consentMarkbarBV.setImage(UIImage(systemName: icon), for: .normal)
        consentMarkbarBV.tintColor = styleStorebarBV.purple
    }

    private func agreementAlertbarBV() {
        let alert = UIAlertController(title: "End User License Agreement", message: sessionStore.agreementCopybarBV(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Decline", style: .cancel))
        alert.addAction(UIAlertAction(title: "Agree", style: .default) { _ in
            sessionStore.agreementFlowbarBV(true)
        })
        present(alert, animated: true)
    }

    private func alertSurfacebarBV(_ text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension loginPagebarBV: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "barb://terms" {
            navigationController?.pushViewController(agreementPage(), animated: true)
            return false
        }
        if URL.absoluteString == "barb://privacy" {
            navigationController?.pushViewController(policyPagebarBV(), animated: true)
            return false
        }
        return false
    }
}
