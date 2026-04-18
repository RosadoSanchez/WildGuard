//
//  EnergencyView.swift
//  WildGuard
//
//  Created by Samantha Carmona Santos on 18/04/26.
//

import SwiftUI

struct EmergencyView: View {
    
    @State var contacts: [EmergencyContact]
    
    var body: some View {
        List {
            ForEach(contacts) { contact in
                VStack(alignment: .leading) {
                    Text(contact.name)
                    Text(contact.phone)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .onDelete { indexSet in
                contacts.remove(atOffsets: indexSet)
            }
        }
        .navigationTitle("Emergencia")
        .toolbar {
            EditButton()
        }
    }
}
