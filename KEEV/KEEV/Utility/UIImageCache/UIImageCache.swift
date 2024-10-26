//
//  UIImageCache.swift
//  KEEV
//
//  Created by 김준성 on 10/25/24.
//

import UIKit

/// `UIImage`를 캐싱해주는 객체
///
/// `UIImage`를 Data로 바꿔서 캐싱을 합니다.
///
/// `UIImage`는 `png`와 `jpeg` 형식의 데이터로 변경을 할 수 있는데,
///
///  이와 관련하여, `ImageType`이라는 열거형을 만들어 이미지 형식을 정해서 저장할 수 있도록 했습니다.
///
/// - Author: newJunsung
actor UIImageCache {
    // MARK: Private attributes
    private let cache: CacheManagerProtocol
    private let imageType: ImageType
    
    // MARK: Intitializations
    
    /// `UIImageCache`의 기본 생성자
    ///
    /// - Parameters:
    ///   - cache: `CacheManagerProtocol`을 채택한 클래스를 주입하여 다양한 캐싱 전략에 맞게 캐싱할 수 있습니다.
    ///   - imageType: 저장할 이미지의 형식을 `png`와 `jpeg` 중에서 고르면 됩니다.
    ///
    /// - Author: newJunsung
    init(cache: CacheManagerProtocol, imageType: ImageType) {
        self.cache = cache
        self.imageType = imageType
    }
    
    // MARK: Functions
    
    /// 키에 맞는 이미지를 반환합니다.
    func image(for key: String) async -> UIImage? {
        do {
            let data = try await cache.loadFromCache(for: "\(key).\(imageType)")
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
    
    /// 키와 이미지를 저장합니다.
    func store(uiImage: UIImage, for key: String) async throws {
        guard let data = imageType.data(for: uiImage) else {
            throw CacheError.notFound
        }
        
        try await cache.storeInCache(data, for: "\(key).\(imageType)")
    }
    
    /// 키와 이미지를 삭제합니다.
    func remove(key: String) async throws {
        try await cache.removeFromCache(for: "\(key).\(imageType)")
    }
}

extension UIImageCache {
    enum ImageType: CustomStringConvertible {
        case jpeg(quality: CGFloat)
        case png
        
        var description: String {
            switch self {
            case .jpeg:
                "jpeg"
            case .png:
                "png"
            }
        }
        
        func data(for uiImage: UIImage) -> Data? {
            switch self {
            case .jpeg(let quality):
                uiImage.jpegData(compressionQuality: quality)
            case .png:
                uiImage.pngData()
            }
        }
    }
}
