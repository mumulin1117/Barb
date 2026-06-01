import UIKit

enum styleStorebarBV {
    static let backgroundTop = UIColor(red: 220 / 255, green: 250 / 255, blue: 1, alpha: 1)
    static let backgroundBottom = UIColor(red: 253 / 255, green: 237 / 255, blue: 245 / 255, alpha: 1)
    static let blue = UIColor(red: 48 / 255, green: 158 / 255, blue: 246 / 255, alpha: 1)
    static let purple = UIColor(red: 82 / 255, green: 28 / 255, blue: 245 / 255, alpha: 1)
    static let pink = UIColor(red: 247 / 255, green: 128 / 255, blue: 168 / 255, alpha: 1)
    static let mint = UIColor(red: 43 / 255, green: 210 / 255, blue: 229 / 255, alpha: 1)
    static let mutedText = UIColor(red: 135 / 255, green: 135 / 255, blue: 145 / 255, alpha: 1)
    static let card = UIColor.white.withAlphaComponent(0.94)

    static func titleFont(_ size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .heavy)
    }

    static func bodyFont(_ size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .regular)
    }

    static func gradientLayer(bounds: CGRect, cornerRadius: CGFloat) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = [mint.cgColor, purple.cgColor, pink.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.cornerRadius = cornerRadius
        return layer
    }
}
