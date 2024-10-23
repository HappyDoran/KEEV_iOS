//
//  FullPhotosView.swift
//  KEEV
//
//  Created by Yune Cho on 10/23/24.
//

import SwiftUI

struct FullPhotosView: View {
    let photos: [String]
    @Binding var selectedPhoto: String
    
    var body: some View {
        TabView(selection: $selectedPhoto) {
            ForEach(photos, id: \.self) { photo in
                Image(photo)
                    .resizable()
                    .scaledToFit()
                    .tag(photo)
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

#Preview {
    FullPhotosView(photos: ["temp1", "temp2", "temp3", "temp4", "temp5"], selectedPhoto: .constant("temp1"))
}
