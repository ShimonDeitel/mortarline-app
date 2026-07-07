import SwiftUI

/// Bespoke palette for Mortarline — tuned for its own domain, not shared.
enum Theme {
    static let accent = Color(red: 0.35, green: 0.30, blue: 0.25)
    static let accentSoft = Color(red: 0.65, green: 0.55, blue: 0.40)
    static let background = Color(red: 0.08, green: 0.07, blue: 0.06)
    static let card = Color(red: 0.08, green: 0.07, blue: 0.06).opacity(0.92)

    static let titleFont = Font.system(.largeTitle, design: .serif).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)
}
