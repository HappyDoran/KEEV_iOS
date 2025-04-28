//
//  Banner.swift
//  KEEV
//
//  Created by Doran on 11/23/24.
//

import SwiftUI

protocol BannerProtocol {
    var title: String { get }
    var description: String { get }
    var image: Image { get }
    var detailImage: Image { get }
    var detailDescriptionImage: Image { get }
    var descriptionView: AnyView { get }
}

struct Banner: BannerProtocol {
    let title: String
    let description: String
    let image: Image // Image 타입으로 변경
    let detailImage: Image
    let detailDescriptionImage: Image
    var descriptionView: AnyView {
        return AnyView(CarouselFirstView())
    }
}
