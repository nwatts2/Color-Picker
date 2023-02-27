//
//  RenameColorView.swift
//  Color Picker
//
//  Modal displaying a form for renaming an existing color in a palette
//
//  Created by Nuah on 2/22/23.
//

import SwiftUI

struct RenameColorView: View {
    @EnvironmentObject var viewmodel: PickerViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var colorName: String = ""
    
    @State var showingAlert: Bool = false
    
    var colorEntry: ColorEntry
    var palette: Palette
    
    var color: Color {
        return Color(red: CGFloat(colorEntry.rgba[0]) / 255.0, green: CGFloat(colorEntry.rgba[1]) / 255.0, blue: CGFloat(colorEntry.rgba[2]) / 255.0, opacity: CGFloat(colorEntry.rgba[3]) / 255.0)
    }
    
    init(colorEntry: ColorEntry, palette: Palette) {
        self.colorEntry = colorEntry
        self.palette = palette
        colorName = colorEntry.name
    }
    
    var body: some View {
        VStack {
            Text("Rename Color")
                .font(.title)
            RoundedRectangle(cornerRadius: 10)
                .fill(color)
                .frame(height: 40)
            Spacer()
            HStack {
                Text("Color Name:")
                TextField("Enter a name", text: $colorName)
                    .onSubmit {
                        if (colorName != "") {
                            viewmodel.renameColor(name: colorName, color: colorEntry, palette: palette)
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            showingAlert = true
                        }
                    }
            }
            Spacer()
            HStack {
                Button {
                    if (colorName != "") {
                        viewmodel.renameColor(name: colorName, color: colorEntry, palette: palette)
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showingAlert = true
                    }
                    
                    
                } label : {
                    Text("Rename")
                }
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                }
            }
        }
        .frame(width:350, height: 150)
        .padding()
        .alert("Please give this color a name", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}

struct RenameColorView_Previews: PreviewProvider {
    static var previews: some View {
        RenameColorView(colorEntry: ColorEntry(id: 0, name: "White", rgba: [255, 255, 255, 255]), palette: Palette(id: 0, name: "Test", entries: [])).environmentObject(PickerViewModel())
    }
}
