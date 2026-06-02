import UIKit

private struct contactSectionbarBV {
    let groupbarBV: contactGroupbarBV
    let contactsbarBV: [trustedContact]
}

final class contactSurfacebarBV: localSurfacebarBV, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    private let store: localStorebarBV
    private let headerBarbarBV = UIView()
    private let titleLabelbarBV = UILabel()
    private let titleLinebarBV = gradientPill(type: .system)
    private let addButtonbarBV = gradientPill(type: .system)
    private let searchCardbarBV = UIView()
    private let searchIconbarBV = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    private let searchFieldbarBV = UITextField()
    private let filterScrollbarBV = UIScrollView()
    private let filterStackbarBV = UIStackView()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let emptyLabelbarBV = UILabel()
    private var selectedGroupbarBV: contactGroupbarBV?
    private var searchKeywordbarBV = ""

    private var filteredSectionsbarBV: [contactSectionbarBV] {
        let keywordbarBV = searchKeywordbarBV.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let groupsbarBV = selectedGroupbarBV.map { [$0] } ?? contactGroupbarBV.allCases
        return groupsbarBV.compactMap { groupbarBV in
            let contactsbarBV = store.contactPoolbarBV.filter { contactbarBV in
                guard contactbarBV.groupFilter == groupbarBV else { return false }
                guard !contactbarBV.blockFlag, !store.blockedFlagbarBV(contactSeedbarBV: contactbarBV.contactSeed) else { return false }
                guard !keywordbarBV.isEmpty else { return true }
                return searchableTextbarBV(for: contactbarBV).contains(keywordbarBV)
            }
            guard !contactsbarBV.isEmpty else { return nil }
            return contactSectionbarBV(groupbarBV: groupbarBV, contactsbarBV: contactsbarBV)
        }
    }

    init(store: localStorebarBV) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        title = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderbarBV()
        configureSearchbarBV()
        configureFiltersbarBV()
        configureTablebarBV()
        configureEmptybarBV()
        reloadContentbarBV()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        renderFiltersbarBV()
        reloadContentbarBV()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureHeaderbarBV() {
        titleLabelbarBV.text = "Partner"
        titleLabelbarBV.font = styleStorebarBV.italicFontbarBV(34)
        titleLabelbarBV.textColor = .black
        titleLabelbarBV.adjustsFontSizeToFitWidth = true
        titleLabelbarBV.minimumScaleFactor = 0.72

        titleLinebarBV.isUserInteractionEnabled = false
        titleLinebarBV.colorsbarBV = styleStorebarBV.replyChoiceColorsbarBV
        titleLinebarBV.locationsbarBV = styleStorebarBV.replyChoiceLocationsbarBV
        titleLinebarBV.cornerRadiusbarBV = 2

        addButtonbarBV.setImage(UIImage(systemName: "plus"), for: .normal)
        addButtonbarBV.tintColor = .black
        addButtonbarBV.backgroundColor = .clear
        addButtonbarBV.colorsbarBV = [
            UIColor.white.withAlphaComponent(0.98),
            UIColor(red: 235 / 255, green: 250 / 255, blue: 1, alpha: 1),
            UIColor(red: 1, green: 225 / 255, blue: 248 / 255, alpha: 1)
        ]
        addButtonbarBV.locationsbarBV = [0, 0.48, 1]
        addButtonbarBV.layer.shadowColor = UIColor.black.cgColor
        addButtonbarBV.layer.shadowOpacity = 0.08
        addButtonbarBV.layer.shadowRadius = 10
        addButtonbarBV.layer.shadowOffset = CGSize(width: 0, height: 5)
        addButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.showAddContactbarBV()
        }, for: .touchUpInside)

        view.addSubview(headerBarbarBV)
        [titleLabelbarBV, titleLinebarBV, addButtonbarBV].forEach {
            headerBarbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        headerBarbarBV.translatesAutoresizingMaskIntoConstraints = false

        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 32)
        let buttonSizebarBV = styleStorebarBV.controlbarBV(52)
        NSLayoutConstraint.activate([
            headerBarbarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: styleStorebarBV.spacebarBV(22, minimumbarBV: 14, maximumbarBV: 28)),
            headerBarbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInsetbarBV),
            headerBarbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInsetbarBV),
            headerBarbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(58, minimumbarBV: 50, maximumbarBV: 62)),

            titleLabelbarBV.leadingAnchor.constraint(equalTo: headerBarbarBV.leadingAnchor),
            titleLabelbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor, constant: -styleStorebarBV.spacebarBV(2, minimumbarBV: 0, maximumbarBV: 2)),
            titleLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: addButtonbarBV.leadingAnchor, constant: -styleStorebarBV.metricbarBV(16, minimumbarBV: 12, maximumbarBV: 18)),

            titleLinebarBV.leadingAnchor.constraint(equalTo: titleLabelbarBV.leadingAnchor),
            titleLinebarBV.topAnchor.constraint(equalTo: titleLabelbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(5, minimumbarBV: 4, maximumbarBV: 6)),
            titleLinebarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(56, minimumbarBV: 48, maximumbarBV: 62)),
            titleLinebarBV.heightAnchor.constraint(equalToConstant: 4),

            addButtonbarBV.trailingAnchor.constraint(equalTo: headerBarbarBV.trailingAnchor),
            addButtonbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            addButtonbarBV.widthAnchor.constraint(equalToConstant: buttonSizebarBV),
            addButtonbarBV.heightAnchor.constraint(equalToConstant: buttonSizebarBV)
        ])
    }

    private func configureSearchbarBV() {
        searchCardbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.96)
        searchCardbarBV.layer.cornerRadius = styleStorebarBV.controlbarBV(56) / 2
        searchCardbarBV.layer.masksToBounds = true
        searchIconbarBV.tintColor = styleStorebarBV.mutedText
        searchIconbarBV.contentMode = .scaleAspectFit
        searchFieldbarBV.placeholder = "mobile phone number Email..."
        searchFieldbarBV.font = styleStorebarBV.fontbarBV(16, weight: .semibold)
        searchFieldbarBV.textColor = .black
        searchFieldbarBV.tintColor = styleStorebarBV.purple
        searchFieldbarBV.clearButtonMode = .whileEditing
        searchFieldbarBV.returnKeyType = .search
        searchFieldbarBV.autocorrectionType = .no
        searchFieldbarBV.autocapitalizationType = .none
        searchFieldbarBV.delegate = self
        searchFieldbarBV.addAction(UIAction { [weak self] _ in
            self?.searchKeywordbarBV = self?.searchFieldbarBV.text ?? ""
            self?.reloadContentbarBV()
        }, for: .editingChanged)

        view.addSubview(searchCardbarBV)
        [searchIconbarBV, searchFieldbarBV].forEach {
            searchCardbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        searchCardbarBV.translatesAutoresizingMaskIntoConstraints = false
        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 32)
        NSLayoutConstraint.activate([
            searchCardbarBV.topAnchor.constraint(equalTo: headerBarbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(16, minimumbarBV: 12, maximumbarBV: 20)),
            searchCardbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInsetbarBV),
            searchCardbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInsetbarBV),
            searchCardbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.controlbarBV(56)),

            searchIconbarBV.leadingAnchor.constraint(equalTo: searchCardbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(20, minimumbarBV: 16, maximumbarBV: 22)),
            searchIconbarBV.centerYAnchor.constraint(equalTo: searchCardbarBV.centerYAnchor),
            searchIconbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(28, minimumbarBV: 24, maximumbarBV: 30)),
            searchIconbarBV.heightAnchor.constraint(equalTo: searchIconbarBV.widthAnchor),

            searchFieldbarBV.leadingAnchor.constraint(equalTo: searchIconbarBV.trailingAnchor, constant: styleStorebarBV.metricbarBV(14, minimumbarBV: 10, maximumbarBV: 16)),
            searchFieldbarBV.trailingAnchor.constraint(equalTo: searchCardbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            searchFieldbarBV.topAnchor.constraint(equalTo: searchCardbarBV.topAnchor),
            searchFieldbarBV.bottomAnchor.constraint(equalTo: searchCardbarBV.bottomAnchor)
        ])
    }

    private func configureFiltersbarBV() {
        filterScrollbarBV.showsHorizontalScrollIndicator = false
        filterScrollbarBV.alwaysBounceHorizontal = true
        filterStackbarBV.axis = .horizontal
        filterStackbarBV.alignment = .center
        filterStackbarBV.spacing = styleStorebarBV.metricbarBV(24, minimumbarBV: 18, maximumbarBV: 30)
        view.addSubview(filterScrollbarBV)
        filterScrollbarBV.addSubview(filterStackbarBV)
        filterScrollbarBV.translatesAutoresizingMaskIntoConstraints = false
        filterStackbarBV.translatesAutoresizingMaskIntoConstraints = false

        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 32)
        NSLayoutConstraint.activate([
            filterScrollbarBV.topAnchor.constraint(equalTo: searchCardbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(20, minimumbarBV: 14, maximumbarBV: 24)),
            filterScrollbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterScrollbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterScrollbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(48, minimumbarBV: 42, maximumbarBV: 52)),

            filterStackbarBV.topAnchor.constraint(equalTo: filterScrollbarBV.contentLayoutGuide.topAnchor),
            filterStackbarBV.leadingAnchor.constraint(equalTo: filterScrollbarBV.contentLayoutGuide.leadingAnchor, constant: sideInsetbarBV),
            filterStackbarBV.trailingAnchor.constraint(equalTo: filterScrollbarBV.contentLayoutGuide.trailingAnchor, constant: -sideInsetbarBV),
            filterStackbarBV.bottomAnchor.constraint(equalTo: filterScrollbarBV.contentLayoutGuide.bottomAnchor),
            filterStackbarBV.heightAnchor.constraint(equalTo: filterScrollbarBV.frameLayoutGuide.heightAnchor)
        ])
        renderFiltersbarBV()
    }

    private func configureTablebarBV() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = styleStorebarBV.metricbarBV(72, minimumbarBV: 64, maximumbarBV: 78)
        tableView.sectionHeaderTopPadding = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: styleStorebarBV.spacebarBV(16, minimumbarBV: 12, maximumbarBV: 20), right: 0)
        tableView.register(contactPanelbarBV.self, forCellReuseIdentifier: contactPanelbarBV.reuseID)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: filterScrollbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(6, minimumbarBV: 2, maximumbarBV: 8)),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 32)),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 32)),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func configureEmptybarBV() {
        emptyLabelbarBV.textAlignment = .center
        emptyLabelbarBV.textColor = styleStorebarBV.mutedText
        emptyLabelbarBV.font = styleStorebarBV.fontbarBV(17, weight: .semibold)
        emptyLabelbarBV.numberOfLines = 0
        view.addSubview(emptyLabelbarBV)
        emptyLabelbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyLabelbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: styleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 38)),
            emptyLabelbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -styleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 38)),
            emptyLabelbarBV.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: -styleStorebarBV.spacebarBV(24, minimumbarBV: 12, maximumbarBV: 30))
        ])
    }

    private func renderFiltersbarBV() {
        filterStackbarBV.arrangedSubviews.forEach {
            filterStackbarBV.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        filterStackbarBV.addArrangedSubview(filterButtonbarBV(titlebarBV: "All", countbarBV: store.contactPoolbarBV.filter { !$0.blockFlag && !store.blockedFlagbarBV(contactSeedbarBV: $0.contactSeed) }.count, groupbarBV: nil))
        for groupbarBV in contactGroupbarBV.allCases {
            let countbarBV = store.contactPoolbarBV.filter { $0.groupFilter == groupbarBV && !$0.blockFlag && !store.blockedFlagbarBV(contactSeedbarBV: $0.contactSeed) }.count
            filterStackbarBV.addArrangedSubview(filterButtonbarBV(titlebarBV: groupbarBV.rawValue, countbarBV: countbarBV, groupbarBV: groupbarBV))
        }
    }

    private func filterButtonbarBV(titlebarBV: String, countbarBV: Int, groupbarBV: contactGroupbarBV?) -> UIControl {
        let controlbarBV = UIControl()
        let labelbarBV = UILabel()
        let linebarBV = gradientPill(type: .system)
        let selectedbarBV = selectedGroupbarBV == groupbarBV
        labelbarBV.text = groupbarBV == nil ? "\(titlebarBV) \(countbarBV)" : titlebarBV
        labelbarBV.font = selectedbarBV ? styleStorebarBV.fontbarBV(21, weight: .heavy) : styleStorebarBV.italicFontbarBV(21)
        labelbarBV.textColor = selectedbarBV ? .black : UIColor.black.withAlphaComponent(0.34)
        labelbarBV.adjustsFontSizeToFitWidth = true
        labelbarBV.minimumScaleFactor = 0.75
        linebarBV.isHidden = !selectedbarBV
        linebarBV.isUserInteractionEnabled = false
        linebarBV.colorsbarBV = styleStorebarBV.replyChoiceColorsbarBV
        linebarBV.locationsbarBV = styleStorebarBV.replyChoiceLocationsbarBV
        linebarBV.cornerRadiusbarBV = 2
        [labelbarBV, linebarBV].forEach {
            controlbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            labelbarBV.topAnchor.constraint(equalTo: controlbarBV.topAnchor),
            labelbarBV.leadingAnchor.constraint(equalTo: controlbarBV.leadingAnchor),
            labelbarBV.trailingAnchor.constraint(equalTo: controlbarBV.trailingAnchor),
            linebarBV.leadingAnchor.constraint(equalTo: controlbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(18, minimumbarBV: 12, maximumbarBV: 22)),
            linebarBV.trailingAnchor.constraint(equalTo: controlbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(18, minimumbarBV: 12, maximumbarBV: 22)),
            linebarBV.topAnchor.constraint(equalTo: labelbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(4, minimumbarBV: 3, maximumbarBV: 5)),
            linebarBV.heightAnchor.constraint(equalToConstant: 4),
            linebarBV.bottomAnchor.constraint(equalTo: controlbarBV.bottomAnchor)
        ])
        controlbarBV.addAction(UIAction { [weak self] _ in
            self?.selectedGroupbarBV = groupbarBV
            self?.renderFiltersbarBV()
            self?.reloadContentbarBV()
        }, for: .touchUpInside)
        return controlbarBV
    }

    private func reloadContentbarBV() {
        let sectionsbarBV = filteredSectionsbarBV
        tableView.reloadData()
        let emptybarBV = sectionsbarBV.isEmpty
        tableView.isHidden = emptybarBV
        emptyLabelbarBV.isHidden = !emptybarBV
        if !searchKeywordbarBV.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            emptyLabelbarBV.text = "No contacts found."
        } else {
            emptyLabelbarBV.text = selectedGroupbarBV == nil ? "No contacts found." : "No contacts in this group."
        }
    }

    private func searchableTextbarBV(for contactbarBV: trustedContact) -> String {
        let emailbarBV = "\(contactbarBV.placeholderNamebarBV.replacingOccurrences(of: " ", with: ".").lowercased())@barb.local"
        let phoneSeedbarBV = contactbarBV.placeholderNamebarBV.unicodeScalars.reduce(0) { partialbarBV, scalarbarBV in
            partialbarBV + Int(scalarbarBV.value)
        }
        let phonebarBV = "555\(phoneSeedbarBV % 9000000 + 1000000)"
        return [
            contactbarBV.placeholderNamebarBV,
            contactbarBV.placeholderNotebarBV,
            contactbarBV.groupFilter.rawValue,
            emailbarBV,
            phonebarBV
        ].joined(separator: " ").lowercased()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        filteredSectionsbarBV.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredSectionsbarBV[section].contactsbarBV.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let labelbarBV = UILabel()
        let sectionbarBV = filteredSectionsbarBV[section]
        labelbarBV.text = "\(sectionbarBV.groupbarBV.rawValue.uppercased()) · \(sectionbarBV.contactsbarBV.count)"
        labelbarBV.font = styleStorebarBV.fontbarBV(16, weight: .heavy)
        labelbarBV.textColor = .black
        labelbarBV.letterSpacingbarBV(1.4)
        let shellbarBV = UIView()
        shellbarBV.backgroundColor = .clear
        shellbarBV.addSubview(labelbarBV)
        labelbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelbarBV.leadingAnchor.constraint(equalTo: shellbarBV.leadingAnchor),
            labelbarBV.trailingAnchor.constraint(equalTo: shellbarBV.trailingAnchor),
            labelbarBV.bottomAnchor.constraint(equalTo: shellbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10))
        ])
        return shellbarBV
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        styleStorebarBV.metricbarBV(44, minimumbarBV: 36, maximumbarBV: 48)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        styleStorebarBV.spacebarBV(14, minimumbarBV: 8, maximumbarBV: 18)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: contactPanelbarBV.reuseID, for: indexPath) as! contactPanelbarBV
        let sectionbarBV = filteredSectionsbarBV[indexPath.section]
        let contactbarBV = sectionbarBV.contactsbarBV[indexPath.row]
        cell.configure(contact: contactbarBV, firstbarBV: indexPath.row == 0, lastbarBV: indexPath.row == sectionbarBV.contactsbarBV.count - 1)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(detailSurface(contact: filteredSectionsbarBV[indexPath.section].contactsbarBV[indexPath.row], store: store), animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc private func showAddContactbarBV() {
        let addContactbarBV = addContactSurfacebarBV(store: store)
        addContactbarBV.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(addContactbarBV, animated: true)
    }
}

