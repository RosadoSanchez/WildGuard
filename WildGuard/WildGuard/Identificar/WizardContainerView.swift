//
//  WizardContainerView.swift
//  WildGuard
//
//  Created by AGRM  on 18/04/26.
//


import SwiftUI

// MARK: - Wizard Answers

struct WizardAnswers {
    var size     : String = ""
    var color    : String = ""
    var location : String = ""
    var feature  : String = ""
    var allTags  : [String] { [size, color, location, feature].filter { !$0.isEmpty } }
}

struct WizardOption {
    let systemImage : String
    let iconColor   : Color
    let label       : String
    let detail      : String
    let value       : String
}

// MARK: - Container

struct WizardContainerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var step        = 1
    @State private var answers     = WizardAnswers()
    @State private var showResults = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                if showResults {
                    WizardResultsView(answers: answers, onRestart: restart, onDismiss: { dismiss() })
                        .transition(.move(edge: .trailing))
                } else {
                    VStack(spacing: 0) {
                        progressBar
                            .padding(.horizontal, 20)
                            .padding(.top, 4)
                            .padding(.bottom, 20)
                        stepContent
                            .transition(.move(edge: .trailing))
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if showResults { withAnimation { showResults = false; step = 4 } }
                        else if step > 1 { withAnimation { step -= 1 } }
                        else { dismiss() }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left").font(.system(size: 14, weight: .semibold))
                            Text("Atrás")
                        }
                        .foregroundStyle(Color.appGreen)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text(showResults ? "Resultados" : "Paso \(step) de 4")
                        .font(.system(size: 17, weight: .semibold))
                }
                if showResults {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button { restart() } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.counterclockwise").font(.system(size: 13))
                                Text("Reiniciar").font(.system(size: 15))
                            }
                            .foregroundStyle(Color.appGreen)
                        }
                    }
                }
            }
        }
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4).fill(Color.appSearchBar).frame(height: 4)
                RoundedRectangle(cornerRadius: 4).fill(Color.appGreen)
                    .frame(width: geo.size.width * CGFloat(showResults ? 4 : step) / 4.0, height: 4)
                    .animation(.easeInOut(duration: 0.3), value: step)
            }
        }
        .frame(height: 4)
    }

    @ViewBuilder
    private var stepContent: some View {
        switch step {
        case 1:
            WizardStepView(
                question: "¿Qué tamaño tenía?",
                subtitle: "Compáralo con animales comunes",
                options: [
                    WizardOption(systemImage: "hare.fill",            iconColor: Color.appGreen, label: "Pequeño",    detail: "Como un gato o conejo",  value: "pequeño"),
                    WizardOption(systemImage: "dog.fill",             iconColor: Color.appGreen, label: "Mediano",    detail: "Como un perro mediano",  value: "mediano"),
                    WizardOption(systemImage: "pawprint.fill",        iconColor: Color.appGreen, label: "Grande",     detail: "Como un lobo o puma",    value: "grande"),
                    WizardOption(systemImage: "pawprint.circle.fill", iconColor: Color.appGreen, label: "Muy grande", detail: "Como un oso o venado",   value: "muy-grande"),
                ]
            ) { value in answers.size = value; withAnimation { step = 2 } }

        case 2:
            WizardStepView(
                question: "¿Qué color predominaba?",
                subtitle: "El color más visible de su cuerpo",
                options: [
                    WizardOption(systemImage: "circle.fill",           iconColor: Color(hex: "92400E"), label: "Marrón / café",  detail: "Tonos tierra o café",     value: "marron"),
                    WizardOption(systemImage: "circle.fill",           iconColor: Color(hex: "1F2937"), label: "Negro",          detail: "Oscuro predominante",     value: "negro"),
                    WizardOption(systemImage: "circle.fill",           iconColor: Color(hex: "9CA3AF"), label: "Gris",           detail: "Gris plateado o ceniza",  value: "gris"),
                    WizardOption(systemImage: "circle.lefthalf.filled",iconColor: Color(hex: "374151"), label: "Negro y blanco", detail: "Partes oscuras y claras", value: "negro-blanco"),
                    WizardOption(systemImage: "paintpalette.fill",     iconColor: Color.appGreen,       label: "Varios colores", detail: "Manchado o multicolor",   value: "varios"),
                ]
            ) { value in answers.color = value; withAnimation { step = 3 } }

        case 3:
            WizardStepView(
                question: "¿Dónde lo viste?",
                subtitle: "El tipo de lugar del avistamiento",
                options: [
                    WizardOption(systemImage: "building.2.fill", iconColor: Color.appGreen, label: "Zona urbana",     detail: "Calle, colonia, jardín",     value: "urbano"),
                    WizardOption(systemImage: "tree.fill",        iconColor: Color.appGreen, label: "Parque o bosque", detail: "Entre árboles y vegetación", value: "parque"),
                    WizardOption(systemImage: "mountain.2.fill",  iconColor: Color.appGreen, label: "Campo abierto",  detail: "Zonas rocosas o pastizal",   value: "campo"),
                ]
            ) { value in answers.location = value; withAnimation { step = 4 } }

        default:
            WizardStepView(
                question: "¿Qué te llamó la atención?",
                subtitle: "La característica más destacada",
                options: [
                    WizardOption(systemImage: "theatermasks.fill",                iconColor: Color.appGreen, label: "Rayas o máscara",           detail: "Marcas en la cara o cuerpo", value: "rayas"),
                    WizardOption(systemImage: "waveform",                         iconColor: Color.appGreen, label: "Cola muy larga",            detail: "Prominente y visible",       value: "cola-larga"),
                    WizardOption(systemImage: "mouth.fill",                       iconColor: Color.appGreen, label: "Colmillos / hocico grande", detail: "Dientes o nariz notable",    value: "colmillos"),
                    WizardOption(systemImage: "arrow.up.left.and.arrow.up.right", iconColor: Color.appGreen, label: "Cuernos o astas",           detail: "Ramificados o curvos",       value: "cuernos"),
                    WizardOption(systemImage: "lizard.fill",                      iconColor: Color.appGreen, label: "Forma de serpiente",        detail: "Sin patas, reptil",          value: "serpiente"),
                    WizardOption(systemImage: "questionmark.circle.fill",         iconColor: Color.appGreen, label: "Nada especial",             detail: "Apariencia típica",          value: "normal"),
                ]
            ) { value in answers.feature = value; withAnimation { showResults = true } }
        }
    }

    private func restart() {
        withAnimation { step = 1; answers = WizardAnswers(); showResults = false }
    }
}

