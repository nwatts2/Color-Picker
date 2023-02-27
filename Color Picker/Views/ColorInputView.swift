//
//  ColorInputView.swift
//  Color Picker
//
//  Contains a template for the textFields used to modify the working color in the PickerView view
//
//  Created by Nuah on 2/23/23.
//

import SwiftUI

struct ColorInputView: View {
    @EnvironmentObject var viewmodel: PickerViewModel
    
    @FocusState var focus: String?
    
    @Binding var boxText: String
    var placeholder: String
    var mode: String
    var focusText: String
    
    var updateTextFields: () -> Void
    
    func filterText() {
        var newValue = ""
        var convertedInt = 0

        if mode == "hex" {
            for char in boxText.uppercased() {
                switch char {
                    case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F":
                        if newValue.count < 8 {
                            newValue += String(char)
                        }
                    
                    default:
                        continue
                }
            }
            
            boxText = newValue
            viewmodel.convertHexColor(hex: boxText)
            
        } else if mode == "rgba" {
            
            if let filtered = Int(boxText) {
                convertedInt = filtered
                
                if filtered >= 0 && filtered <= 255 {
                    newValue = String(filtered)
                } else {
                    newValue = ""
                }
            } else {
                newValue = ""
            }
            
            boxText = newValue
            
            var newArray = viewmodel.selectedColorEntry.rgba
            
            switch focusText {
                case "red":
                    newArray[0] = convertedInt
                case "green":
                    newArray[1] = convertedInt
                case "blue":
                    newArray[2] = convertedInt
                case "opacity":
                    newArray[3] = convertedInt
                default:
                    break
            }
            
            viewmodel.convertRGBAColor(rgba: newArray)
            
        } else if mode == "hsl" {
            
            if let filtered = Int(boxText) {
                convertedInt = filtered

                if filtered >= 0 && filtered < 360 {
                    newValue = String(filtered)
                } else {
                    newValue = ""
                }
            } else {
                newValue = ""
            }
            
            boxText = newValue
            
            var newArray = viewmodel.selectedColorEntry.hsl
            
            switch focusText {
                case "hue":
                    newArray[0] = convertedInt
                case "saturation":
                    newArray[1] = convertedInt
                case "lightness":
                    newArray[2] = convertedInt
                default:
                    break
            }
            
            viewmodel.convertHSLColor(hsl: newArray)
        }
    
        self.updateTextFields()
    }

    var body: some View {
        TextField("\(placeholder)", text: $boxText, onEditingChanged: { (editingChanged) in
            if !editingChanged {
                filterText()
            }
        })
            .frame(width: mode == "hex" ? 70 : 40)
            .multilineTextAlignment(.trailing)
            .focused($focus, equals: focusText)
            .onAppear {
                if mode == "hex" {
                    boxText = viewmodel.selectedColorEntry.hexString

                } else if mode == "rgba" {
                    var index = 0
                    
                    switch focusText {
                        case "red":
                            index = 0
                        case "green":
                            index = 1
                        case "blue":
                            index = 2
                        case "opacity":
                            index = 3
                        default:
                            break
                    }
                    
                    boxText = String(viewmodel.selectedColorEntry.rgba[index])
                    
                } else if mode == "hsl" {
                    var index = 0
                    
                    switch focusText {
                        case "hue":
                            index = 0
                        case "saturation":
                            index = 1
                        case "lightness":
                            index = 2
                        default:
                            break
                    }
                    
                    boxText = String(viewmodel.selectedColorEntry.hsl[index])
                }
                
            }
            .onSubmit {
                filterText()
            }
    }
}
