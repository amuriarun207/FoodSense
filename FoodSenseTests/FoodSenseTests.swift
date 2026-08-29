import Foundation
import Testing
@testable import FoodSense

struct JSONDecodingTests {
    @Test func decodesPomegranateSample() throws {
        let json = """
        {
          "id": "food-pomegranate",
          "name": "Pomegranate",
          "category": "fruit",
          "scientificName": "Punica granatum",
          "aliases": ["Anar", "Annar"],
          "regionalNames": { "hindi": "Anar", "tamil": "Mathulai" },
          "nutrition": {
            "basis": "100g",
            "energyKcal": 83,
            "proteinG": 1.67,
            "carbohydrateG": 18.7,
            "fatG": 1.17,
            "sugarG": 13.67,
            "fiberG": 4.0,
            "sodiumMg": 3
          },
          "serving": { "amount": 100, "unit": "g" },
          "sourceIDs": ["ifct-2017"],
          "demo": false
        }
        """.data(using: .utf8)!

        let dto = try JSONDecoder().decode(FoodDTO.self, from: json)
        #expect(dto.id == "food-pomegranate")
        #expect(dto.name == "Pomegranate")
        #expect(dto.category == "fruit")
        #expect(dto.aliases == ["Anar", "Annar"])
        #expect(dto.regionalNames?["hindi"] == "Anar")
        #expect(dto.nutrition?.energyKcal == 83)
        #expect(dto.isDemo == false)
    }

    @Test func decodesMissingOptionalNutrition() throws {
        let json = """
        {
          "id": "food-turmeric",
          "name": "Turmeric",
          "category": "spice",
          "aliases": ["Haldi"],
          "demo": true
        }
        """.data(using: .utf8)!

        let dto = try JSONDecoder().decode(FoodDTO.self, from: json)
        let food = dto.toDomain()
        #expect(food.nutrition.energyKcal == nil)
        #expect(food.nutrition.proteinG == nil)
        #expect(food.nutrition.hasCoreValues == false)
        #expect(food.isDemo == true)
    }

    @Test func decodesBundledFoodsJSON() throws {
        let loader = SeedResourceLoader(bundle: .main)
        let foods = try loader.loadFoods()
        #expect(foods.contains(where: { $0.id == "food-pomegranate" }))
        #expect(foods.contains(where: { $0.id == "food-turmeric" }))
        #expect(foods.contains(where: { $0.id == "food-sugar" }))
    }

    @Test func decodesBundledSourcesJSON() throws {
        let loader = SeedResourceLoader(bundle: .main)
        let sources = try loader.loadSources()
        #expect(sources.contains(where: { $0.id == "ifct-2017" }))
        #expect(sources.contains(where: { $0.name == "IFCT 2017" }))
    }
}

struct FoodValidationTests {
    private let validator = FoodDataValidator()

    @Test func rejectsEmptyIDAndName() {
        let foods = [
            FoodDTO(id: "", name: "X", category: "fruit", scientificName: nil, aliases: nil, regionalNames: nil, nutrition: nil, serving: nil, healthProfile: nil, sourceIDs: nil, demo: true),
            FoodDTO(id: "food-x", name: "  ", category: "fruit", scientificName: nil, aliases: nil, regionalNames: nil, nutrition: nil, serving: nil, healthProfile: nil, sourceIDs: nil, demo: true)
        ]
        let report = validator.validate(foods: foods, sources: [])
        #expect(report.validFoods.isEmpty)
        #expect(report.errors.contains(where: { $0.message.contains("ID") }))
        #expect(report.errors.contains(where: { $0.message.contains("name") }))
    }

