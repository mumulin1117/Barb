import UIKit

final class homeSurfacebarBV: localSurfacebarBV {
    private let store: localStorebarBV
    private let stack = UIStackView()

    init(store: localStorebarBV) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        title = "Barb"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "bell.fill"), style: .plain, target: nil, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: nil, action: nil)
        ]
        configureLayout()
        reload()
    }

    private func configureLayout() {
        let scroll = UIScrollView()
        view.addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 18
        scroll.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24)
        ])
    }

    private func reload() {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let summary = cardSurfacebarBV()
        let label = UILabel()
        label.attributedText = summaryText()
        summary.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            summary.heightAnchor.constraint(equalToConstant: 84),
            label.leadingAnchor.constraint(equalTo: summary.leadingAnchor, constant: 22),
            label.centerYAnchor.constraint(equalTo: summary.centerYAnchor)
        ])
        stack.addArrangedSubview(summary)

        for thread in store.replyQueuebarBV() {
            stack.addArrangedSubview(waitingCard(for: thread))
        }

        stack.addArrangedSubview(styleCard())
    }

    private func summaryText() -> NSAttributedString {
        let unread = store.threadPoolbarBV.reduce(0) { $0 + $1.unreadCounter }
        let string = NSMutableAttributedString(
            string: "\(unread)",
            attributes: [.font: styleStorebarBV.titleFont(34), .foregroundColor: styleStorebarBV.blue]
        )
        string.append(NSAttributedString(
            string: " unread · waiting for reply",
            attributes: [.font: UIFont.systemFont(ofSize: 22, weight: .bold), .foregroundColor: UIColor.black]
        ))
        return string
    }

    private func waitingCard(for thread: threadFixturebarBV) -> UIView {
        let card = cardSurfacebarBV()
        let latest = store.localThreadPreviewbarBV(for: thread)
        let name = UILabel()
        name.text = thread.localThreadTitle
        name.font = styleStorebarBV.titleFont(25)
        let body = UILabel()
        body.text = "\"\(latest?.localMessageText ?? "Tap to continue the conversation.")\""
        body.font = styleStorebarBV.bodyFont(22)
        body.numberOfLines = 3
        let button = gradientPill(type: .system)
        button.setTitle("AI Reply", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 23, weight: .heavy)
        button.addAction(UIAction { [weak self] _ in self?.open(thread) }, for: .touchUpInside)
        let vertical = UIStackView(arrangedSubviews: [name, body, button])
        vertical.axis = .vertical
        vertical.spacing = 16
        card.addSubview(vertical)
        vertical.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(greaterThanOrEqualToConstant: 260),
            button.heightAnchor.constraint(equalToConstant: 56),
            vertical.topAnchor.constraint(equalTo: card.topAnchor, constant: 26),
            vertical.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 22),
            vertical.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -22),
            vertical.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -26)
        ])
        return card
    }

    private func styleCard() -> UIView {
        let card = cardSurfacebarBV()
        let title = UILabel()
        title.text = "AI REPLY STYLE"
        title.font = .systemFont(ofSize: 17, weight: .heavy)
        let row = UIStackView()
        row.distribution = .fillEqually
        row.spacing = 10
        for tone in [replyStylebarBV.replyToneWarm, .replyToneShortbarBV, .replyTonePolite] {
            let button = UIButton(type: .system)
            button.setTitle(tone.rawValue, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
            button.backgroundColor = tone == .replyToneWarm ? styleStorebarBV.mint : UIColor.systemGray6
            button.setTitleColor(tone == .replyToneWarm ? .white : .darkGray, for: .normal)
            button.layer.cornerRadius = 14
            row.addArrangedSubview(button)
        }
        let stack = UIStackView(arrangedSubviews: [title, row])
        stack.axis = .vertical
        stack.spacing = 18
        card.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 142),
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 22),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            row.heightAnchor.constraint(equalToConstant: 52)
        ])
        return card
    }

    private func open(_ thread: threadFixturebarBV) {
        navigationController?.pushViewController(threadPagebarBV(store: store, thread: thread), animated: true)
    }
}