final class contactPanelbarBV: UITableViewCell {
    static let reuseID = "contactPanelbarBV"
    private let cardbarBV = UIView()
    private let avatar = avatarSurfacebarBV(initial: "B")
    private let nameLabel = UILabel()
    private let noteLabel = UILabel()
    private let dividerbarBV = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        cardbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.97)
        cardbarBV.layer.masksToBounds = true
        dividerbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.06)
        [cardbarBV].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [avatar, nameLabel, noteLabel, dividerbarBV].forEach {
            cardbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        nameLabel.font = styleStorebarBV.fontbarBV(18, weight: .heavy)
        nameLabel.textColor = .black
        styleStorebarBV.labelFitbarBV(nameLabel, factorbarBV: 0.68, linesbarBV: 1)
        noteLabel.font = styleStorebarBV.fontbarBV(15, weight: .regular)
        noteLabel.textColor = UIColor.black.withAlphaComponent(0.62)
        styleStorebarBV.labelFitbarBV(noteLabel, factorbarBV: 0.7, linesbarBV: 1)
        NSLayoutConstraint.activate([
            cardbarBV.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardbarBV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardbarBV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardbarBV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            avatar.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 32)),
            avatar.centerYAnchor.constraint(equalTo: cardbarBV.centerYAnchor),
            avatar.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(50, minimumbarBV: 44, maximumbarBV: 56)),
            avatar.heightAnchor.constraint(equalTo: avatar.widthAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: styleStorebarBV.metricbarBV(18, minimumbarBV: 14, maximumbarBV: 20)),
            nameLabel.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(20, minimumbarBV: 16, maximumbarBV: 24)),
            nameLabel.topAnchor.constraint(equalTo: cardbarBV.topAnchor, constant: styleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 16)),

            noteLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            noteLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            noteLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: styleStorebarBV.spacebarBV(4, minimumbarBV: 3, maximumbarBV: 5)),
            noteLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(12, minimumbarBV: 8, maximumbarBV: 14)),

            dividerbarBV.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            dividerbarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor),
            dividerbarBV.bottomAnchor.constraint(equalTo: cardbarBV.bottomAnchor),
            dividerbarBV.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(contact: trustedContact, firstbarBV: Bool, lastbarBV: Bool) {
        avatar.text = contact.placeholderAvatar
        avatar.backgroundColor = colorbarBV(for: contact)
        nameLabel.text = contact.placeholderNamebarBV
        noteLabel.text = contact.placeholderNotebarBV
        dividerbarBV.isHidden = lastbarBV
        let radiusbarBV = styleStorebarBV.metricbarBV(24, minimumbarBV: 20, maximumbarBV: 26)
        cardbarBV.layer.cornerRadius = radiusbarBV
        if firstbarBV && lastbarBV {
            cardbarBV.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else if firstbarBV {
            cardbarBV.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if lastbarBV {
            cardbarBV.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cardbarBV.layer.maskedCorners = []
        }
    }

    private func colorbarBV(for contact: trustedContact) -> UIColor {
        switch contact.groupFilter {
        case .familyFilterbarBV:
            if contact.placeholderAvatar == "D" { return UIColor(red: 1, green: 158 / 255, blue: 8 / 255, alpha: 1) }
            if contact.placeholderAvatar == "S" { return UIColor(red: 132 / 255, green: 84 / 255, blue: 238 / 255, alpha: 1) }
            return UIColor(red: 245 / 255, green: 51 / 255, blue: 88 / 255, alpha: 1)
        case .friendFilter:
            if contact.placeholderAvatar == "L" { return UIColor(red: 25 / 255, green: 183 / 255, blue: 165 / 255, alpha: 1) }
            if contact.placeholderAvatar == "A" { return UIColor(red: 55 / 255, green: 116 / 255, blue: 238 / 255, alpha: 1) }
            return UIColor(red: 1, green: 92 / 255, blue: 48 / 255, alpha: 1)
        case .workFilterbarBV:
            return styleStorebarBV.purple
        case .otherFilter:
            return styleStorebarBV.blue
        }
    }
}

final class addContactSurfacebarBV: localSurfacebarBV {
    private let store: localStorebarBV
    private var contactCardLocalbarBV: contactCardbarBV
    private let headerBarbarBV = UIView()
    private let backButtonbarBV = UIButton(type: .system)
    private let headerTitlebarBV = UILabel()
    private let scrollViewbarBV = UIScrollView()
    private let contentViewbarBV = UIView()
    private let contentStackbarBV = UIStackView()
    private let heroTitlebarBV = UILabel()
    private let heroSubtitlebarBV = UILabel()
    private let qrCardbarBV = cardSurfacebarBV(cornerRadius: 30)
    private let qrSurfacebarBV = contactQRSurfacebarBV()
    private let nameLabelbarBV = UILabel()
    private let idLabelbarBV = UILabel()
    private let entryCardbarBV = cardSurfacebarBV(cornerRadius: 26)
    private let entryStackbarBV = UIStackView()
    private weak var requestsEntrybarBV: contactEntryItembarBV?

    init(store: localStorebarBV) {
        self.store = store
        self.contactCardLocalbarBV = store.contactCardFlowbarBV()
        super.init(nibName: nil, bundle: nil)
        title = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderbarBV()
        configureScrollbarBV()
        configureHerobarBV()
        configureQRCardbarBV()
        configureEntriesbarBV()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        refreshCardbarBV()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureHeaderbarBV() {
        backButtonbarBV.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButtonbarBV.tintColor = .black
        backButtonbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.38)
        backButtonbarBV.layer.cornerRadius = styleStorebarBV.controlbarBV(44) / 2
        backButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)

        headerTitlebarBV.text = "Add Contact"
        headerTitlebarBV.font = styleStorebarBV.fontbarBV(21, weight: .heavy)
        headerTitlebarBV.textColor = .black
        headerTitlebarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(headerTitlebarBV, factorbarBV: 0.72, linesbarBV: 1)

        view.addSubview(headerBarbarBV)
        [backButtonbarBV, headerTitlebarBV].forEach {
            headerBarbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        headerBarbarBV.translatesAutoresizingMaskIntoConstraints = false

        let sideInsetbarBV = styleStorebarBV.metricbarBV(26, minimumbarBV: 18, maximumbarBV: 30)
        let buttonSizebarBV = styleStorebarBV.controlbarBV(44)
        NSLayoutConstraint.activate([
            headerBarbarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: styleStorebarBV.spacebarBV(10, minimumbarBV: 6, maximumbarBV: 14)),
            headerBarbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInsetbarBV),
            headerBarbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInsetbarBV),
            headerBarbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(50, minimumbarBV: 46, maximumbarBV: 54)),

            backButtonbarBV.leadingAnchor.constraint(equalTo: headerBarbarBV.leadingAnchor),
            backButtonbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            backButtonbarBV.widthAnchor.constraint(equalToConstant: buttonSizebarBV),
            backButtonbarBV.heightAnchor.constraint(equalToConstant: buttonSizebarBV),

            headerTitlebarBV.centerXAnchor.constraint(equalTo: headerBarbarBV.centerXAnchor),
            headerTitlebarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            headerTitlebarBV.leadingAnchor.constraint(greaterThanOrEqualTo: backButtonbarBV.trailingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            headerTitlebarBV.trailingAnchor.constraint(lessThanOrEqualTo: headerBarbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(54, minimumbarBV: 48, maximumbarBV: 58))
        ])
    }

    private func configureScrollbarBV() {
        scrollViewbarBV.showsVerticalScrollIndicator = false
        scrollViewbarBV.alwaysBounceVertical = true
        scrollViewbarBV.keyboardDismissMode = .onDrag
        contentStackbarBV.axis = .vertical
        contentStackbarBV.alignment = .fill
        contentStackbarBV.spacing = styleStorebarBV.spacebarBV(22, minimumbarBV: 16, maximumbarBV: 26)

        view.addSubview(scrollViewbarBV)
        scrollViewbarBV.addSubview(contentViewbarBV)
        contentViewbarBV.addSubview(contentStackbarBV)
        [scrollViewbarBV, contentViewbarBV, contentStackbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 32)
        NSLayoutConstraint.activate([
            scrollViewbarBV.topAnchor.constraint(equalTo: headerBarbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(4, minimumbarBV: 0, maximumbarBV: 8)),
            scrollViewbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollViewbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewbarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentViewbarBV.topAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.topAnchor),
            contentViewbarBV.leadingAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.leadingAnchor),
            contentViewbarBV.trailingAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.trailingAnchor),
            contentViewbarBV.bottomAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.bottomAnchor),
            contentViewbarBV.widthAnchor.constraint(equalTo: scrollViewbarBV.frameLayoutGuide.widthAnchor),

            contentStackbarBV.topAnchor.constraint(equalTo: contentViewbarBV.topAnchor, constant: styleStorebarBV.spacebarBV(18, minimumbarBV: 10, maximumbarBV: 22)),
            contentStackbarBV.leadingAnchor.constraint(equalTo: contentViewbarBV.leadingAnchor, constant: sideInsetbarBV),
            contentStackbarBV.trailingAnchor.constraint(equalTo: contentViewbarBV.trailingAnchor, constant: -sideInsetbarBV),
            contentStackbarBV.bottomAnchor.constraint(equalTo: contentViewbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(30, minimumbarBV: 22, maximumbarBV: 36))
        ])
    }

    private func configureHerobarBV() {
        heroTitlebarBV.text = "Find someone"
        heroTitlebarBV.font = styleStorebarBV.fontbarBV(34, weight: .heavy)
        heroTitlebarBV.textColor = .black
        heroTitlebarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(heroTitlebarBV, factorbarBV: 0.68, linesbarBV: 1)

        heroSubtitlebarBV.text = "Both sides must agree to connect."
        heroSubtitlebarBV.font = styleStorebarBV.fontbarBV(17, weight: .regular)
        heroSubtitlebarBV.textColor = UIColor.black.withAlphaComponent(0.62)
        heroSubtitlebarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(heroSubtitlebarBV, factorbarBV: 0.72, linesbarBV: 2)

        let heroStackbarBV = UIStackView(arrangedSubviews: [heroTitlebarBV, heroSubtitlebarBV])
        heroStackbarBV.axis = .vertical
        heroStackbarBV.alignment = .fill
        heroStackbarBV.spacing = styleStorebarBV.spacebarBV(8, minimumbarBV: 5, maximumbarBV: 10)
        contentStackbarBV.addArrangedSubview(heroStackbarBV)
    }

    private func configureQRCardbarBV() {
        qrSurfacebarBV.valuebarBV = contactCardLocalbarBV.qrCodeValuebarBV
        nameLabelbarBV.text = contactCardLocalbarBV.namebarBV
        nameLabelbarBV.font = styleStorebarBV.fontbarBV(24, weight: .heavy)
        nameLabelbarBV.textColor = .black
        nameLabelbarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(nameLabelbarBV, factorbarBV: 0.68, linesbarBV: 1)

        idLabelbarBV.text = contactCardLocalbarBV.barbIdbarBV
        idLabelbarBV.font = styleStorebarBV.fontbarBV(15, weight: .heavy)
        idLabelbarBV.textColor = styleStorebarBV.mutedText
        idLabelbarBV.textAlignment = .center
        idLabelbarBV.letterSpacingbarBV(1.0)

        contentStackbarBV.addArrangedSubview(qrCardbarBV)
        [qrSurfacebarBV, nameLabelbarBV, idLabelbarBV].forEach {
            qrCardbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            qrSurfacebarBV.topAnchor.constraint(equalTo: qrCardbarBV.topAnchor, constant: styleStorebarBV.spacebarBV(26, minimumbarBV: 18, maximumbarBV: 30)),
            qrSurfacebarBV.centerXAnchor.constraint(equalTo: qrCardbarBV.centerXAnchor),
            qrSurfacebarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(170, minimumbarBV: 144, maximumbarBV: 184)),
            qrSurfacebarBV.heightAnchor.constraint(equalTo: qrSurfacebarBV.widthAnchor),

            nameLabelbarBV.topAnchor.constraint(equalTo: qrSurfacebarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 20)),
            nameLabelbarBV.leadingAnchor.constraint(equalTo: qrCardbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(20, minimumbarBV: 16, maximumbarBV: 24)),
            nameLabelbarBV.trailingAnchor.constraint(equalTo: qrCardbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(20, minimumbarBV: 16, maximumbarBV: 24)),

            idLabelbarBV.topAnchor.constraint(equalTo: nameLabelbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(6, minimumbarBV: 4, maximumbarBV: 7)),
            idLabelbarBV.leadingAnchor.constraint(equalTo: nameLabelbarBV.leadingAnchor),
            idLabelbarBV.trailingAnchor.constraint(equalTo: nameLabelbarBV.trailingAnchor),
            idLabelbarBV.bottomAnchor.constraint(equalTo: qrCardbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(24, minimumbarBV: 16, maximumbarBV: 28))
        ])
    }

    private func configureEntriesbarBV() {
        entryStackbarBV.axis = .vertical
        entryStackbarBV.spacing = styleStorebarBV.spacebarBV(4, minimumbarBV: 2, maximumbarBV: 6)
        contentStackbarBV.addArrangedSubview(entryCardbarBV)
        entryCardbarBV.addSubview(entryStackbarBV)
        entryStackbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            entryStackbarBV.topAnchor.constraint(equalTo: entryCardbarBV.topAnchor, constant: styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10)),
            entryStackbarBV.leadingAnchor.constraint(equalTo: entryCardbarBV.leadingAnchor, constant: styleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            entryStackbarBV.trailingAnchor.constraint(equalTo: entryCardbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            entryStackbarBV.bottomAnchor.constraint(equalTo: entryCardbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(8, minimumbarBV: 6, maximumbarBV: 10))
        ])

        let scanbarBV = contactEntryItembarBV(titlebarBV: "Scan QR Code", subtitlebarBV: nil, systemImagebarBV: "qrcode.viewfinder")
        scanbarBV.addAction(UIAction { [weak self] _ in self?.showScanbarBV() }, for: .touchUpInside)
        entryStackbarBV.addArrangedSubview(scanbarBV)

        let phonebarBV = contactEntryItembarBV(titlebarBV: "Phone or Email", subtitlebarBV: "Search trusted people", systemImagebarBV: "envelope.fill")
        phonebarBV.addAction(UIAction { [weak self] _ in self?.showHintbarBV("Search coming soon") }, for: .touchUpInside)
        entryStackbarBV.addArrangedSubview(phonebarBV)

        let sharebarBV = contactEntryItembarBV(titlebarBV: "Share my link", subtitlebarBV: contactCardLocalbarBV.shareLinkbarBV, systemImagebarBV: "square.and.arrow.up")
        sharebarBV.addAction(UIAction { [weak self] _ in self?.shareLinkbarBV() }, for: .touchUpInside)
        entryStackbarBV.addArrangedSubview(sharebarBV)

        let requestTextbarBV = "\(contactCardLocalbarBV.pendingRequestCountbarBV) waiting for you"
        let requestsbarBV = contactEntryItembarBV(titlebarBV: "Friend Requests", subtitlebarBV: requestTextbarBV, systemImagebarBV: "bell.badge.fill")
        requestsbarBV.addAction(UIAction { [weak self] _ in self?.showRequestsbarBV() }, for: .touchUpInside)
        entryStackbarBV.addArrangedSubview(requestsbarBV)
        requestsEntrybarBV = requestsbarBV
    }

    private func showScanbarBV() {
        let scanbarBV = scanSurfacebarBV()
        scanbarBV.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(scanbarBV, animated: true)
    }

    private func shareLinkbarBV() {
        let controllerbarBV = UIActivityViewController(
            activityItems: [contactCardLocalbarBV.shareLinkbarBV],
            applicationActivities: nil
        )
        if let popoverbarBV = controllerbarBV.popoverPresentationController {
            popoverbarBV.sourceView = view
            popoverbarBV.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 1, height: 1)
            popoverbarBV.permittedArrowDirections = []
        }
        present(controllerbarBV, animated: true)
    }

    private func showRequestsbarBV() {
        let requestsbarBV = requestsSurfacebarBV(store: store)
        requestsbarBV.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(requestsbarBV, animated: true)
    }

    private func refreshCardbarBV() {
        contactCardLocalbarBV = store.contactCardFlowbarBV()
        nameLabelbarBV.text = contactCardLocalbarBV.namebarBV
        idLabelbarBV.text = contactCardLocalbarBV.barbIdbarBV
        qrSurfacebarBV.valuebarBV = contactCardLocalbarBV.qrCodeValuebarBV
        requestsEntrybarBV?.updateSubtitlebarBV("\(contactCardLocalbarBV.pendingRequestCountbarBV) waiting for you")
    }

    private func showHintbarBV(_ messagebarBV: String) {
        let alertbarBV = UIAlertController(title: nil, message: messagebarBV, preferredStyle: .alert)
        alertbarBV.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertbarBV, animated: true)
    }
}

