import UIKit

final class draftSurfacebarBV: UIViewController {
    private let store: localStorebarBV
    private let thread: threadFixturebarBV
    private let targetMessage: messageFixturebarBV
    private var selectedTone: replyStylebarBV = .replyToneWarm
    private let draftTextView = UITextView()
    private let toneStack = UIStackView()

    var onSend: ((String) -> Void)?

    init(store: localStorebarBV, thread: threadFixturebarBV, targetMessage: messageFixturebarBV) {
        self.store = store
        self.thread = thread
        self.targetMessage = targetMessage
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
        sheetPresentationController?.detents = [.medium(), .large()]
        sheetPresentationController?.prefersGrabberVisible = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        updateDraft()
    }

    private func configureLayout() {
        let titleLabel = UILabel()
        titleLabel.text = "AI Draft"
        titleLabel.font = styleStorebarBV.titleFont(28)
        let contextLabel = UILabel()
        contextLabel.text = "Replying to \(thread.localThreadTitle)"
        contextLabel.font = .systemFont(ofSize: 14, weight: .heavy)
        contextLabel.textColor = styleStorebarBV.purple
        let targetLabel = UILabel()
        targetLabel.text = "\"\(targetMessage.localMessageText)\""
        targetLabel.font = .systemFont(ofSize: 16, weight: .regular)
        targetLabel.numberOfLines = 2
        targetLabel.textColor = .darkGray
        draftTextView.font = .systemFont(ofSize: 22, weight: .regular)
        draftTextView.layer.borderColor = UIColor.systemGray5.cgColor
        draftTextView.layer.borderWidth = 1
        draftTextView.layer.cornerRadius = 16
        toneStack.axis = .horizontal
        toneStack.spacing = 10
        toneStack.distribution = .fillEqually
        for tone in [replyStylebarBV.replyToneWarm, .replyToneShortbarBV, .replyTonePolite] {
            let button = UIButton(type: .system)
            button.setTitle(tone.rawValue, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            button.layer.cornerRadius = 14
            button.addAction(UIAction { [weak self] _ in
                self?.selectedTone = tone
                self?.updateDraft()
            }, for: .touchUpInside)
            toneStack.addArrangedSubview(button)
        }
        let actions = UIStackView()
        actions.spacing = 12
        actions.distribution = .fillEqually
        let regen = UIButton(type: .system)
        regen.setTitle("Regen", for: .normal)
        regen.addAction(UIAction { [weak self] _ in self?.updateDraft() }, for: .touchUpInside)
        let send = gradientPill(type: .system)
        send.setTitle("Send", for: .normal)
        send.setTitleColor(.black, for: .normal)
        send.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.onSend?(self.draftTextView.text)
            self.dismiss(animated: true)
        }, for: .touchUpInside)
        [regen, send].forEach {
            $0.titleLabel?.font = .systemFont(ofSize: 19, weight: .bold)
            $0.layer.cornerRadius = 16
            $0.backgroundColor = $0 === regen ? UIColor.systemGray6 : .clear
            actions.addArrangedSubview($0)
        }
        let stack = UIStackView(arrangedSubviews: [titleLabel, contextLabel, targetLabel, toneStack, draftTextView, actions])
        stack.axis = .vertical
        stack.spacing = 16
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            draftTextView.heightAnchor.constraint(equalToConstant: 170),
            toneStack.heightAnchor.constraint(equalToConstant: 52),
            actions.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    private func updateDraft() {
        draftTextView.text = store.generatedDraftbarBV(for: targetMessage, tone: selectedTone)
        for case let button as UIButton in toneStack.arrangedSubviews {
            let isSelected = button.title(for: .normal) == selectedTone.rawValue
            button.backgroundColor = isSelected ? styleStorebarBV.pink : UIColor.systemGray6
            button.setTitleColor(isSelected ? .white : .darkGray, for: .normal)
        }
    }
}
