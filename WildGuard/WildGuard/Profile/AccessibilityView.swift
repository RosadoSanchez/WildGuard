//
//  AccessibilityView.swift
//  WildGuard
//
//  Created by Samantha Carmona Santos on 18/04/26.
//

import SwiftUI

struct AccessibilityView: View {
    
    @AppStorage("largeText") private var largeText = false
    @AppStorage("highContrast") private var highContrast = false
    @AppStorage("voiceOverEnabled") private var voiceOverEnabled = false
    
    var body: some View {
        Form {
            
            Section(header: Text("Visual")) {
                
                Toggle("Texto grande", isOn: $largeText)
                
                Toggle("Alto contraste", isOn: $highContrast)
            }
            
            
            Section(header: Text("Información")) {
                Text("Estas opciones ayudan a mejorar la visibilidad y accesibilidad de la app.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Accesibilidad")
    }
}

#Preview {
    AccessibilityView()
}
