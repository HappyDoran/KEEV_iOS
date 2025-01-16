//
//  BaseURL.swift
//  KEEV
//
//  Created by Doran on 11/27/24.
//

/// URL에 기본적으로 들어가는 프로퍼티를 정의
///
/// - Note: http, https같은 scheme, 실질적인 주소 host, 포트번호 port
/// - Author: Doran
struct BaseURL: URLBaseComposable {
    let scheme: String
    let host: String
    let port: Int?
}
