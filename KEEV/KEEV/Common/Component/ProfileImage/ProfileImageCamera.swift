//
//  ProfileImageCamera.swift
//  KEEV
//
//  Created by Doran on 10/28/24.
//

import SwiftUI

struct ProfileImageCamera: View {
    var body: some View {
        Circle().frame(width: 28,height: 28).foregroundColor(.brand500)
            .overlay{
                Image(systemName: "camera.fill")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall3, bodyWeight: .medium)))
                    .foregroundColor(.white)
            }

    }
}

#Preview {
    ProfileImageCamera()
}
