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
        switch title {
        case "키브를 소개합니다":
            return AnyView(CarouselFirstView())
        case "올해의 첫 내한,\n어디 갈까?":
            return AnyView(CarouselSecondView())
        case "2024 공연결산.zip\n주요 공연 소개":
            return AnyView(CarouselThirdView())
        default:
            return AnyView(Text("기본 설명 뷰"))
        }
    }
}
