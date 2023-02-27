//
//  Picker.swift
//  Color Picker
//
//  This file holds the primary model for the app, along with child structures and their functions
//
//  Created by Nuah on 2/17/23.
//

import Foundation
import SwiftUI

// Primary model, holds main array containing all color/palette data
class Picker: ObservableObject {
    @Published var palettes: [Palette] = []
    
    // Calls load function and initializes palettes array to its return value
    init() {
        self.palettes = load()
    }
    
    // Creates a new palette and appends to palettes array
    func addPalette(name: String, entries: [ColorEntry]) {
        palettes.append(Palette(id: palettes.count, name: name, entries: entries))
    }
    
    // Renames an existing palette in palettes array
    func renamePalette(name: String, palette: Palette) {
        for index in 0..<palettes.count {
            if index == palette.id {
                palettes[index].rename(name: name)
                break
            }
        }
    }
    
    // Removes an existing palette in palettes array
    func removePalette(id: Int) {
        palettes.remove(at: id)
        
        for index in id..<palettes.count {
            palettes[index].id = index
        }
    }
    
    // Converts palettes array to JSON and saves to a JSON file in Library/Containers/Color Picker/Data/Documents/
    func save() {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("paletteData.json")
            
            try JSONEncoder()
                .encode(palettes)
                .write(to: fileURL)
            
        } catch {
            print("Error saving data")
        }
    }
    
    // Loads JSON file and returns loaded data
    func load() -> [Palette] {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("paletteData.json")
            
            let data = try Data(contentsOf: fileURL)
            let paletteData = try JSONDecoder().decode([Palette].self, from: data)
            
            return paletteData
            
        } catch {
            print("Error loading data")
            
            return []
        }
    }
}

// Structure defining a Palette, holds an array of ColorEntry objects
struct Palette: Identifiable, Equatable, Codable {
    fileprivate(set) var id: Int
    fileprivate(set) var name: String
    fileprivate(set) var entries: [ColorEntry]
    
    init(id: Int, name: String, entries: [ColorEntry]) {
        self.id = id
        self.name = name
        self.entries = entries
    }
    
    // Adds a color to this palette
    mutating func addColor (name: String, rgba: [Int]) {
        self.entries.append(ColorEntry(id: self.entries.count, name: name, rgba: rgba))
    }
    
    // Renames this palette
    mutating func rename (name: String) {
        self.name = name
    }
    
    // Renames a color in this palette
    mutating func renameColor (name: String, id: Int) {
        self.entries[id].name = name
    }
    
    // Removes a color from this palette
    mutating func removeColor (id: Int) {
        self.entries.remove(at: id)
        
        for index in id..<entries.count {
            entries[index].id = index
        }
    }
    
    // Static function defining expected behavior for equating Palette objects
    static func == (lhs: Palette, rhs: Palette) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.entries == rhs.entries
    }
}

// Structure defining a ColorEntry
struct ColorEntry: Identifiable, Equatable, Codable {
    fileprivate(set) var id: Int
    fileprivate(set) var name: String
    private(set) var hex: Int
    private(set) var hsl: [Int]
    
    // Primary value determining ColorEntry's color (could not use SwiftUI Color as it is not Codable)
    var rgba: [Int] {
        
        // Updates HSL and HEX values whenever a change is made to RGBA
        didSet {
            let color = Color(red: CGFloat(self.rgba[0]) / 255.0, green: CGFloat(self.rgba[1]) / 255.0, blue: CGFloat(self.rgba[2]) / 255.0, opacity: CGFloat(self.rgba[3]) / 255.0)

            if let colorValues = color.convertToValues() {
                self.hex = colorValues.hex
                self.hsl = colorValues.hsl
            } else {
                if let convertedHex = Int("FFFFFF", radix: 16) {
                    self.hex = convertedHex
                }
                
                self.rgba = [255, 255, 255, 255]
                self.hsl = [0, 0, 100]
            }
        }
    }
    
    // Calculates string equivalent to Integer hex value
    var hexString: String {
        return String(hex, radix: 16).uppercased()
    }
        
    init(id: Int, name: String, rgba: [Int]) {
        self.id = id
        self.name = name
        self.rgba = rgba
        
        let color = Color(red: CGFloat(rgba[0]) / 255.0, green: CGFloat(rgba[1]) / 255.0, blue: CGFloat(rgba[2]) / 255.0, opacity: CGFloat(rgba[3]) / 255.0)
        
        if let colorValues = color.convertToValues() {
            self.hex = colorValues.hex
            self.hsl = colorValues.hsl
        } else {
            if let convertedHex = Int("FFFFFF", radix: 16) {
                self.hex = convertedHex
            } else {
                self.hex = 0
            }
            
            self.rgba = [255, 255, 255, 255]
            self.hsl = [0, 0, 100]
        }
        
    }
    
    // Static function defining expected behavior for equating ColorEntry objects
    static func == (lhs: ColorEntry, rhs: ColorEntry) -> Bool {
        return lhs.name == rhs.name && lhs.hex == rhs.hex
    }
}

