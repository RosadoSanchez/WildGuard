//
//  Identifyanimalview.swift
//  WildGuard
//
//  Created by AGRM  on 18/04/26.
//

import SwiftUI

struct Identifyanimalview: View {
    @State private var searchText     = ""
    @State private var showWizard     = false
    @State private var selectedAnimal : Animal? = nil

    private var filteredAnimals: [Animal] {
        guard !searchText.isEmpty else { return Animal.all }
        return Animal.all.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.scientificName.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0) {

                    // HEADER
                    headerSection
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 4)

                    // SEARCH BAR
                    stickySearchBar
                        .padding(.bottom, 8)

                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 18
                    ) {
                        ForEach(filteredAnimals) { animal in
                            Button {
                                selectedAnimal = animal
                            } label: {
                                AnimalCard(animal: animal)
                                    .padding(.horizontal, 3)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 4)

                    Spacer().frame(height: 100)
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) { bottomButtonArea }
        }
        .navigationBarHidden(true)
        .navigationDestination(item: $selectedAnimal) {
            AnimalDetailView(animal: $0)
        }
        .sheet(isPresented: $showWizard) {
            WizardContainerView()
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("¿Qué viste?")
                .font(.system(size: 14))
                .foregroundStyle(Color.appTextSecondary)

            Text("Identificar animal")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(Color.appTextPrimary)

            Text("Selecciona el animal que avistaste")
                .font(.system(size: 15))
                .foregroundStyle(Color.appTextSecondary)
        }
    }

    // MARK: - Search bar

    private var stickySearchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.appTextTertiary)
                .font(.system(size: 15))

            TextField("Buscar animal...", text: $searchText)
                .font(.system(size: 15))
                .foregroundStyle(Color.appTextPrimary)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.appSearchBar, in: RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 10)
    }

    // MARK: - Bottom button

    private var bottomButtonArea: some View {
        VStack(spacing: 0) {
            LinearGradient(
                colors: [Color.appBackground.opacity(0), Color.appBackground],
                startPoint: .top, endPoint: .bottom
            )
            .frame(height: 28)
            .allowsHitTesting(false)

            noAnimalButton
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
                .background(Color.appBackground)
        }
    }

    private var noAnimalButton: some View {
        Button { showWizard = true } label: {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(.white.opacity(0.85))

                VStack(alignment: .leading, spacing: 1) {
                    Text("No encuentro mi animal")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Responde unas preguntas y te ayudamos")
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.8))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.appGreen, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.appGreen.opacity(0.35), radius: 12, x: 0, y: 4)
        }
    }
}

#Preview {
    NavigationStack {
        Identifyanimalview()
    }
}
