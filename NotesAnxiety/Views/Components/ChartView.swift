//
//  ChartView.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 17/07/24.
//

import Foundation
import SwiftUI
import Charts

struct ChartView: View {
    let data: [JournalEntry]
    let period: TimePeriod
    
    var body: some View {
        let filteredData = filterEntries(data, for: period)
        let dateRange = Calendar.current.dateRange(for: period)
        
        VStack {
            Group{
                Text("My Anxiety Record")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .padding(.top)
                Text(formattedDateInterval(interval: dateRange))
                    .font(.callout)
                    .foregroundStyle(.black.opacity(0.5))
                    .padding(.leading)
            }
            .frame(maxWidth:.infinity, alignment: .leading)
        
            Chart(filteredData) { entry in
                PointMark(
                    x: .value("Period", entry.createdAt),
                    y: .value("Average Anxiety", entry.anxietyLevel)
                )
                .foregroundStyle(Color.blue)
                .symbol(Circle())
            }
            .chartXAxis {
                AxisMarks( preset: .extended, position: .bottom, values: getXScaleDomain(for: period)) { value in
                    AxisGridLine()
                        .foregroundStyle(Color.black)
                    AxisTick()
                        .foregroundStyle(Color.black)
                    AxisValueLabel {
                        Text(getFormattedLabel(for: value.as(Date.self)!, period: period))
                    }
                    .foregroundStyle(Color.black)
                }
                
            }
            .chartYAxis {
                AxisMarks(preset: .aligned, position: .leading) { value in
                    AxisGridLine()
                        .foregroundStyle(Color.black)
                    AxisTick()
                        .foregroundStyle(Color.black)
                    AxisValueLabel {
                        Text(AnxietyLevelType.label(for: value.as(Int.self)!))
                    }
                    .foregroundStyle(Color.black)
                }
                
            }
            .chartYScale(domain: [1, 4])
            .padding(.vertical, 8)
            .padding()
            
        }
        .frame(height: 350, alignment: .top)
        .background(.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.15), radius: 5)
        .padding(.top, 10)
        
    }
    
    func filterEntries(_ entries: [JournalEntry], for period: TimePeriod) -> [JournalEntry] {
        let dateRange = Calendar.current.dateRange(for: period)
        return entries.filter { value in
            dateRange.contains(value.createdAt)
        }
    }

    func formattedDateInterval(interval: DateInterval) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            let endDate = formatter.string(from: interval.end)
        
            let startDay = Calendar.current.component(.day, from: interval.start)
            
            return "\(startDay) - \(endDate)"
        }
    
    private func getFormattedLabel(for date: Date, period: TimePeriod) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        
        switch period {
        case .lastWeek:
            formatter.dateFormat = "EEE" // Mon, Tue, etc.
        case .lastMonth:
            formatter.dateFormat = "d" // 7, 14, 21, 28
        case .lastSixMonths:
            formatter.dateFormat = "MMM" // Jul, Jun, etc.
        case .lastYear:
            let month = calendar.component(.month, from: date)
            switch month {
            case 1...3:
                return "Q1"
            case 4...6:
                return "Q2"
            case 7...9:
                return "Q3"
            case 10...12:
                return "Q4"
            default:
                return ""
            }
        }
        
        return formatter.string(from: date)
    }
    
    private func getXScaleDomain(for period: TimePeriod) -> [Date] {
        let calendar = Calendar.current
        let now = Date()
        
        switch period {
        case .lastWeek:
            return (0..<7).compactMap {
                calendar.date(byAdding: .day, value: -$0, to: now)
            }.reversed()
        case .lastMonth:
            return (0..<4).compactMap {
                calendar.date(byAdding: .day, value: -($0 * 7), to: now)
            }.reversed()
        case .lastSixMonths:
            return (0..<6).compactMap {
                calendar.date(byAdding: .month, value: -$0, to: now)
            }.reversed()
        case .lastYear:
            return [1, 2, 3, 4].compactMap {
                calendar.date(from: DateComponents(year: calendar.component(.year, from: now), month: ($0 - 1) * 3 + 1))
            }
        }
    }
}

