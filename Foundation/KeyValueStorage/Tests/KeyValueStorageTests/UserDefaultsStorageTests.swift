import Foundation
import Testing
@testable import KeyValueStorage

let key = "myKey"
let value = "Hello, World!"

@Test
func save를_호출하면_밸류가_저장되는가() async throws {
    let storage = MockStorage(storage: UserDefaultsStorage())
    try storage.save(value, forKey: key, encoder: JSONEncoder())

    #expect(try storage.load(key) == value)
    storage.removeAll()
}

@Test
func remove를_호출하면_밸류가_지워지는가() async throws {
    let storage = MockStorage(storage: UserDefaultsStorage())
    
    try storage.save(value, forKey: key, encoder: JSONEncoder())
    storage.remove(key)
    
    #expect(try storage.load(key) == Optional<String>.none)
    storage.removeAll()
}

