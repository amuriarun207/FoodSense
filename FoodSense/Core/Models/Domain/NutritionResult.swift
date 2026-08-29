import Foundation

/// Calculated nutrient amounts for a user-selected quantity.
nonisolated struct NutritionResult: Hashable, Sendable {
    let quantityGrams: Double
    let calories: Double?
    let proteinG: Double?
    let carbohydrateG: Double?
    let sugarG: Double?
    let fiberG: Double?
    let fatG: Double?
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

    var hasAnyValue: Bool {
        calories != nil
            || proteinG != nil
            || carbohydrateG != nil
            || sugarG != nil
            || fiberG != nil
            || fatG != nil
            || sodiumMg != nil
            || calciumMg != nil
            || ironMg != nil
            || magnesiumMg != nil
            || potassiumMg != nil
            || vitaminAUg != nil
            || vitaminCMg != nil
            || vitaminDUg != nil
            || vitaminEMg != nil
            || vitaminKUg != nil
            || thiamineMg != nil
            || riboflavinMg != nil
            || niacinMg != nil
            || vitaminB6Mg != nil
            || folateUg != nil
            || vitaminB12Ug != nil
            || saturatedFatG != nil
            || monounsaturatedFatG != nil
            || polyunsaturatedFatG != nil
            || cholesterolMg != nil
    }
}
