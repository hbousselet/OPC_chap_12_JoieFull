import SwiftUI

// Modèle de données simple
struct Item: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let color: Color
}

//struct ContentView: View {
//    // Données d'exemple
//    @State private var items = [
//        Item(title: "Élément 1", description: "Description détaillée de l'élément 1", color: .blue),
//        Item(title: "Élément 2", description: "Description détaillée de l'élément 2", color: .green),
//        Item(title: "Élément 3", description: "Description détaillée de l'élément 3", color: .orange),
//        Item(title: "Élément 4", description: "Description détaillée de l'élément 4", color: .purple),
//        Item(title: "Élément 5", description: "Description détaillée de l'élément 5", color: .red)
//    ]
//    
//    @State private var selectedItem: Item?
//    
//    var body: some View {
//        NavigationStack {
//            if let selectedItem = selectedItem {
//                // Vue en mode split quand un élément est sélectionné
//                HSplitView<TupleView<(some View, DetailView)>, <#Right: View#>> {
//                    // Liste à gauche (plus petite)
//                    MasterView(items: items, selectedItem: $selectedItem)
//                        .frame(maxWidth: 350)
//                    
//                    // Detail à droite
//                    DetailView(item: selectedItem, selectedItem: $selectedItem)
//                }
//            } else {
//                // Vue liste plein écran au démarrage
//                MasterView(items: items, selectedItem: $selectedItem)
//            }
//        }
//    }
//}
//
//struct MasterView: View {
//    let items: [Item]
//    @Binding var selectedItem: Item?
//    
//    var body: some View {
//        List(items) { item in
//            Button(action: {
//                selectedItem = item
//            }) {
//                HStack {
//                    Circle()
//                        .fill(item.color)
//                        .frame(width: 40, height: 40)
//                    
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text(item.title)
//                            .font(.headline)
//                            .foregroundColor(.primary)
//                        Text("Appuyez pour voir les détails")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                    }
//                    
//                    Spacer()
//                    
//                    if selectedItem?.id == item.id {
//                        Image(systemName: "checkmark")
//                            .foregroundColor(.blue)
//                            .font(.body)
//                    } else {
//                        Image(systemName: "chevron.right")
//                            .foregroundColor(.secondary)
//                            .font(.caption)
//                    }
//                }
//                .padding(.vertical, 4)
//                .background(selectedItem?.id == item.id ? Color.blue.opacity(0.1) : Color.clear)
//                .cornerRadius(8)
//            }
//            .buttonStyle(PlainButtonStyle())
//        }
//        .navigationTitle("Ma Liste")
//        .navigationBarTitleDisplayMode(.large)
//    }
//}
//
//struct DetailView: View {
//    let item: Item
//    @Binding var selectedItem: Item?
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            HStack {
//                Button("← Retour à la liste") {
//                    selectedItem = nil
//                }
//                .font(.body)
//                .foregroundColor(.blue)
//                
//                Spacer()
//            }
//            .padding(.horizontal)
//            
//            Circle()
//                .fill(item.color)
//                .frame(width: 120, height: 120)
//                .shadow(radius: 10)
//            
//            Text(item.title)
//                .font(.largeTitle)
//                .fontWeight(.bold)
//            
//            Text(item.description)
//                .font(.body)
//                .multilineTextAlignment(.center)
//                .padding(.horizontal)
//            
//            Spacer()
//        }
//        .padding()
//        .navigationTitle(item.title)
//        .navigationBarTitleDisplayMode(.inline)
//        .background(Color(.systemGroupedBackground))
//    }
//}
//
//// HSplitView personnalisé pour créer un split horizontal
//struct HSplitView<Left: View, Right: View>: View {
//    let left: Left
//    let right: Right
//    
//    init(@ViewBuilder left: () -> Left, @ViewBuilder right: () -> Right) {
//        self.left = left()
//        self.right = right()
//    }
//    
//    var body: some View {
//        HStack(spacing: 0) {
//            left
//                .background(Color(.systemGroupedBackground))
//            
//            Divider()
//            
//            right
//        }
//    }
//}

#Preview {
    ContentView()
}

struct DividedHStackLayout: _VariadicView_UnaryViewRoot {
    var needToDisplayDetailView: Bool
    
    @ViewBuilder
    func body(children: _VariadicView.Children) -> some View {
        let last = children.last?.id

        HStack {
            ForEach(children) { child in
                child

                if child.id != last {
                    Divider()
                }
            }
        }
    }
}


struct ContentView: View {
    var body: some View {
        DividedHStack(needToDisplayDetail: true, content: {
            Text("Bonjour")
            Text("Comment")
            Text("Vas-tu")
        })
    }
}

struct DividedHStack<Content: View>: View {
    var content: Content
    @State var needToDisplayDetail: Bool

    init(needToDisplayDetail: Bool = false, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.needToDisplayDetail = needToDisplayDetail
    }
    
    var body: some View {
        _VariadicView.Tree(DividedHStackLayout(needToDisplayDetailView: needToDisplayDetail)) {
            content
        }
    }
}
