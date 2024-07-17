//
//  TimePeriod.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 17/07/24.
//

import Foundation

enum TimePeriod: String, CaseIterable {
    case lastWeek = "Week"
    case lastMonth = "Month"
    case lastSixMonths = "6M"
    case lastYear = "Year"
}

extension Calendar {
    func dateRange(for period: TimePeriod) -> DateInterval {
        let endDate = Date()
        var startDate: Date
        
        switch period {
        case .lastWeek:
            startDate = self.date(byAdding: .day, value: -7, to: endDate)!
        case .lastMonth:
            startDate = self.date(byAdding: .month, value: -1, to: endDate)!
        case .lastSixMonths:
            startDate = self.date(byAdding: .month, value: -6, to: endDate)!
        case .lastYear:
            startDate = self.date(byAdding: .year, value: -1, to: endDate)!
        }
        
        return DateInterval(start: startDate, end: endDate)
    }
}
