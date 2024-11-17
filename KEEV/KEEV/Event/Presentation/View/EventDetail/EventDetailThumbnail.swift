//
//  EventDetailThumbnail.swift
//  KEEV
//
//  Created by Doran on 11/17/24.
//

import SwiftUI

struct EventDetailThumbnail: View {
    private let selectedEvent: SimpleEventDTO
    
    init(selectedEvent: SimpleEventDTO) {
        self.selectedEvent = selectedEvent
    }
    
    var body: some View {
        AsyncImage(url: URL(string: selectedEvent.posterURLString)) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(height: 393)
    }
}

#Preview {
    EventDetailThumbnail(selectedEvent: .dummy0)
}
