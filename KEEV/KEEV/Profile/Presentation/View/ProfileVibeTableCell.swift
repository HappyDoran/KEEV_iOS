//
//  ProfileVibeTableCell.swift
//  KEEV
//
//  Created by Yune Cho on 11/16/24.
//

import SwiftUI

struct ProfileVibeTableCell: View {
    private let vibe: VibeUIO
    
    init(vibe: VibeUIO) {
        self.vibe = vibe
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .frame(width: 114, height: 152)
            .overlay {
                URLCachedImage(
                    url: vibe.event.posterURL
                ) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else if phase.error == nil {
                        ProgressView()
                    } else {
                        Text(phase.error?.localizedDescription ?? "알 수 없는 에러가 발생했습니다.")
                    }
                }
                .frame(width: 114, height: 152, alignment: .center)
                .cornerRadius(4)
                .clipped()
            }
    }
}

#Preview {
    ProfileVibeTableCell(vibe: VibeUIO.dummy0)
}
