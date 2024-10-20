//
//  VibeServiceProtocol.swift
//  KEEV
//
//  Created by Yune Cho on 10/19/24.
//

import Foundation

/// VibeService를 구현하기 위한 프로토콜입니다.
///
/// - Author: 라움
protocol VibeServiceProtocol: ObservableObject {
    var vibes: [ReviewDTO] { get }
    
    func getVibes(forKey key: String)
    func setVibes(forKey key: String) async
    func createVibe(newVibe: ReviewDTO)
    func editVibe(newVibe: ReviewDTO)
    func removeVibe(vibe: ReviewDTO)
}
