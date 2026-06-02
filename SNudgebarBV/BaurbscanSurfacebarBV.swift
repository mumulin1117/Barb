import UIKit


final class BaurbscanSurfacebarBV: UIViewController {
    private let headerBarbarBV = UIView()
    private let backButtonbarBV = UIButton(type: .system)
    private let titleLabelbarBV = UILabel()
    private let flashButtonbarBV = UIButton(type: .system)
    private let scanFramebarBV = scanFrameSurfacebarBV()
    private let hintLabelbarBV = UILabel()
    private let actionStackbarBV = UIStackView()
    private let albumActionbarBV = scanActionButtonbarBV(titlebarBV: "Album", systemImagebarBV: "photo.on.rectangle.angled")
    private let flashActionbarBV = scanActionButtonbarBV(titlebarBV: "Flash", systemImagebarBV: "bolt.fill")
    private let myQRActionbarBV = scanActionButtonbarBV(titlebarBV: "My QR", systemImagebarBV: "qrcode")
    private let statusLabelbarBV = UILabel()
    private var statusWorkbarBV: DispatchWorkItem?
    private var isFlashOnbarBV = false {
        didSet { updateFlashbarBV() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 5 / 255, green: 6 / 255, blue: 10 / 255, alpha: 1)
        configureHeaderbarBV()
        configureScanSurfacebarBV()
        configureActionsbarBV()
        configureStatusbarBV()
        updateFlashbarBV()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        scanFramebarBV.startLinebarBV()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scanFramebarBV.stopLinebarBV()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureHeaderbarBV() {
        backButtonbarBV.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButtonbarBV.tintColor = .white
        backButtonbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.10)
        backButtonbarBV.layer.cornerRadius = BaurbstyleStorebarBV.controlbarBV(44) / 2
        backButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)

