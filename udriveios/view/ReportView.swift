import SwiftUI

/* Final View showing a report of the overall driving behavior of the user */
struct ReportView: View {
    
    @State var timeIntervalManager = TimeIntervalManager.getInstance()

    @State var showAlert = false;
    @State var showConfetti = false
    @State var exit = false

    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView(){
            VStack{
                VStack{
                    Text("Punteggio Finale:")
                    Text("\(timeIntervalManager.getCurrentScore(), specifier: "%.2f") %")
                    Text("Miglior Punteggio:")
                    Text("\(timeIntervalManager.getBestScore(), specifier: "%.2f") %")
                    if(showConfetti){
                        Text("Complimenti, hai migliorato il tuo")
                        Text("miglior punteggio!")
                    }
                }.frame(minWidth: 300, maxWidth: .infinity, minHeight: 100 , maxHeight: 500)
                VStack{
                    Text("Il tuo percorso: ")
                    MapView().frame(minWidth: 300, maxWidth: .infinity, minHeight: 500 , maxHeight: 500).padding(20)
                }
                
                HStack{
                    Button(action: {showAlert = true}){
                        HStack{
                            Image(systemName: "stop.fill")
                            Text("Nuova Guida")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .alert(isPresented: $showAlert){
                        Alert(
                            title: Text("Sei sicuro di voler iniziare una nuova guida?"),
                            primaryButton: Alert.Button.default(Text("OK"), action: {
                            }),
                            
                            secondaryButton: Alert.Button.destructive(Text("Annulla"))
                        )
                    }
                    
                    Button(action: {exit = true}){
                        HStack{
                            Image(systemName: "stop.fill")
                            Text("Esci")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .alert(isPresented: $exit){
                        Alert(
                            title: Text("Sei sicuro di voler uscire?"),
                            primaryButton: Alert.Button.default(Text("OK"), action: {
                                    Darwin.exit(0)
                            }),
                            secondaryButton: Alert.Button.destructive(Text("Annulla"))
                        )
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
        .navigationTitle("uDrive")
        .onAppear(){
            CoreDataManager.getInstance().context = viewContext
            if(timeIntervalManager.getBestScore() < timeIntervalManager.getCurrentScore()){
                showConfetti = true
            }
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