final class requestsSurfacebarBV: localSurfacebarBV {
    private let store: localStorebarBV
    private let headerBarbarBV = UIView()
    private let backButtonbarBV = UIButton(type: .system)
    private let titleLabelbarBV = UILabel()
    private let scrollViewbarBV = UIScrollView()
    private let contentViewbarBV = UIView()
    private let stackbarBV = UIStackView()
    private let footerLabelbarBV = UILabel()
    private let statusLabelbarBV = UILabel()
    private var statusWorkbarBV: DispatchWorkItem?

    init(store: localStorebarBV) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        title = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderbarBV()
        configureScrollbarBV()
        configureStatusbarBV()
        renderRequestsbarBV()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        renderRequestsbarBV()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureHeaderbarBV() {
        backButtonbarBV.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButtonbarBV.tintColor = .black
        backButtonbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.38)
        backButtonbarBV.layer.cornerRadius = styleStorebarBV.controlbarBV(44) / 2
        backButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)

        titleLabelbarBV.text = "Requests"
        titleLabelbarBV.font = styleStorebarBV.fontbarBV(28, weight: .heavy)
        titleLabelbarBV.textColor = .black
        titleLabelbarBV.textAlignment = .center
        styleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.68, linesbarBV: 1)

        view.addSubview(headerBarbarBV)
        [backButtonbarBV, titleLabelbarBV].forEach {
            headerBarbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        headerBarbarBV.translatesAutoresizingMaskIntoConstraints = false

        let sideInsetbarBV = styleStorebarBV.metricbarBV(26, minimumbarBV: 18, maximumbarBV: 30)
        let buttonSizebarBV = styleStorebarBV.controlbarBV(44)
        NSLayoutConstraint.activate([
            headerBarbarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: styleStorebarBV.spacebarBV(10, minimumbarBV: 6, maximumbarBV: 14)),
            headerBarbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInsetbarBV),
            headerBarbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInsetbarBV),
            headerBarbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(54, minimumbarBV: 48, maximumbarBV: 58)),

            backButtonbarBV.leadingAnchor.constraint(equalTo: headerBarbarBV.leadingAnchor),
            backButtonbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            backButtonbarBV.widthAnchor.constraint(equalToConstant: buttonSizebarBV),
            backButtonbarBV.heightAnchor.constraint(equalToConstant: buttonSizebarBV),

            titleLabelbarBV.centerXAnchor.constraint(equalTo: headerBarbarBV.centerXAnchor),
            titleLabelbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            titleLabelbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: backButtonbarBV.trailingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            titleLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: headerBarbarBV.trailingAnchor, constant: -styleStorebarBV.metricbarBV(54, minimumbarBV: 48, maximumbarBV: 58))
        ])
    }

    private func configureScrollbarBV() {
        scrollViewbarBV.showsVerticalScrollIndicator = false
        scrollViewbarBV.alwaysBounceVertical = true
        stackbarBV.axis = .vertical
        stackbarBV.alignment = .fill
        stackbarBV.spacing = styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 22)

        view.addSubview(scrollViewbarBV)
        scrollViewbarBV.addSubview(contentViewbarBV)
        contentViewbarBV.addSubview(stackbarBV)
        [scrollViewbarBV, contentViewbarBV, stackbarBV].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        let sideInsetbarBV = styleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 32)
        NSLayoutConstraint.activate([
            scrollViewbarBV.topAnchor.constraint(equalTo: headerBarbarBV.bottomAnchor, constant: styleStorebarBV.spacebarBV(18, minimumbarBV: 12, maximumbarBV: 22)),
            scrollViewbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollViewbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewbarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentViewbarBV.topAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.topAnchor),
            contentViewbarBV.leadingAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.leadingAnchor),
            contentViewbarBV.trailingAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.trailingAnchor),
            contentViewbarBV.bottomAnchor.constraint(equalTo: scrollViewbarBV.contentLayoutGuide.bottomAnchor),
            contentViewbarBV.widthAnchor.constraint(equalTo: scrollViewbarBV.frameLayoutGuide.widthAnchor),

            stackbarBV.topAnchor.constraint(equalTo: contentViewbarBV.topAnchor),
            stackbarBV.leadingAnchor.constraint(equalTo: contentViewbarBV.leadingAnchor, constant: sideInsetbarBV),
            stackbarBV.trailingAnchor.constraint(equalTo: contentViewbarBV.trailingAnchor, constant: -sideInsetbarBV),
            stackbarBV.bottomAnchor.constraint(equalTo: contentViewbarBV.bottomAnchor, constant: -styleStorebarBV.spacebarBV(30, minimumbarBV: 22, maximumbarBV: 36))
        ])

        footerLabelbarBV.text = "Both sides must accept before you can chat."
        footerLabelbarBV.font = styleStorebarBV.fontbarBV(16, weight: .regular)
        footerLabelbarBV.textColor = .black
        footerLabelbarBV.textAlignment = .center
        footerLabelbarBV.numberOfLines = 0
        styleStorebarBV.labelFitbarBV(footerLabelbarBV, factorbarBV: 0.72, linesbarBV: 0)
    }

    private func configureStatusbarBV() {
        statusLabelbarBV.alpha = 0
        statusLabelbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.74)
        statusLabelbarBV.textColor = .white
        statusLabelbarBV.font = styleStorebarBV.fontbarBV(14, weight: .bold)
        statusLabelbarBV.textAlignment = .center
        statusLabelbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(17, minimumbarBV: 15, maximumbarBV: 18)
        statusLabelbarBV.layer.masksToBounds = true
        styleStorebarBV.labelFitbarBV(statusLabelbarBV, factorbarBV: 0.72, linesbarBV: 1)
        view.addSubview(statusLabelbarBV)
        statusLabelbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabelbarBV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabelbarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -styleStorebarBV.spacebarBV(24, minimumbarBV: 16, maximumbarBV: 28)),
            statusLabelbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: styleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 40)),
            statusLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -styleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 40)),
            statusLabelbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(34, minimumbarBV: 30, maximumbarBV: 36))
        ])
    }

    private func renderRequestsbarBV() {
        stackbarBV.arrangedSubviews.forEach {
            stackbarBV.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let pendingbarBV = store.pendingRequestsbarBV()
        let sentbarBV = store.sentRequestsbarBV()
        stackbarBV.addArrangedSubview(sectionTitlebarBV("PENDING · \(pendingbarBV.count) (MUTUAL CONFIRMATION)"))
        stackbarBV.addArrangedSubview(sectionCardbarBV(requestsbarBV: pendingbarBV, sentbarBV: false))
        stackbarBV.addArrangedSubview(sectionTitlebarBV("SENT · \(sentbarBV.count)"))
        stackbarBV.addArrangedSubview(sectionCardbarBV(requestsbarBV: sentbarBV, sentbarBV: true))
        let spacerbarBV = UIView()
        spacerbarBV.translatesAutoresizingMaskIntoConstraints = false
        spacerbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.spacebarBV(12, minimumbarBV: 8, maximumbarBV: 16)).isActive = true
        stackbarBV.addArrangedSubview(spacerbarBV)
        stackbarBV.addArrangedSubview(footerLabelbarBV)
    }

    private func sectionTitlebarBV(_ textbarBV: String) -> UILabel {
        let labelbarBV = UILabel()
        labelbarBV.text = textbarBV
        labelbarBV.font = styleStorebarBV.fontbarBV(15, weight: .heavy)
        labelbarBV.textColor = .black
        labelbarBV.numberOfLines = 1
        labelbarBV.adjustsFontSizeToFitWidth = true
        labelbarBV.minimumScaleFactor = 0.62
        labelbarBV.letterSpacingbarBV(1.6)
        return labelbarBV
    }

    private func sectionCardbarBV(requestsbarBV: [contactRequestbarBV], sentbarBV: Bool) -> UIView {
        let cardbarBV = cardSurfacebarBV(cornerRadius: styleStorebarBV.metricbarBV(26, minimumbarBV: 22, maximumbarBV: 30))
        let stackbarBV = UIStackView()
        stackbarBV.axis = .vertical
        stackbarBV.spacing = 0
        cardbarBV.addSubview(stackbarBV)
        stackbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackbarBV.topAnchor.constraint(equalTo: cardbarBV.topAnchor),
            stackbarBV.leadingAnchor.constraint(equalTo: cardbarBV.leadingAnchor),
            stackbarBV.trailingAnchor.constraint(equalTo: cardbarBV.trailingAnchor),
            stackbarBV.bottomAnchor.constraint(equalTo: cardbarBV.bottomAnchor)
        ])

        if requestsbarBV.isEmpty {
            let emptybarBV = UILabel()
            emptybarBV.text = sentbarBV ? "No sent requests." : "No pending requests."
            emptybarBV.textColor = styleStorebarBV.mutedText
            emptybarBV.textAlignment = .center
            emptybarBV.font = styleStorebarBV.fontbarBV(15, weight: .semibold)
            emptybarBV.numberOfLines = 0
            stackbarBV.addArrangedSubview(emptybarBV)
            emptybarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(76, minimumbarBV: 64, maximumbarBV: 82)).isActive = true
            return cardbarBV
        }

        for (indexbarBV, requestbarBV) in requestsbarBV.enumerated() {
            let rowbarBV = requestPanelbarBV(requestbarBV: requestbarBV, sentbarBV: sentbarBV)
            rowbarBV.acceptHandlerbarBV = { [weak self] requestbarBV in
                self?.acceptbarBV(requestbarBV)
            }
            rowbarBV.rejectHandlerbarBV = { [weak self] requestbarBV in
                self?.rejectbarBV(requestbarBV)
            }
            rowbarBV.cancelHandlerbarBV = { [weak self] requestbarBV in
                self?.cancelbarBV(requestbarBV)
            }
            stackbarBV.addArrangedSubview(rowbarBV)
            rowbarBV.heightAnchor.constraint(greaterThanOrEqualToConstant: styleStorebarBV.metricbarBV(112, minimumbarBV: 96, maximumbarBV: 124)).isActive = true
            if indexbarBV < requestsbarBV.count - 1 {
                let dividerbarBV = UIView()
                dividerbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.06)
                stackbarBV.addArrangedSubview(dividerbarBV)
                dividerbarBV.heightAnchor.constraint(equalToConstant: 1).isActive = true
            }
        }
        return cardbarBV
    }

    private func acceptbarBV(_ requestbarBV: contactRequestbarBV) {
        _ = store.acceptRequestbarBV(requestbarBV)
        renderRequestsbarBV()
        showStatusbarBV("Request accepted")
    }

    private func rejectbarBV(_ requestbarBV: contactRequestbarBV) {
        store.rejectRequestbarBV(requestbarBV)
        renderRequestsbarBV()
        showStatusbarBV("Request rejected")
    }

    private func cancelbarBV(_ requestbarBV: contactRequestbarBV) {
        store.cancelRequestbarBV(requestbarBV)
        renderRequestsbarBV()
        showStatusbarBV("Request cancelled")
    }

    private func showStatusbarBV(_ textbarBV: String) {
        statusWorkbarBV?.cancel()
        statusLabelbarBV.text = "  \(textbarBV)  "
        UIView.animate(withDuration: 0.18) {
            self.statusLabelbarBV.alpha = 1
        }
        let workbarBV = DispatchWorkItem { [weak self] in
            UIView.animate(withDuration: 0.22) {
                self?.statusLabelbarBV.alpha = 0
            }
        }
        statusWorkbarBV = workbarBV
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25, execute: workbarBV)
    }
}

