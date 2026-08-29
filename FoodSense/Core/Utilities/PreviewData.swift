import Foundation

nonisolated enum PreviewData {
    static let ifctSource = Source(
        id: "ifct-2017",
        name: "IFCT 2017",
        organization: "ICMR-NIN",
        year: 2017,
        reference: "Indian Food Composition Tables",
        type: .compositionTable
    )

    static let demoSource = Source(
        id: "demo-sample",
        name: "Ahar V1 sample",
        organization: "Ahar",
        year: 2026,
        reference: "Development sample dataset — not an IFCT record",
        type: .demoSample
    )

    static let sources = [ifctSource, demoSource]

    static let pomegranate = Food(
        id: "food-pomegranate",
        name: "Pomegranate",
        category: .fruit,
        scientificName: "Punica granatum",
        aliases: ["Anar", "Annar"],
        regionalNames: [
            "hindi": "Anar",
            "tamil": "Mathulai",
            "telugu": "Danimma",
            "malayalam": "Mathalam",
            "kannada": "Dalimbey"
        ],
        nutrition: Nutrition(
            basis: "100g",
            energyKcal: 83,
            proteinG: 1.67,
            carbohydrateG: 18.7,
            fatG: 1.17,
            sugarG: 13.67,
            fiberG: 4.0,
            sodiumMg: 3,
            calciumMg: nil,
            ironMg: nil,
            magnesiumMg: nil,
            potassiumMg: nil,
            vitaminAUg: nil,
            vitaminCMg: nil,
            vitaminDUg: nil,
            vitaminEMg: nil,
            vitaminKUg: nil,
            thiamineMg: nil,
            riboflavinMg: nil,
            niacinMg: nil,
            vitaminB6Mg: nil,
            folateUg: nil,
            vitaminB12Ug: nil,
            saturatedFatG: nil,
            monounsaturatedFatG: nil,
            polyunsaturatedFatG: nil,
            cholesterolMg: nil
        ),
        serving: .grams100,
        healthProfile: HealthProfile(
            summary: "Generally suitable as part of a balanced diet.",
            benefits: [
                HealthFact(
                    id: "fact-pomegranate-fiber",
                    title: "Contains dietary fiber",
                    description: "Pomegranate contains dietary fiber, which can contribute to everyday eating patterns when consumed as part of a balanced diet.",
                    type: .benefit,
                    evidenceLevel: .moderate,
                    sourceIDs: ["ifct-2017"]
                )
            ],
            considerations: [
                HealthFact(
                    id: "fact-pomegranate-sugar",
                    title: "Contains natural sugars",
                    description: "Pomegranate contains naturally occurring sugars. Consider overall carbohydrate intake as part of a balanced diet.",
                    type: .consideration,
                    evidenceLevel: .moderate,
                    sourceIDs: ["ifct-2017"]
                )
            ],
            excessIntake: [
                HealthFact(
                    id: "fact-pomegranate-excess",
                    title: "High intake adds energy",
                    description: "High intake may contribute more energy than needed because of the fruit’s natural sugar content.",
                    type: .excessIntake,
                    evidenceLevel: .moderate,
                    sourceIDs: ["ifct-2017"]
                )
            ],
            typicalServingNote: "A typical serving is about 100 g of arils.",
            evidenceLevel: .moderate
        ),
        sourceIDs: ["ifct-2017"],
        isDemo: false,
        isFavorite: false,
        lastViewedAt: nil
    )

    static let turmeric = Food(
        id: "food-turmeric",
        name: "Turmeric",
        category: .spice,
        scientificName: "Curcuma longa",
        aliases: ["Haldi", "Pasupu", "Arishina"],
        regionalNames: [
            "hindi": "Haldi",
            "tamil": "Manjal",
            "telugu": "Pasupu",
            "kannada": "Arishina",
            "malayalam": "Manjal"
        ],
        nutrition: .empty,
        serving: Serving(amount: 2, unit: "g"),
        healthProfile: nil,
        sourceIDs: ["demo-sample"],
        isDemo: true,
        isFavorite: false,
        lastViewedAt: nil
    )

    static let sugar = Food(
        id: "food-sugar",
        name: "Sugar",
        category: .sweetener,
        scientificName: nil,
        aliases: ["Cheeni", "Sakkare", "Sarkara"],
        regionalNames: [
            "hindi": "Cheeni",
            "tamil": "Sarkarai"
        ],
        nutrition: Nutrition(
            basis: "100g",
            energyKcal: nil,
            proteinG: nil,
            carbohydrateG: 100,
            fatG: nil,
            sugarG: 100,
            fiberG: nil,
            sodiumMg: nil,
            calciumMg: nil,
            ironMg: nil,
            magnesiumMg: nil,
            potassiumMg: nil,
            vitaminAUg: nil,
            vitaminCMg: nil,
            vitaminDUg: nil,
            vitaminEMg: nil,
            vitaminKUg: nil,
            thiamineMg: nil,
            riboflavinMg: nil,
            niacinMg: nil,
            vitaminB6Mg: nil,
            folateUg: nil,
            vitaminB12Ug: nil,
            saturatedFatG: nil,
            monounsaturatedFatG: nil,
            polyunsaturatedFatG: nil,
            cholesterolMg: nil
        ),
        serving: .grams100,
        healthProfile: nil,
        sourceIDs: ["demo-sample"],
        isDemo: true,
        isFavorite: false,
        lastViewedAt: nil
    )

    static let foods = [pomegranate, turmeric, sugar]
}
