import SwiftUI

struct EventCarouselView: View {
    var imageNames: [String] = ["MainBanner1", "MainBanner2", "MainBanner3"]
    let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
    
    @State private var selectedImageIndex: Int = 0
    @State private var itemsArray: [String] = []

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $selectedImageIndex) {
                ForEach(0..<imageNames.count, id: \.self) { index in
                    Image(imageNames[index])
                        .resizable()
                        .scaledToFill()
                        .tag(index)
                        .frame(height: 226)
                        .clipped()
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Dots indicator
            HStack(spacing: 4) {
                ForEach(0..<imageNames.count, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(selectedImageIndex == index ? 1 : 0.33))
                        .frame(width: 6, height: 6)
                    
                }
            }
        }
        .onReceive(timer) { _ in
            withAnimation(.default) {
                selectedImageIndex = (selectedImageIndex + 1) % imageNames.count
            }
        }
    }
}

#Preview {
    EventCarouselView()
}
