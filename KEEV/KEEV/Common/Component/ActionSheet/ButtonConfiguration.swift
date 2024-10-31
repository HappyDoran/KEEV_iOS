//
//  ButtonConfiguration.swift
//  KEEV
//
//  Created by 김준성 on 10/31/24.
//

import SwiftUI

extension KEEVActionSheet {
    protocol ButtonConfiguration: Identifiable {
        var title: String { get }
        var image: Image? { get }
        var color: Color { get }
        var action: () -> Void { get }
    }
}

extension KEEVActionSheet.ButtonConfiguration {
    var id: String { title }
}

extension KEEVActionSheet {
    enum DefaultConfiguration {
        case modify(title: String, action: () -> Void)
        case share(title: String, action: () -> Void)
        case delete(title: String, action: () -> Void)
        case report(title: String, action: () -> Void)
    }
}

extension KEEVActionSheet.DefaultConfiguration: KEEVActionSheet.ButtonConfiguration {
    var title: String {
        switch self {
        case .modify(let title, _): return title
        case .share(let title, _): return title
        case .delete(let title, _): return title
        case .report(let title, _): return title
        }
    }
    
    var image: Image? {
        switch self {
        case .modify: Image(systemName: "pencil.line")
        case .share: Image(systemName: "square.and.arrow.up")
        case .delete: Image(systemName: "trash.fill")
        case .report: Image(systemName: "light.beacon.max.fill")
        }
    }
    
    var color: Color {
        switch self {
        case .modify: fallthrough
        case .share: return .gray300
        case .delete: fallthrough
        case .report: return .red500
        }
    }
    
    var action: () -> Void {
        switch self {
        case .modify(_, let action): return action
        case .share(_, let action): return action
        case .delete(_, let action): return action
        case .report(_, let action): return action
        }
    }
}
