//
//  Animal.swift
//  WildGuard
//
//  Created by AGRM  on 18/04/26.
//

import SwiftUI

// MARK: - Danger Level

enum DangerLevel: String, CaseIterable {
    case high     = "Peligro alto"
    case moderate = "Peligro moderado"
    case caution  = "Precaución"
    case safe     = "Sin peligro"

    var foregroundColor: Color {
        switch self {
        case .high:     return .dangerHighText
        case .moderate: return .dangerModerateText
        case .caution:  return .dangerCautionText
        case .safe:     return .dangerSafeText
        }
    }
    var backgroundColor: Color {
        switch self {
        case .high:     return .dangerHighBg
        case .moderate: return .dangerModerateBg
        case .caution:  return .dangerCautionBg
        case .safe:     return .dangerSafeBg
        }
    }
}

// MARK: - Immediate Step

struct ImmediateStep: Identifiable {
    let id     = UUID()
    let number : Int
    let title  : String
    let detail : String
}

// MARK: - Wizard Tags

struct WizardTags {
    var size     : String
    var color    : String
    var location : String
    var feature  : String
}

// MARK: - Animal

struct Animal: Identifiable, Hashable {
    let id             = UUID()
    let name           : String
    let scientificName : String
    let dangerLevel    : DangerLevel
    let imageURL       : String       // ← URL de Wikipedia Commons
    let steps          : [ImmediateStep]
    let wizardTags     : WizardTags

