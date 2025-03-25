//
//  VibeFeedHeaderView.swift
//  KEEV
//
//  Created by Yune Cho on 3/24/25.
//

import SwiftUI

struct VibeFeedHeaderView: LoginCheckableView {
    @Environment(AppState.self) var appState
    
    @Binding var feedSection: FeedSection
    @Binding var isPresented: Bool
    
    @State private var barX: CGFloat = 0
    private let barHeight: CGFloat = 4
    private let barWidth: CGFloat = 82
    
    var body: some View {
        VStack(spacing: 0) {
            vibeFeedHeader
            vibeFeedTab
        }
    }
}

private extension VibeFeedHeaderView {
    var vibeFeedHeader: some View {
        VStack(spacing: 0){
            HStack(spacing: 0){
                Text("바이브")
                    .figmaFont(PretendardFont.title(style: .xl))
                
                Spacer()
                
                Button {
                    checkLoginBefore {
                        isPresented = true
                    }
                } label: {
                    CreateVibeButtonView()
                }
            }
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
    }
    
    var vibeFeedTab: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                HStack(spacing: 0) {
                    Text("전체")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .semibold)))
                        .foregroundColor(feedSection == .all ? .gray50 : .gray500)
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            feedSection = .all
                        }
                    
                    Text("팔로잉")
                        .foregroundColor(feedSection == .following ? .gray50 : .gray500)
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .semibold)))
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            feedSection = .following
                        }
                }
                .frame(height: 46)
            }
            .overlay(alignment: .bottom) {
                ZStack {
                    Rectangle()
                        .foregroundStyle(.grayBG800)
                        .frame(height: 1)
                    
                    Rectangle()
                        .fill(Color.brand500)
                        .frame(width: barWidth, height: barHeight)
                        .offset(x: feedSection == .all ? -((geometry.size.width / 4)) : (geometry.size.width / 4), y: 0)
                        .animation(.easeInOut, value: feedSection)
                }
            }
            .backgroundForKEEV()
        }
        .frame(height: 46)
    }
}

#Preview {
    VibeFeedHeaderView(feedSection: .constant(.all), isPresented: .constant(false))
}
