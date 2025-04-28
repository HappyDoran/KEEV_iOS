import Foundation
import Testing
@testable import Network

typealias Mock = URLComposableMock

@Test func 스킴과_호스트만_제대로_들어갔을_때() async throws {
    var urlComponents = URLComponents()
    #expect(urlComponents.build(from: Mock.test0) == Mock.result0)
}


@Test func 스킴과_호스트가_제대로_들어가고_쿼리만_들어갔을_때() async throws {
    var urlComponents = URLComponents()
    #expect(urlComponents.build(from: Mock.test1) == Mock.result1)
}

@Test func 스킴과_호스트가_제대로_들어가고_패스만_들어갔을_때() async throws {
    var urlComponents = URLComponents()
    #expect(urlComponents.build(from: Mock.test2) == Mock.result2)
}

@Test func 스킴과_호스트가_제대로_들어가고_패스와_쿼리가_들어갔을_때() async throws {
    var urlComponents = URLComponents()
    #expect(urlComponents.build(from: Mock.test3) == Mock.result3)
}

@Test func 스킴과_호스트가_제대로_들어가고_포트만_들어갔을_때() async throws {
    var urlComponents = URLComponents()
    #expect(urlComponents.build(from: Mock.test4) == Mock.result4)
}

@Test func 스킴과_호스트가_제대로_들어가고_포트와_쿼리가_들어갔을_때() async throws {
    var urlComponents = URLComponents()
    #expect(urlComponents.build(from: Mock.test5) == Mock.result5)
}

@Test func 스킴과_호스트가_제대로_들어가고_포트와_패스가_들어갔을_때() async throws {
    var urlComponents = URLComponents()
    #expect(urlComponents.build(from: Mock.test6) == Mock.result6)
}

@Test func 스킴과_호스트가_제대로_들어가고_포트와_패스_쿼리가_모두_들어갔을_때() async throws {
    var urlComponents = URLComponents()
    #expect(urlComponents.build(from: Mock.test7) == Mock.result7)
}

@Test func 잘못된_스킴이_들어갔을_때() async throws {
    var urlComponents = URLComponents()
    #expect(urlComponents.build(from: Mock.test8) == Mock.result9)
}

@Test func 잘못된_스킴이_들어가고_호스트가_없을_때() async throws {
    var urlComponents = URLComponents()
    #expect(urlComponents.build(from: Mock.test9) == Mock.result9)
}

@Test func 스킴과_호스트_포트_패스_쿼리_모두에_아무_것도_들어가지_않았을_때() async throws {
    var urlComponents = URLComponents()
    #expect(urlComponents.build(from: Mock.test10) == Mock.result10)
}
