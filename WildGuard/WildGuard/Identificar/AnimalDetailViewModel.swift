//
//  AnimalDetailViewModel.swift
//  WildGuard
//
//  Created by AGRM  on 18/04/26.
//

import SwiftUI
import FoundationModels

// MARK: - Generable structs para structured output

@Generable
struct AIStep {
    @Guide(description: "Título corto y accionable del paso, máximo 5 palabras")
    var title: String

    @Guide(description: "Descripción breve de qué hacer exactamente, máximo 20 palabras")
    var detail: String
}

@Generable
struct AIStepsResponse {
    @Guide(description: "Lista de exactamente 4 pasos inmediatos de seguridad, ordenados por prioridad")
    var steps: [AIStep]
}

// MARK: - ViewModel

@Observable
class AnimalDetailViewModel {

    var aiAdvice       : String         = ""
    var aiSteps        : [ImmediateStep] = []
    var isGenerating   : Bool           = false
    var isGeneratingSteps: Bool         = false
    var aiError        : String?        = nil

    func generateAll(for animal: Animal) async {
        guard aiAdvice.isEmpty else { return }  // no regenerar si ya cargó

        // Lanzar ambas generaciones en paralelo
        async let adviceTask : Void = generateAdvice(for: animal)
        async let stepsTask  : Void = generateSteps(for: animal)
        _ = await (adviceTask, stepsTask)
    }

    // MARK: - Consejo contextual (streaming)

    private func generateAdvice(for animal: Animal) async {
        isGenerating = true

        let hour = Calendar.current.component(.hour, from: Date())
        let timeOfDay: String
        switch hour {
        case 5..<12:  timeOfDay = "por la mañana"
        case 12..<19: timeOfDay = "por la tarde"
        default:      timeOfDay = "de noche"
        }

        let prompt = """
        Un usuario acaba de avistar un \(animal.name) (\(animal.scientificName)) \
        en zona suburbana, \(timeOfDay). Nivel de peligro: \(animal.dangerLevel.rawValue).
        En 2-3 oraciones cortas en español, da el consejo más importante e inmediato \
        para esta situación específica. Sé directo, claro y enfocado en seguridad personal.
        No uses listas, solo texto corrido.
        """

        do {
            guard SystemLanguageModel.default.isAvailable else {
                aiAdvice = fallbackAdvice(for: animal)
                isGenerating = false
                return
            }
            let session = LanguageModelSession()
            let stream  = session.streamResponse(to: prompt)
            for try await partial in stream {
                aiAdvice = partial.content
            }
        } catch {
            aiAdvice = fallbackAdvice(for: animal)
            aiError  = error.localizedDescription
        }

        isGenerating = false
    }

    // MARK: - Pasos inmediatos (structured output con @Generable)

    private func generateSteps(for animal: Animal) async {
        isGeneratingSteps = true

        let prompt = """
        Animal: \(animal.name) (\(animal.scientificName))
        Nivel de peligro: \(animal.dangerLevel.rawValue)

        Genera exactamente 4 pasos inmediatos de seguridad para alguien que \
        acaba de avistar este animal en una zona suburbana de México.
        Los pasos deben ser específicos para este animal, accionables e inmediatos.
        Escribe en español, de forma directa y clara.
        """

        do {
            guard SystemLanguageModel.default.isAvailable else {
                aiSteps = animal.steps
                isGeneratingSteps = false
                return
            }

            let session  = LanguageModelSession()
            let response = try await session.respond(
                to: prompt,
                generating: AIStepsResponse.self
            )

            // Convertir AIStep → ImmediateStep con número
            aiSteps = response.content.steps.enumerated().map { index, step in
                ImmediateStep(number: index + 1, title: step.title, detail: step.detail)
            }

        } catch {
            // Fallback a pasos hardcodeados si FM falla
            aiSteps = animal.steps
            aiError = error.localizedDescription
        }

        isGeneratingSteps = false
    }

    // MARK: - Fallbacks

    private func fallbackAdvice(for animal: Animal) -> String {
        switch animal.dangerLevel {
        case .high:
            return "Mantén la calma y no hagas movimientos bruscos. Retrocede lentamente sin darle la espalda al animal y busca refugio seguro de inmediato."
        case .moderate:
            return "No corras ni te acerques. Hazte ver grande, habla en voz firme y retrocede despacio hacia un lugar seguro."
        case .caution:
            return "Mantén distancia prudente y no intentes alimentar ni tocar al animal. Aléjate tranquilamente."
        case .safe:
            return "Este animal no representa peligro inmediato. Obsérvalo desde lejos y evita perturbarlo."
        }
    }
}
