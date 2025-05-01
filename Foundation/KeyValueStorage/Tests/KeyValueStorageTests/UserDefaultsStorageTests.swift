import Foundation
import Testing
@testable import KeyValueStorage

struct Todo: Codable, Equatable {
    let title: String
    let isCompleted: Bool
    let date: Date
    init(title: String = "sample todo", isCompleted: Bool = false, date: Date = Date()) {
        self.title = title
        self.isCompleted = isCompleted
        self.date = date
    }
}

let value = Todo()
let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601
    return decoder
}()
let encoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    encoder.dateEncodingStrategy = .iso8601
    return encoder
}()

@Test
func save를_호출하면_밸류가_저장되는가() async throws {
    let key = UUID().uuidString
    let storage = MockStorage(storage: UserDefaultsStorage())
    try storage.save(value, forKey: key, encoder: JSONEncoder())

    #expect(try storage.load(key) == value)
    storage.removeAll()
}

@Test
func 아무것도_없는_상태에서_load를_호출하면_저장한_nil이_나온다() async throws {
    let key = UUID().uuidString
    let storage = MockStorage(storage: UserDefaultsStorage())
    let condition : Int? = try storage.load(key)
    
    #expect(condition == nil)
    storage.removeAll()
}

@Test
func remove를_호출하면_밸류가_지워지는가() async throws {
    let key = UUID().uuidString
    let storage = MockStorage(storage: UserDefaultsStorage())
    
    try storage.save(value, forKey: key, encoder: JSONEncoder())
    storage.remove(key)
    
    #expect(try storage.load(key) == Optional<String>.none)
    storage.removeAll()
}

@Test
func 잘못된_디코더로_디코딩_시_에러가_발생하는가() async throws {
    let key = UUID().uuidString
    let storage = MockStorage(storage: UserDefaultsStorage())
    try storage.save(value, forKey: key, encoder: encoder)
    
    #expect(throws: StorageError.self) {
        let _: Todo? = try storage.load(key)
    }
    storage.removeAll()
}
