import UIKit

final class threadPagebarBV: localSurfacebarBV, UITableViewDataSource, UITableViewDelegate {
    private let store: localStorebarBV
    private var thread: threadFixturebarBV
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let composer = UITextField()

    init(store: localStorebarBV, thread: threadFixturebarBV) {
        self.store = store
        self.thread = thread
        super.init(nibName: nil, bundle: nil)
        title = thread.localThreadTitle
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: nil, action: nil)
        configureTable()
        configureComposer()
    }

    private func configureTable() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(messageSurfacebarBV.self, forCellReuseIdentifier: messageSurfacebarBV.reuseID)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -72)
        ])
    }

    private func configureComposer() {
        let bar = UIView()
        bar.backgroundColor = .white
        let plus = UIButton(type: .system)
        plus.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        plus.tintColor = styleStorebarBV.purple
        let mic = UIButton(type: .system)
        mic.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        mic.tintColor = styleStorebarBV.purple
        composer.placeholder = "Type a message..."
        composer.backgroundColor = UIColor.systemGray6
        composer.layer.cornerRadius = 22
        composer.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        composer.leftViewMode = .always
        composer.returnKeyType = .send
        composer.addAction(UIAction { [weak self] _ in self?.sendTypedMessage() }, for: .primaryActionTriggered)
        view.addSubview(bar)
        [plus, composer, mic].forEach {
            bar.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        bar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bar.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            bar.heightAnchor.constraint(equalToConstant: 72),
            plus.leadingAnchor.constraint(equalTo: bar.leadingAnchor, constant: 16),
            plus.centerYAnchor.constraint(equalTo: bar.centerYAnchor),
            plus.widthAnchor.constraint(equalToConstant: 44),
            plus.heightAnchor.constraint(equalToConstant: 44),
            composer.leadingAnchor.constraint(equalTo: plus.trailingAnchor, constant: 10),
            composer.trailingAnchor.constraint(equalTo: mic.leadingAnchor, constant: -10),
            composer.centerYAnchor.constraint(equalTo: bar.centerYAnchor),
            composer.heightAnchor.constraint(equalToConstant: 46),
            mic.trailingAnchor.constraint(equalTo: bar.trailingAnchor, constant: -16),
            mic.centerYAnchor.constraint(equalTo: bar.centerYAnchor),
            mic.widthAnchor.constraint(equalToConstant: 44),
            mic.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        store.messagePool(for: thread).count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: messageSurfacebarBV.reuseID, for: indexPath) as! messageSurfacebarBV
        cell.configure(message: store.messagePool(for: thread)[indexPath.row], store: store)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = store.messagePool(for: thread)[indexPath.row]
        guard !message.sentFlag else { return }
        let sheet = draftSurfacebarBV(store: store, thread: thread, targetMessage: message)
        sheet.onSend = { [weak self] text in
            guard let self else { return }
            self.store.sendButton(text, in: self.thread)
            self.tableView.reloadData()
            self.scrollToBottom()
        }
        present(sheet, animated: true)
    }

    private func sendTypedMessage() {
        guard let text = composer.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return }
        composer.text = nil
        store.sendButton(text, in: thread)
        tableView.reloadData()
        scrollToBottom()
    }

    private func scrollToBottom() {
        let count = store.messagePool(for: thread).count
        guard count > 0 else { return }
        tableView.scrollToRow(at: IndexPath(row: count - 1, section: 0), at: .bottom, animated: true)
    }
}

final class messageSurfacebarBV: UITableViewCell {
    static let reuseID = "messageSurfacebarBV"
    private let bubble = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        bubble.numberOfLines = 0
        bubble.font = .systemFont(ofSize: 20, weight: .regular)
        bubble.layer.cornerRadius = 18
        bubble.layer.masksToBounds = true
        contentView.addSubview(bubble)
        bubble.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(message: messageFixturebarBV, store: localStorebarBV) {
        bubble.text = "  \(message.localMessageText)  "
        bubble.textColor = message.sentFlag ? .white : .black
        bubble.backgroundColor = message.sentFlag ? styleStorebarBV.blue : .white
        bubble.textAlignment = .natural
        NSLayoutConstraint.deactivate(contentView.constraints)
        let leading = bubble.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: message.sentFlag ? 76 : 18)
        let trailing = bubble.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: message.sentFlag ? -18 : -76)
        NSLayoutConstraint.activate([
            bubble.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubble.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            message.sentFlag ? bubble.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18) : bubble.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            leading,
            trailing
        ])
    }
}
