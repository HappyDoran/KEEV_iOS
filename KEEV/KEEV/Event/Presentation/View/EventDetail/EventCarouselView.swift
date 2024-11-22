import SwiftUI

struct EventCarouselView: View {
//    var imageNames: [String] = ["MainBanner1", "MainBanner2", "MainBanner3"]
    let timer = Timer.publish(every: 5.0, on: .main, in: .common).autoconnect()
    
    @State private var selectedImageIndex: Int = 0


    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $selectedImageIndex) {
                ForEach(0..<banners.count, id: \.self) { index in
                    banner(index: index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            capsuleView
        }
        .onReceive(timer) { _ in
            withAnimation(.default) {
                selectedImageIndex = (selectedImageIndex + 1) % banners.count
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
                    Text("\(selectedImageIndex+1) ")
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
        ZStack(alignment: .bottomLeading) {
            Image(banners[index].imageName)
                .resizable()
                .scaledToFill()
                .tag(index)
                .frame(height: 264)
                .clipped()
            VStack(alignment: .leading, spacing: 4){
                Text(banners[index].title)
                    .figmaFont(PretendardFont.title(style: .lg))
                    .foregroundColor(.gray50)
                    .multilineTextAlignment(.leading)
                
                Text(banners[index].description)
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
