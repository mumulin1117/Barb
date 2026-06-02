import UIKit

final class BaurbCreatePagebarBV: barbCanvasbarBV {
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
        guard !BaurbsessionStore.agreementAcceptedbarBV, !firstAgreementbarBV else { return }
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
        titleTextbarBV.text = "Create an account"
        titleTextbarBV.font = BaurbstyleStorebarBV.titleFont(34)
        titleTextbarBV.textAlignment = .center
        titleTextbarBV.numberOfLines = 0
        titleTextbarBV.adjustsFontSizeToFitWidth = true
        titleTextbarBV.minimumScaleFactor = 0.78
        titleTextbarBV.lineBreakMode = .byWordWrapping
        let subtitleTextbarBV = UILabel()
        subtitleTextbarBV.text = "Create a new account for you"
        subtitleTextbarBV.font = BaurbstyleStorebarBV.fontbarBV(20, weight: .regular)
        subtitleTextbarBV.textColor = UIColor.black.withAlphaComponent(0.65)
        subtitleTextbarBV.textAlignment = .center
        subtitleTextbarBV.numberOfLines = 0
        BaurbstyleStorebarBV.labelFitbarBV(subtitleTextbarBV, factorbarBV: 0.72, linesbarBV: 0)
        emailEntrybarBV.keyboardType = .emailAddress
        emailEntrybarBV.autocapitalizationType = .none
        privacySeed.isSecureTextEntry = true
        let actionButtonbarBV = gradientPill(type: .system)
        actionButtonbarBV.setTitle("Next", for: .normal)
        actionButtonbarBV.setTitleColor(UIColor.black.withAlphaComponent(0.62), for: .normal)
        actionButtonbarBV.titleLabel?.font = BaurbstyleStorebarBV.fontbarBV(22, weight: .heavy)
        BaurbstyleStorebarBV.buttonFitbarBV(actionButtonbarBV)
        actionButtonbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.controlbarBV(56)).isActive = true
        actionButtonbarBV.addAction(UIAction { [weak self] _ in self?.registerFlowbarBV() }, for: .touchUpInside)
        stackSurfacebarBV.addArrangedSubview(titleTextbarBV)
        stackSurfacebarBV.setCustomSpacing(BaurbstyleStorebarBV.spacebarBV(18, minimumbarBV: 10, maximumbarBV: 24), after: titleTextbarBV)
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

    private func registerFlowbarBV() {
        guard BaurbsessionStore.agreementAcceptedbarBV else {
            agreementAlertbarBV()
            return
        }
        let emailEntry = emailEntrybarBV.text ?? ""
        let privacySeed = privacySeed.text ?? ""
        if let alertText = BaurbsessionStore.registerFlowbarBV(emailEntry: emailEntry, privacySeed: privacySeed) {
            alertSurfacebarBV(alertText)
            return
        }
        navigationController?.pushViewController(BaurbmaterialPage(emailEntry: emailEntry, privacySeed: privacySeed), animated: true)
    }

    private func alertSurfacebarBV(_ text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func agreementAlertbarBV() {
        let alert = UIAlertController(title: "End User License Agreement", message: BaurbsessionStore.agreementCopybarBV(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Decline", style: .cancel))
        alert.addAction(UIAlertAction(title: "Agree", style: .default) { _ in
            BaurbsessionStore.agreementFlowbarBV(true)
        })
        present(alert, animated: true)
    }
}
