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
            } else if phase.error == nil {
                ProgressView()
            } else {
                let _ = print(phase.error!)
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
            }
        }
        .mask(Circle())
    }
}

#Preview {
    URLCircleImage(url: SimpleUserUIO.dummy1.profileImageURL)
}
