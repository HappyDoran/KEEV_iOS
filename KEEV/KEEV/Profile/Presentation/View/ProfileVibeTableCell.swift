//
//  ProfileVibeTableCell.swift
//  KEEV
//
//  Created by Yune Cho on 11/16/24.
//

import SwiftUI

/// 바이브의 표시 방식을 테이블로 선택했을 때 보여지는 각각의 테이블 셀
///
/// 바이브의 표시 방식을 테이블로 선택했을 때 테이블에서 보여지는 각각의 테이블 셀입니다.
///
/// - Author: 라움
struct ProfileVibeTableCell: View {
    private let vibe: VibeUIO
    
    init(vibe: VibeUIO) {
        self.vibe = vibe
    }
    
    var body: some View {
        URLCachedImage(
            url: vibe.event.posterURL
        ) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
            } else if phase.error == nil {
                ProgressView()
            } else {
                Text(phase.error?.localizedDescription ?? "알 수 없는 에러가 발생했습니다.")
            }
        }
        .mask {
            RoundedRectangle(cornerRadius: 4)
                .aspectRatio(114 / 152, contentMode: .fit)
        }
    }
}

#Preview {
    ProfileVibeTableCell(vibe: VibeUIO.dummy0)
}
