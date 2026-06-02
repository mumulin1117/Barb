import UIKit

final class agreementPage: localSurfacebarBV {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User Agreement"
        configureLayout()
    }

    private func configureLayout() {
        let scroll = UIScrollView()
        let label = UILabel()
        view.addSubview(scroll)
        scroll.addSubview(label)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = styleStorebarBV.fontbarBV(16, weight: .regular)
        label.textColor = .black
        styleStorebarBV.labelFitbarBV(label, factorbarBV: 0.72, linesbarBV: 0)
        label.text = """
        User Agreement

        Barb is a local demo messaging experience. You agree to use the app only for lawful, respectful, and familiar communication.

        Apple Guideline 1.2 User Generated Content
        You agree not to create, send, simulate, or encourage abusive, threatening, harassing, hateful, explicit, exploitative, or otherwise objectionable content. Barb includes blocking, reporting, safer contact controls, and privacy settings to support a cleaner experience.

        EULA
        This app follows Apple's Standard End User License Agreement where applicable. Your use of this app is licensed, not sold. You may not misuse, reverse engineer, redistribute, or use this app in a way that violates applicable law, Apple platform rules, or these terms.

        Local Data
        Login, registration, profile, and conversation demo data are stored locally on this device. No real server request is made by this demo flow.
        """
        let insetbarBV = styleStorebarBV.metricbarBV(22, minimumbarBV: 16, maximumbarBV: 24)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            label.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: styleStorebarBV.spacebarBV(22, minimumbarBV: 16, maximumbarBV: 24)),
            label.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: insetbarBV),
            label.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -insetbarBV),
            label.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -styleStorebarBV.spacebarBV(22, minimumbarBV: 16, maximumbarBV: 24))
        ])
    }
}
