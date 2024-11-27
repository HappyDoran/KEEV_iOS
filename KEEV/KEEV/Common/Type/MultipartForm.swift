//
//  MultipartForm.swift
//  KEEV
//
//  Created by 김준성 on 11/27/24.
//

import Foundation

/// Multipart/form-data를 만드는 builder
///
/// 다양한 Content를 저장하고, 이를 바탕으로 form-data를 만들어줍니다.
/// 사용법은 아래와 같습니다.
///
/// 1. 우선 빌더를 만듭니다.
/// ```swift
/// var builder = MultipartFormBuilder()
/// ```
///
/// 2. 데이터를 준비해둡니다.
/// ```swift
/// let vibe = """
/// {
/// "eventID" : "d4cd371d-e67e-45ec-9805-58a91403609f",
/// "rating" : "4.2345"
/// }
/// """.data(using: .utf8)!
///
/// let image1 = """
/// fjeiowfajiow;fi38982u8rfj28ejdhu3hfuahyegy235r737e82gr26u7gfbeahf78we
/// """.data(using: .utf8)!
///
/// let image2 = """
/// fjeiowfajiow;fi38982u8rfj28ejdhu3hfuahyegy235r737e82gr26u7gfbeahf78we
/// """.data(using: .utf8)!
///
/// ```
///
/// 3. 데이터를 builder에 삽입합니다.
/// ```swift
/// builder.append(name: "vibeData", fileName: nil, content: .json(data: vibe))
/// builder.append(name: "vibeImages", fileName: "공연후기1.jpeg", content: .jpeg(data: image1))
/// builder.append(name: "vibeImages", fileName: "공연후기2.jpeg", content: .png(data: image2))
///
/// ```
/// 4. `build()`를 통해 빌더를 만듭니다.
/// ```swift
/// let (boundary, data) = builder.build()!
/// ```
///
/// 5. URLRequest에 boundary를 지정합니다.
/// ```swift
/// var req = URLRequest(url: tempURL)
/// req.httpMethod = "POST"
/// req.setValue("multipart/form-data; boundary=\"\(boundary)\"", forHTTPHeaderField: "Content-Type")
/// req.body = data
///
/// ```
/// - Note: `build()`의 경우, 저장했던 Form들의 개수에 따라 시간이 더 걸릴 수 있습니다. 시간복잡도는 O(`n`)입니다.
/// - Warning: `build()`는 빌드 시, `String`을 `data`함수를 통해 강제 언래핑해서 넣습니다. 이 과정에서 이모지 등을 데이터로 만드는 과정에서 충돌이 날 수도 있습니다.
/// - Author: newJunsung
struct MultipartFormBuilder {
    private typealias Form = (String, String?, Content)
    
    /// 빌드 시에 사용되는 바운더리 값
    let boundary: String
    private var forms = [Form]()
    
    subscript(index: Int) -> (String, String?, Content) {
        forms[index]
    }
    
    init() {
        self.boundary = "----\(UUID().uuidString)"
    }
    
    ///
    mutating func append(name: String, fileName: String? = nil, content: Content) {
        forms.append((name, fileName, content))
    }
    
    mutating func remove(at index: Int) -> (String, String?, Content)? {
        forms.remove(at: index)
    }
    
    /// 파일이름에 해당하는 배열을 삭제합니다. 중복되는 파일명이 있다면
    mutating func remove(fileName: String, isFirst: Bool = true) -> (String, String?, Content)? {
        guard let index = forms.firstIndex(where: {
            $0.1 == fileName
        }) else {
            return nil
        }
        
        return forms.remove(at: index)
    }
    
    mutating func removeAll() {
        forms.removeAll()
    }
    
    func build() -> (String, Data)? {
        var data = Data()
        
        for (name, fileName, content) in forms {
            data.append("\(boundary)\r\n".data(using: .utf8)!)
            data.append(deposition(name: name, fileName: fileName))
            data.append("Content-Type: \(content)\r\n\r\n".data(using: .utf8)!)
            data.append(content.data)
            data.append("\r\n".data(using: .utf8)!)
        }
        data.append("\(boundary)--\r\n".data(using: .utf8)!)
        
        return (boundary, data)
    }
    
    private func deposition(name: String, fileName: String?) -> Data {
        if let fileName {
            return "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n\r\n".data(using: .utf8)!
        }
        return "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!
    }
}

extension MultipartFormBuilder {
    enum Content: CustomStringConvertible {
        case json(data: Data)
        case jpeg(data: Data)
        case png(data: Data)
        
        var data: Data {
            switch self {
            case .json(let data): data
            case .jpeg(let data): data
            case .png(let data): data
            }
        }
        
        var description: String {
            switch self {
            case .json: "application/json"
            case .jpeg: "image/jpeg"
            case .png: "image/png"
            }
        }
    }
}

