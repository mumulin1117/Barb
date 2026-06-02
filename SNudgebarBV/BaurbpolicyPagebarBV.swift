import UIKit

final class BaurbpolicyPagebarBV: barbCanvasbarBV {
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
        label.font = BaurbstyleStorebarBV.fontbarBV(16, weight: .regular)
        label.textColor = .black
        BaurbstyleStorebarBV.labelFitbarBV(label, factorbarBV: 0.72, linesbarBV: 0)
        label.text = """
        Privacy Policy

        Barb is built for familiar messaging with AI-assisted replies. This policy explains the information Barb keeps, how it is used, and the controls available to you.

        Information You Provide
        Barb may store your email, password credential, display name, avatar choice, birthday, selected contacts, conversations, AI Tone choices, coin balance, notification preferences, privacy settings, reports, and blocked contacts. These records are used to keep your chats, profile, settings, and safety controls available in the app.

        Messages and AI Reply
        Barb uses the message you select and the tone you choose to prepare AI Quick Reply drafts inside the app experience. You can edit or discard suggestions before sending. Barb does not require you to send an AI suggestion unchanged.

        Contacts and Safety Controls
        Contact requests, accepted contacts, reports, and block actions help maintain a trusted messaging space. If you block a contact, Barb can remove that contact from visible contact and conversation areas and show the contact in Blacklist until you unblock them.

        Purchases and Coins
        Optional coin packages and related Apple purchase identifiers may be used to support AI Tone unlocks or draft regeneration. Apple handles the purchase transaction flow. Barb stores the resulting wallet state for the active account profile.

        Your Controls
        You can manage notification settings, privacy settings, blocked contacts, AI tone selection, log out, and account deletion inside Barb. Delete Account clears the current account profile and sign-in state on this device according to the app's account flow.

        EULA Notice
        This Privacy Policy works together with the User Agreement and Apple's Standard End User License Agreement where applicable. You must not use Barb to create, send, request, encourage, or distribute harmful, abusive, explicit, harassing, deceptive, illegal, or otherwise objectionable material.

        Children and Sensitive Content
        Barb is intended for responsible everyday communication. Do not use Barb to target minors, share non-consensual content, promote violence, encourage self-harm, or bypass reporting and blocking controls.

        Updates
        Barb may update this policy when features change. Continued use after an update means you accept the updated policy.
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
