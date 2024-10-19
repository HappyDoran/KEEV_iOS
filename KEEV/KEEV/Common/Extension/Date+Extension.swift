//
//  Date+Extension.swift
//  KEEV
//
//  Created by Doran on 10/19/24.
//

import Foundation

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
