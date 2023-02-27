//
//  PickerView.swift
//  Color Picker
//
//  Displays the current working color, and allows changes to be made through the modification of several different values
//
//  Created by Nuah on 2/17/23.
//

import SwiftUI

struct PickerView: View {
    @EnvironmentObject var viewmodel: PickerViewModel
    @FocusState var focus: String?
    
    let pasteboard = NSPasteboard.general
    
    @State var tempColor = Color.white
    @State var showModal = false
    
    @State var hexText: String = ""
    
    @State var redText: String = ""
    @State var greenText: String = ""
    @State var blueText: String = ""
    @State var opacityText: String = ""
    
    @State var hueText: String = ""
    @State var satText: String = ""
    @State var litText: String = ""
    
    func updateTextFields() {
            if focus != "hex" {
                hexText = viewmodel.selectedColorEntry.hexString

            }
            
            if focus != "red" && focus != "blue" && focus != "green" && focus != "opacity" {
                redText = String(viewmodel.selectedColorEntry.rgba[0])
                greenText = String(viewmodel.selectedColorEntry.rgba[1])
                blueText = String(viewmodel.selectedColorEntry.rgba[2])
                opacityText = String(viewmodel.selectedColorEntry.rgba[3])
            }
        
            if focus != "hue" && focus != "saturation" && focus != "lightness" {
                hueText = String(viewmodel.selectedColorEntry.hsl[0])
                satText = String(viewmodel.selectedColorEntry.hsl[1])
                litText = String(viewmodel.selectedColorEntry.hsl[2])
            }
    }

    
    var body: some View {
        VStack {
            Text("Color Picker")
                .font(.system(size: 50))
                .bold()
                .underline()
            RoundedRectangle(cornerRadius: 20)
                .fill(viewmodel.selectedColor)
                .frame(width: 250, height: 250)
            ColorPicker(selection: $tempColor, label: {
                Text("Select a Color:")
                    .font(.title)
            })
            .onChange(of: tempColor) { newColor in
                if let colorValues = newColor.convertToValues() {
                    viewmodel.selectedColorEntry.rgba = colorValues.rgba
                    
                    updateTextFields()

                }
                
            }
            HStack (spacing: 1) {
                Text("HEX: #")
                ColorInputView(focus: _focus, boxText: $hexText, placeholder: "FFFFFF", mode: "hex", focusText: "hex", updateTextFields: self.updateTextFields)
            }
            HStack (spacing: 1) {
                Text("RGBA: ( ")
                ColorInputView(focus: _focus, boxText: $redText, placeholder: "0", mode: "rgba", focusText: "red", updateTextFields: self.updateTextFields)
                Text(", ")
                ColorInputView(focus: _focus, boxText: $greenText, placeholder: "0", mode: "rgba", focusText: "green", updateTextFields: self.updateTextFields)
                Text(", ")
                ColorInputView(focus: _focus, boxText: $blueText, placeholder: "0", mode: "rgba", focusText: "blue", updateTextFields: self.updateTextFields)
                Text(", ")
                ColorInputView(focus: _focus, boxText: $opacityText, placeholder: "0", mode: "rgba", focusText: "opacity", updateTextFields: self.updateTextFields)
                Text(" )")
            }
            HStack (spacing: 1) {
                Text("HSL: ( ")
                ColorInputView(focus: _focus, boxText: $hueText, placeholder: "0°", mode: "hsl", focusText: "hue", updateTextFields: self.updateTextFields)
                Text("°, ")
                ColorInputView(focus: _focus, boxText: $satText, placeholder: "0%", mode: "hsl", focusText: "saturation", updateTextFields: self.updateTextFields)
                Text("%, ")
                ColorInputView(focus: _focus, boxText: $litText, placeholder: "0%", mode: "hsl", focusText: "lightness", updateTextFields: self.updateTextFields)
                Text(" )")

            }
            
            HStack {
                Button {
                    showModal = true
                } label: {
                    Text("Add")
                }
                
                Menu {
                    Button {
                        pasteboard.clearContents()
                        pasteboard.setString("#\(viewmodel.selectedColorEntry.hexString)", forType: .string)
                        
                    } label: {
                        Text("Copy HEX Value")
                    }
                    
                    Button {
                        pasteboard.clearContents()
                        pasteboard.setString("rgba(\(viewmodel.selectedColorEntry.rgba[0]), \(viewmodel.selectedColorEntry.rgba[1]), \(viewmodel.selectedColorEntry.rgba[2]), \(viewmodel.selectedColorEntry.rgba[3]))", forType: .string)
                        
                    } label: {
                        Text("Copy RGBA Value")
                    }
                    
                    Button {
                        pasteboard.clearContents()
                        pasteboard.setString("hsl(\(viewmodel.selectedColorEntry.hsl[0]), \(viewmodel.selectedColorEntry.hsl[1]), \(viewmodel.selectedColorEntry.hsl[2]))", forType: .string)
                        
                    } label: {
                        Text("Copy HSL Value")
                    }
                    
                    Button {
                        pasteboard.clearContents()
                        pasteboard.setString("Color(red: \(viewmodel.selectedColorEntry.rgba[0])/255, green:\(viewmodel.selectedColorEntry.rgba[1])/255, blue: \(viewmodel.selectedColorEntry.rgba[2])/255, opacity: \(viewmodel.selectedColorEntry.rgba[3])/255)", forType: .string)
                        
                    } label: {
                        Text("Copy Swift Format")
                    }
                    
                } label: {
                    Image(systemName: "doc.on.doc.fill")
                }
                .menuStyle(BorderlessButtonMenuStyle())
                .menuIndicator(.hidden)
                .fixedSize()
            }
            
        }
        .contentShape(Rectangle())
        .onTapGesture {
            focus = nil
        }
        .sheet(isPresented: $showModal, content: {
            AddColorView()
                .environmentObject(viewmodel)
        })
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView().environmentObject(PickerViewModel())
    }
}
