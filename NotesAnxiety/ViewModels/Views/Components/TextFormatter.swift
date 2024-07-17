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
    @Binding var boldIsPressed : Bool
    @Binding var italicIsPressed : Bool
    @Binding var monospaceIsPressed : Bool
    @Binding var strikeIsPressed : Bool
    @Binding var realContent: String
    
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
                            .foregroundColor(.white)
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
                            .foregroundColor(.white)
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
                            .foregroundColor(.white)
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
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        self.monospaceIsPressed.toggle()
                        editNotesView.titleIsPressed = false
                        editNotesView.subHeadingIsPressed = false
                        editNotesView.bodyIsPressed = false
                        editNotesView.headingIsPressed = false
                        formatText(content: editNotesView.content, isBold: self.boldIsPressed, isItalic: self.italicIsPressed, isStrike: self.strikeIsPressed, isMono: monospaceIsPressed)
                    }) {
                        Text("Monostyled")
//                             frame(maxHeight:.)
                            .font(Font.system(.body, design: .monospaced))
                            .font(.system(size: 17))
                            .padding(5)
                            .background(editNotesView.monostyledIsPressed ? Color.yellow : Color.gray)
                            .cornerRadius(10)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                }
            }
            HStack{
                Button(action: {
                    self.boldIsPressed.toggle()
                    editNotesView.italicIsPressed = false
                    editNotesView.underlineIsPressed = false
                    editNotesView.strikeThroughIsPressed = false
                    formatText(content: editNotesView.content, isBold: self.boldIsPressed, isItalic: self.italicIsPressed, isStrike: self.strikeIsPressed, isMono: monospaceIsPressed)
                }) {
                    Text("B")
                        .padding(5)
                        .font(.system(size: 28))
                        .fontWeight(.bold)
                        .background(editNotesView.boldIsPressed ? Color.yellow : Color.gray)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                Spacer()
                
                Button(action: {
                    self.italicIsPressed.toggle()
                    editNotesView.boldIsPressed = false
                    editNotesView.underlineIsPressed = false
                    editNotesView.strikeThroughIsPressed = false
                    formatText(content: editNotesView.content, isBold: self.boldIsPressed, isItalic: self.italicIsPressed, isStrike: self.strikeIsPressed, isMono: self.monospaceIsPressed)
                }) {
                    Text("I")
                        .padding(5)
                        .font(.system(size: 28))
                        .italic()
                        .background(editNotesView.italicIsPressed ? Color.yellow : Color.gray)
                        .cornerRadius(10)
                        .foregroundColor(.white)
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
                        .foregroundColor(.white)
                }
                Spacer()
                
                Button(action: {
                    self.strikeIsPressed.toggle()
                    editNotesView.italicIsPressed = false
                    editNotesView.underlineIsPressed = false
                    editNotesView.boldIsPressed = false
                    formatText(content: editNotesView.content, isBold: self.boldIsPressed, isItalic: self.italicIsPressed, isStrike: self.strikeIsPressed, isMono: monospaceIsPressed)
                }) {
                    Text("S")
                        .padding(5)
                        .font(.system(size: 28))
                        .strikethrough()
                        .background(editNotesView.strikeThroughIsPressed ? Color.yellow : Color.gray)
                        .cornerRadius(10)
                        .foregroundColor(.white)
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
                            .foregroundColor(.white)
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
                            .foregroundColor(.white)
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
                            .foregroundColor(.white)
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
                            .foregroundColor(.white)
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
                            .foregroundColor(.white)
                    }
                }
        
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)

    }
    
    func formatText(content: String, isBold: Bool, isItalic: Bool, isStrike: Bool, isMono: Bool){
        if isBold == true{
                realContent = "**\(realContent)**"
//            return realContent
        }else if isBold == false{
                var updatedContent = realContent
            updatedContent = updatedContent.replacingOccurrences(of: "*", with: "")
                realContent = updatedContent
        }
        if isItalic == true{
                realContent = "_\(realContent)_"
//            return realContent
        }else if isItalic == false{
                var updatedContent = realContent
            updatedContent = updatedContent.replacingOccurrences(of: "_", with: "")
                realContent = updatedContent
        }
        if isStrike == true{
                realContent = "~~\(realContent)~~"
//            return realContent
        }else if isStrike == false{
                var updatedContent = realContent
            updatedContent = updatedContent.replacingOccurrences(of: "~", with: "")
                realContent = updatedContent
        }
        if isMono == true{
                realContent = "`\(realContent)`"
//            return realContent
        }else if isMono == false{
                var updatedContent = realContent
            updatedContent = updatedContent.replacingOccurrences(of: "`", with: "")
                realContent = updatedContent
        }
        
    }

}


//#Preview {
//    TextFormatter()
//}
