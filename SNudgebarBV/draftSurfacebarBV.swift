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
        self.selectedTone = store.selectedReplyTonebarBV
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
        styleStorebarBV.labelFitbarBV(titleLabel, factorbarBV: 0.72, linesbarBV: 1)
        let contextLabel = UILabel()
        contextLabel.text = "Replying to \(thread.localThreadTitle)"
        contextLabel.font = styleStorebarBV.fontbarBV(14, weight: .heavy)
        contextLabel.textColor = styleStorebarBV.purple
        styleStorebarBV.labelFitbarBV(contextLabel, factorbarBV: 0.68, linesbarBV: 1)
        let targetLabel = UILabel()
        targetLabel.text = "\"\(targetMessage.localMessageText)\""
        targetLabel.font = styleStorebarBV.fontbarBV(16, weight: .regular)
        targetLabel.numberOfLines = 2
        targetLabel.textColor = .darkGray
        styleStorebarBV.labelFitbarBV(targetLabel, factorbarBV: 0.72, linesbarBV: 2)
        draftTextView.font = styleStorebarBV.fontbarBV(22, weight: .regular)
        draftTextView.layer.borderColor = UIColor.systemGray5.cgColor
        draftTextView.layer.borderWidth = 1
        draftTextView.layer.cornerRadius = styleStorebarBV.metricbarBV(14, minimumbarBV: 12, maximumbarBV: 16)
        let toneTitle = UILabel()
        toneTitle.text = "AI REPLY STYLE"
        toneTitle.font = styleStorebarBV.fontbarBV(14, weight: .heavy)
        toneTitle.textColor = .black
        styleStorebarBV.labelFitbarBV(toneTitle, factorbarBV: 0.72, linesbarBV: 1)
        let toneEntry = UIButton(type: .system)
        toneEntry.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        toneEntry.tintColor = UIColor.black.withAlphaComponent(0.38)
        toneEntry.accessibilityLabel = "AI Tones"
        toneEntry.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            let tonesbarBV = aiTonesSurfacebarBV(storebarBV: self.store)
            let navbarBV = UINavigationController(rootViewController: tonesbarBV)
            navbarBV.modalPresentationStyle = .pageSheet
            self.present(navbarBV, animated: true)
        }, for: .touchUpInside)
        let toneHeader = UIStackView(arrangedSubviews: [toneTitle, UIView(), toneEntry])
        toneHeader.axis = .horizontal
        toneHeader.alignment = .center
        toneStack.axis = .horizontal
        toneStack.spacing = styleStorebarBV.metricbarBV(8, minimumbarBV: 6, maximumbarBV: 10)
        toneStack.distribution = .fillEqually
        var tonesbarBV: [replyStylebarBV] = [.replyToneWarm, .replyToneShortbarBV, .replyTonePolite]
        if !tonesbarBV.contains(selectedTone) {
            tonesbarBV.append(selectedTone)
        }
        for tone in tonesbarBV {
            let button = UIButton(type: .system)
            button.setTitle(tone.rawValue, for: .normal)
            button.titleLabel?.font = styleStorebarBV.fontbarBV(tonesbarBV.count > 3 ? 14 : 16, weight: .bold)
            styleStorebarBV.buttonFitbarBV(button, factorbarBV: 0.68)
            button.layer.cornerRadius = styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)
            button.addAction(UIAction { [weak self] _ in
                self?.selectedTone = tone
                self?.updateDraft()
            }, for: .touchUpInside)
            toneStack.addArrangedSubview(button)
        }
        let actions = UIStackView()
        actions.spacing = styleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 12)
        actions.distribution = .fillEqually
        let regen = UIButton(type: .system)
        regen.setTitle("Regen", for: .normal)
        regen.addAction(UIAction { [weak self] _ in self?.regenerateDraftbarBV() }, for: .touchUpInside)
        let send = gradientPill(type: .system)
        send.setTitle("Send", for: .normal)
        send.setTitleColor(.black, for: .normal)
        send.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.onSend?(self.draftTextView.text)
            self.dismiss(animated: true)
        }, for: .touchUpInside)
        [regen, send].forEach {
            $0.titleLabel?.font = styleStorebarBV.fontbarBV(19, weight: .bold)
            styleStorebarBV.buttonFitbarBV($0)
            $0.layer.cornerRadius = styleStorebarBV.metricbarBV(14, minimumbarBV: 12, maximumbarBV: 16)
            $0.backgroundColor = $0 === regen ? UIColor.systemGray6 : .clear
            actions.addArrangedSubview($0)
        }
        let stack = UIStackView(arrangedSubviews: [titleLabel, contextLabel, targetLabel, toneHeader, toneStack, draftTextView, actions])
        stack.axis = .vertical
        stack.spacing = styleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 16)
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: styleStorebarBV.spacebarBV(24, minimumbarBV: 16, maximumbarBV: 28)),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: styleStorebarBV.metricbarBV(20, minimumbarBV: 16, maximumbarBV: 22)),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -styleStorebarBV.metricbarBV(20, minimumbarBV: 16, maximumbarBV: 22)),
            draftTextView.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(154, minimumbarBV: 132, maximumbarBV: 170)),
            toneHeader.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(30, minimumbarBV: 28, maximumbarBV: 32)),
            toneEntry.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(30, minimumbarBV: 28, maximumbarBV: 32)),
            toneEntry.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(30, minimumbarBV: 28, maximumbarBV: 32)),
            toneStack.heightAnchor.constraint(equalToConstant: styleStorebarBV.controlbarBV(48)),
            actions.heightAnchor.constraint(equalToConstant: styleStorebarBV.controlbarBV(52))
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

    private func regenerateDraftbarBV() {
        guard store.spendCoinsbarBV(amountbarBV: 100, typebarBV: "aiReplyRegeneratebarBV") else {
            let alertbarBV = UIAlertController(
                title: "Not enough coins",
                message: "Sorry, you don't have enough coins to pay, please go to recharge",
                preferredStyle: .alert
            )
            alertbarBV.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alertbarBV.addAction(UIAlertAction(title: "Buy", style: .default) { [weak self] _ in
                guard let self else { return }
                let topUpbarBV = topUpSurfacebarBV(storebarBV: self.store)
                let navbarBV = UINavigationController(rootViewController: topUpbarBV)
                navbarBV.modalPresentationStyle = .pageSheet
                self.present(navbarBV, animated: true)
            })
            present(alertbarBV, animated: true)
            return
        }
        updateDraft()
    }
}
