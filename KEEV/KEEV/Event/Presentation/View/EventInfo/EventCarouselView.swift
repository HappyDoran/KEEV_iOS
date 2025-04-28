import SwiftUI

/// 메인 베너 이미지 캐러셀 뷰
///
/// 이미지가 오른쪽으로만 계속 넘어가는 무한 캐러셀입니다.
///
/// - important : banner에 아무것도 들어가지 않을 경우 에러가 발생합니다.
///
/// - Author: Doran
struct EventCarouselView: View {
    
    
    @State private var selectedImageIndex: Int = 0
    @State private var itemsArray: [BannerProtocol] = []
    
    let introduceKEEV: Banner = Banner(title: "키브를 소개합니다", description: "키브의 A to Z, 키브에 대해 알아봅시다", image: Image("Banner1"), detailImage: Image("DetailBanner1"), detailDescriptionImage: Image("DetailDescription1"))
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            NavigationLink {
                EventCarouselDetailScreen(bannerItem: introduceKEEV)
            } label: {
                banner
            }
            capsuleView
        }
        .frame(height: 264)
    }
}

extension EventCarouselView {
    private var capsuleView: some View {
        Capsule()
            .fill(Color.gray950.opacity(0.8))
            .frame(width: 42, height: 21)
            .overlay{
                HStack(spacing : 0) {
                    Text("1 ")
                        .foregroundColor(.gray50)
                    Text("/ 1")
                        .foregroundColor(.gray500)
                }
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
            }
            .padding(.bottom, 20)
            .padding(.trailing, 16)
    }
}

extension EventCarouselView {
    private var banner: some View {
        introduceKEEV.image
            .resizable()
            .scaledToFill()
            .frame(height: 264)
            .clipped()
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(introduceKEEV.title)
                        .figmaFont(PretendardFont.title(style: .lg))
                        .foregroundColor(.gray50)
                        .multilineTextAlignment(.leading)
                    
                    Text(introduceKEEV.description)
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .medium)))
                        .foregroundColor(.gray100)
                }
                .padding(.bottom, 20)
                .padding(.leading, 16)
            }
    }
}

#Preview {
    EventCarouselView()
}
