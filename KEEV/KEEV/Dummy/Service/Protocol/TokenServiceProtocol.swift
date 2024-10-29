//
//  TokenServiceProtocol.swift
//  KEEV
//
//  Created by Doran on 10/29/24.
//

import SwiftUI

protocol TokenServiceProtocol: ObservableObject {
    func save() -> Void
    func load() -> Void
    func delete() -> Void
}
