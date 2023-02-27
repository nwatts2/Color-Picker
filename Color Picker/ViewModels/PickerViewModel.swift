//
//  PickerViewModel.swift
//  Color Picker
//
//  This file holds the primary View Model for the app
//
//  Created by Nuah on 2/17/23.
//

import Foundation
import SwiftUI

// Primary View Model, determines what the front end of the app has access to in the Picker model
class PickerViewModel: ObservableObject {
    // Initializes Picker model
    @ObservedObject var picker = Picker()
    
    @Published var selectedColorEntry: ColorEntry = ColorEntry(id: 0, name: "Selected Color", rgba: [255, 255, 255, 255])
    var selectedColor: Color {
        return Color(red: CGFloat(selectedColorEntry.rgba[0]) / 255.0, green: CGFloat(selectedColorEntry.rgba[1]) / 255.0, blue: CGFloat(selectedColorEntry.rgba[2]) / 255.0, opacity: CGFloat(selectedColorEntry.rgba[3]) / 255.0)
    }
    
    @Published var selectedPalette: Palette = Palette(id: 0, name: "", entries: [])
            
    var palettes: [Palette] {
        return picker.palettes
    }
    
    // Calls addPalette method from model
    func addPalette (name: String, entries: [ColorEntry]) {
        picker.addPalette(name: name, entries: entries)
        self.updateView()
    }
    
    // Calls renamePalette method from model
    func renamePalette (name: String, palette: Palette) {
        picker.renamePalette(name: name, palette: palette)
        self.updateView()
    }
    
    // Calls removePalette method from model after identifying correct palette to remove
    func deletePalette (palette: Palette) {
        for index in 0..<picker.palettes.count {
            if picker.palettes[index] == palette {
                picker.removePalette(id: index)
                self.updateView()
                return
            }
        }
        
        print("Error deleting \(palette.name) palette")
    }
    
    // Locates correct palette in palettes array and calls addColor method on that palette
    func addColor (name: String, palette: Palette) {
        if let colorValues = selectedColor.convertToValues() {

            for index in 0..<picker.palettes.count {
                if picker.palettes[index].id == palette.id {
                    print(selectedColor)
                    picker.palettes[index].addColor(name: name, rgba: colorValues.rgba)
                    self.updateView()
                    return
                }
            }
        }
        
        
        print("Error adding color to \(palette.name) palette")
    }
    
    // Locates correct palette in palettes array, locates correct color within that palette, and calls renameColor on that color
    func renameColor (name: String, color: ColorEntry, palette: Palette) {
        for paletteIndex in 0..<picker.palettes.count {
            if paletteIndex == palette.id {
                for index in 0..<picker.palettes[paletteIndex].entries.count {
                    if index == color.id {
                        picker.palettes[paletteIndex].renameColor(name: name, id: index)
                        self.updateView()
                        return
                    }
                }
            }
        }
        
        print("Error renaming color from \(palette.name) palette")
        
    }
    
    // Locates correct palette in palettes array, locates correct color within that palette, and calls removeColor on that color
    func deleteColor (color: ColorEntry, palette: Palette) {
        for index in 0..<picker.palettes.count {
            if picker.palettes[index] == palette {
                for colorIndex in 0..<picker.palettes[index].entries.count {
                    if picker.palettes[index].entries[colorIndex] == color {
                        picker.palettes[index].removeColor(id: colorIndex)
                        self.updateView()
                        return
                    }
                }
            }
        }
        
        print("Error deleting color from \(palette.name) palette")
    }
    
    // Modifies selectedColor's color based on a provided HEX value
    func convertHexColor (hex: String) {
        let color = Color.convertHexToColor(hexString: hex)
        
        if let colorValues = color.convertToValues() {
            selectedColorEntry.rgba = colorValues.rgba
        }
        self.updateView()
    }
    
    // Modifies selectedColor's color based on a provided HSL value
    func convertHSLColor (hsl: [Int]) {
        let color = Color.convertHSLToColor(hsl: hsl)
        
        if let colorValues = color.convertToValues() {
            selectedColorEntry.rgba = colorValues.rgba
        }
        
        self.updateView()
    }
    
    // Modifies selectedColor's color based on a provided RGBA value
    func convertRGBAColor (rgba: [Int]) {
        selectedColorEntry.rgba = rgba
        self.updateView()
    }
    
    // Updates the main view
    func updateView() {
        picker.save()
        self.objectWillChange.send()
    }
    
}
