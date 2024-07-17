//
//  InsightView.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 15/07/24.
//

import SwiftUI
import Charts

struct InsightView: View {
    @State private var favoriteColor = 0
    var dataPoints = [
        DataPointModel(value: 1, label: "Jan"),
        DataPointModel(value: 3, label: "Feb"),
        DataPointModel(value: 2, label: "Mar"),
        DataPointModel(value: 4, label: "Apr"),
        DataPointModel(value: 6, label: "May"),
        DataPointModel(value: 5, label: "Jun")
    ]
    
    var body: some View {
        VStack {
            Picker("What is your favorite color?",
                   selection: $favoriteColor
            ) {
                Text("Week").tag(0)
                Text("Month").tag(1)
                Text("6M").tag(2)
                Text("Year").tag(2)
            }
                   .pickerStyle(.segmented)
            Chart(dataPoints) { dataPoint in
                PointMark(
                    x: .value("Label", dataPoint.label),
                    y: .value("Value", dataPoint.value)
                )
                .foregroundStyle(Color.red)
                .symbol(Circle())
            }
            .chartYScale(domain: 0...10)             .padding()
            .frame(height: 300, alignment: .top)
            Spacer()
        }
        
        .padding(.horizontal, 10)
        .navigationTitle("My Insight")
    }
}

#Preview {
    InsightView()
}
