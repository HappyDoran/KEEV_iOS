//
//  UIImageCache.swift
//  KEEV
//
//  Created by 김준성 on 10/25/24.
//

import UIKit

final class UIImageCache {
    private let cache: CacheManagerProtocol
    
    init(cache: CacheManagerProtocol) {
        self.cache = cache
    }
    
    func image(for key: String) async -> UIImage? {
        do {
            let data = try await cache.loadFromCache(for: key)
            return UIImage(data: data)
        } catch {
            print(error)
            return nil
        }
    }
    
    func store(uiImage: UIImage, _ imageType: ImageType, for key: String) async throws {
        guard let data = imageType.data(for: uiImage) else {
            throw CacheError.notFound
        }
        
        try await cache.storeInCache(data, for: "\(key).\(imageType)")
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