    static func == (lhs: Animal, rhs: Animal) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: - Data

extension Animal {
    static let all: [Animal] = [
        Animal(
            name: "Oso negro", scientificName: "Ursus americanus",
            dangerLevel: .moderate,
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/01_Schwarzb%C3%A4r.jpg/400px-01_Schwarzb%C3%A4r.jpg",
            steps: [
                ImmediateStep(number: 1, title: "No corras ni grites",       detail: "Mantén la calma. Huir activa el instinto de persecución. Habla con voz firme."),
                ImmediateStep(number: 2, title: "Hazte más grande",          detail: "Levanta los brazos, abre tu chamarra. Muéstrate imponente sin avanzar."),
                ImmediateStep(number: 3, title: "Retrocede despacio",        detail: "Mantén contacto visual y retrocede lentamente sin darle la espalda."),
                ImmediateStep(number: 4, title: "Busca refugio cerrado",     detail: "Entra a un edificio o vehículo si está cerca. Cierra la puerta."),
            ],
            wizardTags: WizardTags(size: "muy-grande", color: "negro", location: "parque", feature: "normal")
        ),
        Animal(
            name: "Jabalí", scientificName: "Sus scrofa",
            dangerLevel: .moderate,
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Sus_scrofa_scrofa.jpg/400px-Sus_scrofa_scrofa.jpg",
            steps: [
                ImmediateStep(number: 1, title: "No te interpongas",         detail: "Nunca te pongas entre una madre y sus crías."),
                ImmediateStep(number: 2, title: "Sube a algo alto",          detail: "Los jabalíes no trepan. Busca un árbol, banca o vehículo."),
                ImmediateStep(number: 3, title: "Retrocede sin correr",      detail: "Aléjate lateral o diagonalmente, nunca de frente."),
            ],
            wizardTags: WizardTags(size: "grande", color: "negro", location: "parque", feature: "colmillos")
        ),
        Animal(
            name: "Coyote", scientificName: "Canis latrans",
            dangerLevel: .caution,
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Canis_latrans_standing.jpg/400px-Canis_latrans_standing.jpg",
            steps: [
                ImmediateStep(number: 1, title: "Hazte notar",               detail: "Grita, aplaude, agita los brazos. El hazing funciona."),
                ImmediateStep(number: 2, title: "No corras",                 detail: "Retrocede lentamente manteniendo contacto visual."),
                ImmediateStep(number: 3, title: "Protege mascotas",          detail: "Levanta perros pequeños o niños si los hay cerca."),
            ],
            wizardTags: WizardTags(size: "mediano", color: "marron", location: "campo", feature: "normal")
        ),
        Animal(
            name: "Puma", scientificName: "Puma concolor",
            dangerLevel: .high,
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Cougar_on_the_Boulder_Ridge_Trail.jpg/400px-Cougar_on_the_Boulder_Ridge_Trail.jpg",
            steps: [
                ImmediateStep(number: 1, title: "Mantente de frente",        detail: "Nunca le des la espalda. El puma ataca por detrás."),
                ImmediateStep(number: 2, title: "Hazte grande",              detail: "Levanta los brazos, abre la chamarra, habla fuerte."),
                ImmediateStep(number: 3, title: "Si ataca, pelea",           detail: "A diferencia del oso, con el puma debes defenderte activamente."),
                ImmediateStep(number: 4, title: "Retrocede sin correr",      detail: "Sal del área lentamente sin movimientos bruscos."),
            ],
            wizardTags: WizardTags(size: "grande", color: "marron", location: "campo", feature: "normal")
        ),
        Animal(
            name: "Víbora de cascabel", scientificName: "Crotalus sp.",
            dangerLevel: .high,
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Crotalus_atrox_2.jpg/400px-Crotalus_atrox_2.jpg",
            steps: [
                ImmediateStep(number: 1, title: "Detente inmediatamente",    detail: "No hagas movimientos bruscos ni intentes atraparla."),
                ImmediateStep(number: 2, title: "Retrocede despacio",        detail: "Aléjate al menos 2 metros. Su alcance es la mitad de su longitud."),
                ImmediateStep(number: 3, title: "Si hay mordida, inmoviliza",detail: "Mantén la extremidad bajo el corazón y busca atención médica."),
            ],
            wizardTags: WizardTags(size: "pequeño", color: "marron", location: "campo", feature: "serpiente")
        ),
        Animal(
            name: "Venado cola blanca", scientificName: "Odocoileus virginianus",
            dangerLevel: .caution,
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Whitetail_doe.jpg/400px-Whitetail_doe.jpg",
            steps: [
                ImmediateStep(number: 1, title: "Mantén distancia",          detail: "Especialmente en época de celo o con crías. Los machos pueden embestir."),
                ImmediateStep(number: 2, title: "No alimentes",              detail: "Alimentarlos los hace perder el miedo a humanos."),
            ],
            wizardTags: WizardTags(size: "grande", color: "marron", location: "parque", feature: "cuernos")
        ),
        Animal(
            name: "Zorrillo", scientificName: "Mephitis mephitis",
            dangerLevel: .caution,
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Spilogale_gracilis.jpg/400px-Spilogale_gracilis.jpg",
            steps: [
                ImmediateStep(number: 1, title: "No te acerques",            detail: "Si levanta la cola, es advertencia de rociado."),
                ImmediateStep(number: 2, title: "Aléjate sin asustar",       detail: "Movimientos lentos y sin ruido. El spray puede llegar a 3 metros."),
                ImmediateStep(number: 3, title: "Si rocía, lava con H₂O₂",  detail: "Mezcla agua oxigenada, bicarbonato y jabón. Evita los ojos."),
            ],
            wizardTags: WizardTags(size: "pequeño", color: "negro-blanco", location: "urbano", feature: "rayas")
        ),
        Animal(
            name: "Mapache", scientificName: "Procyon lotor",
            dangerLevel: .caution,
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Raccoon_%28Procyon_lotor%29_2.jpg/400px-Raccoon_%28Procyon_lotor%29_2.jpg",
            steps: [
                ImmediateStep(number: 1, title: "No alimentes ni toques",    detail: "Pueden transmitir rabia y leptospirosis."),
                ImmediateStep(number: 2, title: "Asegura la basura",         detail: "Son atraídos por alimento. Evita dejar bolsas accesibles."),
                ImmediateStep(number: 3, title: "Si muerde, médico urgente", detail: "Requiere protocolo antirrábico inmediato."),
            ],
            wizardTags: WizardTags(size: "pequeño", color: "gris", location: "urbano", feature: "rayas")
        ),
        Animal(
            name: "Tejón", scientificName: "Taxidea taxus",
            dangerLevel: .caution,
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/df/Taxidea_taxus2.jpg/400px-Taxidea_taxus2.jpg",
            steps: [
                ImmediateStep(number: 1, title: "No acorrales",              detail: "Son agresivos cuando se sienten atrapados."),
                ImmediateStep(number: 2, title: "Mantén mascotas alejadas",  detail: "Pueden atacar perros si se sienten amenazados."),
            ],
            wizardTags: WizardTags(size: "pequeño", color: "gris", location: "campo", feature: "rayas")
        ),
        Animal(
            name: "Tlacuache", scientificName: "Didelphis virginiana",
            dangerLevel: .safe,
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Didelphis_virginiana.jpg/400px-Didelphis_virginiana.jpg",
            steps: [
                ImmediateStep(number: 1, title: "Observa desde lejos",       detail: "Son inofensivos. Juegan a estar muertos cuando se asustan."),
                ImmediateStep(number: 2, title: "No los muevas",             detail: "Si parece muerto, déjalo. Recuperará la conciencia solo."),
            ],
            wizardTags: WizardTags(size: "pequeño", color: "gris", location: "urbano", feature: "cola-larga")
        ),
    ]
}

// MARK: - Color Hex Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int & 0xFF)          / 255
        self.init(red: r, green: g, blue: b)
    }
}
