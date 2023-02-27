//
//  ColorView.swift
//  Color Picker
//
//  Displays the data from a ColorEntry object within the PaletteView view
//
//  Created by Nuah on 2/17/23.
//

import SwiftUI

struct ColorView: View {
    @EnvironmentObject var viewmodel: PickerViewModel
    
    @State var isDeleting: Bool = false
    @State var isRenaming: Bool = false
    
    @State var isHidden: Bool = true
        
    var colorEntry: ColorEntry
    var color: Color {
        return Color(red: CGFloat(colorEntry.rgba[0]) / 255.0, green: CGFloat(colorEntry.rgba[1]) / 255.0, blue: CGFloat(colorEntry.rgba[2]) / 255.0, opacity: CGFloat(colorEntry.rgba[3]) / 255.0)
    }
    var palette: Palette
    
    let pasteboard = NSPasteboard.general
        
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Colors.colorBackground)
                .frame(width: 195, height: 230)
            VStack (spacing: 5) {
                HStack {
                    Menu {
                        Button {
                            pasteboard.clearContents()
                            pasteboard.setString("#\(colorEntry.hexString)", forType: .string)
                            
                        } label: {
                            Text("Copy HEX Value")
                        }
                        
                        Button {
                            pasteboard.clearContents()
                            pasteboard.setString("rgba(\(colorEntry.rgba[0]), \(colorEntry.rgba[1]), \(colorEntry.rgba[2]), \(colorEntry.rgba[3]))", forType: .string)
                            
                        } label: {
                            Text("Copy RGBA Value")
                        }
                        
                        Button {
                            pasteboard.clearContents()
                            pasteboard.setString("hsl(\(colorEntry.hsl[0]), \(colorEntry.hsl[1]), \(colorEntry.hsl[2]))", forType: .string)
                            
                        } label: {
                            Text("Copy HSL Value")
                        }
                        
                        Button {
                            pasteboard.clearContents()
                            pasteboard.setString("Color(red: \(colorEntry.rgba[0])/255, green:\(colorEntry.rgba[1])/255, blue: \(colorEntry.rgba[2])/255, opacity: \(colorEntry.rgba[3])/255)", forType: .string)
                            
                        } label: {
                            Text("Copy Swift Format")
                        }
                        
                        Divider()
                        
                        Button {
                            isRenaming = true
                            
                        } label: {
                            Label("Rename Color", systemImage: "pencil")
                        }
                        
                        Button {
                            isDeleting = true
                            
                        } label: {
                            Label("Delete Color", systemImage: "trash")
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                    .menuStyle(BorderlessButtonMenuStyle())
                    .menuIndicator(.hidden)
                    .fixedSize()
                    .offset(x: 70)
                }
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(color)
                    .frame(width: 100, height: 100)
                    .background(RoundedRectangle(cornerRadius:20).stroke(Colors.colorBorder, lineWidth: 8))
                Text(colorEntry.name)
                    .font(.headline)
                Text("HEX: #\(colorEntry.hexString)")
                Text("RGBA: ( \(colorEntry.rgba[0]), \(colorEntry.rgba[1]), \(colorEntry.rgba[2]), \(colorEntry.rgba[3]) )")
                Text("HSL: ( \(colorEntry.hsl[0]), \(colorEntry.hsl[1]), \(colorEntry.hsl[2]) )")
            }
            .font(.body)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.2)) {
                isHidden = false
            }
        }
        .onDisappear {
            withAnimation(.easeInOut(duration: 0.2)) {
                isHidden = true
            }
            
        }
        .frame(height: isHidden ? 0 : nil)
        .opacity(isHidden ? 0 : 1)
        .clipped()
        .sheet(isPresented: $isRenaming) {
            RenameColorView(colorEntry: colorEntry, palette: palette)
        }
        .confirmationDialog("Are you sure you would like to delete this color?", isPresented: $isDeleting) {
            Button {
                viewmodel.deleteColor(color: colorEntry, palette: palette)
            } label: {
                Text("Delete '\(colorEntry.name)'")
                    .foregroundColor(.white)
                    .background(.red)
            }
        }
        
    }
}

struct ColorView_Previews: PreviewProvider {
    static var previews: some View {
        ColorView(colorEntry: ColorEntry(id: 0, name: "Red", rgba: [255, 0, 0, 255]), palette: Palette(id: 0, name: "Test", entries: [])).environmentObject(PickerViewModel())
    }
}
