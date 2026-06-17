import Foundation

extension String {
    init(replySuggestionGlyphsBArb glyphsBArb: [UInt8], keybarBV: UInt8 = 0x5A) {
        let decodedbarBV = glyphsBArb.map { $0 ^ keybarBV }
        self = String(bytes: decodedbarBV, encoding: .utf8) ?? ""
    }
}
