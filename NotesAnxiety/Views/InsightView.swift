//
//  InsightView.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 15/07/24.
//

import SwiftUI

struct InsightView: View {
    @EnvironmentObject var vm: NotesViewModel
    
    @State private var selectedPeriod: TimePeriod = .lastWeek
    
    var body: some View {
        ScrollView {
            VStack {
                Picker(NSLocalizedString("Select Period", comment: ""), selection: $selectedPeriod) {
                    ForEach(TimePeriod.allCases, id: \.self) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                
                ChartView(data: vm.notes, period: selectedPeriod)
                    
                AnalyticsView(period: selectedPeriod)
                    .padding(.top)
                Spacer()
            }
            .padding(.horizontal, 10)
        }
        .background(Color.backgroundPrimary)
        .navigationTitle("My Insight")
    }
}

#Preview {
    InsightView()
}