final class requestPanelbarBV: UIView {
    var acceptHandlerbarBV: ((contactRequestbarBV) -> Void)?
    var rejectHandlerbarBV: ((contactRequestbarBV) -> Void)?
    var cancelHandlerbarBV: ((contactRequestbarBV) -> Void)?

    private let requestbarBV: contactRequestbarBV
    private let sentbarBV: Bool
    private let avatarbarBV = avatarSurfacebarBV(initial: "B")
    private let nameLabelbarBV = UILabel()
    private let sourceLabelbarBV = UILabel()
    private let actionStackbarBV = UIStackView()

    init(requestbarBV: contactRequestbarBV, sentbarBV: Bool) {
        self.requestbarBV = requestbarBV
        self.sentbarBV = sentbarBV
        super.init(frame: .zero)
        configurebarBV()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configurebarBV() {
        avatarbarBV.text = requestbarBV.avatarbarBV
        avatarbarBV.backgroundColor = colorbarBV()
        nameLabelbarBV.text = requestbarBV.namebarBV
        nameLabelbarBV.font = styleStorebarBV.fontbarBV(20, weight: .heavy)
        nameLabelbarBV.textColor = .black
        styleStorebarBV.labelFitbarBV(nameLabelbarBV, factorbarBV: 0.62, linesbarBV: 1)
        sourceLabelbarBV.text = requestbarBV.sourceTextbarBV
        sourceLabelbarBV.font = styleStorebarBV.fontbarBV(16, weight: .regular)
        sourceLabelbarBV.textColor = UIColor.black.withAlphaComponent(0.62)
        sourceLabelbarBV.numberOfLines = 2
        sourceLabelbarBV.lineBreakMode = .byTruncatingTail

        let textStackbarBV = UIStackView(arrangedSubviews: [nameLabelbarBV, sourceLabelbarBV])
        textStackbarBV.axis = .vertical
        textStackbarBV.spacing = styleStorebarBV.spacebarBV(5, minimumbarBV: 3, maximumbarBV: 6)
        textStackbarBV.alignment = .fill

        actionStackbarBV.axis = .vertical
        actionStackbarBV.alignment = .fill
        actionStackbarBV.spacing = styleStorebarBV.spacebarBV(7, minimumbarBV: 5, maximumbarBV: 8)
        configureActionsbarBV()

        [avatarbarBV, textStackbarBV, actionStackbarBV].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let avatarSizebarBV = styleStorebarBV.metricbarBV(56, minimumbarBV: 48, maximumbarBV: 60)
        NSLayoutConstraint.activate([
            avatarbarBV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: styleStorebarBV.metricbarBV(28, minimumbarBV: 18, maximumbarBV: 30)),
            avatarbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarbarBV.widthAnchor.constraint(equalToConstant: avatarSizebarBV),
            avatarbarBV.heightAnchor.constraint(equalTo: avatarbarBV.widthAnchor),

            textStackbarBV.leadingAnchor.constraint(equalTo: avatarbarBV.trailingAnchor, constant: styleStorebarBV.metricbarBV(18, minimumbarBV: 12, maximumbarBV: 20)),
            textStackbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            textStackbarBV.trailingAnchor.constraint(equalTo: actionStackbarBV.leadingAnchor, constant: -styleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 12)),
            textStackbarBV.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: styleStorebarBV.spacebarBV(16, minimumbarBV: 12, maximumbarBV: 18)),
            textStackbarBV.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -styleStorebarBV.spacebarBV(16, minimumbarBV: 12, maximumbarBV: 18)),

            actionStackbarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -styleStorebarBV.metricbarBV(24, minimumbarBV: 16, maximumbarBV: 28)),
            actionStackbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionStackbarBV.widthAnchor.constraint(equalToConstant: sentbarBV ? styleStorebarBV.metricbarBV(112, minimumbarBV: 94, maximumbarBV: 122) : styleStorebarBV.metricbarBV(92, minimumbarBV: 78, maximumbarBV: 98))
        ])
    }

    private func configureActionsbarBV() {
        if sentbarBV {
            let cancelbarBV = requestButtonbarBV(titlebarBV: "Cancel", gradientbarBV: false, darkbarBV: true)
            cancelbarBV.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                self.cancelHandlerbarBV?(self.requestbarBV)
            }, for: .touchUpInside)
            actionStackbarBV.addArrangedSubview(cancelbarBV)
            cancelbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(44, minimumbarBV: 38, maximumbarBV: 46)).isActive = true
            return
        }

        let acceptbarBV = requestButtonbarBV(titlebarBV: "Accept", gradientbarBV: true, darkbarBV: false)
        acceptbarBV.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.acceptHandlerbarBV?(self.requestbarBV)
        }, for: .touchUpInside)
        actionStackbarBV.addArrangedSubview(acceptbarBV)
        acceptbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(36, minimumbarBV: 32, maximumbarBV: 38)).isActive = true

        let rejectbarBV = requestButtonbarBV(titlebarBV: "Reject", gradientbarBV: false, darkbarBV: false)
        rejectbarBV.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.rejectHandlerbarBV?(self.requestbarBV)
        }, for: .touchUpInside)
        actionStackbarBV.addArrangedSubview(rejectbarBV)
        rejectbarBV.heightAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(36, minimumbarBV: 32, maximumbarBV: 38)).isActive = true
    }

    private func requestButtonbarBV(titlebarBV: String, gradientbarBV: Bool, darkbarBV: Bool) -> UIButton {
        let buttonbarBV: UIButton = gradientbarBV ? gradientPill(type: .system) : UIButton(type: .system)
        buttonbarBV.setTitle(titlebarBV, for: .normal)
        buttonbarBV.titleLabel?.font = styleStorebarBV.fontbarBV(15, weight: .heavy)
        styleStorebarBV.buttonFitbarBV(buttonbarBV, factorbarBV: 0.64)
        buttonbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(16, minimumbarBV: 14, maximumbarBV: 18)
        if let gradientButtonbarBV = buttonbarBV as? gradientPill {
            gradientButtonbarBV.colorsbarBV = styleStorebarBV.replyChoiceColorsbarBV
            gradientButtonbarBV.locationsbarBV = styleStorebarBV.replyChoiceLocationsbarBV
            gradientButtonbarBV.setTitleColor(.white, for: .normal)
        } else if darkbarBV {
            buttonbarBV.backgroundColor = .black
            buttonbarBV.setTitleColor(.white, for: .normal)
            buttonbarBV.layer.borderWidth = 1.4
            buttonbarBV.layer.borderColor = styleStorebarBV.mint.cgColor
            buttonbarBV.clipsToBounds = true
        } else {
            buttonbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.05)
            buttonbarBV.setTitleColor(.black, for: .normal)
            buttonbarBV.clipsToBounds = true
        }
        return buttonbarBV
    }

    private func colorbarBV() -> UIColor {
        switch requestbarBV.avatarbarBV {
        case "J":
            return UIColor(red: 135 / 255, green: 84 / 255, blue: 237 / 255, alpha: 1)
        case "E":
            return UIColor(red: 231 / 255, green: 61 / 255, blue: 155 / 255, alpha: 1)
        default:
            return UIColor(red: 105 / 255, green: 120 / 255, blue: 142 / 255, alpha: 1)
        }
    }
}

