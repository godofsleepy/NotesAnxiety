//
//  TextFormatter.swift
//  NotesAnxiety
//
//  Created by Sena Kristiawan on 11/07/24.
//

import SwiftUI

struct TextFormatter: View {
    
    @Environment(\.presentationMode) var presentationMode
    var keyboard: Keyboard
    
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
                        keyboard.titleIsPressed.toggle()
                        keyboard.headingIsPressed = false
                        keyboard.subHeadingIsPressed = false
                        keyboard.bodyIsPressed = false
                        keyboard.monostyledIsPressed = false
                    }) {
                        Text("Title")
                            .font(.system(size: 28))
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(5)
                            .background(keyboard.titleIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        keyboard.headingIsPressed.toggle()
                        keyboard.titleIsPressed = false
                        keyboard.subHeadingIsPressed = false
                        keyboard.bodyIsPressed = false
                        keyboard.monostyledIsPressed = false
                        
                    }) {
                        Text("Heading")
                            .font(.system(size: 17))
                            .padding(5)
                            .background(keyboard.headingIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
            
                    Button(action: {
                        keyboard.subHeadingIsPressed.toggle()
                        keyboard.titleIsPressed = false
                        keyboard.headingIsPressed = false
                        keyboard.bodyIsPressed = false
                        keyboard.monostyledIsPressed = false
                    }) {
                        Text("Subheading")
                            .font(.system(size: 15))
                            .padding(5)
                            .background(keyboard.subHeadingIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    
                    Button(action: {
                        keyboard.bodyIsPressed.toggle()
                        keyboard.titleIsPressed = false
                        keyboard.subHeadingIsPressed = false
                        keyboard.headingIsPressed = false
                        keyboard.monostyledIsPressed = false
                    }) {
                        Text("Body")
                            .font(.system(size: 17))
                            .padding(5)
                            .background(keyboard.bodyIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                            .font(.body)
                            .fontWeight(.regular)
                    }
                    
                    Button(action: {
                        keyboard.monostyledIsPressed.toggle()
                        keyboard.titleIsPressed = false
                        keyboard.subHeadingIsPressed = false
                        keyboard.bodyIsPressed = false
                        keyboard.headingIsPressed = false
                    }) {
                        Text("Monostyled")
//                            .frame(maxHeight:.)
                            .font(Font.system(.body, design: .monospaced))
                            .font(.system(size: 17))
                            .padding(5)
                            .background(keyboard.monostyledIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                            .fontWeight(.bold)
                    }
                    
                }
            }
            HStack{
                Button(action: {
                    keyboard.boldIsPressed.toggle()
                    keyboard.italicIsPressed = false
                    keyboard.underlineIsPressed = false
                    keyboard.strikeThroughIsPressed = false
                }) {
                    Text("B")
                        .padding(5)
                        .font(.system(size: 28))
                        .fontWeight(.bold)
                        .background(keyboard.boldIsPressed ? Color.yellow : Color.gray)
                        .cornerRadius(10)
                }
                Spacer()
                
                Button(action: {
                    keyboard.italicIsPressed.toggle()
                    keyboard.boldIsPressed = false
                    keyboard.underlineIsPressed = false
                    keyboard.strikeThroughIsPressed = false
                }) {
                    Text("I")
                        .padding(5)
                        .font(.system(size: 28))
                        .italic()
                        .background(keyboard.italicIsPressed ? Color.yellow : Color.gray)
                        .cornerRadius(10)
                }
                Spacer()
                
                Button(action: {
                    keyboard.underlineIsPressed.toggle()
                    keyboard.italicIsPressed = false
                    keyboard.boldIsPressed = false
                    keyboard.strikeThroughIsPressed = false
                }) {
                    Text("U")
                        .padding(5)
                        .font(.system(size: 28))
                        .underline()
                        .background(keyboard.underlineIsPressed ? Color.yellow : Color.gray)
                        .cornerRadius(10)
                }
                Spacer()
                
                Button(action: {
                    keyboard.strikeThroughIsPressed.toggle()
                    keyboard.italicIsPressed = false
                    keyboard.underlineIsPressed = false
                    keyboard.boldIsPressed = false
                }) {
                    Text("S")
                        .padding(5)
                        .font(.system(size: 28))
                        .strikethrough()
                        .background(keyboard.strikeThroughIsPressed ? Color.yellow : Color.gray)
                        .cornerRadius(10)
                }
                
            }
            HStack{
                HStack{
                    Button(action: {
                        keyboard.bulletIsPressed.toggle()
                        keyboard.listIsPressed = false
                        keyboard.numberIsPressed = false
                        keyboard.alignLeftIsPressed = false
                        keyboard.alignRightIsPressed = false
                    }) {
                        Image(systemName: "list.bullet")
                            .padding(5)
                            .font(.system(size: 28))
                            .strikethrough()
                            .background(keyboard.bulletIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        keyboard.listIsPressed.toggle()
                        keyboard.bulletIsPressed = false
                        keyboard.numberIsPressed = false
                        keyboard.alignLeftIsPressed = false
                        keyboard.alignRightIsPressed = false
                    }) {
                        Image(systemName: "list.dash")
                            .padding(5)
                            .font(.system(size: 28))
                            .strikethrough()
                            .background(keyboard.listIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        keyboard.numberIsPressed.toggle()
                        keyboard.listIsPressed = false
                        keyboard.bulletIsPressed = false
                        keyboard.alignLeftIsPressed = false
                        keyboard.alignRightIsPressed = false
                    }) {
                        Image(systemName: "list.number")
                            .padding(5)
                            .font(.system(size: 28))
                            .strikethrough()
                            .background(keyboard.numberIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                    }
                }
                Spacer()
                HStack{
                    Button(action: {
                        keyboard.alignLeftIsPressed.toggle()
                        keyboard.listIsPressed = false
                        keyboard.numberIsPressed = false
                        keyboard.bulletIsPressed = false
                        keyboard.alignRightIsPressed = false
                    }) {
                        Image(systemName: "text.alignleft")
                            .padding(5)
                            .font(.system(size: 28))
                            .strikethrough()
                            .background(keyboard.alignLeftIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        keyboard.alignRightIsPressed.toggle()
                        keyboard.listIsPressed = false
                        keyboard.numberIsPressed = false
                        keyboard.alignLeftIsPressed = false
                        keyboard.bulletIsPressed = false
                    }) {
                        Image(systemName: "text.alignright")
                            .padding(5)
                            .font(.system(size: 28))
                            .strikethrough()
                            .background(keyboard.alignRightIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                    }
                }
        
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)

    }
}

#Preview {
    TextFormatter()
}
