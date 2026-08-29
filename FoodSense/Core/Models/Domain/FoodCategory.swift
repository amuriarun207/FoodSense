import Foundation

/// Canonical food categories used in seed data and search.
/// Display names are user-facing and independent of the raw JSON keys.
nonisolated enum FoodCategory: String, Codable, CaseIterable, Hashable, Sendable, Identifiable {
    case fruit
    case vegetable
    case leafyVegetable
    case cereal
    case millet
    case pulse
    case legume
    case spice
    case herb
    case nut
    case seed
    case dairy
    case egg
    case poultry
    case meat
    case fish
    case seafood
    case oil
    case fat
    case sweetener
    case ingredient
    case indianDish
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .fruit: return "Fruit"
        case .vegetable: return "Vegetable"
        case .leafyVegetable: return "Leafy Vegetable"
        case .cereal: return "Cereal"
        case .millet: return "Millet"
        case .pulse: return "Pulse"
        case .legume: return "Legume"
        case .spice: return "Spice"
        case .herb: return "Herb"
        case .nut: return "Nut"
        case .seed: return "Seed"
        case .dairy: return "Dairy"
        case .egg: return "Egg"
        case .poultry: return "Poultry"
        case .meat: return "Meat"
        case .fish: return "Fish"
        case .seafood: return "Seafood"
        case .oil: return "Oil"
        case .fat: return "Fat"
        case .sweetener: return "Sweetener"
        case .ingredient: return "Ingredient"
        case .indianDish: return "Indian Dish"
        case .other: return "Other"
        }
    }

    var systemImage: String {
        switch self {
        case .fruit: return "leaf.fill"
        case .vegetable, .leafyVegetable: return "carrot.fill"
        case .cereal, .millet: return "tree.fill"
        case .pulse, .legume: return "circle.grid.2x2.fill"
        case .spice, .herb: return "sparkles"
        case .nut, .seed: return "oval.fill"
        case .dairy: return "drop.fill"
        case .egg: return "oval.portrait.fill"
        case .poultry, .meat: return "fork.knife"
        case .fish, .seafood: return "fish.fill"
        case .oil, .fat: return "drop.triangle.fill"
        case .sweetener: return "cube.fill"
        case .ingredient: return "leaf.circle.fill"
        case .indianDish: return "takeoutbag.and.cup.and.straw.fill"
        case .other: return "square.grid.2x2.fill"
        }
    }
}

/// Home-screen groupings that map one or more `FoodCategory` values to a single chip.
nonisolated enum CategoryGroup: String, CaseIterable, Identifiable, Hashable, Sendable {
    case fruits
    case vegetables
    case cerealsAndMillets
    case pulsesAndLegumes
    case spices
    case nutsAndSeeds
    case dairy
    case eggs
    case meat
    case fishAndSeafood
    case oilsAndFats
    case sweeteners
    case indianDishes
    case herbsAndIngredients

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .fruits: return "Fruits"
        case .vegetables: return "Vegetables"
        case .cerealsAndMillets: return "Cereals & Millets"
        case .pulsesAndLegumes: return "Pulses & Legumes"
        case .spices: return "Spices"
        case .nutsAndSeeds: return "Nuts & Seeds"
        case .dairy: return "Dairy"
        case .eggs: return "Eggs"
        case .meat: return "Meat"
        case .fishAndSeafood: return "Fish & Seafood"
        case .oilsAndFats: return "Oils & Fats"
        case .sweeteners: return "Sweeteners"
        case .indianDishes: return "Indian Dishes"
        case .herbsAndIngredients: return "Herbs & Ingredients"
        }
    }

    var systemImage: String {
        switch self {
        case .fruits: return "leaf.fill"
        case .vegetables: return "carrot.fill"
        case .cerealsAndMillets: return "tree.fill"
        case .pulsesAndLegumes: return "circle.grid.2x2.fill"
        case .spices: return "sparkles"
        case .nutsAndSeeds: return "oval.fill"
        case .dairy: return "drop.fill"
        case .eggs: return "oval.portrait.fill"
        case .meat: return "fork.knife"
        case .fishAndSeafood: return "fish.fill"
        case .oilsAndFats: return "drop.triangle.fill"
        case .sweeteners: return "cube.fill"
        case .indianDishes: return "takeoutbag.and.cup.and.straw.fill"
        case .herbsAndIngredients: return "leaf.circle.fill"
        }
    }

    var foodCategories: [FoodCategory] {
        switch self {
        case .fruits: return [.fruit]
        case .vegetables: return [.vegetable, .leafyVegetable]
        case .cerealsAndMillets: return [.cereal, .millet]
        case .pulsesAndLegumes: return [.pulse, .legume]
        case .spices: return [.spice]
        case .nutsAndSeeds: return [.nut, .seed]
        case .dairy: return [.dairy]
        case .eggs: return [.egg]
        case .meat: return [.meat, .poultry]
        case .fishAndSeafood: return [.fish, .seafood]
        case .oilsAndFats: return [.oil, .fat]
        case .sweeteners: return [.sweetener]
        case .indianDishes: return [.indianDish]
        case .herbsAndIngredients: return [.herb, .ingredient]
        }
    }
}
