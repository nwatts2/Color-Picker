//
//  Color_PickerApp.swift
//  Color Picker
//
//  Parent view for entire application, defines window size and properties
//
//  Created by Nuah on 2/17/23.
//

import SwiftUI

@main
struct Color_PickerApp: App {
    var windowWidth: CGFloat = 1050.0
    var windowHeight: CGFloat = 600.0
    
    var body: some Scene {
        WindowGroup {
            MenuView()
                .frame(minWidth: windowWidth, idealWidth: windowWidth, maxWidth: windowWidth, minHeight: windowHeight, idealHeight: windowHeight, maxHeight: windowHeight, alignment: .center)
                .background(Colors.background)

        }
        .windowResizability(.contentSize)
    }
}
