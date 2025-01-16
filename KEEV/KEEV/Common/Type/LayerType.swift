//
//  LayerType.swift
//  KEEV
//
//  Created by 김준성 on 1/6/25.
//

/// 아키텍쳐의 레이어를 정의하는 타입.
///
/// 이 타입은 현재 3개의 케이스로 구성되어 있습니다.
///
/// 첫 번째는 뷰를 나타내는 `view(of: String)`,
///
/// 두 번째는 서비스를 나타내는 `service(of: String)`,
///
/// 마지막으로 유틸리티를 나타내는 `utility(of: String)`이 있습니다.
///
/// 사용법은 아래와 같습니다.
/// ```swift
/// struct MyView: View {
///     let layer = LayerType.view(of: "\(type(of: self))")
///     var body: some View { ... }
/// }
/// ```
///
/// - Author: newJunsung
enum LayerType {
    case view(of: String)
    case service(of: String)
    case utility(of: String)
}

extension LayerType: CustomStringConvertible {
    var description: String {
        switch self {
        case .view(let name):
            name
        case .service(let name):
            name
        case .utility(let name):
            name
        }
    }
}
