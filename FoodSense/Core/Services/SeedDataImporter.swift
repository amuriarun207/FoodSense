import Foundation
import SwiftData
import os

/// Imports bundled JSON into SwiftData once per seed version.
/// User state (favorites, recently viewed) is preserved when the seed version changes.
@MainActor
final class SeedDataImporter {
    private let modelContext: ModelContext
    private let loader: SeedResourceLoader
    private let validator: FoodDataValidator
    private let logger = Logger(subsystem: "com.learning.FoodSense", category: "SeedDataImporter")

    init(
        modelContext: ModelContext,
        loader: SeedResourceLoader = SeedResourceLoader(),
        validator: FoodDataValidator = FoodDataValidator()
    ) {
        self.modelContext = modelContext
        self.loader = loader
        self.validator = validator
    }

    func importIfNeeded() throws -> SeedImportStatus {
        let existing = try existingMetadata()
        if let existing, existing.version == SeedDataVersion.current {
            return .alreadyImported(version: existing.version)
        }

        let previousVersion = existing?.version
        let report = try loadAndValidate()
        try apply(report: report)

        if let previousVersion {
            return .migrated(from: previousVersion, to: SeedDataVersion.current, foodCount: report.validFoods.count)
        }
        return .imported(
            version: SeedDataVersion.current,
            foodCount: report.validFoods.count,
            sourceCount: report.validSources.count,
            skippedCount: report.errors.count
        )
    }

    /// Always re-imports seed records. Used by tests.
    func importNow() throws -> SeedImportStatus {
        let report = try loadAndValidate()
        try apply(report: report)
        return .imported(
            version: SeedDataVersion.current,
            foodCount: report.validFoods.count,
            sourceCount: report.validSources.count,
            skippedCount: report.errors.count
        )
    }

    private func loadAndValidate() throws -> ValidationReport {
        let foods = try loader.loadFoods()
        let sources = try loader.loadSources()
        let report = validator.validate(foods: foods, sources: sources)

        for issue in report.errors {
            logger.error("Seed validation error: \(issue.message, privacy: .public)")
        }
        for issue in report.warnings {
            logger.notice("Seed validation warning: \(issue.message, privacy: .public)")
        }

        if report.validFoods.isEmpty {
            throw SeedDataError.emptyDataset
        }
        return report
    }

    private func apply(report: ValidationReport) throws {
        try upsertSources(report.validSources)
        try upsertFoods(report.validFoods)
        try upsertMetadata(foodCount: report.validFoods.count)
        do {
            try modelContext.save()
        } catch {
            throw SeedDataError.persistence(error.localizedDescription)
        }
    }

    private func existingMetadata() throws -> SeedMetadataEntity? {
        var descriptor = FetchDescriptor<SeedMetadataEntity>()
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    private func upsertSources(_ sources: [SourceDTO]) throws {
        for dto in sources {
            let id = dto.id
            var descriptor = FetchDescriptor<SourceEntity>(predicate: #Predicate { $0.id == id })
            descriptor.fetchLimit = 1
            if let existing = try modelContext.fetch(descriptor).first {
                existing.name = dto.name
                existing.organization = dto.organization
                existing.year = dto.year
                existing.reference = dto.reference
                existing.typeRaw = dto.type ?? SourceType.other.rawValue
            } else {
                modelContext.insert(
                    SourceEntity(
                        id: dto.id,
                        name: dto.name,
                        organization: dto.organization,
                        year: dto.year,
                        reference: dto.reference,
                        typeRaw: dto.type ?? SourceType.other.rawValue
                    )
                )
            }
        }
    }

    private func upsertFoods(_ foods: [FoodDTO]) throws {
        for dto in foods {
            let id = dto.id
            var descriptor = FetchDescriptor<FoodEntity>(predicate: #Predicate { $0.id == id })
            descriptor.fetchLimit = 1
            let entity: FoodEntity
            if let existing = try modelContext.fetch(descriptor).first {
                entity = existing
            } else {
                entity = FoodEntity(id: dto.id, name: dto.name, categoryRaw: dto.category)
                modelContext.insert(entity)
            }

            entity.apply(dto: dto)
            replaceHealthFacts(on: entity, from: dto)
        }
    }

    private func replaceHealthFacts(on entity: FoodEntity, from dto: FoodDTO) {
        let existingByID = Dictionary(uniqueKeysWithValues: entity.healthFacts.map { ($0.id, $0) })
        var keepIDs = Set<String>()

        guard let profile = dto.healthProfile else {
            for fact in entity.healthFacts {
                modelContext.delete(fact)
            }
            entity.healthFacts = []
            return
        }

        let grouped: [(HealthFactType, [HealthFactDTO])] = [
            (.benefit, profile.benefits ?? []),
            (.consideration, profile.considerations ?? []),
            (.excessIntake, profile.excessIntake ?? [])
        ]

        for (type, facts) in grouped {
            for factDTO in facts {
                keepIDs.insert(factDTO.id)
                if let existing = existingByID[factDTO.id] {
                    existing.title = factDTO.title
                    existing.factDescription = factDTO.description
                    existing.typeRaw = factDTO.type ?? type.rawValue
                    existing.evidenceLevelRaw = factDTO.evidenceLevel ?? profile.evidenceLevel ?? EvidenceLevel.insufficient.rawValue
                    existing.sourceIDs = factDTO.sourceIDs ?? []
                    existing.food = entity
                } else {
                    let fact = HealthFactEntity(
                        id: factDTO.id,
                        title: factDTO.title,
                        factDescription: factDTO.description,
                        typeRaw: factDTO.type ?? type.rawValue,
                        evidenceLevelRaw: factDTO.evidenceLevel ?? profile.evidenceLevel ?? EvidenceLevel.insufficient.rawValue,
                        sourceIDs: factDTO.sourceIDs ?? [],
                        food: entity
                    )
                    modelContext.insert(fact)
                    entity.healthFacts.append(fact)
                }
            }
        }

        for fact in entity.healthFacts where !keepIDs.contains(fact.id) {
            modelContext.delete(fact)
        }
    }

    private func upsertMetadata(foodCount: Int) throws {
        if let existing = try existingMetadata() {
            existing.version = SeedDataVersion.current
            existing.importedAt = Date()
            existing.foodCount = foodCount
        } else {
            modelContext.insert(
                SeedMetadataEntity(
                    version: SeedDataVersion.current,
                    importedAt: Date(),
                    foodCount: foodCount
                )
            )
        }
    }
}
