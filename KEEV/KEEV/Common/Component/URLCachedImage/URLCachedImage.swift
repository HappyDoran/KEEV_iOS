//
//  URLCachedImage.swift
//  KEEV
//
//  Created by 김준성 on 11/13/24.
//

import SwiftUI

fileprivate let cache = UIImageCache.shared
fileprivate let session = URLSession.shared

/// URL의 이미지를 캐싱하고 보여주는 뷰
///
/// 기존의 `AsyncImage`와 다른 점은 캐싱을 한다는 점입니다.
///
/// 캐싱을 `UIImageCache`를 통해 하고 있습니다.
///
/// 사용법은 아래와 같습니다:
///
/// ```swift
/// VStack {
///     URLCachedImage(
///         url: URL(string: "https://ticketimage.interpark.com/Play/image/large/24/24016374_p.gif")
///     ) { phase in
///         if let image = phase.image { // 이미지를 성공적으로 불러왔을 때
///             image
///                .resizable()
///         } else if phase.error == nil { // 이미지를 불러오는 중일 때
///             ProgressView()
///         } else { // 에러가 발생했을 때
///             Text(phase.error?.localizedDescription ?? "알 수 없는 에러가 발생했습니다.")
///         }
///     }
///     .frame(width: 150, height: 150, alignment: .center)
///     Text("fefe")
/// }
/// ```
///
/// - Note: 캐싱을 하기 위한 인스턴스로 `UIImageCache.shared`를 사용하고 다운을 받기 위한 인스턴스로 `URLSession.shared`를 사용합니다.
/// - Author: newJunsung
struct URLCachedImage<Content: View>: View where Content: View {
    @State private var phase: AsyncImagePhase = .empty
    
    let url: URL?
    
    @ViewBuilder
    let content: (AsyncImagePhase) -> Content
    
    var body: some View {
        content(phase)
            .task(configureImage)
    }
    
    @Sendable
    private func configureImage() async {
        if let url {
            await fetchImage(from: url)
        } else {
            phase = .failure(URLCachedImage.FetchError.invalidURL)
        }
    }
    
    private func fetchImage(from url: URL) async {
        if let cachedImage = cache.image(for: url) {
            print("hit cache")
            phase = .success(Image(uiImage: cachedImage))
        } else {
            await downloadImage(from: url)
        }
    }
    
    private func downloadImage(from url: URL) async {
        do {
            let (data, _) = try await session.data(from: url)
            if let downloadedImage = UIImage(data: data) {
                print("downloaded image")
                await cache.store(downloadedImage, for: url)
                phase = .success(Image(uiImage: downloadedImage))
            } else {
                phase = .failure(URLCachedImage.FetchError.invalidImage)
            }
        } catch {
            phase = .failure(error)
        }
    }
}

extension URLCachedImage {
    enum FetchError: Error {
        case invalidURL
        case invalidImage
    }
}

#Preview {
    VStack {
        URLCachedImage(
            url: URL(string: "https://ticketimage.interpark.com/Play/image/large/24/24016374_p.gif")
        ) { phase in
            
            if let image = phase.image {
                image
                    .resizable()
            } else if phase.error == nil {
                ProgressView()
            } else {
                Text(phase.error?.localizedDescription ?? "알 수 없는 에러가 발생했습니다.")
            }
        }
        .frame(width: 150, height: 150, alignment: .center)
        Text("fefe")
    }
}