// Extends Color to add several quality of life functions for converting between color values
extension Color {
    
    // Converts current Swift UI color to HEX, HSL, and RGBA values, then returns them in a tuple
    func convertToValues() -> (hex: Int, rgba: [Int], hsl: [Int])? {
        var colorData = (hex: 0, rgba: [255, 255, 255, 255], hsl: [0, 0, 100])
        
        guard let cgColor = self.cgColor else {
            print("bad cgcolor")
            return nil
        }
        
        guard let components = cgColor.components else {
            print("bad components")
            return nil
        }
        
        var R: Float = 0.0
        var G: Float = 0.0
        var B: Float = 0.0
        var A: Float = Float(1.0)
        
        if components.count >= 3 {
            R = Float(components[0])
            G = Float(components[1])
            B = Float(components[2])
            
        } else if components.count >= 2 {
            R = Float(components[0])
            G = Float(components[0])
            B = Float(components[0])
            A = Float(components[1])
        }
                
        let r = lroundf(255 * R)
        let g = lroundf(255 * G)
        let b = lroundf(255 * B)
        var a = lroundf(255 * A)
        
        if components.count >= 4 {
            A = Float(components[3])
            a = lroundf(255 * A)
        }
        
        let max: Float = max(R, G, B)
        let min: Float = min(R, G, B)
        
        var h: Int = 0
        var s: Int = 0
        
        let l: Int = lroundf((max + min) / 2 * 100)
        
        if max != min {
            if l <= 50 {
                s = lroundf((max - min) / (max + min) * 100)
            } else {
                s = lroundf((max - min) / (2.0 - max - min) * 100)
            }
            
            if max == R {
                h = lroundf((G - B) / (max - min))
                
            } else if max == G {
                h = lroundf(2.0 + (B - R) / (max - min))
                
            } else if max == B {
                h = lroundf(3.0 + (R - G) / (max - min))
            }
            
            h *= 60
            
            if h < 0 {
                h += 360
            }
        }
        
        colorData.rgba = [r, g, b, a]
        
        if a != 255 {
            if let convertedHex = Int(String(format: "%02lX%02lX%02lX%02lX", r, g, b, a), radix: 16) {
                colorData.hex = convertedHex
            }
        } else {
            if let convertedHex = Int(String(format: "%02lX%02lX%02lX", r, g, b), radix: 16) {
                colorData.hex = convertedHex
            }
        }

        colorData.hsl = [h, s, l]

        return colorData
    }
    
    // Static function to convert any HEX value to a Swift UI color, then returns the color
    static func convertHexToColor(hexString: String) -> Color {
        
        var hex = hexString
        
        if hex.count == 0 {
            hex = "FFFFFF"
            
        } else if hex.count < 6 {
            var zeros = ""
            
            for _ in 0..<(6 - hex.count) {
                zeros += "0"
            }
            
            hex = zeros + hex
        }
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hex.count
        
        guard Scanner(string: hex).scanHexInt64(&rgb) else {return Color(red: 1, green: 1, blue: 1)}
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        }
          
        
        return Color(red: r, green: g, blue: b, opacity: a)
    }
    
    // Static function to convert any HSL value to a Swift UI color, then returns the color
    static func convertHSLToColor(hsl: [Int]) -> Color {
        let h = Double(hsl[0]) / 360.0
        let s = Double(hsl[1]) / 100.0
        let l = Double(hsl[2]) / 100.0
        
        if s == 0 {
            return Color(red: l, green: l, blue: l)
        } else {
            let temp1 = l < 0.5 ? (l * (1.0 + s)) : (l + s - (l * s))
            let temp2 = (2 * l) - temp1
            
            let r = h + 0.333
            let g = h
            let b = h - 0.333
            
            var rgb = [r, g, b]
            
            for index in 0...2 {
                if rgb[index] > 1 {
                    rgb[index] -= 1
                } else if rgb[index] < 0 {
                    rgb[index] += 1
                }
                
                if (6 * rgb[index]) < 1 {
                    rgb[index] = ((temp1 - temp2) * 6 * rgb[index]) + temp2
                    
                } else if (2 * rgb[index]) < 1 {
                    rgb[index] = temp1
                    
                } else if (3 * rgb[index]) < 2 {
                    rgb[index] = ((temp1 - temp2) * (0.666 - rgb[index]) * 6) + temp2
                    
                } else {
                    rgb[index] = temp2
                }
            }
            
            return Color(red: rgb[0], green: rgb[1], blue: rgb[2])
            
        }
    }
    
    // Static function to convert any RGBA value to a Swift UI color, then returns the color
    static func convertRGBAToColor(rgba: [Int]) -> Color {
        return Color(red: Double(rgba[0]) / 255, green: Double(rgba[1]) / 255, blue: Double(rgba[2]) / 255, opacity: Double(rgba[3]) / 255)
    }
}

