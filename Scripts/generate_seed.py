#!/usr/bin/env python3
"""Generate V1 sample seed JSON. Demo records are marked demo=true."""

import json
from pathlib import Path

OUT = Path(__file__).resolve().parents[1] / "FoodSense" / "Resources" / "SeedData"
OUT.mkdir(parents=True, exist_ok=True)

sources = [
    {
        "id": "ifct-2017",
        "name": "IFCT 2017",
        "organization": "ICMR-NIN",
        "year": 2017,
        "reference": "Indian Food Composition Tables",
        "type": "compositionTable",
    },
    {
        "id": "demo-sample",
        "name": "FoodSense V1 sample",
        "organization": "FoodSense",
        "year": 2026,
        "reference": "Development sample dataset — not an IFCT record",
        "type": "demoSample",
    },
]

categories = [
    {"id": "fruits", "displayName": "Fruits", "foodCategories": ["fruit"]},
    {"id": "vegetables", "displayName": "Vegetables", "foodCategories": ["vegetable", "leafyVegetable"]},
    {"id": "cerealsAndMillets", "displayName": "Cereals & Millets", "foodCategories": ["cereal", "millet"]},
    {"id": "pulsesAndLegumes", "displayName": "Pulses & Legumes", "foodCategories": ["pulse", "legume"]},
    {"id": "spices", "displayName": "Spices", "foodCategories": ["spice"]},
    {"id": "nutsAndSeeds", "displayName": "Nuts & Seeds", "foodCategories": ["nut", "seed"]},
    {"id": "dairy", "displayName": "Dairy", "foodCategories": ["dairy"]},
    {"id": "eggs", "displayName": "Eggs", "foodCategories": ["egg"]},
    {"id": "meat", "displayName": "Meat", "foodCategories": ["meat", "poultry"]},
    {"id": "fishAndSeafood", "displayName": "Fish & Seafood", "foodCategories": ["fish", "seafood"]},
    {"id": "oilsAndFats", "displayName": "Oils & Fats", "foodCategories": ["oil", "fat"]},
    {"id": "sweeteners", "displayName": "Sweeteners", "foodCategories": ["sweetener"]},
    {"id": "indianDishes", "displayName": "Indian Dishes", "foodCategories": ["indianDish"]},
    {"id": "herbsAndIngredients", "displayName": "Herbs & Ingredients", "foodCategories": ["herb", "ingredient"]},
]


def food(
    id,
    name,
    category,
    aliases=None,
    regional=None,
    scientific=None,
    nutrition=None,
    serving=None,
    health=None,
    source_ids=None,
    demo=True,
):
    record = {
        "id": id,
        "name": name,
        "category": category,
        "scientificName": scientific,
        "aliases": aliases or [],
        "regionalNames": regional or {},
        "serving": serving or {"amount": 100, "unit": "g"},
        "sourceIDs": source_ids or (["demo-sample"] if demo else ["ifct-2017"]),
        "demo": demo,
    }
    if nutrition is not None:
        record["nutrition"] = nutrition
    if health is not None:
        record["healthProfile"] = health
    return record


pomegranate_health = {
    "summary": "Generally suitable as part of a balanced diet.",
    "benefits": [
        {
            "id": "fact-pomegranate-fiber",
            "title": "Contains dietary fiber",
            "description": "Pomegranate contains dietary fiber, which can contribute to everyday eating patterns when consumed as part of a balanced diet.",
            "type": "benefit",
            "evidenceLevel": "moderate",
            "sourceIDs": ["ifct-2017"],
        }
    ],
    "considerations": [
        {
            "id": "fact-pomegranate-sugar",
            "title": "Contains natural sugars",
            "description": "Pomegranate contains naturally occurring sugars. Consider overall carbohydrate intake as part of a balanced diet.",
            "type": "consideration",
            "evidenceLevel": "moderate",
            "sourceIDs": ["ifct-2017"],
        }
    ],
    "excessIntake": [
        {
            "id": "fact-pomegranate-excess",
            "title": "High intake adds energy",
            "description": "High intake may contribute more energy than needed because of the fruit's natural sugar content.",
            "type": "excessIntake",
            "evidenceLevel": "moderate",
            "sourceIDs": ["ifct-2017"],
        }
    ],
    "typicalServing": "A typical serving is about 100 g of arils.",
    "evidenceLevel": "moderate",
}

