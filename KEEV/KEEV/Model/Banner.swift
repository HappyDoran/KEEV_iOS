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
    var image: Image { get } // Image 타입으로 변경
}

struct Banner: BannerProtocol {
    let title: String
    let description: String
    let image: Image // Image 타입으로 변경
}
