//
//  FullPhotosView.swift
//  KEEV
//
//  Created by Yune Cho on 10/23/24.
//

import SwiftUI

/// 전체 화면으로 사진을 볼 수 있는 뷰
///
/// 바이브 상에서 작게 보이는 사진을 전체 화면으로 볼 수 있는 뷰입니다.
///
/// - Note: 화면 확대/축소와 관련된 제스처는 화면이 확대된 상태에서의 버그 발생으로 인해서 포함시키지 않았습니다. 이후에 버그 해결하면 기능 추가토록 하겠습니다.
/// - Author: 라움
struct FullPhotosView: View {
    let photos: [String]
    @Binding var selectedPhoto: String
    
    @Environment(\.dismiss) private var dismiss
    
    // 현재 기능상 포함되어있지 않은 확대/축소를 위해 필요한 프로퍼티입니다.
    @State private var scale: CGFloat = 1.0
    @State private var latestScale: CGFloat = 1.0
    
    // 핀치 제스처로 이미지를 확대하고 축소할 수 있는 제스처
    // 현재 기능상 포함되어있지 않은 제스처입니다.
    private var magnification: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                let delta = value.magnification / latestScale
                latestScale = value.magnification
                scale *= delta
            }
            .onEnded { _ in
                latestScale = 1.0
                if scale < latestScale {
                    scale = 1.0
                }
            }
    }
    
    // 더블탭 제스처로 이미지를 확대하고 축소할 수 있는 제스처
    // 현재 기능상 포함되어있지 않은 제스처입니다.
    private var doubleTap: some Gesture {
        TapGesture(count: 2)
            .onEnded { _ in
                if scale == 1.0 {
                    scale *= 2.0
                } else {
                    scale = 1.0
                }
            }
    }
    
    // 화면을 아래로 쓸어내리는 동작으로 fullScreenCover인 화면을 닫을 수 있는 제스처
    private var slideDown: some Gesture {
        DragGesture()
            .onEnded { value in
                if value.location.y - value.startLocation.y > 100 {
                    dismiss()
                }
            }
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedPhoto) {
                ForEach(photos, id: \.self) { photo in
                    Image(photo)
                        .resizable()
                        .scaledToFit()
                        .tag(photo)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .gesture(slideDown)
            
            VStack {
                HStack(spacing: 40) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(Color.white)
                            .frame(width: 32, height: 24)
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer()
                }
                .frame(width: 393, height: 133)
                .padding(.top, 16)
                .background {
                    LinearGradient(
                        colors: [Color(red: 0.09, green: 0.09, blue: 0.09), Color(red: 0.09, green: 0.09, blue: 0.09, opacity: 0)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                
                Spacer()
                
                LinearGradient(
                    colors: [Color(red: 0.09, green: 0.09, blue: 0.09, opacity: 0), Color(red: 0.09, green: 0.09, blue: 0.09)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: 393, height: 96)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    FullPhotosView(photos: ["temp1", "temp2", "temp3", "temp4", "temp5"], selectedPhoto: .constant("temp1"))
}