    @Test func rejectsInvalidCategoryAndNegativeNutrition() {
        let nutrition = NutritionDTO(
            basis: "100g", energyKcal: -1, proteinG: nil, carbohydrateG: nil, fatG: nil, sugarG: nil, fiberG: nil, sodiumMg: nil,
            calciumMg: nil, ironMg: nil, magnesiumMg: nil, potassiumMg: nil, vitaminAUg: nil, vitaminCMg: nil, vitaminDUg: nil,
            vitaminEMg: nil, vitaminKUg: nil, thiamineMg: nil, riboflavinMg: nil, niacinMg: nil, vitaminB6Mg: nil, folateUg: nil,
            vitaminB12Ug: nil, saturatedFatG: nil, monounsaturatedFatG: nil, polyunsaturatedFatG: nil, cholesterolMg: nil
        )
        let foods = [
            FoodDTO(id: "food-bad-cat", name: "Mystery", category: "spaceship", scientificName: nil, aliases: nil, regionalNames: nil, nutrition: nil, serving: nil, healthProfile: nil, sourceIDs: nil, demo: true),
            FoodDTO(id: "food-neg", name: "Neg", category: "fruit", scientificName: nil, aliases: nil, regionalNames: nil, nutrition: nutrition, serving: ServingDTO(amount: 100, unit: "g"), healthProfile: nil, sourceIDs: nil, demo: true),
            FoodDTO(id: "food-serving", name: "Zero", category: "fruit", scientificName: nil, aliases: nil, regionalNames: nil, nutrition: nil, serving: ServingDTO(amount: 0, unit: "g"), healthProfile: nil, sourceIDs: nil, demo: true)
        ]
        let report = validator.validate(foods: foods, sources: [])
        #expect(report.validFoods.isEmpty)
        #expect(report.errors.contains(where: { $0.message.contains("Category") }))
        #expect(report.errors.contains(where: { $0.message.contains("negative") }))
        #expect(report.errors.contains(where: { $0.message.contains("Serving") }))
    }

    @Test func skipsDuplicateIDsAndKeepsFirst() {
        let first = FoodDTO(id: "food-dup", name: "First", category: "fruit", scientificName: nil, aliases: nil, regionalNames: nil, nutrition: nil, serving: nil, healthProfile: nil, sourceIDs: nil, demo: true)
        let second = FoodDTO(id: "food-dup", name: "Second", category: "fruit", scientificName: nil, aliases: nil, regionalNames: nil, nutrition: nil, serving: nil, healthProfile: nil, sourceIDs: nil, demo: true)
        let report = validator.validate(foods: [first, second], sources: [])
        #expect(report.validFoods.count == 1)
        #expect(report.validFoods.first?.name == "First")
        #expect(report.errors.contains(where: { $0.message.contains("Duplicate") }))
    }

    @Test func acceptsValidFood() {
        let food = FoodDTO(
            id: "food-pomegranate",
            name: "Pomegranate",
            category: "fruit",
            scientificName: "Punica granatum",
            aliases: ["Anar"],
            regionalNames: ["hindi": "Anar"],
            nutrition: NutritionDTO(
                basis: "100g", energyKcal: 83, proteinG: 1.67, carbohydrateG: 18.7, fatG: 1.17, sugarG: 13.67, fiberG: 4, sodiumMg: 3,
                calciumMg: nil, ironMg: nil, magnesiumMg: nil, potassiumMg: nil, vitaminAUg: nil, vitaminCMg: nil, vitaminDUg: nil,
                vitaminEMg: nil, vitaminKUg: nil, thiamineMg: nil, riboflavinMg: nil, niacinMg: nil, vitaminB6Mg: nil, folateUg: nil,
                vitaminB12Ug: nil, saturatedFatG: nil, monounsaturatedFatG: nil, polyunsaturatedFatG: nil, cholesterolMg: nil
            ),
            serving: ServingDTO(amount: 100, unit: "g"),
            healthProfile: nil,
            sourceIDs: ["ifct-2017"],
            demo: false
        )
        let source = SourceDTO(id: "ifct-2017", name: "IFCT 2017", organization: "ICMR-NIN", year: 2017, reference: "Indian Food Composition Tables", type: "compositionTable")
        let report = validator.validate(foods: [food], sources: [source])
        #expect(report.validFoods.count == 1)
        #expect(report.errors.isEmpty)
    }
}

struct SearchEngineTests {
    private let engine = FoodSearchEngine()
    private let foods = PreviewData.foods