        titleLabelbarBV.text = "Scan"
        titleLabelbarBV.textColor = .white
        titleLabelbarBV.font = BaurbstyleStorebarBV.fontbarBV(21, weight: .heavy)
        titleLabelbarBV.textAlignment = .center
        BaurbstyleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.72, linesbarBV: 1)

        flashButtonbarBV.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
        flashButtonbarBV.tintColor = .white
        flashButtonbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.10)
        flashButtonbarBV.layer.cornerRadius = BaurbstyleStorebarBV.controlbarBV(44) / 2
        flashButtonbarBV.addAction(UIAction { [weak self] _ in
            self?.toggleFlashbarBV()
        }, for: .touchUpInside)

        view.addSubview(headerBarbarBV)
        [backButtonbarBV, titleLabelbarBV, flashButtonbarBV].forEach {
            headerBarbarBV.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        headerBarbarBV.translatesAutoresizingMaskIntoConstraints = false

        let sideInsetbarBV = BaurbstyleStorebarBV.metricbarBV(24, minimumbarBV: 18, maximumbarBV: 28)
        let buttonSizebarBV = BaurbstyleStorebarBV.controlbarBV(44)
        NSLayoutConstraint.activate([
            headerBarbarBV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: BaurbstyleStorebarBV.spacebarBV(10, minimumbarBV: 6, maximumbarBV: 14)),
            headerBarbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInsetbarBV),
            headerBarbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInsetbarBV),
            headerBarbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(50, minimumbarBV: 46, maximumbarBV: 54)),

            backButtonbarBV.leadingAnchor.constraint(equalTo: headerBarbarBV.leadingAnchor),
            backButtonbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            backButtonbarBV.widthAnchor.constraint(equalToConstant: buttonSizebarBV),
            backButtonbarBV.heightAnchor.constraint(equalToConstant: buttonSizebarBV),

            flashButtonbarBV.trailingAnchor.constraint(equalTo: headerBarbarBV.trailingAnchor),
            flashButtonbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            flashButtonbarBV.widthAnchor.constraint(equalToConstant: buttonSizebarBV),
            flashButtonbarBV.heightAnchor.constraint(equalToConstant: buttonSizebarBV),

            titleLabelbarBV.centerXAnchor.constraint(equalTo: headerBarbarBV.centerXAnchor),
            titleLabelbarBV.centerYAnchor.constraint(equalTo: headerBarbarBV.centerYAnchor),
            titleLabelbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: backButtonbarBV.trailingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14)),
            titleLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: flashButtonbarBV.leadingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(12, minimumbarBV: 8, maximumbarBV: 14))
        ])
    }

    private func configureScanSurfacebarBV() {
        hintLabelbarBV.text = "Point your camera at a Barb QR code\nto send a friend request."
        hintLabelbarBV.textColor = UIColor.white.withAlphaComponent(0.68)
        hintLabelbarBV.textAlignment = .center
        hintLabelbarBV.numberOfLines = 0
        hintLabelbarBV.font = BaurbstyleStorebarBV.fontbarBV(16, weight: .semibold)
        BaurbstyleStorebarBV.labelFitbarBV(hintLabelbarBV, factorbarBV: 0.72, linesbarBV: 0)

        view.addSubview(scanFramebarBV)
        view.addSubview(hintLabelbarBV)
        scanFramebarBV.translatesAutoresizingMaskIntoConstraints = false
        hintLabelbarBV.translatesAutoresizingMaskIntoConstraints = false

        let widthRulebarBV = scanFramebarBV.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.68)
        widthRulebarBV.priority = .defaultHigh
        let centerRulebarBV = scanFramebarBV.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(68, minimumbarBV: 44, maximumbarBV: 84))
        centerRulebarBV.priority = .defaultHigh

        NSLayoutConstraint.activate([
            scanFramebarBV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanFramebarBV.topAnchor.constraint(greaterThanOrEqualTo: headerBarbarBV.bottomAnchor, constant: BaurbstyleStorebarBV.spacebarBV(44, minimumbarBV: 28, maximumbarBV: 56)),
            scanFramebarBV.widthAnchor.constraint(lessThanOrEqualToConstant: BaurbstyleStorebarBV.metricbarBV(286, minimumbarBV: 238, maximumbarBV: 304)),
            scanFramebarBV.widthAnchor.constraint(greaterThanOrEqualToConstant: BaurbstyleStorebarBV.metricbarBV(210, minimumbarBV: 188, maximumbarBV: 222)),
            scanFramebarBV.heightAnchor.constraint(equalTo: scanFramebarBV.widthAnchor),
            widthRulebarBV,
            centerRulebarBV,

            hintLabelbarBV.topAnchor.constraint(equalTo: scanFramebarBV.bottomAnchor, constant: BaurbstyleStorebarBV.spacebarBV(34, minimumbarBV: 20, maximumbarBV: 42)),
            hintLabelbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 42)),
            hintLabelbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(34, minimumbarBV: 24, maximumbarBV: 42))
        ])
    }

    private func configureActionsbarBV() {
        actionStackbarBV.axis = .horizontal
        actionStackbarBV.distribution = .fillEqually
        actionStackbarBV.alignment = .fill
        actionStackbarBV.spacing = BaurbstyleStorebarBV.metricbarBV(18, minimumbarBV: 12, maximumbarBV: 24)

        albumActionbarBV.addAction(UIAction { [weak self] _ in
            self?.showStatusbarBV("Album scan is unavailable right now.")
        }, for: .touchUpInside)
        flashActionbarBV.addAction(UIAction { [weak self] _ in
            self?.toggleFlashbarBV()
        }, for: .touchUpInside)
        myQRActionbarBV.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)

        [albumActionbarBV, flashActionbarBV, myQRActionbarBV].forEach { actionStackbarBV.addArrangedSubview($0) }
        view.addSubview(actionStackbarBV)
        actionStackbarBV.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            actionStackbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 38)),
            actionStackbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(30, minimumbarBV: 22, maximumbarBV: 38)),
            actionStackbarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(20, minimumbarBV: 12, maximumbarBV: 26)),
            actionStackbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(78, minimumbarBV: 68, maximumbarBV: 84)),
            hintLabelbarBV.bottomAnchor.constraint(lessThanOrEqualTo: actionStackbarBV.topAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(24, minimumbarBV: 16, maximumbarBV: 32))
        ])
    }

    private func configureStatusbarBV() {
        statusLabelbarBV.alpha = 0
        statusLabelbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.16)
        statusLabelbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(17, minimumbarBV: 15, maximumbarBV: 18)
        statusLabelbarBV.layer.masksToBounds = true
        statusLabelbarBV.textColor = .white
        statusLabelbarBV.textAlignment = .center
        statusLabelbarBV.font = BaurbstyleStorebarBV.fontbarBV(14, weight: .bold)
        BaurbstyleStorebarBV.labelFitbarBV(statusLabelbarBV, factorbarBV: 0.72, linesbarBV: 1)
        view.addSubview(statusLabelbarBV)
        statusLabelbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabelbarBV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabelbarBV.bottomAnchor.constraint(equalTo: actionStackbarBV.topAnchor, constant: -BaurbstyleStorebarBV.spacebarBV(14, minimumbarBV: 10, maximumbarBV: 16)),
            statusLabelbarBV.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: BaurbstyleStorebarBV.metricbarBV(42, minimumbarBV: 30, maximumbarBV: 48)),
            statusLabelbarBV.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -BaurbstyleStorebarBV.metricbarBV(42, minimumbarBV: 30, maximumbarBV: 48)),
            statusLabelbarBV.heightAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(34, minimumbarBV: 30, maximumbarBV: 36))
        ])
    }

    private func toggleFlashbarBV() {
        isFlashOnbarBV.toggle()
        showStatusbarBV(isFlashOnbarBV ? "Flash on" : "Flash off")
    }

    private func updateFlashbarBV() {
        let colorbarBV = isFlashOnbarBV ? BaurbstyleStorebarBV.purple : UIColor.white.withAlphaComponent(0.10)
        let tintbarBV = isFlashOnbarBV ? .white : UIColor.white.withAlphaComponent(0.92)
        flashButtonbarBV.backgroundColor = colorbarBV
        flashButtonbarBV.tintColor = tintbarBV
        flashActionbarBV.setActivebarBV(isFlashOnbarBV)
    }

    private func showStatusbarBV(_ messagebarBV: String) {
        statusWorkbarBV?.cancel()
        statusLabelbarBV.text = "  \(messagebarBV)  "
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

final class scanFrameSurfacebarBV: UIView {
    private let scanLinebarBV = scanLineSurfacebarBV()
    private var runningFlagbarBV = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white.withAlphaComponent(0.03)
        layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(20, minimumbarBV: 16, maximumbarBV: 22)
        layer.masksToBounds = false
        addSubview(scanLinebarBV)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scanLinebarBV.frame = CGRect(
            x: bounds.width * 0.12,
            y: bounds.midY - 2,
            width: bounds.width * 0.76,
            height: 4
        )
        if runningFlagbarBV {
            startLinebarBV()
        }
    }

    override func draw(_ rect: CGRect) {
        let pathbarBV = UIBezierPath()
        let lengthbarBV = min(rect.width, rect.height) * 0.22
        let insetbarBV = max(3, BaurbstyleStorebarBV.metricbarBV(4, minimumbarBV: 3, maximumbarBV: 5))
        let radiusbarBV = BaurbstyleStorebarBV.metricbarBV(14, minimumbarBV: 11, maximumbarBV: 16)

        func cornerbarBV(from startbarBV: CGPoint, through midbarBV: CGPoint, to endbarBV: CGPoint) {
            pathbarBV.move(to: startbarBV)
            pathbarBV.addArc(
                withCenter: midbarBV,
                radius: radiusbarBV,
                startAngle: atan2(startbarBV.y - midbarBV.y, startbarBV.x - midbarBV.x),
                endAngle: atan2(endbarBV.y - midbarBV.y, endbarBV.x - midbarBV.x),
                clockwise: startbarBV.x > midbarBV.x || startbarBV.y < midbarBV.y
            )
            pathbarBV.addLine(to: endbarBV)
        }

        pathbarBV.move(to: CGPoint(x: insetbarBV, y: insetbarBV + lengthbarBV))
        pathbarBV.addLine(to: CGPoint(x: insetbarBV, y: insetbarBV + radiusbarBV))
        cornerbarBV(
            from: CGPoint(x: insetbarBV, y: insetbarBV + radiusbarBV),
            through: CGPoint(x: insetbarBV + radiusbarBV, y: insetbarBV + radiusbarBV),
            to: CGPoint(x: insetbarBV + radiusbarBV, y: insetbarBV)
        )
        pathbarBV.addLine(to: CGPoint(x: insetbarBV + lengthbarBV, y: insetbarBV))

        pathbarBV.move(to: CGPoint(x: rect.maxX - insetbarBV - lengthbarBV, y: insetbarBV))
        pathbarBV.addLine(to: CGPoint(x: rect.maxX - insetbarBV - radiusbarBV, y: insetbarBV))
        cornerbarBV(
            from: CGPoint(x: rect.maxX - insetbarBV - radiusbarBV, y: insetbarBV),
            through: CGPoint(x: rect.maxX - insetbarBV - radiusbarBV, y: insetbarBV + radiusbarBV),
            to: CGPoint(x: rect.maxX - insetbarBV, y: insetbarBV + radiusbarBV)
        )
        pathbarBV.addLine(to: CGPoint(x: rect.maxX - insetbarBV, y: insetbarBV + lengthbarBV))

        pathbarBV.move(to: CGPoint(x: insetbarBV, y: rect.maxY - insetbarBV - lengthbarBV))
        pathbarBV.addLine(to: CGPoint(x: insetbarBV, y: rect.maxY - insetbarBV - radiusbarBV))
        cornerbarBV(
            from: CGPoint(x: insetbarBV, y: rect.maxY - insetbarBV - radiusbarBV),
            through: CGPoint(x: insetbarBV + radiusbarBV, y: rect.maxY - insetbarBV - radiusbarBV),
            to: CGPoint(x: insetbarBV + radiusbarBV, y: rect.maxY - insetbarBV)
        )
        pathbarBV.addLine(to: CGPoint(x: insetbarBV + lengthbarBV, y: rect.maxY - insetbarBV))

        pathbarBV.move(to: CGPoint(x: rect.maxX - insetbarBV - lengthbarBV, y: rect.maxY - insetbarBV))
        pathbarBV.addLine(to: CGPoint(x: rect.maxX - insetbarBV - radiusbarBV, y: rect.maxY - insetbarBV))
        cornerbarBV(
            from: CGPoint(x: rect.maxX - insetbarBV - radiusbarBV, y: rect.maxY - insetbarBV),
            through: CGPoint(x: rect.maxX - insetbarBV - radiusbarBV, y: rect.maxY - insetbarBV - radiusbarBV),
            to: CGPoint(x: rect.maxX - insetbarBV, y: rect.maxY - insetbarBV - radiusbarBV)
        )
        pathbarBV.addLine(to: CGPoint(x: rect.maxX - insetbarBV, y: rect.maxY - insetbarBV - lengthbarBV))

        UIColor.white.setStroke()
        pathbarBV.lineWidth = BaurbstyleStorebarBV.metricbarBV(5, minimumbarBV: 4, maximumbarBV: 6)
        pathbarBV.lineCapStyle = .round
        pathbarBV.stroke()
    }

    func startLinebarBV() {
        runningFlagbarBV = true
        guard bounds.height > 0 else { return }
        scanLinebarBV.layer.removeAnimation(forKey: "scanLinebarBV")
        let animationbarBV = CABasicAnimation(keyPath: "position.y")
        animationbarBV.fromValue = bounds.height * 0.24
        animationbarBV.toValue = bounds.height * 0.76
        animationbarBV.duration = 1.8
        animationbarBV.autoreverses = true
        animationbarBV.repeatCount = .infinity
        animationbarBV.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scanLinebarBV.layer.add(animationbarBV, forKey: "scanLinebarBV")
    }

    func stopLinebarBV() {
        runningFlagbarBV = false
        scanLinebarBV.layer.removeAnimation(forKey: "scanLinebarBV")
    }
}

