//
//  Date+Ext.swift
//  UnsplashPics
//
//  Created by 1 on 06.02.2025.
//

import Foundation

extension Date {
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.timeZone = .current
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    static func createDateFormatter() -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        return formatter
    }
    
    static func format(dateString: String) -> String? {
        let isoFormatter = createDateFormatter()
        if let date = isoFormatter.date(from: dateString) {
            return shortDateFormatter.string(from: date)
        }
        return nil
    }
}