    @Test func aliasSearchFindsPomegranate() {
        let results = engine.search(query: "anar", foods: foods)
        #expect(results.first?.name == "Pomegranate")
        #expect(engine.rank(food: PreviewData.pomegranate, query: "anar") == .exactAlias)
    }

    @Test func aliasSearchFindsTurmericForHaldi() {
        let results = engine.search(query: "haldi", foods: foods)
        #expect(results.first?.name == "Turmeric")
    }

    @Test func regionalNameSearchFindsTurmericForManjal() {
        let results = engine.search(query: "manjal", foods: foods)
        #expect(results.first?.name == "Turmeric")
        #expect(engine.rank(food: PreviewData.turmeric, query: "manjal") == .exactRegionalName)
    }

    @Test func englishNameSearchIsCaseInsensitive() {
        let results = engine.search(query: "POMEGRANATE", foods: foods)
        #expect(results.first?.name == "Pomegranate")
        #expect(engine.rank(food: PreviewData.pomegranate, query: "pomegranate") == .exactName)
    }

    @Test func startsWithRanksAheadOfContains() {
        let rice = Food(
            id: "food-rice",
            name: "Rice",
            category: .cereal,
            scientificName: nil,
            aliases: [],
            regionalNames: [:],
            nutrition: .empty,
            serving: .grams100,
            healthProfile: nil,
            sourceIDs: [],
            isDemo: true,
            isFavorite: false,
            lastViewedAt: nil
        )
        let brownRice = Food(
            id: "food-brown-rice-dish",
            name: "Lemon rice",
            category: .indianDish,
            scientificName: nil,
            aliases: [],
            regionalNames: [:],
            nutrition: .empty,
            serving: .grams100,
            healthProfile: nil,
            sourceIDs: [],
            isDemo: true,
            isFavorite: false,
            lastViewedAt: nil
        )
        let results = engine.search(query: "rice", foods: [brownRice, rice])
        #expect(results.first?.id == "food-rice")
        #expect(engine.rank(food: rice, query: "rice") == .exactName)
        #expect(engine.rank(food: brownRice, query: "rice") == .contains)
    }

    @Test func ignoresPunctuationAndWhitespace() {
        let results = engine.search(query: "  Anar!  ", foods: foods)
        #expect(results.first?.name == "Pomegranate")
    }

    @Test func emptyQueryReturnsNoResults() {
        #expect(engine.search(query: "   ", foods: foods).isEmpty)
    }
}

struct NutritionCalculatorTests {
    private let calculator = NutritionCalculator()

    @Test func oneHundredGramsMatchesSourceValues() {
        let result = calculator.calculate(food: PreviewData.pomegranate, quantityGrams: 100)
        #expect(result.calories == 83)
        #expect(result.proteinG == 1.67)
        #expect(result.sugarG == 13.67)
    }

    @Test func twoHundredGramsDoublesCalories() {
        let result = calculator.calculate(food: PreviewData.pomegranate, quantityGrams: 200)
        #expect(result.calories == 166)
    }

    @Test func fiveHundredGramsScalesCalories() {
        let result = calculator.calculate(food: PreviewData.pomegranate, quantityGrams: 500)
        #expect(result.calories == 415)
    }

    @Test func thirtyGramsOfSugarIsThirtyGramsSugar() {
        let result = calculator.calculate(food: PreviewData.sugar, quantityGrams: 30)
        #expect(result.sugarG == 30)
        #expect(result.carbohydrateG == 30)
    }

    @Test func missingOptionalValuesStayNil() {
        let result = calculator.calculate(food: PreviewData.turmeric, quantityGrams: 100)
        #expect(result.calories == nil)
        #expect(result.proteinG == nil)
        #expect(result.hasAnyValue == false)
    }

    @Test func formatterDropsUnnecessaryDecimals() {
        #expect(NutritionFormatter.number(83) == "83")
        #expect(NutritionFormatter.number(18.7) == "18.7")
        #expect(NutritionFormatter.number(13.67) == "13.7")
        #expect(NutritionFormatter.calories(83) == "83 kcal")
    }
}
