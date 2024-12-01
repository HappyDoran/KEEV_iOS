//
//  URLCircleImage.swift
//  KEEV
//
//  Created by 김준성 on 11/19/24.
//

import SwiftUI

struct URLCircleImage: View {
    let url: URL?
    
    var body: some View {
        URLCachedImage(url: url) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if let error = phase.error {
                let _ = print(error)
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .mask(Circle())
    }
}

#Preview {
    URLCircleImage(url: SimpleUserUIO.dummy1.profileImageURL)
}
