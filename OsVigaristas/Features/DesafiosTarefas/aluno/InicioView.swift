import SwiftUI

struct InicioView: View {
    @State private var selectedSegment = 0
    
    var body: some View {
        NavigationStack() {
            VStack {
                Picker("Atividade", selection: $selectedSegment) {
                    Text("Desafios").tag(0)
                    Text("Tarefas").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()

                // Feed content
                if selectedSegment == 0 {
                    ListaDesafios()
                } else if selectedSegment == 1 {
                    ListaTarefas()
                }
                Spacer()
            }

            // MARK: Toolbar
            
            
            .navigationTitle("Resumo")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        //navegacao pra perfil
                    } label: {
                        (Text("40").foregroundStyle(.black) + Text(Image(systemName: "bitcoinsign.circle.fill")))
                    +
                    (Text("  4").foregroundStyle(.black) + Text(Image(systemName: "flame.fill")))
                    }
                }
            }
        }
    }
}


//MARK: DESAFIOS
struct ListaDesafios: View {
    var body: some View {
        ScrollView(){
            ForEach(0..<2, id: \.self) {
                i in Card(index: i)
                Spacer(minLength: 20)
            }
        }
        
    }
}


//MARK: TAREFAS
struct ListaTarefas: View {
    var body: some View {
        ScrollView(){
            ForEach(0..<5, id: \.self) {
                i in Card(index: i)
                Spacer(minLength: 20)
            }
        }
        
    }
}
