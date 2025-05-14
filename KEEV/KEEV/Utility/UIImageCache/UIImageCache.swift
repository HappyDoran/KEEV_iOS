//
//  UIImageCache.swift
//  KEEV
//
//  Created by 김준성 on 10/28/24.
//

import Foundation
import UIKit

import Caching

/// 이미지를 캐싱하는 액터
///
/// 이 액터를 생성할 때, 환경설정을 반드시 해줘야합니다.
///
/// 환경 설정에 들어가야하는 요소로는, 이미지의 총 개수, 캐싱된 이미지의 총 용량, 캐싱된 이미지의 유통기한이 있습니다.
///
/// - Author: newJunsung
actor UIImageCache {
    typealias Cache = ExpiringCache<URL, UIImage>
    
    static let shared = UIImageCache(configuration: Cache.Configuration(memoryLimit: 1024 * 1024 * 128, countLimit: 512, expirationInterval: 256, cleanUpInterval: nil))
    
    private let cache: Cache
    
    /// 환경설정을 주입하여 UIImageCache를 생성합니다.
    /// 
    /// 환경 설정에 들어가야하는 요소로는, 이미지의 총 개수, 캐싱된 이미지의 총 용량, 캐싱된 이미지의 유통기한이 있습니다.
    init(configuration: Cache.Configuration) {
        self.cache = .init(configuration: configuration)
    }
    
    /// URL에 해당하는 이미지를 캐시 메모리에서 가져옵니다.
    ///
    /// - Parameters:
    ///   - key: 저장했던 이미지의 URL
    ///
    /// 캐싱된 이미지를 가져옵니다. 이 함수의 경우, `nonisolated`이기 때문에 동기적으로 호출이 가능합니다.
    ///
    /// - Returns: 이미지가 있으면 `UIImage`를 반환하고 없으면 `nil`을 반환합니다.
    /// - Author: newJunsung
    nonisolated func image(for key: URL) -> UIImage? {
        cache.get(forKey: key)
    }
    
    /// 키와 이미지를 캐싱하는 함수
    ///
    /// - Parameters:
    ///   - image: 저장할 이미지
    ///   - key: 저장하고 싶은 이미지의 URL
    ///
    /// URL과 이미지를 저장합니다.
    ///
    /// URL은 Key으로써 저장되고, UIImage는 Value로써 저장됩니다.
    ///
    /// - Author: newJunsung
    func store(_ image: UIImage, for key: URL) {
        cache.set(image, forKey: key)
    }
    
    /// 키 값에 해당하는 이미지를 삭제합니다.
    /// - Author: newJunsung
    func remove(for key: URL) {
        cache.remove(forKey: key)
    }
    
    /// 키 값과 캐싱된 이미지를 전부 삭제합니다.
    /// - Author: newJunsung
    func removeAll() {
        cache.removeAll()
    }
}
