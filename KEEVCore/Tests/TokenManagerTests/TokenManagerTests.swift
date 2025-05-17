import Foundation
import Testing
@testable import KEEVCore

extension TokenManager.Configuration {
    static var mock: Self {
        .init(refreshInterval: 1, storage: MockStorage(), network: MockAPIClient())
    }
}

// MARK: fetch 테스트
@Test func 액세스_토큰이_없을_때_nil을_반환한다() async throws {
    let manager = TokenManager(configuration: .mock)
    let _ = try await manager.fetch(.accessToken)
    #expect(true)
}

@Test func 리프레시_토큰이_없을_때_nil을_반환한다() async throws {
    let manager = TokenManager(configuration: .mock)
    let _ = try await manager.fetch(.refreshToken)
    #expect(true)
}

@Test func 액세스_토큰이_만료되었을_때_expired를_반환한다() async throws {
    let manager = TokenManager(configuration: .mock)
    await manager.store([.accessToken: UUID().uuidString])
    await #expect(throws: TokenError.self) {
        let _ = try await manager.fetch(.accessToken)
    }
}

// MARK: refreshAccessToken 테스트
@Test func 리프레시_토큰이_없을_때_액세스_토큰을_갱신할_수_없다() async throws {
    let manager = TokenManager(configuration: .mock)
    await #expect(throws: TokenError.self) {
        let _ = try await manager.refreshAccessToken()
    }
}
@Test func 액세스_토큰을_갱신할_수_있다() async throws {
    let manager = TokenManager(configuration: .mock)
    await manager.store([.refreshToken: UUID().uuidString])
    let prevAccessToken = try await manager.fetch(.accessToken)
    let newAccessToken = try await manager.refreshAccessToken()
    #expect(prevAccessToken != newAccessToken)
}


// MARK: remove 테스트
@Test func 액세스_토큰이_정상적으로_삭제된다() async throws {
    let manager = TokenManager(configuration: .mock)
    await manager.store([.accessToken: UUID().uuidString])
    await manager.remove(.accessToken)
    await #expect(throws: TokenError.self) {
        _ = try await manager.fetch(.accessToken)
    }
}

@Test func 리프레시_토큰이_정상적으로_삭제된다() async throws {
    let manager = TokenManager(configuration: .mock)
    await manager.store([.refreshToken: UUID().uuidString])
    await manager.remove(.refreshToken)
    await #expect(throws: TokenError.self) {
        _ = try await manager.fetch(.refreshToken)
    }
}

@Test func 모든_토큰이_정상적으로_삭제된다() async throws {
    let manager = TokenManager(configuration: .mock)
    await manager.store([
        .accessToken: UUID().uuidString,
        .refreshToken: UUID().uuidString
    ])
    await manager.removeAll()
    
    await #expect(throws: TokenError.self) {
        _ = try await manager.fetch(.accessToken)
    }
    
    await #expect(throws: TokenError.self) {
        _ = try await manager.fetch(.refreshToken)
    }
}

// MARK: store 테스트
@Test func 액세스_토큰을_정상적으로_저장한다() async throws {
    let manager = TokenManager(configuration: .mock)
    let accessToken = UUID().uuidString
    await manager.store([.accessToken: accessToken])
    await #expect(try manager.fetch(.accessToken) == accessToken)
}

@Test func 리프레시_토큰을_정상적으로_저장한다() async throws {
    let manager = TokenManager(configuration: .mock)
    let refreshToken = UUID().uuidString
    await manager.store([.refreshToken: refreshToken])
    await #expect(try manager.fetch(.refreshToken) == refreshToken)
}

@Test func 모든_토큰을_정상적으로_저장한다() async throws {
    let manager = TokenManager(configuration: .mock)
    let accessToken = UUID().uuidString
    let refreshToken = UUID().uuidString
    await manager.store([
        .accessToken: accessToken,
        .refreshToken: refreshToken
    ])
    await #expect(try manager.fetch(.accessToken) == accessToken)
    await #expect(try manager.fetch(.refreshToken) == refreshToken)
}
