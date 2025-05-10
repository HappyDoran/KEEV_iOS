import Testing
@testable import Caching

let testKey = "test"
let testValue = 42

@Test func 값을_저장하고_불러오면_값이_같게_나온다() async throws {
    let configuration = ExpiringCache<String, Int>.Configuration(memoryLimit: 1024, countLimit: 100, expirationInterval: 10, cleanUpInterval: nil)
    let cache = ExpiringCache<String, Int>(configuration: configuration)
    cache.set(testValue, forKey: testKey)
    #expect(cache.get(forKey: testKey) == testValue)
}

@Test func 값이_없을_때_nil이_나온다() async throws {
    let configuration = ExpiringCache<String, Int>.Configuration(memoryLimit: 1024, countLimit: 100, expirationInterval: 10, cleanUpInterval: nil)
    let cache = ExpiringCache<String, Int>(configuration: configuration)
    
    #expect(cache.get(forKey: testKey) == nil)
}

@Test func 값이_존재해도_지나간_시간이면_nil이_나온다() async throws {
    let configuration = ExpiringCache<String, Int>.Configuration(memoryLimit: 1024, countLimit: 100, expirationInterval: 1, cleanUpInterval: nil)
    let cache = ExpiringCache<String, Int>(configuration: configuration)
    cache.set(testValue, forKey: testKey)
    try await Task.sleep(for: .seconds(2))
    #expect(cache.get(forKey: testKey) == nil)
}

@Test func 지정된_시간마다_자동으로_clean_up_되어_만료된_값이_삭제된다() async throws {
    let configuration = ExpiringCache<String, Int>.Configuration(memoryLimit: 1024, countLimit: 100, expirationInterval: 0.5, cleanUpInterval: 1)
    let cache = ExpiringCache<String, Int>(configuration: configuration)
    cache.set(testValue, forKey: testKey)
    try await Task.sleep(for: .seconds(2))
    #expect(cache.get(forKey: testKey) == nil)
}

@Test func 저장한_값을_삭제하면_nil이_나온다() async throws {
    let configuration = ExpiringCache<String, Int>.Configuration(memoryLimit: 1024, countLimit: 100, expirationInterval: 10, cleanUpInterval: nil)
    let cache = ExpiringCache<String, Int>(configuration: configuration)
    cache.set(testValue, forKey: testKey)
    cache.remove(forKey: testKey)
    #expect(cache.get(forKey: testKey) == nil)
}

@Test func 저장한_값을_전부_삭제하면_모두_nil이_나온다() async throws {
    let configuration = ExpiringCache<String, Int>.Configuration(memoryLimit: 1024, countLimit: 100, expirationInterval: 10, cleanUpInterval: nil)
    let cache = ExpiringCache<String, Int>(configuration: configuration)
    cache.set(testValue, forKey: testKey)
    cache.removeAll()
    #expect(cache.get(forKey: testKey) == nil)
}

@Test func 개수제한을_넘어버리면_캐싱된_값이_삭제된다() async throws {
    let configuration = ExpiringCache<String, Int>.Configuration(memoryLimit: 1024, countLimit: 1, expirationInterval: nil, cleanUpInterval: nil)
    let cache = ExpiringCache<String, Int>(configuration: configuration)
    cache.set(testValue, forKey: testKey)
    cache.set(2, forKey: "t")
    #expect(cache.get(forKey: testKey) == nil)
}

@Test func 값을_덮어씌우면_기존의_값이_삭제된다() async throws {
    let configuration = ExpiringCache<String, Int>.Configuration(memoryLimit: 1024, countLimit: 1, expirationInterval: nil, cleanUpInterval: nil)
    let cache = ExpiringCache<String, Int>(configuration: configuration)
    cache.set(testValue, forKey: testKey)
    cache.set(2, forKey: testKey)
    #expect(cache.get(forKey: testKey) != testValue)
}
