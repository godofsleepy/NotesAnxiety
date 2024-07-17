//
//  AnalyticsView.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 17/07/24.
//

import SwiftUI

struct AnalyticsView: View {
    let data: [NoteEntity]
    let period: TimePeriod
    
    var body: some View {
        let top3CategoriesWithPercentages = getTop3CategoryAnxiety(from: data)
        
        HStack( spacing: 16) {
            VStack(alignment: .leading) {
                Text("Your anxiety this week most triggered by:")
                    .font(.headline)
                    .padding(.bottom, 8)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(nil)
                
                ForEach(top3CategoriesWithPercentages, id: \.category){ v in
                    HStack(spacing: 8) {
                        Text("\(v.percentage)%")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(v.category)
                            .font(.body)
                    }
                }

                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemGray5))
            .cornerRadius(8)
            
            VStack {
                VStack(alignment: .leading) {
                    Text("Your total record is")
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.headline)
                    Text("10")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("for this \(period.rawValue)")
                        .font(.body)
                }
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                
                Spacer()
                
                
                VStack(alignment: .leading) {
                    Text("Last check in")
                        .font(.headline)
                    Text("1")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("day ago")
                        .font(.body)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                
            }
        }
    }
    func getTop3CategoryAnxiety(from entries: [NoteEntity]) -> [(category: String, percentage: Int)] {
        // Create a dictionary to count occurrences of each category
        var categoryCount: [String: Int] = [:]
        
        // Count occurrences of each category
        for entry in entries {
            let categoryAnxiety = entry.categoryAnxiety!.split(separator: ",")
            for category in categoryAnxiety {
                categoryCount[String(category), default: 0] += 1
            }
        }
        
        // Calculate the total number of category occurrences
        let totalCount = categoryCount.values.reduce(0, +)
        
        // Sort the categories by their count in descending order
        let sortedCategories = categoryCount.sorted { $0.value > $1.value }
        
        // Get the top 3 categories with their percentages rounded to two decimal places
        let top3Categories = sortedCategories.prefix(3).map { (category, count) in
            (category: category, percentage: Int(((Double(count) / Double(totalCount)) * 100)))
        }
        
        return top3Categories
    }

    
}

//#Preview {
//    AnalyticsView()
//}