final class contactEntryItembarBV: UIControl {
    private let iconShellbarBV = UIView()
    private let iconViewbarBV = UIImageView()
    private let titleLabelbarBV = UILabel()
    private let subtitleLabelbarBV = UILabel()
    private let chevronbarBV = UIImageView(image: UIImage(systemName: "chevron.right"))
    private let textStackbarBV = UIStackView()

    init(titlebarBV: String, subtitlebarBV: String?, systemImagebarBV: String) {
        super.init(frame: .zero)
        configurebarBV(titlebarBV: titlebarBV, subtitlebarBV: subtitlebarBV, systemImagebarBV: systemImagebarBV)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.15) {
                self.alpha = self.isHighlighted ? 0.62 : 1
            }
        }
    }

    private func configurebarBV(titlebarBV: String, subtitlebarBV: String?, systemImagebarBV: String) {
        backgroundColor = .clear
        iconShellbarBV.backgroundColor = UIColor(red: 236 / 255, green: 250 / 255, blue: 1, alpha: 1)
        iconShellbarBV.layer.cornerRadius = styleStorebarBV.metricbarBV(18, minimumbarBV: 16, maximumbarBV: 20)
        iconViewbarBV.image = UIImage(systemName: systemImagebarBV)
        iconViewbarBV.tintColor = styleStorebarBV.purple
        iconViewbarBV.contentMode = .scaleAspectFit

        titleLabelbarBV.text = titlebarBV
        titleLabelbarBV.font = styleStorebarBV.fontbarBV(17, weight: .heavy)
        titleLabelbarBV.textColor = .black
        styleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.72, linesbarBV: 1)

        subtitleLabelbarBV.text = subtitlebarBV
        subtitleLabelbarBV.font = styleStorebarBV.fontbarBV(13, weight: .semibold)
        subtitleLabelbarBV.textColor = styleStorebarBV.mutedText
        subtitleLabelbarBV.isHidden = subtitlebarBV == nil
        styleStorebarBV.labelFitbarBV(subtitleLabelbarBV, factorbarBV: 0.68, linesbarBV: 1)

        chevronbarBV.tintColor = UIColor.black.withAlphaComponent(0.28)
        chevronbarBV.contentMode = .scaleAspectFit
        textStackbarBV.axis = .vertical
        textStackbarBV.alignment = .fill
        textStackbarBV.spacing = styleStorebarBV.spacebarBV(3, minimumbarBV: 2, maximumbarBV: 4)
        textStackbarBV.addArrangedSubview(titleLabelbarBV)
        textStackbarBV.addArrangedSubview(subtitleLabelbarBV)

        iconShellbarBV.addSubview(iconViewbarBV)
        [iconShellbarBV, textStackbarBV, chevronbarBV].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        iconViewbarBV.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: styleStorebarBV.metricbarBV(66, minimumbarBV: 58, maximumbarBV: 70)),

            iconShellbarBV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            iconShellbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconShellbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(42, minimumbarBV: 38, maximumbarBV: 44)),
            iconShellbarBV.heightAnchor.constraint(equalTo: iconShellbarBV.widthAnchor),

            iconViewbarBV.centerXAnchor.constraint(equalTo: iconShellbarBV.centerXAnchor),
            iconViewbarBV.centerYAnchor.constraint(equalTo: iconShellbarBV.centerYAnchor),
            iconViewbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(22, minimumbarBV: 19, maximumbarBV: 24)),
            iconViewbarBV.heightAnchor.constraint(equalTo: iconViewbarBV.widthAnchor),

            textStackbarBV.leadingAnchor.constraint(equalTo: iconShellbarBV.trailingAnchor, constant: styleStorebarBV.metricbarBV(14, minimumbarBV: 10, maximumbarBV: 16)),
            textStackbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            textStackbarBV.trailingAnchor.constraint(equalTo: chevronbarBV.leadingAnchor, constant: -styleStorebarBV.metricbarBV(10, minimumbarBV: 8, maximumbarBV: 12)),

            chevronbarBV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -styleStorebarBV.metricbarBV(12, minimumbarBV: 10, maximumbarBV: 14)),
            chevronbarBV.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronbarBV.widthAnchor.constraint(equalToConstant: styleStorebarBV.metricbarBV(16, minimumbarBV: 14, maximumbarBV: 18)),
            chevronbarBV.heightAnchor.constraint(equalTo: chevronbarBV.widthAnchor)
        ])
    }

    func updateSubtitlebarBV(_ subtitlebarBV: String?) {
        subtitleLabelbarBV.text = subtitlebarBV
        subtitleLabelbarBV.isHidden = subtitlebarBV == nil
    }
}

