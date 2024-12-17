//
//  OverflowContentViewModifier.swift
//  KEEV
//
//  Created by Doran on 12/17/24.
//

import SwiftUI

struct OverflowContentViewModifier: ViewModifier {
    @State private var contentOverflow: Bool = false
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
            .background(
                GeometryReader { contentGeometry in
                    Color.clear
                        .onAppear {
                            updateContentOverflow(contentHeight: contentGeometry.size.height, geometryHeight: geometry.size.height)
                        }
                        .onChange(of: contentGeometry.size.height) { _, newHeight in
                            updateContentOverflow(contentHeight: newHeight, geometryHeight: geometry.size.height)
                        }
                        .onChange(of: geometry.size.height) { _, newHeight in
                            updateContentOverflow(contentHeight: contentGeometry.size.height, geometryHeight: newHeight)
                        }
                }
            )
            .wrappedInScrollView(when: contentOverflow)
        }
    }
}

extension OverflowContentViewModifier {
    private func updateContentOverflow(contentHeight: CGFloat, geometryHeight: CGFloat) {
        contentOverflow = contentHeight > geometryHeight
    }
}

