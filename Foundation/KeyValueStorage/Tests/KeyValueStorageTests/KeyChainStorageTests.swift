//
//  KeyChainStorageTests.swift
//  KeyValueStorage
//
//  Created by junsungkim on 5/2/25.
//

import Foundation
import Testing
@testable import KeyValueStorage

@Test
func KeyChain_save를_호출하면_밸류가_저장되는가() async throws {
    let key = UUID().uuidString
    let storage = MockStorage(storage: KeyChainStorage(service: "test"))
    
    try storage.save(value, forKey: key, encoder: JSONEncoder())

    #expect(try storage.load(key) == value)
    storage.removeAll()
}

@Test
func KeyChain_아무것도_없는_상태에서_load를_호출하면_저장한_nil이_나온다() async throws {
    let key = UUID().uuidString
    let storage = MockStorage(storage: KeyChainStorage(service: "test"))
    let condition : Int? = try storage.load(key)
    
    #expect(condition == nil)
    storage.removeAll()
}

@Test
func KeyChain_remove를_호출하면_밸류가_지워지는가() async throws {
    let key = UUID().uuidString
    let storage = MockStorage(storage: KeyChainStorage(service: "test"))
    
    try storage.save(value, forKey: key, encoder: JSONEncoder())
    storage.remove(key)
    
    #expect(try storage.load(key) == Optional<String>.none)
    storage.removeAll()
}

@Test
func KeyChain_잘못된_디코더로_디코딩_시_에러가_발생하는가() async throws {
    let key = UUID().uuidString
    let storage = MockStorage(storage: KeyChainStorage(service: "test"))
    
    try storage.save(value, forKey: key, encoder: encoder)
    
    #expect(throws: StorageError.self) {
        let _: Todo? = try storage.load(key)
    }
    storage.removeAll()
}
