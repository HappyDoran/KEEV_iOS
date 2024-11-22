import SwiftUI

struct EventCarouselView: View {
    var imageNames: [String] = ["MainBanner1", "MainBanner2", "MainBanner3"]
    let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
    
    @State private var selectedImageIndex: Int = 0


    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $selectedImageIndex) {
                ForEach(0..<imageNames.count, id: \.self) { index in
                    Image(imageNames[index])
                        .resizable()
                        .scaledToFill()
                        .tag(index)
                        .frame(height: 264)
                        .clipped()
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            Capsule()
                .fill(Color.gray950.opacity(0.8))
                .frame(width: 42, height: 21)
                .overlay{
                    HStack(spacing : 0) {
                        Text("\(selectedImageIndex+1) ")
                            .foregroundColor(.gray50)
                        Text("/ \(imageNames.count)")
                            .foregroundColor(.gray500)
                    }
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                }


        }
        .onReceive(timer) { _ in
            withAnimation(.default) {
                selectedImageIndex = (selectedImageIndex + 1) % imageNames.count
            }
        }
        .frame(height: 264)
    }
}

#Preview {
    EventCarouselView()
}
