//
//  ProfileScreenVibeManager.swift
//  KEEV
//
//  Created by Yune Cho on 12/1/24.
//

import Foundation

/// 앱을 사용중인 기기에서 작성한 바이브를 관리하는 Manager
///
/// 앱을 사용중인 기기에서 작성한 바이브를 관리하는 Manger입니다.
///
/// 사용중인 기기에서 바이브를 작성할 경우에 Manager의 vibes에 바이브를 추가합니다.
///
/// - Note: 쇼케이스 때 사용하기 위한 임시 파일입니다.
/// - Author: 라움
class VibeManager: ObservableObject {
    /// 앱을 사용중인 기기에서 작성한 바이브의 배열
    @Published var vibes: [VibeUIO] = []
    
    /// 바이브의 개수를 리턴하는 함수
    func getVibesCount() -> Int {
        return vibes.count
    }
    
    /// 바이브를 새로 작성할 경우 Manager의 바이브 목록에 추가하는 함수
    func addVibe(vibe: VibeUIO) {
        vibes.append(vibe)
    }
    
    /// 바이브를 삭제했을 때 바이브 목록에서도 삭제해주는 함수
    func deleteVibe(vibeID: Int) {
        vibes.removeAll(where: { $0.id == vibeID })
    }
    
    /// 바이브가 수정되었을 때 바이브 목록에도 수정된 것을 반영해주는 함수
    func modifyVibe(vibeID: Int, modifiedVibe: VibeUIO) throws {
        guard let index = vibes.firstIndex(where: { $0.id == vibeID }) else { throw VibeError.multipartFormBuilderError }
        vibes[index] = modifiedVibe
    }
}
