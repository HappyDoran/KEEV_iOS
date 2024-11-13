//
//  URLCachedImage.swift
//  KEEV
//
//  Created by 김준성 on 11/13/24.
//

import SwiftUI

fileprivate let cache = UIImageCache.shared
fileprivate let session = URLSession.shared

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

//#Preview {
//    URLCachedImage(url: .init(string: "https://ticketimage.interpark.com/Play/image/large/24/24016374_p.gif")!) { phase in
//        switch phase {
//        case .empty:
//            ProgressView()
//        case .success(let image):
//            image.resizable().scaledToFit()
//        case .failure(let error):
//            Text("error: \(error)")
//        @unknown default:
//            Text("fefe")
//        }
//    }
//    .onAppear {
//        AppEnvironment.setupDependency()
//    }
//}
