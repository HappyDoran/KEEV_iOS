//
//  File.swift
//  KEEVCore
//
//  Created by junsungkim on 5/17/25.
//

import Foundation

import Network

final class MockAPIClient: APIClient {
    private let data: Data =
"""
{
    "id": 1253,
    "nickname": "포비",
    "email": "gdkffxbjjc@privaterelay.appleid.com",
    "description": "",
    "profileImageURL": "https://keev-dev.s3.ap-northeast-2.amazonaws.com/user/1253/profileImage/포비 2기.png",
    "backgroundImageURL": "",
    "followerCount": 0,
    "followingCount": 0,
    "accessToken": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJnZGtmZnhiampjQHByaXZhdGVyZWxheS5hcHBsZWlkLmNvbSIsInVzZXJJZCI6MTI1Mywicm9sZSI6IlJPTEVfVVNFUiIsImlhdCI6MTc0MjM1MzU3MywiZXhwIjoxNzQyMzU3MTczfQ.ooslgZnyRer7HtsJn9Y0aSq4KN2scBE4deuQQIGUXww",
    "refreshToken": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJnZGtmZnhiampjQHByaXZhdGVyZWxheS5hcHBsZWlkLmNvbSIsInVzZXJJZCI6MTI1Mywicm9sZSI6IlJPTEVfVVNFUiIsImlhdCI6MTc0MjM1MzU3MiwiZXhwIjoxNzQ0OTQ1NTcyfQ.qVD0Mv0rwoH2Q6YoboxwYMFkx0pjNzJO_UtnAfDxKSk",
    "createdDate": "2025-03-19T12:06:09.358742"
}
""".data(using: .utf8)!
    
    func request<T>(by converter: some Network.URLRequestConvertible, for type: T.Type, decoder: JSONDecoder) async throws -> T where T : Decodable {
        try decoder.decode(T.self, from: data)
    }
    
    func request(by converter: some Network.URLRequestConvertible) async throws -> Network.APIResponse {
        (data, 200)
    }
    
    func request(from request: URLRequest) async throws -> Network.APIResponse {
        (data, 200)
    }
    
    func request<T>(from request: URLRequest, for type: T.Type, decoder: JSONDecoder) async throws -> T where T : Decodable {
        try decoder.decode(T.self, from: data)
    }
}

