import Foundation

nonisolated struct NutritionDTO: Codable, Hashable, Sendable {
    let basis: String?
    let energyKcal: Double?
    let proteinG: Double?
    let carbohydrateG: Double?
    let fatG: Double?
    let sugarG: Double?
    let fiberG: Double?
    let sodiumMg: Double?
    let calciumMg: Double?
    let ironMg: Double?
    let magnesiumMg: Double?
    let potassiumMg: Double?
    let vitaminAUg: Double?
    let vitaminCMg: Double?
    let vitaminDUg: Double?
    let vitaminEMg: Double?
    let vitaminKUg: Double?
    let thiamineMg: Double?
    let riboflavinMg: Double?
    let niacinMg: Double?
    let vitaminB6Mg: Double?
    let folateUg: Double?
    let vitaminB12Ug: Double?
    let saturatedFatG: Double?
    let monounsaturatedFatG: Double?
    let polyunsaturatedFatG: Double?
    let cholesterolMg: Double?

    func toDomain() -> Nutrition {
        Nutrition(
            basis: basis ?? "100g",
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
        )
    }
}
