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
                AsyncImage(url: vibe.event.posterURL) { result in
                    result.image?
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 114, height: 152)
                        .cornerRadius(4)
                        .clipped()
                }
            }
    }
}

#Preview {
    ProfileVibeTableCell(vibe: VibeUIO.dummy0)
}
