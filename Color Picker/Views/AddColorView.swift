//
//  AddColorView.swift
//  Color Picker
//
//  Modal displaying a form for adding a color to a palette
//
//  Created by Nuah on 2/19/23.
//

import SwiftUI

struct AddColorView: View {
    @EnvironmentObject var viewmodel: PickerViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var colorName: String = ""
    
    @State var showingAlert: Bool = false
    @State var showingNewPalette: Bool = false
        
    var body: some View {
        VStack {
            Text("Add Color to Palette")
                .font(.title)
            RoundedRectangle(cornerRadius: 10)
                .fill(viewmodel.selectedColor)
                .frame(height: 40)
            Spacer()
            HStack {
                Text("Palette:")
                Spacer()
                Menu {
                    ForEach(viewmodel.palettes, id: \.id) { palette in
                        Button {
                            viewmodel.selectedPalette = palette
                            
                        } label: {
                            Text(palette.name)
                        }
                    }
                } label: {
                    Text(viewmodel.selectedPalette.name == "" ? "Choose Palette" : viewmodel.selectedPalette.name)
                }
                Button {
                    showingNewPalette = true
                } label: {
                    Text("+")
                }
            }
            HStack {
                Text("Color Name:")
                TextField("Enter a name", text: $colorName)
                    .onSubmit {
                        if (viewmodel.selectedPalette.name != "" && colorName != "") {
                            viewmodel.addColor(name: colorName, palette: viewmodel.selectedPalette)
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            showingAlert = true
                        }
                    }
            }
            Spacer()
            HStack {
                Button {
                    if (viewmodel.selectedPalette.name != "" && colorName != "") {
                        viewmodel.addColor(name: colorName, palette: viewmodel.selectedPalette)
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showingAlert = true
                    }
                    
                    
                } label : {
                    Text("Add")
                }
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                }
            }
        }
        .frame(width:350, height: 200)
        .padding()
        .alert("Please select a palette and give this color a name", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .sheet(isPresented: $showingNewPalette, content: {
            AddPaletteView(defaultColor: false)
                .environmentObject(viewmodel)
        })
    }
}

struct AddColorView_Previews: PreviewProvider {
    static var previews: some View {
        AddColorView().environmentObject(PickerViewModel())
    }
}
