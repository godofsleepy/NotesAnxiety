//
//  ListCellView.swift
//  Anxiety Notes
//
//  Created by Filbert Chai on 10/07/24.
//

import SwiftUI

struct ListCellView: View {
    var note: NoteModel
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 5) {
                HStack{
                    if note.anxiety != nil {
                        Image(systemName: note.anxiety!.type.icon!)
                            .font(.title3)
                            .foregroundColor(note.anxiety!.type.color)
                            .frame(alignment: .top)
                            
                    }
                    Text(note.title ?? "New Note")
                        .lineLimit(1)
                        .font(.title3)
                        .fontWeight(.bold)

                }
                
                Text(note.content ?? "No content available")
                    .lineLimit(1)
                    .fontWeight(.light)
                
                Text("\(note.createdAt, formatter: dateFormatter)")
                    .font(.footnote)
                    .foregroundColor(.gray)
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
