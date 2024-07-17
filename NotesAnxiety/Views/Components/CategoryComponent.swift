//
//  CategoryComponent.swift
//  Notessss
//
//  Created by Sena Kristiawan on 17/07/24.
//

import SwiftUI

struct CategoryComponent: View {
    var title: String
    var body: some View {
        Button(action: {}, label: {
            Text(title)
                .font(.system(size: 14))
                .padding(EdgeInsets(top: 6, leading: 14, bottom: 6, trailing: 14))
                .foregroundStyle(Color.black)
                .background(
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(Color.white)
                        .stroke(Color.gray, lineWidth: 1)
                    )
        })

    }
}

#Preview {
    CategoryComponent(title: "test")
}
