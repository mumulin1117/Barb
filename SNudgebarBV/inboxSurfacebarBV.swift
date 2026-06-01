import UIKit

final class inboxSurfacebarBV: localSurfacebarBV, UITableViewDataSource, UITableViewDelegate {
    private let store: localStorebarBV
    private let tableView = UITableView(frame: .zero, style: .plain)

    init(store: localStorebarBV) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        title = "Message"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: nil, action: nil)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(threadSurface.self, forCellReuseIdentifier: threadSurface.reuseID)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        store.threadPoolbarBV.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        106
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: threadSurface.reuseID, for: indexPath) as! threadSurface
        let thread = store.threadPoolbarBV[indexPath.row]
        cell.configure(thread: thread, latest: store.localThreadPreviewbarBV(for: thread), store: store)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(threadPagebarBV(store: store, thread: store.threadPoolbarBV[indexPath.row]), animated: true)
    }
}

final class threadSurface: UITableViewCell {
    static let reuseID = "threadSurface"
    private let card = cardSurfacebarBV(cornerRadius: 20)
    private let avatar = avatarSurfacebarBV(initial: "B")
    private let titleLabel = UILabel()
    private let previewLabel = UILabel()
    private let statusLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        [avatar, titleLabel, previewLabel, statusLabel].forEach {
            card.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        titleLabel.font = .systemFont(ofSize: 21, weight: .heavy)
        previewLabel.font = .systemFont(ofSize: 17, weight: .regular)
        previewLabel.textColor = .darkGray
        statusLabel.font = .systemFont(ofSize: 15, weight: .medium)
        statusLabel.textColor = .systemGreen
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            avatar.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            avatar.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 58),
            avatar.heightAnchor.constraint(equalToConstant: 58),
            titleLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 22),
            previewLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            previewLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            previewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            statusLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -18),
            statusLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 24)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(thread: threadFixturebarBV, latest: messageFixturebarBV?, store: localStorebarBV) {
        titleLabel.text = thread.localThreadTitle
        previewLabel.text = latest?.localMessageText
        statusLabel.text = thread.unreadCounter > 0 ? "\(thread.unreadCounter) waiting" : "Online"
        let initial = thread.localThreadTitle.first.map(String.init) ?? "B"
        avatar.text = initial
        avatar.backgroundColor = thread.smallGroupFlag ? styleStorebarBV.pink : styleStorebarBV.purple
    }
}
