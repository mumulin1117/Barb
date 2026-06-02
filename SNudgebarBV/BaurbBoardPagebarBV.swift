import UIKit

final class BaurbBoardPagebarBV: barbCanvasbarBV {
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
        agreementSignalbarBV = NotificationCenter.default.addObserver(forName: BaurbsessionStore.agreementSignalbarBV, object: nil, queue: .main) { [weak self] _ in
            self?.agreementRefreshbarBV()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        agreementRefreshbarBV()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !BaurbsessionStore.agreementAcceptedbarBV, !firstAgreementbarBV else { return }
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
        let sideInsetbarBV = BaurbstyleStorebarBV.metricbarBV(20, minimumbarBV: 16, maximumbarBV: 22)
        NSLayoutConstraint.activate([
            scrollSurfacebarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollSurfacebarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollSurfacebarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollSurfacebarBV.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            stackSurfacebarBV.topAnchor.constraint(equalTo: scrollSurfacebarBV.contentLayoutGuide.topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(40, minimumbarBV: 22, maximumbarBV: 52)),
            stackSurfacebarBV.leadingAnchor.constraint(equalTo: scrollSurfacebarBV.frameLayoutGuide.leadingAnchor, constant: sideInsetbarBV),
            stackSurfacebarBV.trailingAnchor.constraint(equalTo: scrollSurfacebarBV.frameLayoutGuide.trailingAnchor, constant: -sideInsetbarBV),
            stackSurfacebarBV.bottomAnchor.constraint(equalTo: scrollSurfacebarBV.contentLayoutGuide.bottomAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(24, minimumbarBV: 16, maximumbarBV: 28))
        ])
        let titleTextbarBV = UILabel()
        titleTextbarBV.text = "Sign in with email"
        titleTextbarBV.font = BaurbstyleStorebarBV.titleFont(34)
        titleTextbarBV.textAlignment = .center
        titleTextbarBV.numberOfLines = 0
        titleTextbarBV.adjustsFontSizeToFitWidth = true
        titleTextbarBV.minimumScaleFactor = 0.78
        titleTextbarBV.lineBreakMode = .byWordWrapping
        let subtitleTextbarBV = UILabel()
        subtitleTextbarBV.text = ""//"We'll send you a code to verify it's you."
        subtitleTextbarBV.font = BaurbstyleStorebarBV.fontbarBV(20, weight: .regular)
        subtitleTextbarBV.textColor = UIColor.black.withAlphaComponent(0.65)
        subtitleTextbarBV.textAlignment = .center
        subtitleTextbarBV.numberOfLines = 0
        BaurbstyleStorebarBV.labelFitbarBV(subtitleTextbarBV, factorbarBV: 0.72, linesbarBV: 0)
        emailEntrybarBV.keyboardType = .emailAddress
        emailEntrybarBV.autocapitalizationType = .none
        emailEntrybarBV.textContentType = .username
        privacySeed.isSecureTextEntry = true
        privacySeed.textContentType = .password
        let actionButtonbarBV = gradientPill(type: .system)
        actionButtonbarBV.setTitle("Log in", for: .normal)
        actionButtonbarBV.setTitleColor(UIColor.black.withAlphaComponent(0.62), for: .normal)
        actionButtonbarBV.titleLabel?.font = BaurbstyleStorebarBV.fontbarBV(22, weight: .heavy)
        BaurbstyleStorebarBV.buttonFitbarBV(actionButtonbarBV)
        actionButtonbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(56)).isActive = true
        actionButtonbarBV.addAction(UIAction { [weak self] _ in self?.loginFlowbarBV() }, for: .touchUpInside)
        stackSurfacebarBV.addArrangedSubview(titleTextbarBV)
        stackSurfacebarBV.setCustomSpacing(BaurbstyleStorebarBV.spacebarBV(12, minimumbarBV: 8, maximumbarBV: 16), after: titleTextbarBV)
        stackSurfacebarBV.addArrangedSubview(subtitleTextbarBV)
        stackSurfacebarBV.setCustomSpacing(BaurbstyleStorebarBV.spacebarBV(48, minimumbarBV: 26, maximumbarBV: 58), after: subtitleTextbarBV)
        stackSurfacebarBV.addArrangedSubview(sectionTitlebarBV("Email"))
        stackSurfacebarBV.setCustomSpacing(BaurbstyleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 18), after: stackSurfacebarBV.arrangedSubviews.last!)
        stackSurfacebarBV.addArrangedSubview(inputPanelbarBV(emailEntrybarBV, "Please enter your email address.", "envelope.fill"))
        stackSurfacebarBV.setCustomSpacing(BaurbstyleStorebarBV.spacebarBV(38, minimumbarBV: 22, maximumbarBV: 46), after: stackSurfacebarBV.arrangedSubviews.last!)
        stackSurfacebarBV.addArrangedSubview(sectionTitlebarBV("Password"))
        stackSurfacebarBV.setCustomSpacing(BaurbstyleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 18), after: stackSurfacebarBV.arrangedSubviews.last!)
        stackSurfacebarBV.addArrangedSubview(inputPanelbarBV(privacySeed, "Please enter your password.", "lock.fill"))
        stackSurfacebarBV.setCustomSpacing(BaurbstyleStorebarBV.spacebarBV(78, minimumbarBV: 34, maximumbarBV: 98), after: stackSurfacebarBV.arrangedSubviews.last!)
        stackSurfacebarBV.addArrangedSubview(actionButtonbarBV)
        stackSurfacebarBV.setCustomSpacing(BaurbstyleStorebarBV.spacebarBV(28, minimumbarBV: 18, maximumbarBV: 36), after: actionButtonbarBV)
        stackSurfacebarBV.addArrangedSubview(switcherbarBV())
        stackSurfacebarBV.setCustomSpacing(BaurbstyleStorebarBV.spacebarBV(52, minimumbarBV: 28, maximumbarBV: 68), after: stackSurfacebarBV.arrangedSubviews.last!)
        stackSurfacebarBV.addArrangedSubview(consentbarBV())
    }

    private func inputPanelbarBV(_ field: UITextField, _ placeholder: String, _ icon: String) -> UIView {
        let fieldHeightbarBV = BaurbstyleStorebarBV.controlbarBV(56)
        let card = cardSurfacebarBV(cornerRadius: fieldHeightbarBV / 2)
        let symbol = UIImageView(image: UIImage(systemName: icon))
        symbol.tintColor = .black
        field.placeholder = placeholder
        field.font = BaurbstyleStorebarBV.fontbarBV(18, weight: .regular)
        field.adjustsFontSizeToFitWidth = true
        field.minimumFontSize = BaurbstyleStorebarBV.sizebarBV(12)
        field.textColor = .black
        card.addSubview(symbol)
        card.addSubview(field)
        symbol.translatesAutoresizingMaskIntoConstraints = false
        field.translatesAutoresizingMaskIntoConstraints = false
        let iconWidthbarBV = BaurbstyleStorebarBV.metricbarBV(23, minimumbarBV: 20, maximumbarBV: 24)
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: fieldHeightbarBV),
            symbol.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(26, minimumbarBV: 20, maximumbarBV: 30)),
            symbol.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            symbol.widthAnchor.constraint(equalToConstant: iconWidthbarBV),
            field.leadingAnchor.constraint(equalTo: symbol.trailingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(14, minimumbarBV: 10, maximumbarBV: 16)),
            field.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 22)),
            field.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])
        return card
    }

    private func sectionTitlebarBV(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = BaurbstyleStorebarBV.fontbarBV(24, weight: .heavy)
        label.textColor = .black
        BaurbstyleStorebarBV.labelFitbarBV(label, factorbarBV: 0.72, linesbarBV: 1)
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
        text.font = BaurbstyleStorebarBV.fontbarBV(18, weight: .regular)
        BaurbstyleStorebarBV.labelFitbarBV(text, factorbarBV: 0.7, linesbarBV: 1)
        let action = UIButton(type: .system)
        action.setTitle("Sign up", for: .normal)
        action.titleLabel?.font = BaurbstyleStorebarBV.fontbarBV(18, weight: .heavy)
        BaurbstyleStorebarBV.buttonFitbarBV(action)
        action.addAction(UIAction { [weak self] _ in
            self?.navigationController?.pushViewController(BaurbCreatePagebarBV(), animated: true)
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
            BaurbsessionStore.agreementFlowbarBV(!BaurbsessionStore.agreementAcceptedbarBV)
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
                .font: BaurbstyleStorebarBV.fontbarBV(18, weight: .regular),
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
        row.spacing = BaurbstyleStorebarBV.metricbarBV(8, minimumbarBV: 6, maximumbarBV: 10)
        row.isLayoutMarginsRelativeArrangement = true
        let insetbarBV = BaurbstyleStorebarBV.metricbarBV(18, minimumbarBV: 8, maximumbarBV: 26)
        row.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: insetbarBV, bottom: 0, trailing: insetbarBV)
        consentMarkbarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(24, minimumbarBV: 22, maximumbarBV: 28)).isActive = true
        agreementRefreshbarBV()
        return row
    }

    private func loginFlowbarBV() {
        guard BaurbsessionStore.agreementAcceptedbarBV else {
            agreementAlertbarBV()
            return
        }
        if let alertText = BaurbsessionStore.loginFlowbarBV(emailEntry: emailEntrybarBV.text ?? "", privacySeed: privacySeed.text ?? "") {
            alertSurfacebarBV(alertText)
        }
    }

    private func agreementRefreshbarBV() {
        let icon = BaurbsessionStore.agreementAcceptedbarBV ? "checkmark.square.fill" : "square"
        consentMarkbarBV.setImage(UIImage(systemName: icon), for: .normal)
        consentMarkbarBV.tintColor = BaurbstyleStorebarBV.purple
    }

    private func agreementAlertbarBV() {
        let alert = UIAlertController(title: "End User License Agreement", message: BaurbsessionStore.agreementCopybarBV(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Decline", style: .cancel))
        alert.addAction(UIAlertAction(title: "Agree", style: .default) { _ in
            BaurbsessionStore.agreementFlowbarBV(true)
        })
        present(alert, animated: true)
    }

    private func alertSurfacebarBV(_ text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension BaurbBoardPagebarBV: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "barb://terms" {
            navigationController?.pushViewController(BaurbagreementPage(), animated: true)
            return false
        }
        if URL.absoluteString == "barb://privacy" {
            navigationController?.pushViewController(BaurbpolicyPagebarBV(), animated: true)
            return false
        }
        return false
    }
}
