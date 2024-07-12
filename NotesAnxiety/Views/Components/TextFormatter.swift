//
//  TextFormatter.swift
//  NotesAnxiety
//
//  Created by Sena Kristiawan on 11/07/24.
//

import SwiftUI

struct TextFormatter: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State public var titleIsPressed = false
    @State public var headingIsPressed = false
    @State public var subHeadingIsPressed = false
    @State public var bodyIsPressed = false
    @State public var monostyledIsPressed = false
    
    @State public var boldIsPressed = false
    @State public var italicIsPressed = false
    @State public var underlineIsPressed = false
    @State public var strikeThroughIsPressed = false
    
    @State public var bulletIsPressed = false
    @State public var listIsPressed = false
    @State public var numberIsPressed = false
    @State public var alignLeftIsPressed = false
    @State public var alignRightIsPressed = false
    
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
                        titleIsPressed.toggle()
                        headingIsPressed = false
                        subHeadingIsPressed = false
                        bodyIsPressed = false
                        monostyledIsPressed = false
                    }) {
                        Text("Title")
                            .font(.system(size: 28))
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(5)
                            .background(titleIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        headingIsPressed.toggle()
                        titleIsPressed = false
                        subHeadingIsPressed = false
                        bodyIsPressed = false
                        monostyledIsPressed = false
                        
                    }) {
                        Text("Heading")
                            .font(.system(size: 17))
                            .padding(5)
                            .background(headingIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
            
                    Button(action: {
                        subHeadingIsPressed.toggle()
                          titleIsPressed = false
                          headingIsPressed = false
                          bodyIsPressed = false
                          monostyledIsPressed = false
                    }) {
                        Text("Subheading")
                            .font(.system(size: 15))
                            .padding(5)
                            .background(  subHeadingIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    
                    Button(action: {
                          bodyIsPressed.toggle()
                          titleIsPressed = false
                          subHeadingIsPressed = false
                          headingIsPressed = false
                          monostyledIsPressed = false
                    }) {
                        Text("Body")
                            .font(.system(size: 17))
                            .padding(5)
                            .background(  bodyIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                            .font(.body)
                            .fontWeight(.regular)
                    }
                    
                    Button(action: {
                        monostyledIsPressed.toggle()
                          titleIsPressed = false
                          subHeadingIsPressed = false
                          bodyIsPressed = false
                          headingIsPressed = false
                    }) {
                        Text("Monostyled")
//                             frame(maxHeight:.)
                            .font(Font.system(.body, design: .monospaced))
                            .font(.system(size: 17))
                            .padding(5)
                            .background(  monostyledIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                            .fontWeight(.bold)
                    }
                    
                }
            }
            HStack{
                Button(action: {
                    boldIsPressed.toggle()
                      italicIsPressed = false
                      underlineIsPressed = false
                      strikeThroughIsPressed = false
                }) {
                    Text("B")
                        .padding(5)
                        .font(.system(size: 28))
                        .fontWeight(.bold)
                        .background(  boldIsPressed ? Color.yellow : Color.gray)
                        .cornerRadius(10)
                }
                Spacer()
                
                Button(action: {
                      italicIsPressed.toggle()
                      boldIsPressed = false
                      underlineIsPressed = false
                      strikeThroughIsPressed = false
                }) {
                    Text("I")
                        .padding(5)
                        .font(.system(size: 28))
                        .italic()
                        .background(  italicIsPressed ? Color.yellow : Color.gray)
                        .cornerRadius(10)
                }
                Spacer()
                
                Button(action: {
                      underlineIsPressed.toggle()
                      italicIsPressed = false
                      boldIsPressed = false
                      strikeThroughIsPressed = false
                }) {
                    Text("U")
                        .padding(5)
                        .font(.system(size: 28))
                        .underline()
                        .background(  underlineIsPressed ? Color.yellow : Color.gray)
                        .cornerRadius(10)
                }
                Spacer()
                
                Button(action: {
                      strikeThroughIsPressed.toggle()
                      italicIsPressed = false
                      underlineIsPressed = false
                      boldIsPressed = false
                }) {
                    Text("S")
                        .padding(5)
                        .font(.system(size: 28))
                        .strikethrough()
                        .background(  strikeThroughIsPressed ? Color.yellow : Color.gray)
                        .cornerRadius(10)
                }
                
            }
            HStack{
                HStack{
                    Button(action: {
                          bulletIsPressed.toggle()
                          listIsPressed = false
                          numberIsPressed = false
                          alignLeftIsPressed = false
                          alignRightIsPressed = false
                    }) {
                        Image(systemName: "list.bullet")
                            .padding(5)
                            .font(.system(size: 28))
                            .strikethrough()
                            .background(  bulletIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                    }
                    Button(action: {
                          listIsPressed.toggle()
                          bulletIsPressed = false
                          numberIsPressed = false
                          alignLeftIsPressed = false
                          alignRightIsPressed = false
                    }) {
                        Image(systemName: "list.dash")
                            .padding(5)
                            .font(.system(size: 28))
                            .strikethrough()
                            .background(  listIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        numberIsPressed.toggle()
                          listIsPressed = false
                          bulletIsPressed = false
                          alignLeftIsPressed = false
                          alignRightIsPressed = false
                    }) {
                        Image(systemName: "list.number")
                            .padding(5)
                            .font(.system(size: 28))
                            .strikethrough()
                            .background(  numberIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                    }
                }
                Spacer()
                HStack{
                    Button(action: {
                          alignLeftIsPressed.toggle()
                          listIsPressed = false
                          numberIsPressed = false
                          bulletIsPressed = false
                          alignRightIsPressed = false
                    }) {
                        Image(systemName: "text.alignleft")
                            .padding(5)
                            .font(.system(size: 28))
                            .strikethrough()
                            .background(  alignLeftIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                    }
                    Button(action: {
                          alignRightIsPressed.toggle()
                          listIsPressed = false
                          numberIsPressed = false
                          alignLeftIsPressed = false
                          bulletIsPressed = false
                    }) {
                        Image(systemName: "text.alignright")
                            .padding(5)
                            .font(.system(size: 28))
                            .strikethrough()
                            .background(  alignRightIsPressed ? Color.yellow : Color.gray)
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
