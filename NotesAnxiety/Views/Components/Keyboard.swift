import SwiftUI

struct Keyboard: View {
    @State private var notes = "Sena ganteng"
    @State private var textFormatter = false
    var txtF : TextFormatter
    
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
                
                    Button(action: {
                        
                    }){
                        
                    }
                }
            }
            .sheet(isPresented: $textFormatter){
                TextFormatter()
                    .presentationDetents([.height(200)])
            }
            .onChange(of: notes){  newValue in
                
                if txtF.boldIsPressed == true{
                    notes = "<b>\(newValue)</b>"
                    //notes = notes.bold
                }
                
            }
    }
}

#Preview {
    Keyboard(txtF: TextFormatter())
}
