//
//  SightingsView.swift
//  WildGuard
//
//  Created by Samantha Carmona Santos on 18/04/26.
//

import SwiftUI

struct SightingsView: View {
    let sightings: [Sighting]
    
    var body: some View {
        List(sightings) { sighting in
            VStack(alignment: .leading) {
                Text(sighting.title)
                Text(sighting.date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Avistamientos")
    }
}