final class scanLineSurfacebarBV: UIView {
    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        layer.cornerRadius = 2
        layer.masksToBounds = true
        if let layerbarBV = layer as? CAGradientLayer {
            layerbarBV.colors = [
                UIColor.clear.cgColor,
                BaurbstyleStorebarBV.purple.cgColor,
                BaurbstyleStorebarBV.pink.cgColor,
                UIColor.clear.cgColor
            ]
            layerbarBV.locations = [0, 0.22, 0.78, 1]
            layerbarBV.startPoint = CGPoint(x: 0, y: 0.5)
            layerbarBV.endPoint = CGPoint(x: 1, y: 0.5)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class scanActionButtonbarBV: UIControl {
    private let iconShellbarBV = UIView()
    private let iconViewbarBV = UIImageView()
    private let titleLabelbarBV = UILabel()

    init(titlebarBV: String, systemImagebarBV: String) {
        super.init(frame: .zero)
        iconViewbarBV.image = UIImage(systemName: systemImagebarBV)
        titleLabelbarBV.text = titlebarBV
        configurebarBV()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.14) {
                self.alpha = self.isHighlighted ? 0.58 : 1
            }
        }
    }

    private func configurebarBV() {
        iconShellbarBV.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        iconShellbarBV.layer.cornerRadius = BaurbstyleStorebarBV.metricbarBV(22, minimumbarBV: 20, maximumbarBV: 24)
        iconViewbarBV.tintColor = .white
        iconViewbarBV.contentMode = .scaleAspectFit
        titleLabelbarBV.textColor = UIColor.white.withAlphaComponent(0.84)
        titleLabelbarBV.textAlignment = .center
        titleLabelbarBV.font = BaurbstyleStorebarBV.fontbarBV(14, weight: .bold)
        BaurbstyleStorebarBV.labelFitbarBV(titleLabelbarBV, factorbarBV: 0.72, linesbarBV: 1)

        iconShellbarBV.addSubview(iconViewbarBV)
        [iconShellbarBV, titleLabelbarBV].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        iconViewbarBV.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconShellbarBV.topAnchor.constraint(equalTo: topAnchor),
            iconShellbarBV.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconShellbarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(46, minimumbarBV: 40, maximumbarBV: 50)),
            iconShellbarBV.heightAnchor.constraint(equalTo: iconShellbarBV.widthAnchor),

            iconViewbarBV.centerXAnchor.constraint(equalTo: iconShellbarBV.centerXAnchor),
            iconViewbarBV.centerYAnchor.constraint(equalTo: iconShellbarBV.centerYAnchor),
            iconViewbarBV.widthAnchor.constraint(equalToConstant: BaurbstyleStorebarBV.metricbarBV(22, minimumbarBV: 19, maximumbarBV: 24)),
            iconViewbarBV.heightAnchor.constraint(equalTo: iconViewbarBV.widthAnchor),

            titleLabelbarBV.topAnchor.constraint(equalTo: iconShellbarBV.bottomAnchor, constant: BaurbstyleStorebarBV.spacebarBV(8, minimumbarBV: 5, maximumbarBV: 9)),
            titleLabelbarBV.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabelbarBV.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabelbarBV.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }

    func setActivebarBV(_ activebarBV: Bool) {
        iconShellbarBV.backgroundColor = activebarBV ? BaurbstyleStorebarBV.purple : UIColor.white.withAlphaComponent(0.12)
        iconViewbarBV.tintColor = .white
        titleLabelbarBV.textColor = activebarBV ? .white : UIColor.white.withAlphaComponent(0.84)
    }
}
