//
//  ListCellView.swift
//  Anxiety Notes
//
//  Created by Filbert Chai on 10/07/24.
//

import SwiftUI

struct ListCellView: View {
    var note: NoteEntity
    
    var body: some View {
        HStack {
            if note.pinned {
                Image(systemName: "pin.fill")
                    .foregroundColor(.orange)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(note.title ?? "New Note")
                    .lineLimit(1)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(note.content ?? "No content available")
                    .lineLimit(1)
                    .fontWeight(.light)
                if let timestamp = note.timestamp {
                    Text("\(timestamp, formatter: dateFormatter)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
//        formatter.timeStyle = .short
        return formatter
    }
}
