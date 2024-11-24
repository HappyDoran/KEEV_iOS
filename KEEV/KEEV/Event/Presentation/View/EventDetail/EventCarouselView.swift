import SwiftUI

struct EventCarouselView: View {
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    @State private var selectedImageIndex: Int = 0
    @State private var itemsArray: [Banner] = []


    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $selectedImageIndex) {
                ForEach(0..<itemsArray.count, id: \.self) { index in
                    banner(index: index)
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
            print(selectedImageIndex)
            print(newValue)
            if newValue == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    itemsArray.removeLast(3)
                    itemsArray.insert(contentsOf: banners, at: 0)
                    selectedImageIndex += banners.count
                }
            } else if newValue == itemsArray.count - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    itemsArray.removeFirst(3)
                    itemsArray.append(contentsOf: banners)
                    selectedImageIndex = selectedImageIndex - banners.count
                }
            }
        }
        .onReceive(timer) { _ in
            withAnimation(.default) {
                selectedImageIndex += 1
                if selectedImageIndex > itemsArray.count {
                    selectedImageIndex = selectedImageIndex - banners.count - 1
                }
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
        ZStack(alignment: .bottomLeading) {
            Image(itemsArray[index].imageName)
                .resizable()
                .scaledToFill()
                .tag(index)
                .frame(height: 264)
                .clipped()
            VStack(alignment: .leading, spacing: 4){
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
