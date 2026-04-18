import SwiftUI
import FoundationModels

struct JabaliLearningView: View {
    
    let animalName = "Jabali"
    
    @State private var facts: [String] = []
    @State private var isLoading = false
    
    var body: some View {
        
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            ScrollView {
                
                VStack(spacing: 16) {
                    
                    Image(animalName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 110, height: 110)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.appGreenLight.opacity(0.4), lineWidth: 2)
                        )
                        .shadow(color: Color.appGreen.opacity(0.2), radius: 8)
                    
                    Text(animalName)
                        .font(.largeTitle.bold())
                        .foregroundColor(Color.appTextPrimary)
                    
                    // LOADING / FACTS
                    if isLoading {
                        ProgressView("Generando con IA...")
                            .tint(Color.appGreen)
                            .foregroundColor(Color.appTextSecondary)
                    } else {
                        ForEach(facts, id: \.self) { fact in
                            Text("• \(fact)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.white) // 👈 clave para contraste
                                .foregroundColor(Color.appTextDark)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 4)
                        }
                    }
                    
                    Button(action: {
                        Task { await generateFacts() }
                    }) {
                        Text("Generar con IA")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.appGreen)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: Color.appGreen.opacity(0.3), radius: 6)
                    }
                }
                .padding()
            }
        }
    }
    
    func generateFacts() async {
        isLoading = true
        
        do {
            let session = LanguageModelSession()
            
            let prompt = """
                        Genera un parráfo introductorio corto sobre \(animalName). Habla sobre su habitat, su dieta y sus características.
                        También dame estos datos: Nivel de peligro del animal: 🟢 Bajo riesgo, 🟡 Precaución, 🔴 Alto riesgo
                        Genera 4 datos educativos claros sobre el animal \(animalName).

                        Reglas estrictas para los datos educativos:
                        - NO uses Markdown
                        - NO uses asteriscos (*)
                        - NO uses negritas ni símbolos de formato
                        - Devuelve solo texto plano
                        - Un dato por línea
                        - Una oración únicamente por dato.
                        - Una viñeta por dato
                        """
            
            let response = try await session.respond(to: prompt)
            
            let parsed = response.content
                .split(separator: "\n")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
            
            await MainActor.run {
                self.facts = parsed
                self.isLoading = false
            }
            
        } catch {
            await MainActor.run {
                self.facts = ["Error generando información con AI."]
                self.isLoading = false
            }
        }
    }
}

#Preview {
    VStack {
        JabaliLearningView()
    }
}
