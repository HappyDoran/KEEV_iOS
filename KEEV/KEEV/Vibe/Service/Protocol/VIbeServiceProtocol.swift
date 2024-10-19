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
protocol VibeServiceProtocol {
    var vibes: [ReviewDTO] { get }
    
    func createVibe(forKey key: String, newVibe: ReviewDTO)
    func getVibes(forKey key: String)
    func editVibe(forKey key: String, newVibe: ReviewDTO)
    func removeVibe(forKey key: String, _ id: String)
}
