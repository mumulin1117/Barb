import UIKit

final class policyPagebarBV: localSurfacebarBV {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Privacy Policy"
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
        Privacy Policy

        Barb stores registration, login state, profile fields, and demo conversation state locally on this device through UserDefaults.

        Apple Guideline 1.2 Safety
        Barb is designed around familiar contacts, blocking, reporting, and privacy controls. Users must not use profile fields, local messages, or simulated replies to create harmful, abusive, explicit, harassing, or objectionable material.

        EULA Notice
        This privacy policy works together with Apple's Standard End User License Agreement and the User Agreement. Continued use means you accept local data storage and responsible behavior rules.

        No Server Requests
        The login and registration flow does not connect to Firebase, Supabase, a custom server, or any real backend service.
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
