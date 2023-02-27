//
//  AddPaletteView.swift
//  Color Picker
//
//  Modal displaying a form for creating a new palette
//
//  Created by Nuah on 2/19/23.
//

import SwiftUI

struct AddPaletteView: View {
    @EnvironmentObject var viewmodel: PickerViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var paletteName: String = ""
    @State var showingAlert: Bool = false
    
    var defaultColor: Bool
    
    var body: some View {
        VStack {
            Text("New Palette")
                .font(.title)
            Spacer()
            HStack {
                Text("Palette Name:")
                TextField("Enter a name", text: $paletteName)
                    .onSubmit {
                        if paletteName != "" {
                            if defaultColor {
                                viewmodel.addPalette(name: paletteName, entries: [ColorEntry(id: 0, name: "White", rgba: [255, 255, 255, 255])])

                            } else {
                                viewmodel.addPalette(name: paletteName, entries: [])

                            }
                            viewmodel.selectedPalette = viewmodel.palettes[viewmodel.palettes.count - 1]
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            showingAlert = true
                        }
                    }
            }
            Spacer()
            HStack {
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                }
                Spacer()
                Button {
                    if paletteName != "" {
                        if defaultColor {
                            viewmodel.addPalette(name: paletteName, entries: [ColorEntry(id: 0, name: "White", rgba: [255, 255, 255, 255])])

                        } else {
                            viewmodel.addPalette(name: paletteName, entries: [])

                        }
                        viewmodel.selectedPalette = viewmodel.palettes[viewmodel.palettes.count - 1]
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showingAlert = true
                    }
                    
                    
                } label : {
                    Text("Create Palette")
                }

                Spacer()
                
            }
        }
        .frame(width:350, height: 100)
        .padding()
        .alert("Please enter a name for this new palette", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
            
        }
    }
}

struct AddPaletteView_Previews: PreviewProvider {
    static var previews: some View {
        AddPaletteView(defaultColor: true)
    }
}
