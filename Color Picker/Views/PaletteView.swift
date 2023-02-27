//
//  PaletteView.swift
//  Color Picker
//
//  Displays a dropdown for each palette in the palettes array
//
//  Created by Nuah on 2/17/23.
//

import SwiftUI

struct PaletteView: View {
    @EnvironmentObject var viewmodel: PickerViewModel
    
    var palette: Palette
    @State var isHovered: Bool = false
    @State var isHidden: Bool = true
    @State var isEditing: Bool = false
    @State var isDeleting: Bool = false
    
    @State var paletteName: String = ""
    
    var body: some View {
        VStack (alignment: .leading) {
            ZStack {
                Colors.headerBackground
                HStack {
                    if isEditing {
                        TextField(palette.name, text: $paletteName)
                            .font(.title)
                            .bold()
                            .textFieldStyle(.squareBorder)
                            .onSubmit {
                                isEditing = false
                                viewmodel.renamePalette(name: paletteName, palette: palette)
                            }
                    } else {
                        Text(palette.name)
                            .font(.title)
                            .bold()
                    }
                    Spacer()
                    if isEditing {
                        Button {
                            isEditing = false
                            viewmodel.renamePalette(name: paletteName, palette: palette)
                        } label: {
                            Image(systemName: "checkmark")
                                .background(.clear)
                        }
                    }
                    Menu {
                            Button {
                                paletteName = palette.name
                                isEditing = true
                            } label: {
                                Label("Rename", systemImage: "pencil")
                            }
                        
                        Button {
                            isDeleting = true
                            
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .foregroundColor(.red)
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                    .menuStyle(BorderlessButtonMenuStyle())
                    .menuIndicator(.hidden)
                    .fixedSize()
                    Image(systemName: isHidden ? "chevron.down" : "chevron.up")
                }
                .padding([.top, .bottom], 5)
                .padding([.leading, .trailing], 10)
                .overlay(RoundedRectangle(cornerRadius:10).stroke(.white, lineWidth: isHovered ? 3 : 0))
                .confirmationDialog("Are you sure you would like to delete this palette?", isPresented: $isDeleting) {
                    Button {
                        viewmodel.deletePalette(palette: palette)
                    } label: {
                        Text("Delete '\(palette.name)'")
                            .foregroundColor(.white)
                            .background(.red)
                    }
                    
                }
            }
            .contentShape(RoundedRectangle(cornerRadius: 10))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onHover { over in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isHovered = over
                }
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isHidden.toggle()
                }
            }
            ScrollView (.horizontal, showsIndicators: false) {
                HStack (spacing: 10) {
                    ForEach(palette.entries) {entry in
                        ColorView(colorEntry: entry, palette: palette)
                    }
                }
            }
            .frame(width: 650, height: isHidden ? 0 : nil)
            .padding([.trailing], 15)
            .opacity(isHidden ? 0 : 1)
            .clipped()
            .offset(x: 15)            
        }
        .environmentObject(viewmodel)
        .padding([.trailing, .leading, .top, .bottom], 5)
        
    }
}

struct PaletteView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteView(palette: Palette(id: 0, name: "Test", entries: [
            ColorEntry(id: 0, name: "Red", rgba: [255, 0, 0, 255]),
            ColorEntry(id: 1, name: "Green", rgba: [0, 255, 0, 255]),
            ColorEntry(id: 2, name: "Blue", rgba: [0, 0, 255, 255])
        ])).environmentObject(PickerViewModel())
    }
}
