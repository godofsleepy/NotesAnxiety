//
//  TextFormatter.swift
//  NotesAnxiety
//
//  Created by Sena Kristiawan on 11/07/24.
//

import SwiftUI

struct TextFormatter: View {
    
    private let editNotesView = EditNotesView()
    
    @Environment(\.presentationMode) var presentationMode
    
//    var  :
    
    var body: some View {
        VStack{
            HStack{
                Text("Format")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.gray)
                        
                }
            }
            ScrollView(.horizontal){
                HStack{
                    Button(action: {
                        editNotesView.titleIsPressed.toggle()
                        editNotesView.headingIsPressed = false
                        editNotesView.subHeadingIsPressed = false
                        editNotesView.bodyIsPressed = false
                        editNotesView.monostyledIsPressed = false
                    }) {
                        Text("Title")
                            .font(.system(size: 28))
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(5)
                            .background(editNotesView.titleIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        editNotesView.headingIsPressed.toggle()
                        editNotesView.titleIsPressed = false
                        editNotesView.subHeadingIsPressed = false
                        editNotesView.bodyIsPressed = false
                        editNotesView.monostyledIsPressed = false
                        
                    }) {
                        Text("Heading")
                            .font(.system(size: 17))
                            .padding(5)
                            .background(editNotesView.headingIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
            
                    Button(action: {
                        editNotesView.subHeadingIsPressed.toggle()
                        editNotesView.titleIsPressed = false
                        editNotesView.headingIsPressed = false
                        editNotesView.bodyIsPressed = false
                        editNotesView.monostyledIsPressed = false
                    }) {
                        Text("Subheading")
                            .font(.system(size: 15))
                            .padding(5)
                            .background(editNotesView.subHeadingIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    
                    Button(action: {
                        editNotesView.bodyIsPressed.toggle()
                        editNotesView.titleIsPressed = false
                        editNotesView.subHeadingIsPressed = false
                        editNotesView.headingIsPressed = false
                        editNotesView.monostyledIsPressed = false
                    }) {
                        Text("Body")
                            .font(.system(size: 17))
                            .padding(5)
                            .background(editNotesView.bodyIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                            .font(.body)
                            .fontWeight(.regular)
                    }
                    
                    Button(action: {
                        editNotesView.monostyledIsPressed.toggle()
                        editNotesView.titleIsPressed = false
                        editNotesView.subHeadingIsPressed = false
                        editNotesView.bodyIsPressed = false
                        editNotesView.headingIsPressed = false
                    }) {
                        Text("Monostyled")
//                             frame(maxHeight:.)
                            .font(Font.system(.body, design: .monospaced))
                            .font(.system(size: 17))
                            .padding(5)
                            .background(editNotesView.monostyledIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                            .fontWeight(.bold)
                    }
                    
                }
            }
            HStack{
                Button(action: {
                    editNotesView.boldIsPressed.toggle()
                    editNotesView.italicIsPressed = false
                    editNotesView.underlineIsPressed = false
                    editNotesView.strikeThroughIsPressed = false
                    
                }) {
                    Text("B")
                        .padding(5)
                        .font(.system(size: 28))
                        .fontWeight(.bold)
                        .background(editNotesView.boldIsPressed ? Color.yellow : Color.gray)
                        .cornerRadius(10)
                }
                Spacer()
                
                Button(action: {
                    editNotesView.italicIsPressed.toggle()
                    editNotesView.boldIsPressed = false
                    editNotesView.underlineIsPressed = false
                    editNotesView.strikeThroughIsPressed = false
                }) {
                    Text("I")
                        .padding(5)
                        .font(.system(size: 28))
                        .italic()
                        .background(editNotesView.italicIsPressed ? Color.yellow : Color.gray)
                        .cornerRadius(10)
                }
                Spacer()
                
                Button(action: {
                    editNotesView.underlineIsPressed.toggle()
                    editNotesView.italicIsPressed = false
                    editNotesView.boldIsPressed = false
                    editNotesView.strikeThroughIsPressed = false
                }) {
                    Text("U")
                        .padding(5)
                        .font(.system(size: 28))
                        .underline()
                        .background(editNotesView.underlineIsPressed ? Color.yellow : Color.gray)
                        .cornerRadius(10)
                }
                Spacer()
                
                Button(action: {
                    editNotesView.strikeThroughIsPressed.toggle()
                    editNotesView.italicIsPressed = false
                    editNotesView.underlineIsPressed = false
                    editNotesView.boldIsPressed = false
                }) {
                    Text("S")
                        .padding(5)
                        .font(.system(size: 28))
                        .strikethrough()
                        .background(editNotesView.strikeThroughIsPressed ? Color.yellow : Color.gray)
                        .cornerRadius(10)
                }
                
            }
            HStack{
                HStack{
                    Button(action: {
                        editNotesView.bulletIsPressed.toggle()
                        editNotesView.listIsPressed = false
                        editNotesView.numberIsPressed = false
                        editNotesView.alignLeftIsPressed = false
                        editNotesView.alignRightIsPressed = false
                    }) {
                        Image(systemName: "list.bullet")
                            .padding(5)
                            .font(.system(size: 28))
                            .strikethrough()
                            .background(editNotesView.bulletIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        editNotesView.listIsPressed.toggle()
                        editNotesView.bulletIsPressed = false
                        editNotesView.numberIsPressed = false
                        editNotesView.alignLeftIsPressed = false
                        editNotesView.alignRightIsPressed = false
                    }) {
                        Image(systemName: "list.dash")
                            .padding(5)
                            .font(.system(size: 28))
                            .strikethrough()
                            .background(editNotesView.listIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        editNotesView.numberIsPressed.toggle()
                        editNotesView.listIsPressed = false
                        editNotesView.bulletIsPressed = false
                        editNotesView.alignLeftIsPressed = false
                        editNotesView.alignRightIsPressed = false
                    }) {
                        Image(systemName: "list.number")
                            .padding(5)
                            .font(.system(size: 28))
                            .strikethrough()
                            .background(editNotesView.numberIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                    }
                }
                Spacer()
                HStack{
                    Button(action: {
                        editNotesView.alignLeftIsPressed.toggle()
                        editNotesView.listIsPressed = false
                        editNotesView.numberIsPressed = false
                        editNotesView.bulletIsPressed = false
                        editNotesView.alignRightIsPressed = false
                    }) {
                        Image(systemName: "text.alignleft")
                            .padding(5)
                            .font(.system(size: 28))
                            .strikethrough()
                            .background(editNotesView.alignLeftIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        editNotesView.alignRightIsPressed.toggle()
                        editNotesView.listIsPressed = false
                        editNotesView.numberIsPressed = false
                        editNotesView.alignLeftIsPressed = false
                        editNotesView.bulletIsPressed = false
                    }) {
                        Image(systemName: "text.alignright")
                            .padding(5)
                            .font(.system(size: 28))
                            .strikethrough()
                            .background(editNotesView.alignRightIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                    }
                }
        
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)

    }

}


//#Preview {
//    TextFormatter()
//}
