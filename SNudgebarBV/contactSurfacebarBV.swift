import UIKit

final class contactSurfacebarBV: localSurfacebarBV, UITableViewDataSource, UITableViewDelegate {
    private let store: localStorebarBV
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    init(store: localStorebarBV) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        title = "Partner"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(showScan))
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(contactPanelbarBV.self, forCellReuseIdentifier: contactPanelbarBV.reuseID)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        contactGroupbarBV.allCases.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        contactGroupbarBV.allCases[section].rawValue.uppercased()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts(in: section).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: contactPanelbarBV.reuseID, for: indexPath) as! contactPanelbarBV
        cell.configure(contact: contacts(in: indexPath.section)[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(detailSurface(contact: contacts(in: indexPath.section)[indexPath.row]), animated: true)
    }

    private func contacts(in section: Int) -> [trustedContact] {
        let group = contactGroupbarBV.allCases[section]
        return store.contactPoolbarBV.filter { $0.groupFilter == group }
    }

    @objc private func showScan() {
        navigationController?.pushViewController(scanSurfacebarBV(), animated: true)
    }
}

final class contactPanelbarBV: UITableViewCell {
    static let reuseID = "contactPanelbarBV"
    private let avatar = avatarSurfacebarBV(initial: "B")
    private let nameLabel = UILabel()
    private let noteLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        [avatar, nameLabel, noteLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        nameLabel.font = .systemFont(ofSize: 21, weight: .heavy)
        noteLabel.font = .systemFont(ofSize: 16, weight: .regular)
        noteLabel.textColor = .darkGray
        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 50),
            avatar.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            noteLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            noteLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            noteLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            noteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(contact: trustedContact) {
        avatar.text = contact.placeholderAvatar
        avatar.backgroundColor = contact.onlineFlagbarBV ? styleStorebarBV.purple : styleStorebarBV.blue
        nameLabel.text = contact.placeholderNamebarBV
        noteLabel.text = contact.placeholderNotebarBV
    }
}
