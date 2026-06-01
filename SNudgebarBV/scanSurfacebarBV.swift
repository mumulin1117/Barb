import UIKit

final class scanSurfacebarBV: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scan"
        view.backgroundColor = .black
        let frame = UIView()
        frame.layer.borderColor = UIColor.white.cgColor
        frame.layer.borderWidth = 4
        frame.layer.cornerRadius = 12
        let line = UIView()
        line.backgroundColor = styleStorebarBV.pink
        let help = UILabel()
        help.text = "Point your camera at a Barb QR code\nto send a friend request."
        help.textColor = .lightGray
        help.textAlignment = .center
        help.numberOfLines = 0
        help.font = .systemFont(ofSize: 18, weight: .regular)
        let actions = UIStackView()
        actions.distribution = .fillEqually
        actions.spacing = 18
        ["Album", "Flash", "My QR"].forEach { title in
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor.white.withAlphaComponent(0.12)
            button.layer.cornerRadius = 18
            actions.addArrangedSubview(button)
        }
        [frame, line, help, actions].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            frame.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            frame.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            frame.widthAnchor.constraint(equalToConstant: 240),
            frame.heightAnchor.constraint(equalToConstant: 240),
            line.centerYAnchor.constraint(equalTo: frame.centerYAnchor),
            line.leadingAnchor.constraint(equalTo: frame.leadingAnchor, constant: 24),
            line.trailingAnchor.constraint(equalTo: frame.trailingAnchor, constant: -24),
            line.heightAnchor.constraint(equalToConstant: 3),
            help.topAnchor.constraint(equalTo: frame.bottomAnchor, constant: 60),
            help.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            help.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            actions.topAnchor.constraint(equalTo: help.bottomAnchor, constant: 34),
            actions.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            actions.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44),
            actions.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
}
