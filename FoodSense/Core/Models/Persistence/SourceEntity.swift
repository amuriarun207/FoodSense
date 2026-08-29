import Foundation
import SwiftData

@Model
final class SourceEntity {
    @Attribute(.unique) var id: String
    var name: String
    var organization: String?
    var year: Int?
    var reference: String?
    var typeRaw: String

    init(
        id: String,
        name: String,
        organization: String? = nil,
        year: Int? = nil,
        reference: String? = nil,
        typeRaw: String = SourceType.other.rawValue
    ) {
        self.id = id
        self.name = name
        self.organization = organization
        self.year = year
        self.reference = reference
        self.typeRaw = typeRaw
    }

    func toDomain() -> Source {
        Source(
            id: id,
            name: name,
            organization: organization,
            year: year,
            reference: reference,
            type: SourceType(rawValue: typeRaw) ?? .other
        )
    }
}
