import Foundation

nonisolated struct SeedResourceLoader: Sendable {
    let bundle: Bundle

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    func loadFoods() throws -> [FoodDTO] {
        try decode([FoodDTO].self, resource: "foods")
    }

    func loadSources() throws -> [SourceDTO] {
        try decode([SourceDTO].self, resource: "sources")
    }

    func loadCategories() throws -> [CategoryDTO] {
        try decode([CategoryDTO].self, resource: "categories")
    }

    func decode<T: Decodable>(_ type: T.Type, resource: String) throws -> T {
        let url = try locate(resource: resource, extension: "json")
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw SeedDataError.missingResource(name: "\(resource).json")
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw SeedDataError.invalidJSON(name: "\(resource).json", underlying: error.localizedDescription)
        }
    }

    private func locate(resource: String, extension ext: String) throws -> URL {
        let candidates: [URL?] = [
            bundle.url(forResource: resource, withExtension: ext, subdirectory: "Resources/SeedData"),
            bundle.url(forResource: resource, withExtension: ext, subdirectory: "SeedData"),
            bundle.url(forResource: resource, withExtension: ext)
        ]
        if let url = candidates.compactMap({ $0 }).first {
            return url
        }
        throw SeedDataError.missingResource(name: "\(resource).\(ext)")
    }
}
