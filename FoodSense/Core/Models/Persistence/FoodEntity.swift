import Foundation
import SwiftData

@Model
final class FoodEntity {
    @Attribute(.unique) var id: String
    var name: String
    var categoryRaw: String
    var scientificName: String?
    var aliases: [String]
    var regionalNamesJSON: String
    var sourceIDs: [String]
    var isDemo: Bool
    var isFavorite: Bool
    var lastViewedAt: Date?

    var servingAmount: Double
    var servingUnit: String

    var healthSummary: String?
    var healthEvidenceLevelRaw: String?
    var typicalServingNote: String?

    var energyKcal: Double?
    var proteinG: Double?
    var carbohydrateG: Double?
    var fatG: Double?
    var sugarG: Double?
    var fiberG: Double?
    var sodiumMg: Double?
    var calciumMg: Double?
    var ironMg: Double?
    var magnesiumMg: Double?
    var potassiumMg: Double?
    var vitaminAUg: Double?
    var vitaminCMg: Double?
    var vitaminDUg: Double?
    var vitaminEMg: Double?
    var vitaminKUg: Double?
    var thiamineMg: Double?
    var riboflavinMg: Double?
    var niacinMg: Double?
    var vitaminB6Mg: Double?
    var folateUg: Double?
    var vitaminB12Ug: Double?
    var saturatedFatG: Double?
    var monounsaturatedFatG: Double?
    var polyunsaturatedFatG: Double?
    var cholesterolMg: Double?

    @Relationship(deleteRule: .cascade, inverse: \HealthFactEntity.food)
    var healthFacts: [HealthFactEntity]

    init(
        id: String,
        name: String,
        categoryRaw: String,
        scientificName: String? = nil,
        aliases: [String] = [],
        regionalNamesJSON: String = "{}",
        sourceIDs: [String] = [],
        isDemo: Bool = false,
        isFavorite: Bool = false,
        lastViewedAt: Date? = nil,
        servingAmount: Double = 100,
        servingUnit: String = "g",
        healthSummary: String? = nil,
        healthEvidenceLevelRaw: String? = nil,
        typicalServingNote: String? = nil,
        healthFacts: [HealthFactEntity] = []
    ) {
        self.id = id
        self.name = name
        self.categoryRaw = categoryRaw
        self.scientificName = scientificName
        self.aliases = aliases
        self.regionalNamesJSON = regionalNamesJSON
        self.sourceIDs = sourceIDs
        self.isDemo = isDemo
        self.isFavorite = isFavorite
        self.lastViewedAt = lastViewedAt
        self.servingAmount = servingAmount
        self.servingUnit = servingUnit
        self.healthSummary = healthSummary
        self.healthEvidenceLevelRaw = healthEvidenceLevelRaw
        self.typicalServingNote = typicalServingNote
        self.healthFacts = healthFacts
    }

    var regionalNames: [String: String] {
        get {
            guard let data = regionalNamesJSON.data(using: .utf8),
                  let decoded = try? JSONDecoder().decode([String: String].self, from: data) else {
                return [:]
            }
            return decoded
        }
        set {
            if let data = try? JSONEncoder().encode(newValue),
               let json = String(data: data, encoding: .utf8) {
                regionalNamesJSON = json
            } else {
                regionalNamesJSON = "{}"
            }
        }
    }

    func toDomain() -> Food {
        let facts = healthFacts.map { $0.toDomain() }
        let profile = HealthProfile(
            summary: healthSummary,
            benefits: facts.filter { $0.type == .benefit },
            considerations: facts.filter { $0.type == .consideration },
            excessIntake: facts.filter { $0.type == .excessIntake },
            typicalServingNote: typicalServingNote,
            evidenceLevel: healthEvidenceLevelRaw.flatMap(EvidenceLevel.init(rawValue:))
        )

        return Food(
            id: id,
            name: name,
            category: FoodCategory(rawValue: categoryRaw) ?? .other,
            scientificName: scientificName,
            aliases: aliases,
            regionalNames: regionalNames,
            nutrition: Nutrition(
                basis: "100g",
                energyKcal: energyKcal,
                proteinG: proteinG,
                carbohydrateG: carbohydrateG,
                fatG: fatG,
                sugarG: sugarG,
                fiberG: fiberG,
                sodiumMg: sodiumMg,
                calciumMg: calciumMg,
                ironMg: ironMg,
                magnesiumMg: magnesiumMg,
                potassiumMg: potassiumMg,
                vitaminAUg: vitaminAUg,
                vitaminCMg: vitaminCMg,
                vitaminDUg: vitaminDUg,
                vitaminEMg: vitaminEMg,
                vitaminKUg: vitaminKUg,
                thiamineMg: thiamineMg,
                riboflavinMg: riboflavinMg,
                niacinMg: niacinMg,
                vitaminB6Mg: vitaminB6Mg,
                folateUg: folateUg,
                vitaminB12Ug: vitaminB12Ug,
                saturatedFatG: saturatedFatG,
                monounsaturatedFatG: monounsaturatedFatG,
                polyunsaturatedFatG: polyunsaturatedFatG,
                cholesterolMg: cholesterolMg
            ),
            serving: Serving(amount: servingAmount, unit: servingUnit),
            healthProfile: profile.hasContent ? profile : nil,
            sourceIDs: sourceIDs,
            isDemo: isDemo,
            isFavorite: isFavorite,
            lastViewedAt: lastViewedAt
        )
    }

    func apply(dto: FoodDTO) {
        name = dto.name
        categoryRaw = dto.category
        scientificName = dto.scientificName
        aliases = dto.aliases ?? []
        regionalNames = dto.regionalNames ?? [:]
        sourceIDs = dto.sourceIDs ?? []
        isDemo = dto.isDemo
        servingAmount = dto.serving?.amount ?? 100
        servingUnit = dto.serving?.unit ?? "g"

        let profile = dto.healthProfile
        healthSummary = profile?.summary
        healthEvidenceLevelRaw = profile?.evidenceLevel
        typicalServingNote = profile?.typicalServing

        let nutrition = dto.nutrition
        energyKcal = nutrition?.energyKcal
        proteinG = nutrition?.proteinG
        carbohydrateG = nutrition?.carbohydrateG
        fatG = nutrition?.fatG
        sugarG = nutrition?.sugarG
        fiberG = nutrition?.fiberG
        sodiumMg = nutrition?.sodiumMg
        calciumMg = nutrition?.calciumMg
        ironMg = nutrition?.ironMg
        magnesiumMg = nutrition?.magnesiumMg
        potassiumMg = nutrition?.potassiumMg
        vitaminAUg = nutrition?.vitaminAUg
        vitaminCMg = nutrition?.vitaminCMg
        vitaminDUg = nutrition?.vitaminDUg
        vitaminEMg = nutrition?.vitaminEMg
        vitaminKUg = nutrition?.vitaminKUg
        thiamineMg = nutrition?.thiamineMg
        riboflavinMg = nutrition?.riboflavinMg
        niacinMg = nutrition?.niacinMg
        vitaminB6Mg = nutrition?.vitaminB6Mg
        folateUg = nutrition?.folateUg
        vitaminB12Ug = nutrition?.vitaminB12Ug
        saturatedFatG = nutrition?.saturatedFatG
        monounsaturatedFatG = nutrition?.monounsaturatedFatG
        polyunsaturatedFatG = nutrition?.polyunsaturatedFatG
        cholesterolMg = nutrition?.cholesterolMg
    }
}
