//
//  VibeContentView.swift
//  KEEV
//
//  Created by 김준성 on 11/19/24.
//

import SwiftUI

struct VibeContentView: LoginCheckableView {
    @Environment(AppState.self) var appState: AppState
    
    @Binding private var vibe: VibeUIO
    @Binding private var isLiked: Bool
    private let likeTapHandler: () -> Void
    
    init(vibe: Binding<VibeUIO>, isLiked: Binding<Bool>, likeTapHandler: @escaping () -> Void) {
        self._vibe = vibe
        self._isLiked = isLiked
        self.likeTapHandler = likeTapHandler
    }
    
    @State private var imageIndexTag: Int = 0
    
    var body: some View {
        VStack(spacing: 24) {
            vibeContent
            heartAndCommentCount
                .padding(.vertical, 12)
        }
    }
}

private extension VibeContentView {
    var vibeContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            userInfo
            if vibe.imageURLs.count > 0 {
                vibeImages
            }
            if let comment = vibe.comment {
                Text(comment.splitWords())
            }
            dateText
        }
    }
    
    var userInfo: some View {
        HStack(spacing: 16) {
            NavigationLink {
                ProfileScreen(userID: vibe.userID, isMyProfile: false, isNavigation: true)
            } label : {
                userProfileImage
                Text(vibe.userNickname)
                    .lineLimit(1)
                    .figmaFont(
                        PretendardFont.body(
                            style: .init(bodySize: .base, bodyWeight: .semibold)
                        )
                    )
            }
            Spacer()
            RatingView(rating: vibe.rating, image: Image(.star))
                .frame(width: 80, height: 16)
        }
        .padding(.horizontal, 4)
    }
    
    var userProfileImage: some View {
        URLCircleImage(url: vibe.userProfileImageURL)
            .frame(width: 40, height: 40)
    }
    
    var vibeImages: some View {
        let count = vibe.imageURLs.count

        return VStack(spacing: 12) {
            imagePages(maxIndex: count)
            pageIndicator(maxIndex: count)
        }
    }
    
    var dateText: some View {
        HStack {
            Text(vibe.createdDate)
                .foregroundStyle(.gray500)
                .figmaFont(
                    PretendardFont.body(
                        style: .init(bodySize: .xsmall2, bodyWeight: .medium)
                    )
                )
            Spacer()
        }
    }
    
    var heartAndCommentCount: some View {
        HStack(spacing: 20) {
            HStack(spacing: 8) {
                Image(isLiked ? "Heart.fill.color" : "Heart")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 18)
                    .onTapGesture(perform: tapLike)
                
                Text(vibe.likeCount > 99 ? "99+" : "\(vibe.likeCount)")
            }
            
            HStack(spacing: 8) {
                Image("Reply")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 18)
                
                Text(vibe.replyCount > 99 ? "99+" : "\(vibe.replyCount)")
            }
            
            Spacer()
        }
        .figmaFont(
            PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium))
        )
        .foregroundStyle(.gray500)
    }
}

private extension VibeContentView {
    private func tapLike() {
        checkLoginBefore {
            likeTapHandler()
        }
    }
}

private extension VibeContentView {
    func imageView(for url: URL?) -> some View {
        AsyncImage(url: url) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if let error = phase.error {
                let _ = debugPrint(error)
                Image("PosterError")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                ProgressView()
            }
        }
    }
    
    func imagePages(maxIndex: Int) -> some View {
        TabView(selection: $imageIndexTag) {
            ForEach(0..<maxIndex, id: \.self) { index in
                imageView(for: vibe.imageURLs[index])
                    .tag(index)
            }
        }
        .mask(RoundedRectangle(cornerRadius: 16))
        .aspectRatio(1, contentMode: .fill)
        .frame(maxWidth: .infinity)
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    func pageIndicator(maxIndex: Int) -> some View {
        HStack(spacing: 4) {
            ForEach(0..<maxIndex, id: \.self) { index in
                Circle()
                    .foregroundStyle(imageIndexTag == index ? .brand500 : .gray600)
            }
            .frame(width: 6, height: 6)
        }
    }
}

#Preview {
    VibeContentView(vibe: .constant(.dummy0), isLiked: .constant(false), likeTapHandler: {
        
    })
    .padding(.top, 20)
    .padding(.horizontal, 16)
}