foods = [
    food(
        "food-pomegranate",
        "Pomegranate",
        "fruit",
        aliases=["Anar", "Annar"],
        regional={
            "hindi": "Anar",
            "tamil": "Mathulai",
            "telugu": "Danimma",
            "malayalam": "Mathalam",
            "kannada": "Dalimbey",
        },
        scientific="Punica granatum",
        nutrition={
            "basis": "100g",
            "energyKcal": 83,
            "proteinG": 1.67,
            "carbohydrateG": 18.7,
            "fatG": 1.17,
            "sugarG": 13.67,
            "fiberG": 4.0,
            "sodiumMg": 3,
        },
        health=pomegranate_health,
        source_ids=["ifct-2017"],
        demo=False,
    ),
    food("food-mango", "Mango", "fruit", aliases=["Aam", "Manga"], regional={"hindi": "Aam", "tamil": "Manga", "telugu": "Mamidi"}, scientific="Mangifera indica"),
    food("food-banana", "Banana", "fruit", aliases=["Kela", "Vazhaipazham"], regional={"hindi": "Kela", "tamil": "Vazhaipazham", "malayalam": "Vazha"}, scientific="Musa paradisiaca"),
    food("food-apple", "Apple", "fruit", aliases=["Seb"], regional={"hindi": "Seb"}, scientific="Malus domestica"),
    food("food-lemon", "Lemon", "fruit", aliases=["Nimbu", "Elumichai"], regional={"hindi": "Nimbu", "tamil": "Elumichai"}, scientific="Citrus limon"),
    food("food-guava", "Guava", "fruit", aliases=["Amrood"], regional={"hindi": "Amrood"}, scientific="Psidium guajava"),
    food("food-papaya", "Papaya", "fruit", aliases=["Papita"], regional={"hindi": "Papita", "tamil": "Pappali"}, scientific="Carica papaya"),
    food("food-orange", "Orange", "fruit", aliases=["Santra", "Naranga"], regional={"hindi": "Santra"}),
    food("food-potato", "Potato", "vegetable", aliases=["Aloo", "Urulai"], regional={"hindi": "Aloo", "tamil": "Urulaikizhangu"}, scientific="Solanum tuberosum"),
    food("food-onion", "Onion", "vegetable", aliases=["Pyaz", "Vengayam"], regional={"hindi": "Pyaz", "tamil": "Vengayam"}, scientific="Allium cepa"),
    food("food-tomato", "Tomato", "vegetable", aliases=["Tamatar", "Thakkali"], regional={"hindi": "Tamatar", "tamil": "Thakkali"}, scientific="Solanum lycopersicum"),
    food("food-carrot", "Carrot", "vegetable", aliases=["Gajar"], regional={"hindi": "Gajar"}, scientific="Daucus carota"),
    food("food-cauliflower", "Cauliflower", "vegetable", aliases=["Gobi", "Phool gobhi"], regional={"hindi": "Phool gobhi"}),
    food("food-brinjal", "Brinjal", "vegetable", aliases=["Baingan", "Kathirikai", "Eggplant"], regional={"hindi": "Baingan", "tamil": "Kathirikai"}, scientific="Solanum melongena"),
    food("food-okra", "Okra", "vegetable", aliases=["Bhindi", "Vendakkai", "Lady finger"], regional={"hindi": "Bhindi", "tamil": "Vendakkai"}, scientific="Abelmoschus esculentus"),
    food("food-green-chili", "Green chilli", "vegetable", aliases=["Hari mirch", "Pachamirchi"], regional={"hindi": "Hari mirch", "tamil": "Pachamirchi"}),
    food("food-spinach", "Spinach", "leafyVegetable", aliases=["Palak"], regional={"hindi": "Palak", "tamil": "Pasalai"}, scientific="Spinacia oleracea"),
    food("food-fenugreek-leaves", "Fenugreek leaves", "leafyVegetable", aliases=["Methi"], regional={"hindi": "Methi"}),
    food("food-amaranth-leaves", "Amaranth leaves", "leafyVegetable", aliases=["Chaulai", "Thotakura"], regional={"hindi": "Chaulai", "telugu": "Thotakura"}),
    food("food-rice-raw", "Rice", "cereal", aliases=["Chawal", "Arisi", "Biyyam"], regional={"hindi": "Chawal", "tamil": "Arisi", "telugu": "Biyyam"}, scientific="Oryza sativa"),
    food("food-basmati-rice", "Basmati rice", "cereal", aliases=["Basmati", "Basmati chawal"], regional={"hindi": "Basmati chawal"}),
    food("food-wheat-flour", "Wheat flour", "cereal", aliases=["Atta", "Godhumai maavu"], regional={"hindi": "Atta", "tamil": "Godhumai maavu"}),
    food("food-ragi", "Finger millet", "millet", aliases=["Ragi", "Nachni", "Kezhvaragu"], regional={"hindi": "Ragi", "tamil": "Kezhvaragu", "kannada": "Ragi"}, scientific="Eleusine coracana"),
    food("food-bajra", "Pearl millet", "millet", aliases=["Bajra", "Kambu"], regional={"hindi": "Bajra", "tamil": "Kambu"}, scientific="Pennisetum glaucum"),
    food("food-jowar", "Sorghum", "millet", aliases=["Jowar", "Cholam"], regional={"hindi": "Jowar", "tamil": "Cholam"}, scientific="Sorghum bicolor"),
    food("food-toor-dal", "Toor dal", "pulse", aliases=["Arhar", "Thuvaram paruppu", "Dal", "Tuvar dal"], regional={"hindi": "Arhar", "tamil": "Thuvaram paruppu", "telugu": "Kandi pappu"}, scientific="Cajanus cajan"),
    food("food-moong-dal", "Moong dal", "pulse", aliases=["Moong", "Pasi paruppu"], regional={"hindi": "Moong", "tamil": "Pasi paruppu"}, scientific="Vigna radiata"),
    food("food-masoor-dal", "Masoor dal", "pulse", aliases=["Masoor", "Red lentil"], regional={"hindi": "Masoor"}),
    food("food-chana-dal", "Chana dal", "pulse", aliases=["Bengal gram dal", "Kadalai paruppu"], regional={"hindi": "Chana dal", "tamil": "Kadalai paruppu"}),
    food("food-chickpea", "Chickpea", "legume", aliases=["Chana", "Kabuli chana", "Kondakadalai"], regional={"hindi": "Chana", "tamil": "Kondakadalai"}, scientific="Cicer arietinum"),
    food("food-rajma", "Kidney beans", "legume", aliases=["Rajma"], regional={"hindi": "Rajma"}),
    food(
        "food-turmeric",
        "Turmeric",
        "spice",
        aliases=["Haldi", "Manjal", "Pasupu", "Arishina", "Halad"],
        regional={"hindi": "Haldi", "tamil": "Manjal", "telugu": "Pasupu", "kannada": "Arishina", "malayalam": "Manjal"},
        scientific="Curcuma longa",
        serving={"amount": 2, "unit": "g"},
    ),
    food("food-cumin", "Cumin", "spice", aliases=["Jeera", "Jeeragam"], regional={"hindi": "Jeera", "tamil": "Jeeragam"}, scientific="Cuminum cyminum", serving={"amount": 2, "unit": "g"}),
    food("food-coriander-seed", "Coriander seed", "spice", aliases=["Dhania", "Kothamalli vidai"], regional={"hindi": "Dhania", "tamil": "Kothamalli vidai"}, serving={"amount": 2, "unit": "g"}),
    food("food-black-pepper", "Black pepper", "spice", aliases=["Kali mirch", "Milagu"], regional={"hindi": "Kali mirch", "tamil": "Milagu"}, scientific="Piper nigrum", serving={"amount": 1, "unit": "g"}),
    food("food-cardamom", "Cardamom", "spice", aliases=["Elaichi", "Elakkai"], regional={"hindi": "Elaichi", "tamil": "Elakkai"}, serving={"amount": 1, "unit": "g"}),
    food("food-fenugreek-seed", "Fenugreek seed", "spice", aliases=["Methi dana", "Vendhayam"], regional={"hindi": "Methi dana", "tamil": "Vendhayam"}, serving={"amount": 2, "unit": "g"}),
    food("food-mustard-seed", "Mustard seed", "seed", aliases=["Rai", "Kadugu"], regional={"hindi": "Rai", "tamil": "Kadugu"}, serving={"amount": 2, "unit": "g"}),
    food("food-ginger", "Ginger", "herb", aliases=["Adrak", "Inji"], regional={"hindi": "Adrak", "tamil": "Inji", "malayalam": "Inji"}, scientific="Zingiber officinale", serving={"amount": 5, "unit": "g"}),
    food("food-garlic", "Garlic", "herb", aliases=["Lehsun", "Poondu"], regional={"hindi": "Lehsun", "tamil": "Poondu"}, scientific="Allium sativum", serving={"amount": 5, "unit": "g"}),
    food("food-curry-leaves", "Curry leaves", "herb", aliases=["Kadi patta", "Karuveppilai"], regional={"hindi": "Kadi patta", "tamil": "Karuveppilai"}, serving={"amount": 2, "unit": "g"}),
    food("food-coriander-leaves", "Coriander leaves", "herb", aliases=["Hara dhania", "Kothamalli"], regional={"hindi": "Hara dhania", "tamil": "Kothamalli"}, serving={"amount": 5, "unit": "g"}),
    food("food-almond", "Almond", "nut", aliases=["Badam"], regional={"hindi": "Badam", "tamil": "Badam"}, scientific="Prunus dulcis", serving={"amount": 15, "unit": "g"}),
    food("food-cashew", "Cashew", "nut", aliases=["Kaju", "Mundiri"], regional={"hindi": "Kaju", "tamil": "Mundiri"}, serving={"amount": 15, "unit": "g"}),
    food("food-groundnut", "Groundnut", "nut", aliases=["Mungfali", "Verkadalai", "Peanut"], regional={"hindi": "Mungfali", "tamil": "Verkadalai"}, scientific="Arachis hypogaea", serving={"amount": 20, "unit": "g"}),
    food("food-coconut", "Coconut", "nut", aliases=["Nariyal", "Thengai"], regional={"hindi": "Nariyal", "tamil": "Thengai", "malayalam": "Thengu"}, scientific="Cocos nucifera"),
    food("food-sesame", "Sesame seed", "seed", aliases=["Til", "Ellu"], regional={"hindi": "Til", "tamil": "Ellu"}, serving={"amount": 10, "unit": "g"}),
    food("food-milk", "Cow milk", "dairy", aliases=["Doodh", "Paal"], regional={"hindi": "Doodh", "tamil": "Paal"}, serving={"amount": 200, "unit": "g"}),
    food("food-curd", "Curd", "dairy", aliases=["Dahi", "Thayir", "Yogurt"], regional={"hindi": "Dahi", "tamil": "Thayir"}, serving={"amount": 100, "unit": "g"}),
    food("food-paneer", "Paneer", "dairy", aliases=["Cottage cheese", "Panneer"], regional={"hindi": "Paneer"}),
    food("food-buttermilk", "Buttermilk", "dairy", aliases=["Chaas", "Moru"], regional={"hindi": "Chaas", "tamil": "Moru"}, serving={"amount": 200, "unit": "g"}),
    food("food-egg", "Hen egg", "egg", aliases=["Anda", "Muttai"], regional={"hindi": "Anda", "tamil": "Muttai"}, serving={"amount": 50, "unit": "g"}),
    food("food-chicken", "Chicken", "poultry", aliases=["Murgi"], regional={"hindi": "Murgi"}),
    food("food-mutton", "Mutton", "meat", aliases=["Gosht", "Aattukari"], regional={"hindi": "Gosht", "tamil": "Aattukari"}),
    food("food-rohu", "Rohu", "fish", aliases=["Rohu fish"], regional={"hindi": "Rohu"}),
    food("food-prawn", "Prawn", "seafood", aliases=["Jhinga", "Eral"], regional={"hindi": "Jhinga", "tamil": "Eral"}),
    food("food-mustard-oil", "Mustard oil", "oil", aliases=["Sarson ka tel"], regional={"hindi": "Sarson ka tel"}, serving={"amount": 10, "unit": "g"}),
    food("food-coconut-oil", "Coconut oil", "oil", aliases=["Nariyal tel", "Thengai ennai"], regional={"hindi": "Nariyal tel", "tamil": "Thengai ennai"}, serving={"amount": 10, "unit": "g"}),
    food("food-groundnut-oil", "Groundnut oil", "oil", aliases=["Mungfali tel"], regional={"hindi": "Mungfali tel"}, serving={"amount": 10, "unit": "g"}),
    food("food-ghee", "Ghee", "fat", aliases=["Clarified butter", "Tuppa"], regional={"hindi": "Ghee", "tamil": "Nei"}, serving={"amount": 10, "unit": "g"}),
    food("food-butter", "Butter", "fat", aliases=["Makhan"], regional={"hindi": "Makhan"}, serving={"amount": 10, "unit": "g"}),
    food(
        "food-sugar",
        "Sugar",
        "sweetener",
        aliases=["Cheeni", "Sakkare", "Sarkara"],
        regional={"hindi": "Cheeni", "tamil": "Sarkarai", "kannada": "Sakkare"},
        nutrition={"basis": "100g", "carbohydrateG": 100, "sugarG": 100},
        serving={"amount": 5, "unit": "g"},
    ),
    food("food-jaggery", "Jaggery", "sweetener", aliases=["Gur", "Vellam", "Bella"], regional={"hindi": "Gur", "tamil": "Vellam", "kannada": "Bella"}, serving={"amount": 10, "unit": "g"}),
    food("food-honey", "Honey", "sweetener", aliases=["Shahad", "Then"], regional={"hindi": "Shahad", "tamil": "Then"}, serving={"amount": 10, "unit": "g"}),
    food("food-tea", "Tea", "ingredient", aliases=["Chai"], regional={"hindi": "Chai", "tamil": "Theneer"}, serving={"amount": 2, "unit": "g"}),
    food("food-tamarind", "Tamarind", "ingredient", aliases=["Imli", "Puli"], regional={"hindi": "Imli", "tamil": "Puli"}, serving={"amount": 10, "unit": "g"}),
    food("food-asafoetida", "Asafoetida", "ingredient", aliases=["Hing", "Perungayam"], regional={"hindi": "Hing", "tamil": "Perungayam"}, serving={"amount": 1, "unit": "g"}),
    food("food-dosa", "Dosa", "indianDish", aliases=["Dosai", "Dose"], regional={"hindi": "Dosa", "tamil": "Dosai", "kannada": "Dose"}),
    food("food-idli", "Idli", "indianDish", aliases=["Idly"], regional={"tamil": "Idli", "kannada": "Idli"}),
    food("food-sambar", "Sambar", "indianDish", aliases=["Sambhar"], regional={"tamil": "Sambar", "telugu": "Sambar"}),
    food("food-dal-tadka", "Dal tadka", "indianDish", aliases=["Dal", "Tadka dal"], regional={"hindi": "Dal tadka"}),
    food("food-roti", "Roti", "indianDish", aliases=["Chapati", "Phulka", "Roti chapati"], regional={"hindi": "Roti"}),
    food("food-biryani", "Biryani", "indianDish", aliases=["Biriyani"], regional={"hindi": "Biryani", "tamil": "Biriyani"}),
    food("food-khichdi", "Khichdi", "indianDish", aliases=["Khichri", "Pongal"], regional={"hindi": "Khichdi", "tamil": "Pongal"}),
]

(OUT / "sources.json").write_text(json.dumps(sources, indent=2) + "\n", encoding="utf-8")
(OUT / "categories.json").write_text(json.dumps(categories, indent=2) + "\n", encoding="utf-8")
(OUT / "foods.json").write_text(json.dumps(foods, indent=2) + "\n", encoding="utf-8")
print(f"Wrote {len(foods)} foods, {len(sources)} sources, {len(categories)} categories to {OUT}")
