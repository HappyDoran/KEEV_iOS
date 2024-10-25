//
//  UIImageCache.swift
//  KEEV
//
//  Created by 김준성 on 10/25/24.
//

import UIKit

actor UIImageCache {
    private let cache: CacheManagerProtocol
    private let imageType: ImageType
    
    init(cache: CacheManagerProtocol, imageType: ImageType) {
        self.cache = cache
        self.imageType = imageType
    }
    
    func image(for key: String) async -> UIImage? {
        do {
            let data = try await cache.loadFromCache(for: "\(key).\(imageType)")
            return UIImage(data: data)
        } catch {
            print(error)
            return nil
        }
    }
    
    func store(uiImage: UIImage, for key: String) async throws {
        guard let data = imageType.data(for: uiImage) else {
            throw CacheError.notFound
        }
        
        try await cache.storeInCache(data, for: "\(key).\(imageType)")
    }
    
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