// MARK: - Step View

struct WizardStepView: View {
    let question : String
    let subtitle : String
    let options  : [WizardOption]
    let onSelect : (String) -> Void

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(question)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color.appTextPrimary)
                    Text(subtitle)
                        .font(.system(size: 15))
                        .foregroundStyle(Color.appTextSecondary)
                }
                .padding(.horizontal, 20)

                VStack(spacing: 10) {
                    ForEach(options, id: \.value) { option in
                        Button { onSelect(option.value) } label: {
                            WizardOptionRow(option: option)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 32)
        }
    }
}

// MARK: - Option Row

struct WizardOptionRow: View {
    let option: WizardOption
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: option.systemImage)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(option.iconColor)
                .frame(width: 52, height: 52)
                .background(option.iconColor.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))
            VStack(alignment: .leading, spacing: 2) {
                Text(option.label)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.appTextPrimary)
                Text(option.detail)
                    .font(.system(size: 13))
                    .foregroundStyle(Color.appTextSecondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.appTextTertiary)
        }
        .padding(14)
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
    }
}

// MARK: - Results View

struct WizardResultsView: View {
    let answers   : WizardAnswers
    let onRestart : () -> Void
    let onDismiss : () -> Void

    @State private var selectedAnimal: Animal? = nil

    private var rankedAnimals: [(animal: Animal, score: Int)] {
        Animal.all.map { animal in
            var score = 0
            if animal.wizardTags.size     == answers.size     { score += 3 }
            if animal.wizardTags.color    == answers.color    { score += 2 }
            if animal.wizardTags.location == answers.location { score += 1 }
            if animal.wizardTags.feature  == answers.feature  { score += 2 }
            return (animal, score)
        }
        .filter { $0.score > 0 }
        .sorted { $0.score > $1.score }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Posibles coincidencias")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color.appTextPrimary)
                    Text("Basado en tus respuestas, podrías haber visto:")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.appTextSecondary)
                    HStack(spacing: 8) {
                        ForEach(answers.allTags, id: \.self) { tag in
                            Text(tag)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(Color.appGreen)
                                .padding(.horizontal, 12).padding(.vertical, 6)
                                .background(Color.appGreenMint.opacity(0.6), in: Capsule())
                        }
                    }
                }
                .padding(.horizontal, 20)

                if rankedAnimals.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 48)).foregroundStyle(Color.appTextTertiary)
                        Text("No encontramos coincidencias exactas")
                            .font(.system(size: 16, weight: .semibold)).foregroundStyle(Color.appTextPrimary)
                        Text("Intenta con otras respuestas")
                            .font(.system(size: 14)).foregroundStyle(Color.appTextSecondary)
                    }
                    .frame(maxWidth: .infinity).padding(40)
                } else {
                    VStack(spacing: 10) {
                        ForEach(Array(rankedAnimals.enumerated()), id: \.element.animal.id) { index, item in
                            Button { selectedAnimal = item.animal } label: {
                                ResultRow(animal: item.animal, isBest: index == 0)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                }

                Button { onRestart() } label: {
                    Text("Ninguno es correcto — intentar de nuevo")
                        .font(.system(size: 15))
                        .foregroundStyle(Color.appTextSecondary)
                        .frame(maxWidth: .infinity).padding(.vertical, 14)
                        .background(Color.appSearchBar, in: RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 20).padding(.bottom, 32)
            }
            .padding(.top, 8)
        }
        .navigationDestination(item: $selectedAnimal) { AnimalDetailView(animal: $0) }
    }
}

// MARK: - Result Row

struct ResultRow: View {
    let animal : Animal
    let isBest : Bool

    var body: some View {
        HStack(spacing: 0) {
            AnimalImage(scientificName: animal.scientificName, height: 110)
                .frame(width: 100, height: 110)
                .clipped()

            VStack(alignment: .leading, spacing: 6) {
                if isBest {
                    Text("Mejor coincidencia")
                        .font(.system(size: 11, weight: .bold)).foregroundStyle(.white)
                        .padding(.horizontal, 10).padding(.vertical, 4)
                        .background(Color.appGreen, in: Capsule())
                }
                Text(animal.name)
                    .font(.system(size: 16, weight: .bold)).foregroundStyle(Color.appTextPrimary)
                Text(animal.scientificName)
                    .font(.system(size: 12)).italic().foregroundStyle(Color.appTextSecondary)
                HStack(spacing: 8) {
                    DangerBadge(level: animal.dangerLevel)
                    HStack(spacing: 4) {
                        Text("Ver precauciones")
                            .font(.system(size: 13, weight: .medium)).foregroundStyle(Color.appGreen)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11)).foregroundStyle(Color.appGreen)
                    }
                }
            }
            .padding(12)
            Spacer(minLength: 0)
        }
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(isBest ? Color.appGreen : Color.clear, lineWidth: 2))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

#Preview { WizardContainerView() }
