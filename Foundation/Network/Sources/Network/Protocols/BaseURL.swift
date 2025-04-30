//
//  BaseURL.swift
//  KEEVCore
//
//  Created by junsungkim on 4/28/25.
//

/// 스킴과 호스트 포트를 담은 프로토콜
///
/// 스킴과 호스트, 포트를 담고 있습니다.
/// - Warning: 스킴이 비어있거나, 영어 외의 다른 문자가 들어가면 안됩니다. host의 경우, 비어있으면 안됩니다.
public protocol BaseURL {
    var scheme: String { get }
    var host: String { get }
    var port: Int? { get }
}
