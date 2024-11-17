//
//  EventVibeHeader.swift
//  KEEV
//
//  Created by Doran on 11/18/24.
//

import SwiftUI

struct EventVibeHeader: View {
    var body: some View {
        HStack(spacing: 0){
            Button(action: {}){
                HStack(spacing: 0){
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.brand500)
                    Text("최신순")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                        .foregroundColor(.gray500)
                }
            }
            Spacer()
            Button(action: {
                
            }){
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray700)
                    .frame(width: 75, height: 29)
                    .overlay{
                        HStack(spacing: 0){
                            Text("글쓰기")
                                .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium)))
                                .foregroundColor(.brand500)
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.brand500)
                        }
                    }
            }
        }
        .frame(height: 61)
    }
}

#Preview {
    EventVibeHeader()
}
