//
//  VibeServiceProtocol.swift
//  KEEV
//
//  Created by Yune Cho on 11/24/24.
//

import Foundation
import SwiftUI

/// VibeService를 구현하기 위한 프로토콜
///
/// VibeService를 구현하기 위한 프로토콜입니다.
///
/// - Author: 라움
protocol VibeServiceProtocol: LayerRepresentable, AnyObject {
    /// 바이브 갯수를 조회하는 함수
    ///
    /// - Parameters:
    ///   - eventID: 이벤트 ID
    ///
    /// 이벤트 ID를 통해 이벤트에 현재까지 기록된 바이브의 갯수를 가져오는 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 이벤트에 현재까지 기록된 바이브의 갯수
    ///
    /// - Author: 라움
    func getVibeCount(eventID: String) async throws -> Int
    
    /// 바이브 목록을 가져오는 함수
    ///
    /// - Parameters:
    ///   - page: 가져오고자하는 페이지의 번호
    ///   - size: 한 페이지에 넣을 바이브의 갯수
    ///   - sort: 바이브 정렬 기준
    ///
    /// 페이지네이션이 적용된 바이브 목록을 가져오는 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 페이지네이션이 적용된 바이브 목록
    ///
    /// - Author: 라움
    func getPaginatedVibes(page: Int, size: Int, sort: [(SortCase, SortPattern)]) async throws -> PaginatedResponse<VibeUIO>
    
    /// 특정 이벤트에 해당하는 바이브 목록을 가져오는 함수
    ///
    /// - Parameters:
    ///   - eventID: 특정 이벤트의 ID
    ///   - page: 가져오고자하는 페이지의 번호
    ///   - size: 한 페이지에 넣을 바이브의 갯수
    ///   - sort: 바이브 정렬 기준
    ///
    /// 페이지네이션이 적용된 특정 이벤트의 바이브 목록을 가져오는 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 페이지네이션이 적용된 바이브 목록
    ///
    /// - Author: newJunsung
    func getPaginatedVibes(from eventID: String, page: Int, size: Int, sort: [(SortCase, SortPattern)]) async throws -> PaginatedResponse<VibeUIO>
    
    /// 특정 이벤트에 바이브를 등록하는 함수
    ///
    /// - Parameters:
    ///   - eventID: 이벤트 ID
    ///   - rating: 해당 이벤트의 평점
    ///   - comment: 이벤트 관람 후기
    ///   - images: 이벤트 관람 사진 배열
    ///
    /// 특정 이벤트에 바이브를 등록하는 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 등록된 바이브의 UIO
    ///
    /// - Author: 라움
    func uploadVibe(eventID: String, rating: Double, comment: String?, images: [UIImage]) async throws -> VibeUIO
    
    /// 특정 바이브를 삭제하는 함수
    ///
    /// - Parameters:
    ///   - vibeID: 삭제할 바이브 ID
    ///
    /// 이벤트에 등록된 특정 바이브를 삭제하는 함수입니다.
    ///
    /// - Throws: 에러
    ///
    /// - Author: 라움
    func deleteVibe(vibeID: Int) async throws
    
    /// 기존의 바이브를 수정하는 함수
    ///
    /// - Parameters:
    ///   - vibeID: 원본 바이브의 ID
    ///   - rating: 해당 이벤트의 평점
    ///   - comment: 이벤트 관람 후기
    ///   - previousImageURLs: 이전에 등록된 사진의 URL 배열
    ///   - images: 새롭게 등록된 사진의 배열
    ///
    /// 기존에 등록된 바이브를 수정하는 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 수정된 바이브의 UIO
    ///
    /// - Author: 라움
    func modifyVibe(vibeID: Int, rating: Double, comment: String?, previousImageURLs: [String], images: [UIImage]) async throws -> VibeUIO
    
    /// 사용자가 특정 이벤트에 바이브를 올렸는지에 대한 여부를 확인하는 함수
    ///
    /// - Parameters:
    ///   - eventID: 이벤트 ID
    ///
    /// 사용자가 특정 이벤트에 바이브를 올렸는지에 대한 여부를 확인하는 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 등록된 바이브의 ID
    ///
    /// - Author: 라움
    func checkIfUserUploadedVibe(eventID: String) async throws -> Int
    
    /// 바이브 ID를 통해 바이브를 조회하는 함수
    ///
    /// - Parameters:
    ///   - vibeID: 바이브 ID
    ///
    /// 바이브 ID를 통해 바이브를 조회하는 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 바이브 ID에 해당하는 바이브의 UIO
    ///
    /// - Author: 라움
    func getVibeWithVibeID(vibeID: Int) async throws -> VibeUIO
}
