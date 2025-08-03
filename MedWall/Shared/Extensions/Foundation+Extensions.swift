// MARK: - Foundation Extensions
// File: MedWall/Shared/Extensions/Foundation+Extensions.swift

import Foundation

extension UserDefaults {
    func data<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
    
    func set<T: Codable>(_ value: T, forKey key: String) {
        let data = try? JSONEncoder().encode(value)
        set(data, forKey: key)
    }
}
