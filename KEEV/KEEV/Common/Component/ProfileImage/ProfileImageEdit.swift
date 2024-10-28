//
//  ProfileImageEdit.swift
//  KEEV
//
//  Created by Doran on 10/28/24.
//

import SwiftUI

struct ProfileImageEdit: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ProfileImage()
            ProfileImageCamera().padding(.all, 2)
                
        }
        .frame(width: 140, height: 140)
        
    }
}

#Preview {
    ProfileImageEdit()
}
