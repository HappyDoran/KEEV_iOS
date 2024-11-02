//
//  ProfileImageEdit.swift
//  KEEV
//
//  Created by Doran on 10/28/24.
//

import SwiftUI

/// 프로필 수정시 들어가는 뷰
///
/// 따로 만들어진 프로필 사진 첨부 뷰와 카메라 아이콘 뷰를 합쳐서 만들어 놓은 뷰입니다.
///
/// - Author: Doran
struct ProfileImageEdit: View {
    @Binding var profileImage: UIImage?
    
    @State private var showActionSheet = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ProfileImage(selectedImage: $profileImage)
            
            ProfileImageCamera()
                .padding(.all, 2)
        }
        .frame(width: 140, height: 140)
    }
}

#Preview {
    ProfileImageEdit(profileImage: .constant(UIImage(named: "sample")))
}
