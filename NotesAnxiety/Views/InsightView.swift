//
//  InsightView.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 15/07/24.
//

import SwiftUI
import Charts

struct JournalEntry: Codable, Identifiable {
    var id = UUID()
    var title: String
    var content: String
    var attachments: [String] // Array to hold paths or URLs of images, photos, and audio files
    var anxietyLevel: Double
    var categoryAnxiety: [String] // Array to hold multiple categories
    var createdAt: Date
    var editAt: Date?
    
    // Initializer
    init(title: String, content: String, attachments: [String], anxietyLevel: Double, categoryAnxiety: [String], createdAt: Date, editAt: Date? = nil) {
        self.title = title
        self.content = content
        self.attachments = attachments
        self.anxietyLevel = anxietyLevel
        self.categoryAnxiety = categoryAnxiety
        self.createdAt = createdAt
        self.editAt = editAt
    }
}


struct InsightView: View {
    let sampleData: [JournalEntry] = [
        JournalEntry(title: "Entry 1", content: "Content 1", attachments: [], anxietyLevel: 1.1, categoryAnxiety: ["Work"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 4))!),
        JournalEntry(title: "Entry 2", content: "Content 2", attachments: [], anxietyLevel: 2.3, categoryAnxiety: ["Personal"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 5))!),
        JournalEntry(title: "Entry 3", content: "Content 3", attachments: [], anxietyLevel: 3.7, categoryAnxiety: ["Health"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 6))!),
        JournalEntry(title: "Entry 4", content: "Content 4", attachments: [], anxietyLevel: 2.0, categoryAnxiety: ["Finance"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 7))!),
        JournalEntry(title: "Entry 5", content: "Content 5", attachments: [], anxietyLevel: 1.4, categoryAnxiety: ["Social"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 8))!),
        JournalEntry(title: "Entry 6", content: "Content 6", attachments: [], anxietyLevel: 3.1, categoryAnxiety: ["Work"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 9))!),
        JournalEntry(title: "Entry 7", content: "Content 7", attachments: [], anxietyLevel: 2.6, categoryAnxiety: ["Personal"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 10))!),
        JournalEntry(title: "Entry 8", content: "Content 8", attachments: [], anxietyLevel: 3.8, categoryAnxiety: ["Health"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 11))!),
        JournalEntry(title: "Entry 9", content: "Content 9", attachments: [], anxietyLevel: 1.9, categoryAnxiety: ["Finance"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 12))!),
        JournalEntry(title: "Entry 10", content: "Content 10", attachments: [], anxietyLevel: 2.2, categoryAnxiety: ["Social"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 13))!),
        JournalEntry(title: "Entry 11", content: "Content 11", attachments: [], anxietyLevel: 1.5, categoryAnxiety: ["Work"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 14))!),
        JournalEntry(title: "Entry 12", content: "Content 12", attachments: [], anxietyLevel: 3.2, categoryAnxiety: ["Personal"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 15))!),
        JournalEntry(title: "Entry 13", content: "Content 13", attachments: [], anxietyLevel: 4.0, categoryAnxiety: ["Health"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 16))!),
        JournalEntry(title: "Entry 14", content: "Content 14", attachments: [], anxietyLevel: 2.7, categoryAnxiety: ["Finance"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 17))!),
        JournalEntry(title: "Entry 15", content: "Content 15", attachments: [], anxietyLevel: 1.0, categoryAnxiety: ["Social"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 18))!),
        JournalEntry(title: "Entry 16", content: "Content 16", attachments: [], anxietyLevel: 2.8, categoryAnxiety: ["Work"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 19))!),
        JournalEntry(title: "Entry 17", content: "Content 17", attachments: [], anxietyLevel: 1.6, categoryAnxiety: ["Personal"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 20))!),
        JournalEntry(title: "Entry 18", content: "Content 18", attachments: [], anxietyLevel: 3.9, categoryAnxiety: ["Health"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 21))!),
        JournalEntry(title: "Entry 19", content: "Content 19", attachments: [], anxietyLevel: 2.1, categoryAnxiety: ["Finance"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 22))!),
        JournalEntry(title: "Entry 20", content: "Content 20", attachments: [], anxietyLevel: 3.0, categoryAnxiety: ["Social"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 23))!),
        JournalEntry(title: "Entry 21", content: "Content 21", attachments: [], anxietyLevel: 1.2, categoryAnxiety: ["Work"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 24))!),
        JournalEntry(title: "Entry 22", content: "Content 22", attachments: [], anxietyLevel: 2.9, categoryAnxiety: ["Personal"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 25))!),
        JournalEntry(title: "Entry 23", content: "Content 23", attachments: [], anxietyLevel: 3.5, categoryAnxiety: ["Health"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 26))!),
        JournalEntry(title: "Entry 24", content: "Content 24", attachments: [], anxietyLevel: 1.8, categoryAnxiety: ["Finance"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 27))!),
        JournalEntry(title: "Entry 25", content: "Content 25", attachments: [], anxietyLevel: 2.4, categoryAnxiety: ["Social"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 28))!),
        JournalEntry(title: "Entry 26", content: "Content 26", attachments: [], anxietyLevel: 3.4, categoryAnxiety: ["Work"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 29))!),
        JournalEntry(title: "Entry 27", content: "Content 27", attachments: [], anxietyLevel: 1.7, categoryAnxiety: ["Personal"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 1))!),
        JournalEntry(title: "Entry 28", content: "Content 28", attachments: [], anxietyLevel: 2.5, categoryAnxiety: ["Health"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 2))!),
        JournalEntry(title: "Entry 29", content: "Content 29", attachments: [], anxietyLevel: 3.3, categoryAnxiety: ["Finance"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 3))!),
        JournalEntry(title: "Entry 30", content: "Content 30", attachments: [], anxietyLevel: 2.0, categoryAnxiety: ["Social"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 4))!),
        JournalEntry(title: "Entry 31", content: "Content 31", attachments: [], anxietyLevel: 3.6, categoryAnxiety: ["Work"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 5))!),
        JournalEntry(title: "Entry 32", content: "Content 32", attachments: [], anxietyLevel: 1.9, categoryAnxiety: ["Personal"], createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 6))!),
    ]
    
    @State private var selectedPeriod: TimePeriod = .lastWeek
    
    var body: some View {
        ScrollView {
            VStack {
                Picker("Select Period", selection: $selectedPeriod) {
                    ForEach(TimePeriod.allCases, id: \.self) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                
                ChartView(data: sampleData, period: selectedPeriod)
                GeometryReader { geometry in
                    HStack( spacing: 16) {
                        VStack(alignment: .leading) {
                            Text("Your anxiety this week most triggered by:")
                                .font(.headline)
                                .padding(.bottom, 8)
                            
                            VStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("60%")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                    Text("Parents")
                                        .font(.body)
                                }
                                Spacer()
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("30%")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                    Text("Partner")
                                        .font(.body)
                                }
                                Spacer()
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("10%")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                    Text("Others")
                                        .font(.body)
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                        }
                        .padding()
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(8)
                        
                        VStack {
                            VStack(alignment: .leading) {
                                Text("Your total record is")
                                    .font(.headline)
                                Text("10")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Text("for this week")
                                    .font(.body)
                            }
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
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                        }
                        .background(.red)
                        .frame(height: geometry.size.height)
                        .padding(.horizontal)
                    }
                }
                
                .padding()
                Spacer()
            }
            .padding(.horizontal, 10)
        }
        .navigationTitle("My Insight")
    }
}

#Preview {
    InsightView()
}
