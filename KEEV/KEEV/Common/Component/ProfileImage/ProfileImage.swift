//
//  ProfileImage.swift
//  KEEV
//
//  Created by Doran on 10/28/24.
//

import SwiftUI

/// PhotoPicker를 사용하여 프로필 사진을 첨부, 수정을 하는 구조체
///
/// - `selectedItem`:  picker에서 선택하는 Item, Picker에서 check되는 PhotosPickerItem 타입 변수
/// - `selectedImage`: UI에서 실제로 보여지는 이미지 타입 배열
///
/// - Note: picker에서 프로필 화면 클릭시 Picker가 열린다.
/// nil이였던 selectedImage에 UIImage로 변환된 selectedItem이 복사된다.
///
/// - Author: Doran
struct ProfileImage: View {
    @Binding private var profileImage: UIImage?
    private let editable: Bool
    
    init(profileImage: Binding<UIImage?>, editable: Bool) {
        self._profileImage = profileImage
        self.editable = editable
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if profileImage != nil {
                Image(uiImage: profileImage!)
                    .resizable()
                    .frame(width: 140, height: 140)
                    .scaledToFit()
                    .clipShape(Circle())
            } else {
                ZStack {
                    Circle()
                        .frame(width: 140,height: 140)
                        .foregroundColor(.gray900)
                    
                    Image("ProfileImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 101.12,height: 114.5)
                        .padding(.top, 25.9)
                }
            }
            
            if editable {
                ProfileImageCamera()
                    .padding(.all, 2)
            }
        }
        .frame(width: 140, height: 140)
    }
}

#Preview {
    ProfileImage(profileImage: .constant(UIImage(named: "sample")), editable: true)
}
