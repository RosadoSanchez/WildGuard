//
//  MyCollection.swift
//  WildGuard
//
//  Created by AGRM  on 18/04/26.
//

import SwiftUI

// MARK: - Collection Item Model

struct CollectionItem: Identifiable {
    let id          = UUID()
    let animal      : Animal
    let count       : Int
    let location    : String
    var nickname    : String
    var isNaming    : Bool = false
}

// MARK: - MyCollectionView

struct MyCollectionView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var items: [CollectionItem] = [
        CollectionItem(animal: Animal.all[0], count: 3, location: "Col. del Valle",     nickname: "Bruno"),
        CollectionItem(animal: Animal.all[7], count: 3, location: "Condesa",            nickname: "Bandit"),
        CollectionItem(animal: Animal.all[5], count: 2, location: "Bosque Chapultepec", nickname: "Bambi"),
        CollectionItem(animal: Animal.all[1], count: 2, location: "Pedregal",           nickname: "Colmillo"),
        CollectionItem(animal: Animal.all[9], count: 4, location: "San Ángel",          nickname: "Fantasma"),
        CollectionItem(animal: Animal.all[6], count: 1, location: "Col. del Valle",     nickname: "Manchas"),
        CollectionItem(animal: Animal.all[2], count: 2, location: "Chapultepec",        nickname: "Rayo"),
        CollectionItem(animal: Animal.all[8], count: 1, location: "Pedregal",           nickname: "Rocky"),
    ]

    @State private var namingId : UUID? = nil
    @State private var draftName: String = ""

    private var rows: [[CollectionItem]] {
        stride(from: 0, to: items.count, by: 2).map {
            Array(items[$0..<min($0 + 2, items.count)])
        }
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // Title
                    Text("Mi colección")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(Color.appTextPrimary)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 20)

                    // Stats
                    statsCard
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)

                    // Banner
                    namingBanner
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)

                    // Grid
                    VStack(spacing: 14) {
                        ForEach(rows, id: \.first?.id) { row in
                            HStack(alignment: .top, spacing: 14) {
                                ForEach(row) { item in
                                    CollectionCard(
                                        item: item,
                                        isNaming: namingId == item.id,
                                        draftName: namingId == item.id ? $draftName : .constant(""),
                                        onNamingTap: { startNaming(item) },
                                        onConfirm: { confirmName(item) }
                                    )
                                    .frame(maxWidth: .infinity)
                                }
                                if row.count == 1 { Color.clear.frame(maxWidth: .infinity) }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left").font(.system(size: 14, weight: .semibold))
                        Text("Atrás").font(.system(size: 16))
                    }
                    .foregroundStyle(Color.appGreen)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.appGreen)
                }
            }
        }
        .toolbarBackground(Color.appBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }

    // MARK: - Stats card

    private var statsCard: some View {
        HStack(spacing: 0) {
            statItem(value: "17", label: "avistamientos")
            Divider().frame(height: 40)
            statItem(value: "8",  label: "especies")
            Divider().frame(height: 40)
            statItem(value: "6",  label: "zonas")
        }
        .padding(.vertical, 16)
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color.appGreen)
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(Color.appTextSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Banner

    private var namingBanner: some View {
        HStack(spacing: 10) {
            Image(systemName: "person.2.fill")
                .font(.system(size: 16))
                .foregroundStyle(Color.appGreen)
            Text("¡Ponle un nombre a tus animales! La comunidad verá el apodo que les des.")
                .font(.system(size: 13))
                .foregroundStyle(Color.appTextPrimary)
                .lineSpacing(2)
        }
        .padding(14)
        .background(Color.appGreenMint.opacity(0.5), in: RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Naming logic

    private func startNaming(_ item: CollectionItem) {
        namingId  = item.id
        draftName = item.nickname
    }

    private func confirmName(_ item: CollectionItem) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        if !draftName.trimmingCharacters(in: .whitespaces).isEmpty {
            items[idx].nickname = draftName
        }
        namingId = nil
    }
}

// MARK: - Collection Card

struct CollectionCard: View {
    let item       : CollectionItem
    let isNaming   : Bool
    @Binding var draftName : String
    let onNamingTap: () -> Void
    let onConfirm  : () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Imagen con badge de conteo
            ZStack(alignment: .topTrailing) {
                AnimalImage(scientificName: item.animal.scientificName, height: 110)

                Text("×\(item.count)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(Color.appGreen, in: Capsule())
                    .padding(8)
            }

            // Info
            VStack(alignment: .leading, spacing: 6) {

                // Nombre + chevron
                HStack {
                    Text(item.animal.name)
                        .multilineTextAlignment(.leading)
                        .padding(.trailing, 16).lineLimit(1)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Color.appTextPrimary)
                        .lineLimit(2)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .lineLimit(1)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.appTextTertiary)
                }

                // Ubicación
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.appTextTertiary)
                    Text(item.location)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.appTextSecondary)
                        .lineLimit(1)
                }

                // Nickname row
                if isNaming {
                    // Campo de texto para nombrar
                    HStack(spacing: 6) {
                        TextField("Ponle un nombre...", text: $draftName)
                            .font(.system(size: 13))
                            .foregroundStyle(Color.appTextPrimary)
                            .autocorrectionDisabled()
                            .onSubmit { onConfirm() }
                    }
                    .lineLimit(1)
                    .padding(.horizontal, 10).padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.appGreen, lineWidth: 1.5)
                    )
                } else {
                    HStack(spacing: 6) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(Color.appTextTertiary)
                        Text("\"\(item.nickname)\"")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.appTextSecondary)
                        Spacer()
                        Button { onNamingTap() } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 6, weight: .light))
                                Text("Nombrar")
                                    .font(.system(size: 8, weight: .light))
                            }
                            .lineLimit(1)
                            .foregroundStyle(Color.appGreen)
                            .frame(minWidth: 45)
                            .padding(.horizontal, 5).padding(.vertical, 5)
                            .background(Color.appGreenMint.opacity(0.6), in: Capsule())
                        }
                    }
                    .lineLimit(1)
                }
            }
            .padding(12)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isNaming ? Color.appGreen : Color.clear, lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }
}

#Preview {
    NavigationStack { MyCollectionView() }
}
