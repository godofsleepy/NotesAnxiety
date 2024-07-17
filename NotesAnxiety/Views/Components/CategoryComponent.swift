//
//  CategoryComponent.swift
//  Notessss
//
//  Created by Sena Kristiawan on 17/07/24.
//

import SwiftUI

struct CategoryComponent: View {
    @Binding var value: [String]
    var title: String
    
    var body: some View {
        
        Button(action: {
            let isActive = value.contains(title)
            if isActive {
                removeElement(title, from: &value)
            } else {
                value.append(title)
            }
            print(value)
            
        }, label: {
            Text(title)
                .font(.system(size: 14))
                .padding(EdgeInsets(top: 6, leading: 14, bottom: 6, trailing: 14))
                .foregroundStyle(value.contains(title) ? Color.white : Color.black)
                .background(
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(value.contains(title) ? Color.gray : Color.white)
                        .stroke(Color.gray, lineWidth: 1)
                    
                )
        })
        
    }
    
    
    func removeElement(_ element: String, from array: inout [String]) {
        if let index = array.firstIndex(of: element) {
            array.remove(at: index)
        } else {
            print("Element not found")
        }
    }
}

//#Preview {
//    CategoryComponent(value: .constant(""), title: "test")
//}
