//
//  ProfileEditBackgroundView.swift
//  KEEV
//
//  Created by Yune Cho on 11/5/24.
//

import SwiftUI

struct ProfileEditBackgroundView: View {
    @Binding var newProfile: UserProfile
    @Binding var showBackgroundActionSheet: Bool
    
    var body: some View {
        VStack {
            if let background = newProfile.backgroundImage {
                Image(uiImage: background)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 202)
                    .clipped()
                    .onTapGesture {
                        showBackgroundActionSheet = true
                    }
            } else {
                Color.gray800
                    .frame(height: 202)
                    .onTapGesture {
                        showBackgroundActionSheet = true
                    }
            }
            
            Spacer()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ProfileEditBackgroundView(
        newProfile: .constant(UserProfile()),
        showBackgroundActionSheet: .constant(false)
    )
}
