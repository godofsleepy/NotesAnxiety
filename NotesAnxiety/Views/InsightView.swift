//
//  InsightView.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 15/07/24.
//

import SwiftUI
import Charts

struct InsightView: View {
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
            Chart(dataPoints) { dataPoint in
                PointMark(
                    x: .value("Label", dataPoint.label),
                    y: .value("Value", dataPoint.value)
                )
                .foregroundStyle(Color.red)
                .symbol(Circle())
            }
            .chartYScale(domain: 0...10) // Adjust this as per your data range
            .padding()
            .frame(height: 300, alignment: .top)
        }
        .navigationTitle("My Insight")
    }
}

#Preview {
    InsightView()
}
