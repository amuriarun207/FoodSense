import Foundation

nonisolated enum SearchNormalizer {
    /// Lowercases, strips diacritics, replaces punctuation with spaces, and collapses whitespace.
    static func normalize(_ raw: String) -> String {
        let folded = raw
            .lowercased()
            .folding(options: [.diacriticInsensitive, .widthInsensitive], locale: Locale(identifier: "en_US_POSIX"))

        var scalars: [Unicode.Scalar] = []
        scalars.reserveCapacity(folded.unicodeScalars.count)
        for scalar in folded.unicodeScalars {
            if CharacterSet.alphanumerics.contains(scalar) {
                scalars.append(scalar)
            } else {
                scalars.append(" ")
            }
        }

        return String(String.UnicodeScalarView(scalars))
            .split(whereSeparator: { $0.isWhitespace })
            .joined(separator: " ")
    }
}
