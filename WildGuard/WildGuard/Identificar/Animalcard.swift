//
//  Animalcard.swift
//  WildGuard
//
//  Created by AGRM  on 18/04/26.
//

import SwiftUI

// MARK: - Danger Badge

struct DangerBadge: View {
    let level: DangerLevel
    var body: some View {
        Text(level.rawValue)
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(level.foregroundColor)
            .padding(.horizontal, 10).padding(.vertical, 5)
            .background(level.backgroundColor, in: Capsule())
    }
}

// MARK: - Animal Card

struct AnimalCard: View {
    let animal: Animal

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            AnimalImage(scientificName: animal.scientificName, height: 130)

            VStack(alignment: .leading, spacing: 6) {
                Text(animal.name)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(1)
                Text(animal.scientificName)
                    .font(.system(size: 12)).italic()
                    .foregroundStyle(Color.appTextSecondary)
                    .lineLimit(1)
                DangerBadge(level: animal.dangerLevel)
                    .padding(.top, 2)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 2)
    }
}

#Preview {
    HStack(spacing: 12) {
        AnimalCard(animal: Animal.all[0])
        AnimalCard(animal: Animal.all[3])
    }
    .padding()
    .background(Color.appBackground)
}
