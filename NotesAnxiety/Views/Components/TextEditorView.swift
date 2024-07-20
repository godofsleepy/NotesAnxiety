//
//  TextEditorView.swift
//  Anxiety Notes
//
//  Created by Filbert Chai on 10/07/24.
//

import SwiftUI

struct TextEditorView: View {
    
    @Binding var string: String
    @FocusState var focus: Bool
    @State var textEditorHeight : CGFloat = 20
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            Text(string)
                .foregroundColor(.clear)
                .padding(10)
                .onTapGesture {
                    focus = true
                }
                .background(GeometryReader {
                    Color.clear.preference(key: ViewHeightKey.self,
                                           value: $0.frame(in: .local).size.height)
                })
            
            TextEditor(text: $string)
                .frame(height: max(20,textEditorHeight))
                .focused($focus)
                .border(.clear)
            
            if string.isEmpty {
                Text(NSLocalizedString("How do you feel today?", comment: ""))
                    .font(.title3)
                    .foregroundColor(.gray)
                    .disabled(true)
                    .opacity(0.6)
                    .padding([.top, .leading], 4)
                    .onTapGesture {
                        focus = true
                    }
            }
            
        }.onPreferenceChange(ViewHeightKey.self) { textEditorHeight = $0 }
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
