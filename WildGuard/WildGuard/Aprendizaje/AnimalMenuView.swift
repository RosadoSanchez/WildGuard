import SwiftUI

struct AnimalLearningRouterView: View {
    
    let animalName: String
    
    var body: some View {
        switch animalName {
        case "Coyote":
            CoyoteLearningView()
        case "Oso":
            OsoLearningView()
        case "Mapache":
            MapacheLearningView()
        case "Jabalí":
            JabaliLearningView()
        case "Zorro":
            ZorroLearningView()
        default:
            Text("Animal no disponible")
        }
    }
}

struct AnimalMenuView: View {
    
    let animals = [
        ("Coyote", "Coyote"),
        ("Mapache", "Mapache"),
        ("Jabalí", "Jabali"),
        ("Zorro", "Zorro"),
        ("Oso", "Oso")
    ]

    var body: some View {
        NavigationStack {
            
            VStack(alignment: .leading, spacing: 16) {
                
                Text("Aprende sobre la fauna")
                    .font(.largeTitle.bold())
                
                Text("Selecciona un animal para ver información, datos curiosos y riesgos.")
                    .foregroundColor(.secondary)
                
                ScrollView {
                    VStack(spacing: 12) {
                        
                        ForEach(animals, id: \.0) { animal in
                            
                            NavigationLink {
                                AnimalLearningRouterView(animalName: animal.0)
                            } label: {
                                HStack {
                                    Image(animal.1)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                    
                                    Text(animal.0)
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.appBackground)
                                .cornerRadius(12)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}


#Preview {
    AnimalMenuView()
}
