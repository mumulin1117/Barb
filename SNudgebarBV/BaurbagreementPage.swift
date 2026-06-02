import UIKit

final class BaurbagreementPage: barbCanvasbarBV {
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
        label.font = BaurbstyleStorebarBV.fontbarBV(16, weight: .regular)
        label.textColor = .black
        BaurbstyleStorebarBV.labelFitbarBV(label, factorbarBV: 0.72, linesbarBV: 0)
        label.text = """
        User Agreement

        Welcome to Barb. Barb helps people stay connected with familiar contacts through one-on-one chats, simple group conversations, AI Quick Reply, AI Tone preferences, safer contact controls, reporting, blocking, and privacy settings.

        Your Account and Contacts
        You are responsible for the information you provide, the contacts you add, and the messages you send. Use Barb only for lawful, respectful communication with people you choose to connect with. Do not impersonate another person, misrepresent your identity, harvest contact information, spam others, or use Barb to pressure, deceive, or harm another person.

        AI Quick Reply
        AI Quick Reply and AI Tone suggestions are drafting tools. Suggestions may be incomplete, inappropriate for a situation, or not match your intent. Review and edit every suggestion before sending it. You are responsible for messages you send, including messages based on AI suggestions.

        User-Generated Content and Apple Guideline 1.2
        Do not create, send, request, encourage, or distribute abusive, harassing, threatening, hateful, sexually explicit, exploitative, deceptive, illegal, spam, scam, self-harm, or otherwise objectionable content. Do not target minors, promote violence, share non-consensual intimate content, or bypass safety controls. Barb provides blocking, reporting, privacy settings, and safer contact controls to support a cleaner messaging space.

        Reporting and Blocking
        You can report conversations or block contacts inside Barb. Reports and block actions are used to protect the experience and keep conversations centered on trusted connections. People you block may be prevented from messaging you or interacting with your profile inside the app.

        Coins and AI Tones
        Barb may offer optional coin-based features such as AI Tone unlocks or draft regeneration. Coin balances and tone choices belong to the active account profile. Any Apple in-app purchase flow is handled through Apple's purchase system and remains subject to Apple's terms.

        Privacy and Data
        Barb stores your account state, profile, selected contacts, messages, settings, safety actions, and wallet state on this device unless a feature clearly asks you to use Apple purchase services or share content through iOS. See the Privacy Policy for more detail about data categories and controls.

        EULA
        This app follows Apple's Standard End User License Agreement where applicable. Your use of Barb is licensed, not sold. You may not misuse, reverse engineer, redistribute, disrupt, interfere with safety controls, or use Barb in a way that violates applicable law, Apple platform rules, or these terms.

        Account Removal
        You may log out or delete the current account profile from Set up. Deleting an account profile clears that profile's sign-in state and profile cache on this device. Some safety, purchase, or app integrity records may remain where required by platform rules or device operation.

        By continuing to use Barb, you agree to this User Agreement, the Privacy Policy, and the applicable Apple EULA.
        """
        let insetbarBV = BaurbstyleStorebarBV.metricbarBV(22, minimumbarBV: 16, maximumbarBV: 24)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            label.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(22, minimumbarBV: 16, maximumbarBV: 24)),
            label.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: insetbarBV),
            label.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -insetbarBV),
            label.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(22, minimumbarBV: 16, maximumbarBV: 24))
        ])
    }
}
