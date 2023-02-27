//
//  MenuView.swift
//  Color Picker
//
//  Lays out all major elements within the app
//
//  Created by Nuah on 2/17/23.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var viewmodel = PickerViewModel()
    
    @State var isShowingAddPalette: Bool = false
        
    var body: some View {
        
        ZStack {
            HStack (spacing: 10) {
                PickerView()
                Spacer()
                VStack {
                    HStack {
                        Text("Palettes")
                            .font(.largeTitle)
                        Spacer()
                        Button {
                            isShowingAddPalette = true
                            
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                        .buttonStyle(.plain)
                    }
                    
                    Divider()
                    ScrollView(showsIndicators: false) {
                        VStack (alignment: .leading) {
                            ForEach(viewmodel.palettes) { palette in
                                PaletteView(palette: palette)
                                
                            }
                        }
                        
                    }
                    .frame(height: 500)
                    .padding([.trailing, .leading], 20)
                }
                
            }
            .sheet(isPresented: $isShowingAddPalette) {
                AddPaletteView(defaultColor: true)
            }
            
        }
        .padding()
        .environmentObject(viewmodel)
        
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
