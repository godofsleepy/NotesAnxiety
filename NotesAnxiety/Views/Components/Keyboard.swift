import SwiftUI

struct Keyboard: View {
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
    
    @State private var notes = "Sena ganteng"
    @State private var textFormatter = false
    
    var body: some View {
        TextEditor(text: $notes)
            .font(.body)
            .background(.white)
            .toolbar{
                ToolbarItemGroup(placement: .keyboard){
                    Button(action:{
                        textFormatter = true
                    }){
                        Image(systemName: "textformat")
                    }
                }
            }
            .sheet(isPresented: $textFormatter){
                TextFormatter(keyboard: Keyboard())
                    .presentationDetents([.height(200)])
            }
            .onChange(of: notes){  newValue in
                
                if titleIsPressed == true{
                    notes = "<b>\(newValue)</b>"
                    //notes = notes.bold
                }
                
            }
        
    }
}

#Preview {
    Keyboard()
}
