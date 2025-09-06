protocol DataSource {
    func save<T: Codable>(_ value: T, forKey key: String)
    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T?
    func saveString(_ value: String, forKey key: String)
    func loadString(forKey key: String) -> String?
    func remove(forKey key: String)
    func exists(forKey key: String) -> Bool
}
