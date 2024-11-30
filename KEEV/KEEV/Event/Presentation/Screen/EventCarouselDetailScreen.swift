//
//  EventCarouselDetailScreen.swift
//  KEEV
//
//  Created by Doran on 11/30/24.
//

import SwiftUI

struct EventCarouselDetailScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var banner: any BannerProtocol
    private let title: String
    init (bannerItem: any BannerProtocol) {
        self.banner = bannerItem
        title = bannerItem.title.replacingOccurrences(of: "\n", with: " ")
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                banner.detailImage
                banner.detailDescriptionImage
            }
        }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 24){
                            Image(systemName: "chevron.backward")
                                .foregroundStyle(.gray100)
                            Text(title)
                                .figmaFont(PretendardFont.title(style: .xs))
                                .foregroundStyle(.gray300)
                        }
                    }
                }
            }
    }
}

#Preview {
    NavigationStack {
        EventCarouselDetailScreen(bannerItem: Banner(title: "올해의 마무리,\n공연과 함께", description: "연말의 주요 공연을 확인해보세요!", image: Image("Banner2"), detailImage: Image("DetailBanner2"), detailDescriptionImage: Image("DetailDescription2")))
    }
}
