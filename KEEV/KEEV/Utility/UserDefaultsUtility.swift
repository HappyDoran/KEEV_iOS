//
//  UserDefaultsUtility.swift
//  KEEV
//
//  Created by Yune Cho on 10/17/24.
//

import Foundation

/// UserDefaults를 사용하는 Utility입니다.
///
/// UserDefaults를 이용하는 작업들을 수행하는 Utility입니다.
///
/// - Author: 라움
struct UserDefaultsUtility {
    /// UserDefaults에 String 값을 저장하기 위한 함수
    ///
    /// - Parameters:
    ///   - value: 저장한 문자열
    ///   - key: 키 값
    ///
    /// 문자열을 저장할 일이 있을 수 있어서 만들어놨습니다.
    ///
    /// - Author: 라움
    static func set(_ value: String, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    /// UserDefaults에 String 값을 가져오기 위한 함수
    ///
    /// - Parameters:
    ///   - key: 값을 가져오기 위해 필요한 키 값
    ///
    /// 문자열을 저장할 일이 있을 수 있어서 만들어놨습니다.
    ///
    /// - Returns: key 값에 해당하는 값이 있을 경우에 해당 값을 리턴
    ///
    /// - Author: 라움
    static func get(forKey key: String) -> String? {
        UserDefaults.standard.string(forKey: key)
    }
    
    /// 바이브 데이터를 UserDefaults에 저장하는 함수입니다.
    ///
    /// - Parameters:
    ///   - vibe: 바이브 구조체 데이터
    ///   - key: 키 값(바이브 데이터의 리뷰 고유 ID를 모아놓은 배열에 접근하기 위한 키값이며 AppEnvironment에 선언되어있습니다.)
    ///
    /// 바이브 구조체 데이터를 UserDefaults에 저장하고 해당 바이브의 id값은 id값들을 모아놓은 배열이 저장된 UserDefaults 위치에 저장합니다.
    ///
    /// - Author: 라움
    static func saveVibe(_ vibe: VibeData, forKey key: String) {
        if var vibeIDs = UserDefaults.standard.array(forKey: key) as? [String] {
            setVibe(vibe)
            vibeIDs.append(vibe.id)
            UserDefaults.standard.set(vibeIDs, forKey: key)
        } else {
            setVibe(vibe)
            UserDefaults.standard.set([vibe.id], forKey: key)
        }
    }
    
    // VibeData를 인코딩해서 UserDefaults에 저장하는 함수
    private static func setVibe(_ vibe: VibeData) {
        let encoder = JSONEncoder()
        
        if let encodedData = try? encoder.encode(vibe) {
            UserDefaults.standard.set(encodedData, forKey: vibe.id)
        }
    }
    
    /// UserDefaults로부터 바이브 데이터를 불러오는 함수입니다.
    ///
    /// - Parameters:
    ///   - key: 키 값(바이브 데이터에서의 리뷰 고유 ID)
    ///
    /// UseDefaults에 저장된 데이터를 가져온 후 JSONDecoder로 디코딩하여 바이브 구조체에 저장합니다.
    ///
    /// - Returns: 바이브 구조체 데이터를 리턴합니다.
    ///
    /// - Author: 라움
    static func getVibes(forKey key: String) -> [VibeData] {
        var vibes: [VibeData] = []
        
        if let vibeIDs = UserDefaults.standard.array(forKey: key) as? [String] {
            for id in vibeIDs {
                if let loadedVibe = loadVibe(forKey: id) {
                    vibes.append(loadedVibe)
                }
            }
        }
        
        return vibes
    }
    
    // id값으로 UserDefaults로부터 Data를 가져와서 VibeData로 디코딩 후 리턴하는 함수
    private static func loadVibe(forKey id: String) -> VibeData? {
        if let savedData = UserDefaults.standard.object(forKey: id) as? Data {
            let decoder = JSONDecoder()
            
            if let savedVibe = try? decoder.decode(VibeData.self, from: savedData) {
                return savedVibe
            }
        }
        return nil
    }
    
    /// UserDefaults에서 바이브 데이터를 삭제하는 함수입니다.
    ///
    /// - Parameters:
    ///   - id: 선택한 바이브의 id 값
    ///   - key: 바이브 id들을 모아놓은 배열에 접근하기 위한 key값
    ///
    /// UserDefaults에 존재하는 바이브 id 배열에서 선택된 바이브의 id를 삭제하고 선택한 바이브 id에 해당하는 데이터들도 삭제하는 함수입니다.
    ///
    /// - Author: 라움
    static func removeVibe(id: String, forKey key: String) {
        if var vibeIDs = UserDefaults.standard.array(forKey: key) as? [String] {
            for vibeID in vibeIDs {
                if vibeID == id {
                    UserDefaults.standard.removeObject(forKey: id)
                    vibeIDs.remove(at: vibeIDs.firstIndex(of: vibeID)!)
                    UserDefaults.standard.set(vibeIDs, forKey: key)
                }
            }
        }
    }
}
