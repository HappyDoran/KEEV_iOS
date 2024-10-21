//
//  VibeService.swift
//  KEEV
//
//  Created by Yune Cho on 10/19/24.
//

import Foundation

/// 바이브를 생성, 불러오기, 수정, 삭제할 수 있는 VibeService입니다.
///
/// UserDefaultsUtility를 사용하여 바이브의 생성, 불러오기, 수정, 삭제를 수행할 수 있습니다.
///
/// - Note: ObservableObject로 구현하였습니다.
/// - Author: 라움
class VibeService: VibeServiceProtocol {
    /// 불러온 바이브들의 목록을 저장하는 배열입니다.
    @Published var vibes: [ReviewDTO] = []
    
    private let userDefaultsUtility = UserDefaultsUtility()
    
    /// 바이브 목록을 가져오는 함수입니다.
    ///
    /// - Parameters:
    ///   - key: 키 값
    ///
    /// 키 값을 인자로 받아서 UserDefaults에 저장되어 있는 바이브 목록을 가져옵니다.
    ///
    /// - Author: 라움
    func getVibes(forKey key: String) {
        do {
            vibes = try userDefaultsUtility.get([ReviewDTO].self, forKey: key) ?? vibes
        } catch {
            print(error)
        }
    }
    
    /// 바이브를 저장하는 함수입니다.
    ///
    /// - Parameters:
    ///   - key: 키 값
    ///
    /// 업데이트된 바이브 목록을 키 값에 해당하는 UserDefaults에 저장합니다.
    /// 저장할 데이터가 많아지면 저장하는 시간이 길어지기 때문에 이를 해결하기 위해 async로 작성하였습니다.
    ///
    /// - Author: 라움
    func setVibes(forKey key: String) async {
        do {
            try userDefaultsUtility.set(vibes, forKey: key)
        } catch {
            print(error)
        }
    }
    
    /// 바이브를 저장하는 함수입니다.
    ///
    /// - Parameters:
    ///   - newVibe: 새로 저장할 바이브
    ///
    /// 새로 저장할 바이브를 인자로 받아서 바이브 목록에 추가합니다.
    ///
    /// - Author: 라움
    func createVibe(newVibe: ReviewDTO) {
        vibes.append(newVibe)
    }
    
    /// 바이브를 수정하는 함수입니다.
    ///
    /// - Parameters:
    ///   - newVibe: 바이브 목록에 업데이트할 수정된 바이브
    ///
    /// 수정된 바이브를 인자로 받아서 바이브 목록을 업데이트합니다.
    ///
    /// - Author: 라움
    func editVibe(newVibe: ReviewDTO) {
        if let index = vibes.firstIndex(where: { $0.id == newVibe.id }) {
            vibes[index] = newVibe
        }
    }
    
    /// 바이브를 삭제하는 함수입니다.
    ///
    /// - Parameters:
    ///   - vibe: 삭제할 바이브
    ///
    /// 삭제할 바이브를 인자로 받아서 해당 바이브와 id 값이 일치하는 바이브를 바이브 목록에서 삭제합니다.
    ///
    /// - Author: 라움
    func removeVibe(vibe: ReviewDTO) {
        if let index = vibes.firstIndex(where: { $0.id == vibe.id }) {
            vibes.remove(at: index)
        }
    }
}
