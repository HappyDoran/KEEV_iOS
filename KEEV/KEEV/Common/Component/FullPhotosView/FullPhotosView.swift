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
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var scale: CGFloat = 1.0
    @State private var latestScale: CGFloat = 1.0
    
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
                        .scaleEffect(scale)
                        .gesture(magnification)
                        .gesture(doubleTap)
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
                .padding(.top, 69)
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
