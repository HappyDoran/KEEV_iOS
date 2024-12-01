import SwiftUI

/// 메인 베너 이미지 캐러셀 뷰
///
/// 이미지가 오른쪽으로만 계속 넘어가는 무한 캐러셀입니다.
///
/// - important : banner에 아무것도 들어가지 않을 경우 에러가 발생합니다.
///
/// - Author: Doran
struct EventCarouselView: View {
    let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
    
    @State private var selectedImageIndex: Int = 0
    @State private var itemsArray: [BannerProtocol] = []

    let banners: [Banner] = [
        Banner(title: "키브를 소개합니다", description: "키브의 A to Z, 키브에 대해 알아봅시다", image: Image("Banner1"), detailImage: Image("DetailBanner1"), detailDescriptionImage: Image("DetailDescription1")),
        Banner(title: "올해의 마무리,\n공연과 함께", description: "연말의 주요 공연을 확인해보세요!", image: Image("Banner2"), detailImage: Image("DetailBanner2"), detailDescriptionImage: Image("DetailDescription2")),
        Banner(title: "2024\n한국을 찾은 아티스트", description: "연말의 주요 공연을 확인해보세요!", image: Image("Banner3"), detailImage: Image("DetailBanner3"), detailDescriptionImage: Image("DetailDescription3")),
    ]

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $selectedImageIndex) {
                ForEach(0..<itemsArray.count, id: \.self) { index in
                    NavigationLink {
                        EventCarouselDetailScreen(bannerItem: itemsArray[index] as! Banner)
                    } label: {
                        banner(index: index)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            capsuleView
        }
        .onAppear {
            itemsArray = banners + banners + banners
            selectedImageIndex = banners.count
        }
        .onChange(of: selectedImageIndex) { _, newValue in
            if newValue == 0 {
                Task {
                    try await Task.sleep(nanoseconds: 300_000_000)
                    itemsArray.removeLast(3)
                    itemsArray.insert(contentsOf: banners, at: 0)
                    selectedImageIndex += banners.count
                }
            } else if newValue == itemsArray.count - 1 {
                Task {
                    try await Task.sleep(nanoseconds: 300_000_000)
                    itemsArray.removeFirst(3)
                    itemsArray.append(contentsOf: banners)
                    selectedImageIndex = selectedImageIndex - banners.count
                }
            }
        }
        .onReceive(timer) { _ in
            withAnimation(.default) {
                selectedImageIndex = (selectedImageIndex + 1) % itemsArray.count
            }
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
                    Text("\(selectedImageIndex % banners.count+1) ")
                        .foregroundColor(.gray50)
                    Text("/ \(banners.count)")
                        .foregroundColor(.gray500)
                }
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
            }
            .padding(.bottom, 20)
            .padding(.trailing, 16)
    }
}

extension EventCarouselView {
    private func banner(index: Int) -> some View {
        itemsArray[index].image
            .resizable()
            .scaledToFill()
            .tag(index)
            .frame(height: 264)
            .clipped()
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(itemsArray[index].title)
                        .figmaFont(PretendardFont.title(style: .lg))
                        .foregroundColor(.gray50)
                        .multilineTextAlignment(.leading)
                    
                    Text(itemsArray[index].description)
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