final class contactQRSurfacebarBV: UIView {
    var valuebarBV = "" {
        didSet { setNeedsDisplay() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = styleStorebarBV.metricbarBV(18, minimumbarBV: 16, maximumbarBV: 20)
        layer.borderColor = UIColor.black.withAlphaComponent(0.08).cgColor
        layer.borderWidth = 1
        layer.masksToBounds = true
        contentMode = .redraw
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        UIColor.white.setFill()
        UIBezierPath(roundedRect: rect, cornerRadius: layer.cornerRadius).fill()

        let countbarBV = 15
        let sidebarBV = min(rect.width, rect.height)
        let insetbarBV = sidebarBV * 0.085
        let cellbarBV = (sidebarBV - insetbarBV * 2) / CGFloat(countbarBV)
        let originbarBV = CGPoint(x: rect.midX - (cellbarBV * CGFloat(countbarBV)) / 2, y: rect.midY - (cellbarBV * CGFloat(countbarBV)) / 2)
        let checksumbarBV = valuebarBV.unicodeScalars.reduce(17) { partialbarBV, scalarbarBV in
            (partialbarBV &* 31) &+ Int(scalarbarBV.value)
        }

        drawMarkerbarBV(xbarBV: 0, ybarBV: 0, cellbarBV: cellbarBV, originbarBV: originbarBV)
        drawMarkerbarBV(xbarBV: countbarBV - 4, ybarBV: 0, cellbarBV: cellbarBV, originbarBV: originbarBV)
        drawMarkerbarBV(xbarBV: 0, ybarBV: countbarBV - 4, cellbarBV: cellbarBV, originbarBV: originbarBV)

        UIColor.black.setFill()
        for ybarBV in 0..<countbarBV {
            for xbarBV in 0..<countbarBV {
                guard !markerZonebarBV(xbarBV: xbarBV, ybarBV: ybarBV, countbarBV: countbarBV) else { continue }
                let seedbarBV = xbarBV * 7 + ybarBV * 11 + checksumbarBV
                guard seedbarBV % 4 == 0 || seedbarBV % 7 == 0 else { continue }
                let rectbarBV = CGRect(
                    x: originbarBV.x + CGFloat(xbarBV) * cellbarBV + cellbarBV * 0.14,
                    y: originbarBV.y + CGFloat(ybarBV) * cellbarBV + cellbarBV * 0.14,
                    width: cellbarBV * 0.72,
                    height: cellbarBV * 0.72
                )
                UIBezierPath(roundedRect: rectbarBV, cornerRadius: cellbarBV * 0.14).fill()
            }
        }
    }

    private func markerZonebarBV(xbarBV: Int, ybarBV: Int, countbarBV: Int) -> Bool {
        (xbarBV < 4 && ybarBV < 4)
        || (xbarBV >= countbarBV - 4 && ybarBV < 4)
        || (xbarBV < 4 && ybarBV >= countbarBV - 4)
    }

    private func drawMarkerbarBV(xbarBV: Int, ybarBV: Int, cellbarBV: CGFloat, originbarBV: CGPoint) {
        let outerbarBV = CGRect(
            x: originbarBV.x + CGFloat(xbarBV) * cellbarBV,
            y: originbarBV.y + CGFloat(ybarBV) * cellbarBV,
            width: cellbarBV * 4,
            height: cellbarBV * 4
        )
        UIColor.black.setFill()
        UIBezierPath(roundedRect: outerbarBV, cornerRadius: cellbarBV * 0.38).fill()
        UIColor.white.setFill()
        UIBezierPath(roundedRect: outerbarBV.insetBy(dx: cellbarBV * 0.7, dy: cellbarBV * 0.7), cornerRadius: cellbarBV * 0.24).fill()
        UIColor.black.setFill()
        UIBezierPath(roundedRect: outerbarBV.insetBy(dx: cellbarBV * 1.35, dy: cellbarBV * 1.35), cornerRadius: cellbarBV * 0.18).fill()
    }
}

private extension UILabel {
    func letterSpacingbarBV(_ valuebarBV: CGFloat) {
        guard let textbarBV = text else { return }
        attributedText = NSAttributedString(
            string: textbarBV,
            attributes: [
                .kern: valuebarBV,
                .font: font as Any,
                .foregroundColor: textColor as Any
            ]
        )
    }
}
