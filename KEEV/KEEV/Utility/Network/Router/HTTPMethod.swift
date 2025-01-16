//
//  HTTPMethod.swift
//  KEEV
//
//  Created by Doran on 10/17/24.
//

import Foundation

/// 서버 구조에서 Request되고 Response가 이루어지는 방식을 나열하기 위한 열거형
///
/// 서버가 수행해야 할 동작을 지정해서 요청을 보낼 때 필요한 방식입니다.
///
/// - Author: Doran
enum HTTPMethod: String {
    /// 리소스 조회
    case get = "GET"
    /// 데이터 추가, 등록
    case post = "POST"
    /// 리소스 대체, 수정, 생성
    case put = "PUT"
    /// 리소스 삭제
    case delete = "DELETE"
    /// 리소스 부분 변경(수정)
    case patch = "PATCH"
}

/// HTTPMethod 의 원시값을 추출
///
/// - Note: URL에 "\()"를 표시하기 위한 CustomStringConvertible 프로토콜을 채택합니다.
/// - Author: Doran
extension HTTPMethod: CustomStringConvertible {
    // MARK: enum의 원시값 추출
    var description: String { self.rawValue }
}
