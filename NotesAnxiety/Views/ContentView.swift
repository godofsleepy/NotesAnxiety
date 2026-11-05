//
//  ContentView.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 08/07/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(NotesViewModel.self) private var vm

    var body: some View {
        ZStack(alignment: .bottom) {
            SkyBackground(level: vm.skyLevel)
            Group {
                switch vm.tab {
                case .sky: HomeView()
                case .journal: JournalView()
                }
            }
            .safeAreaPadding(.bottom, 64)
            // Keeps scrolled content out from under the status bar.
            .clipped()
            tabBar
                .ignoresSafeArea(.keyboard)
        }
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
        .task { vm.fetchNotes() }
    }

    private var tabBar: some View {
        HStack {
            tabButton(.sky, title: "Sky", systemImage: "cloud.fill")
            tabButton(.journal, title: "Journal", systemImage: "book")
        }
        .padding(.top, 8)
        .padding(.horizontal, 24)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(Color(red: 10 / 255, green: 20 / 255, blue: 35 / 255).opacity(0.35))
                .overlay(alignment: .top) {
                    Rectangle().fill(.white.opacity(0.14)).frame(height: 1)
                }
                .ignoresSafeArea(edges: .bottom)
        }
    }

    private func tabButton(_ tab: AppTab, title: LocalizedStringKey, systemImage: String) -> some View {
        Button {
            vm.tab = tab
        } label: {
            VStack(spacing: 2) {
                Image(systemName: systemImage)
                    .font(.system(size: 22))
                    .frame(height: 26)
                Text(title)
                    .font(.rounded(.caption2))
            }
            .foregroundStyle(.white.opacity(vm.tab == tab ? 1 : 0.6))
            .frame(maxWidth: .infinity, minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(vm.tab == tab ? .isSelected : [])
    }
}

#Preview {
    ContentView()
        .environment(DependencyInjection.shared.notesViewModel())
}
