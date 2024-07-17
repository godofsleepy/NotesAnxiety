//
//  TextEditorView.swift
//  Anxiety Notes
//
//  Created by Filbert Chai on 10/07/24.
//

import SwiftUI

enum Elements {
    case image
    case text
}
struct TextEditorView: View {
    
    @State var elements: [Elements] = []
    @Binding var string: String
    @State var textEditorHeight : CGFloat = 20
    @Binding var image: UIImage?
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            TextEditor(text: $string)
                .frame(height: max(20,textEditorHeight))
                .border(.clear)
                .foregroundColor(.clear)
                .onTapGesture {
                    elements.append(Elements.text)
                    elements.append(Elements.image)
                }
            
            
            VStack{
                ForEach(elements, id: \.self){ elements in
                    switch elements{
                    case .image:
                        if image != nil{
                            Image(uiImage: image!)
                                .resizable()
                                .scaledToFit()
                        }
                        
                    case .text:
                        Text(.init(string))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(GeometryReader {
                                Color.clear.preference(key: ViewHeightKey.self,
                                                       value: $0.frame(in: .local).size.height)
                            })
                            .offset(x: -10.0)
                    }
                }
                
                
            }
            if string.isEmpty {
                
                Text("Content")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .disabled(true)
                    .opacity(0.6)
                    .padding([.top, .leading], 4)
            }
            
        }.onPreferenceChange(ViewHeightKey.self) { textEditorHeight = $0 }
            .onAppear{
                if string.description.last == "\n"{
                    elements.append(Elements.text)
                }
                if let image = image {
                    elements.append(Elements.image)
                }
            }
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
