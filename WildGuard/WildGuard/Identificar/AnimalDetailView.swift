//
//  AnimalDetailView.swift
//  WildGuard
//
//  Created by AGRM  on 18/04/26.
//

import SwiftUI

struct AnimalDetailView: View {

    let animal: Animal
    @State private var viewModel  = AnimalDetailViewModel()
    @State private var showReport = false
    @State private var speech     = SpeechService()
    @Environment(\.dismiss) private var dismiss

    // Texto completo que se lee en voz alta
    private var fullSpeechText: String {
        var parts: [String] = []
        parts.append("\(animal.name). Nivel de peligro: \(animal.dangerLevel.rawValue).")
        if !viewModel.aiAdvice.isEmpty {
            parts.append("Qué hacer ahora. \(viewModel.aiAdvice)")
        }
        if !viewModel.aiSteps.isEmpty {
            parts.append("Pasos inmediatos.")
            for step in viewModel.aiSteps {
                parts.append("Paso \(step.number). \(step.title). \(step.detail)")
            }
        }
        return parts.joined(separator: ". ")
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.appBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    heroCard.padding(.horizontal, 20).padding(.top, 12)
                    aiAdviceSection.padding(.horizontal, 20).padding(.top, 24)
                    stepsSection.padding(.horizontal, 20).padding(.top, 24)
                    Spacer().frame(height: 100)
                }
            }

            reportButton.padding(.horizontal, 20).padding(.bottom, 16)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) { backButton }
            ToolbarItem(placement: .principal) {
                Text(animal.name).font(.system(size: 17, weight: .semibold))
            }
            ToolbarItem(placement: .navigationBarTrailing) { animalThumbnail }
        }
        .toolbarBackground(Color.appBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .sheet(isPresented: $showReport) { ReportConfirmationView(animal: animal) }
        .task { await viewModel.generateAll(for: animal) }
        .onDisappear { speech.stop() }
    }

    // MARK: - Toolbar

    private var backButton: some View {
        Button { dismiss() } label: {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left").font(.system(size: 14, weight: .semibold))
                Text("Atrás").font(.system(size: 16))
            }
            .foregroundStyle(Color.appGreen)
        }
    }

    private var animalThumbnail: some View {
        AnimalImage(scientificName: animal.scientificName, height: 34)
            .frame(width: 34, height: 34)
            .clipShape(Circle())
    }

    // MARK: - Hero card

    private var heroCard: some View {
        HStack(spacing: 14) {
            AnimalImage(scientificName: animal.scientificName, height: 64)
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(animal.name)
                    .font(.system(size: 20, weight: .bold)).foregroundStyle(.white)
                Text(animal.scientificName)
                    .font(.system(size: 13)).italic().foregroundStyle(.white.opacity(0.8))
                Text(animal.dangerLevel.rawValue)
                    .font(.system(size: 12, weight: .medium)).foregroundStyle(.white)
                    .padding(.horizontal, 12).padding(.vertical, 5)
                    .background(.white.opacity(0.2), in: Capsule())
                    .overlay(Capsule().stroke(.white.opacity(0.3), lineWidth: 1))
            }
            Spacer()
        }
        .padding(16)
        .background(Color.appGreen, in: RoundedRectangle(cornerRadius: 18))
    }

    // MARK: - AI Advice

    private var aiAdviceSection: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack(spacing: 6) {
                Text("Qué hacer ahora")
                    .font(.system(size: 18, weight: .bold)).foregroundStyle(Color.appTextPrimary)
                Text("✦").font(.system(size: 14)).foregroundStyle(Color.appGreen)

                Spacer()

                // ── Botón escuchar
                Button {
                    speech.speak(fullSpeechText)
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: speech.isSpeaking
                              ? "stop.circle.fill"
                              : "speaker.wave.2.fill")
                            .font(.system(size: 14))
                        Text(speech.isSpeaking ? "Detener" : "Escuchar")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundStyle(Color.appGreen)
                    .padding(.horizontal, 12).padding(.vertical, 6)
                    .background(Color.appGreenMint.opacity(0.6), in: Capsule())
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Spacer()
                    Label("Generado por IA · on device", systemImage: "")
                        .font(.system(size: 11)).foregroundStyle(Color.appTextTertiary)
                }
                if viewModel.isGenerating && viewModel.aiAdvice.isEmpty {
                    shimmerLines(count: 3)
                } else {
                    Text(viewModel.aiAdvice)
                        .font(.system(size: 16)).foregroundStyle(Color.appTextPrimary).lineSpacing(4)
                        .animation(.easeIn(duration: 0.1), value: viewModel.aiAdvice)
                }
            }
            .padding(16)
            .background(.white, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
        }
    }

    // MARK: - Steps

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Text("Pasos inmediatos")
                    .font(.system(size: 18, weight: .bold)).foregroundStyle(Color.appTextPrimary)
                Text("✦").font(.system(size: 14)).foregroundStyle(Color.appGreen)
            }
            if viewModel.isGeneratingSteps && viewModel.aiSteps.isEmpty {
                VStack(spacing: 10) {
                    ForEach(0..<4, id: \.self) { _ in stepShimmer }
                }
            } else {
                ForEach(viewModel.aiSteps) { StepCard(step: $0) }
            }
        }
    }

    // MARK: - Shimmers

    private func shimmerLines(count: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(0..<count, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 4).fill(Color.appShimmer)
                    .frame(maxWidth: .infinity).frame(height: 14)
            }
            RoundedRectangle(cornerRadius: 4).fill(Color.appShimmer).frame(width: 160, height: 14)
        }
    }

    private var stepShimmer: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle().fill(Color.appShimmer).frame(width: 30, height: 30)
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4).fill(Color.appShimmer).frame(width: 140, height: 13)
                RoundedRectangle(cornerRadius: 4).fill(Color.appShimmer).frame(maxWidth: .infinity).frame(height: 11)
            }
            Spacer()
        }
        .padding(14)
        .background(.white, in: RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
    }

    // MARK: - Report button

    private var reportButton: some View {
        Button { showReport = true } label: {
            Text("Reportar este avistamiento →")
                .font(.system(size: 16, weight: .semibold)).foregroundStyle(.white)
                .frame(maxWidth: .infinity).padding(.vertical, 16)
                .background(Color.appGreen, in: RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.appGreen.opacity(0.3), radius: 10, x: 0, y: 4)
        }
    }
}

// MARK: - Step Card

struct StepCard: View {
    let step: ImmediateStep
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle().fill(Color.appGreen).frame(width: 30, height: 30)
                Text("\(step.number)").font(.system(size: 13, weight: .bold)).foregroundStyle(.white)
            }
            .padding(.top, 2)
            VStack(alignment: .leading, spacing: 3) {
                Text(step.title).font(.system(size: 15, weight: .bold)).foregroundStyle(Color.appTextPrimary)
                Text(step.detail).font(.system(size: 13)).foregroundStyle(Color.appTextSecondary).lineSpacing(2)
            }
            Spacer()
        }
        .padding(14)
        .background(.white, in: RoundedRectangle(cornerRadius: 14))
        .overlay(HStack { RoundedRectangle(cornerRadius: 3).fill(Color.appGreen).frame(width: 4); Spacer() }, alignment: .leading)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
    }
}

#Preview { NavigationStack { AnimalDetailView(animal: Animal.all[0]) } }
